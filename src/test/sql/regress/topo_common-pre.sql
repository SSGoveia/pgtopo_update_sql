-- create schema for topo_rein data, tables, .... 
CREATE SCHEMA topo_rein;
-- give puclic access
GRANT USAGE ON SCHEMA topo_rein TO public;

select CreateTopology('topo_rein_sysdata',4258,0.0000000001);

-- Workaround for PostGIS bug from Sandro, see
-- http://trac.osgeo.org/postgis/ticket/3359
-- Start edge_id from 2
-- Start face_id from 3
SELECT setval('topo_rein_sysdata.edge_data_edge_id_seq', 2, false),
       setval('topo_rein_sysdata.face_face_id_seq', 3, false);

-- give puclic access

GRANT USAGE ON SCHEMA topo_rein_sysdata TO public;


-- This function is used to create indexes
CREATE OR REPLACE FUNCTION topo_rein.get_relation_id( geo TopoGeometry) RETURNS integer AS $$DECLARE
    relation_id integer;
BEGIN
	relation_id := (geo).id;
   	RETURN relation_id;
END;
$$ LANGUAGE plpgsql
IMMUTABLE;

COMMENT ON FUNCTION topo_rein.get_relation_id(TopoGeometry) IS 'Return the id used to find the row in the relation for polygons). Needed to create function based indexs.';



-- A composite type to hold sosi kopi_data
CREATE TYPE topo_rein.sosi_kopidata 
AS (
	omradeid smallint,
	originaldatavert  VARCHAR(50),
	kopidato DATE
);

-- A composite type to hold sosi registreringsversjon
CREATE TYPE topo_rein.sosi_registreringsversjon 
AS (
	produkt varchar,
	versjon varchar
);


-- A composite type to hold sosi kvalitet
-- beskrivelse av kvaliteten på stedfestingen
CREATE TYPE topo_rein.sosi_kvalitet 
AS (
	-- metode for måling i grunnriss (x,y), og høyde (z) når metoden er den samme som ved måling i grunnriss
	-- TODO Hentes fra kode tabell eller bruke en constraint ???
	maalemetode smallint,
	
	-- punktstandardavviket i grunnriss for punkter samt tverravvik for linjer
	-- Merknad: Oppgitt i cm
	noyaktighet integer,

	-- hvor godt den kartlagte detalj var synbar ved kartleggingen
	-- TODO Hentes fra kode tabell eller bruke en constraint ???
	synbarhet smallint
);

-- A composite type to hold sosi sosi felles egenskaper
CREATE TYPE topo_rein.sosi_felles_egenskaper
AS (
	-- identifikasjondato når data ble registrert/observert/målt første gang, som utgangspunkt for første digitalisering
	-- Merknad:førsteDatafangstdato brukes hvis det er av interesse å forvalte informasjon om når en ble klar over objektet. Dette kan for eksempel gjelde datoen for første flybilde som var utgangspunkt for registrering i en database.
	-- lage regler for hvordan den skal brukes, kan i mange tilfeller arves
	-- henger sammen med UUID, ny UUID ny datofangst dato
	forstedatafangstdato DATE,

	-- Unik identifikasjon av et objekt, ivaretatt av den ansvarlige produsent/forvalter, som kan benyttes av eksterne applikasjoner som referanse til objektet. 
	-- NOTE1 Denne eksterne objektidentifikasjonen må ikke forveksles med en tematisk objektidentifikasjon, slik som f.eks bygningsnummer. 
	-- NOTE 2 Denne unike identifikatoren vil ikke endres i løpet av objektets levetid. 
	-- TODO Test if we can use this as a unique id.
	identifikasjon varchar,
	-- bygd opp navnerom/lokalid/versjon
	-- navnerom: NO_LDIR_REINDRIFT_VAARBEITE
	-- versjon: 0
	-- lokalid:  rowid	
	-- eks identifikasjon = "NO_LDIR_REINDRIFT_VAARBEITE 0 199999999"


	-- beskrivelse av kvaliteten på stedfestingen
	-- Merknad: Denne er identisk med ..KVALITET i tidligere versjoner av SOSI.
	kvalitet topo_rein.sosi_kvalitet,

	-- dato for siste endring på objektetdataene 
	-- Merknad: Oppdateringsdato kan være forskjellig fra Datafangsdato ved at data som er registrert kan bufres en kortere eller lengre periode før disse legges inn i datasystemet (databasen).
	-- Definition: Date and time at which this version of the spatial object was inserted or changed in the spatial data set. 
	oppdateringsdato DATE, 

	-- referanse til opphavsmaterialet, kildematerialet, organisasjons/publiseringskilde
	-- Merknad: Kan også beskrive navn på person og årsak til oppdatering
	opphav VARCHAR(255),

	-- dato når dataene er fastslått å være i samsvar med virkeligheten 
	-- Merknad: Verifiseringsdato er identisk med ..DATO i tidligere versjoner av SOSI	verifiseringsdato DATE
	-- lage regler for hvordan den skal brukes
	-- flybilde fra 2008 vil gi data 2008, må være input fra brukeren
	verifiseringsdato DATE,

	-- Hva gjør vi med disse verdiene som vi har brukt tidligere brukte  i AR5 ?
	-- Er vi sikre på at vi ikke trenger de

	-- datafangstdato DATE, 
	-- Vet ikke om vi skal ha med den, må tenke litt
	-- Skal ikke være med hvis Knut og Ingvild ikke sier noe annet
	
	-- vil bli et produktspek til ???
	-- taes med ikke til slutt brukere
	informasjon  VARCHAR(255) ARRAY, 
	
	-- trengs ikke i følge Knut og Ingvild
	-- kopidata topo_rein.sosi_kopidata, 
	
	-- trengs ikke i følge Knut og Ingvild
	-- prosess_historie VARCHAR(255) ARRAY,
	
	-- kan være forskjellige verdier ut fra når data ble lagt f.eks null verdier for nye attributter eldre enn 4.0
	-- bør være med
	registreringsversjon topo_rein.sosi_registreringsversjon

	
);


-- this is type used extrac data from json
CREATE TYPE topo_rein.simple_sosi_felles_egenskaper AS (
	"felles_egenskaper.forstedatafangsdato" date , 
	"felles_egenskaper.verifiseringsdato" date ,
	"felles_egenskaper.oppdateringsdato" date ,
	"felles_egenskaper.opphav" varchar, 
	"felles_egenskaper.kvalitet.maalemetode" int 
);



-- A composite type to hold key value that will recoreded before a update
-- and compared after the update, used be sure no changes hapends out side 
-- the area that should be updated 
-- DROP TYPE topo_rein.closeto_values_type cascade;

CREATE TYPE topo_rein.closeto_values_type
AS (
	-- line length that intersects reinflate
	closeto_length_reinflate_inter numeric,
	
	-- line count that intersects the edge
	closeto_count_edge_inter int,
	
	-- line count that intersetcs reinlinje 
	closeto_count_reinlinje_inter int,
	
	-- used to check that attribute value close has not changed a close to
	artype_and_length_as_text text,
	
	-- used to check that the area is ok after update 
	-- as we use today we do not remove any data we just add new polygins or change exiting 
	-- the layer should always be covered
	envelope_area_inter  numeric

);


-- TODO add more comments
COMMENT ON COLUMN topo_rein.sosi_felles_egenskaper.verifiseringsdato IS 'Sosi common meta attribute';
COMMENT ON COLUMN topo_rein.sosi_felles_egenskaper.opphav IS 'Sosi common meta attribute';
COMMENT ON COLUMN topo_rein.sosi_felles_egenskaper.informasjon IS 'Sosi common meta attribute';

-- ReinbeitebrukerID
-- angir hvilket reinbeitedistrikt som bruker beiteområdet,....
-- Definition indicates which reindeer pasture district uses the pasture area,...

create table if not exists topo_rein.rein_kode_reinbeitedist(
  id integer unique not null,
  distkode varchar(3) unique not null, -- added unique
  definisjon varchar(10),
  distriktnavn varchar);

   
  
-- ReindriftSesongområde  
-- identifiserer hvorvidt reinbeiteområdet er egnet og brukes til vårbeite, høstbeite, etc
-- Definition identifies whether the reindeer pasture area is suitable and is being used for spring grazing, autumn grazing, etc.
create table if not exists topo_rein.rein_kode_sesomr(
  kode integer unique not null,
  kodenavn varchar,
  definisjon varchar
 );
 



  
 
create table if not exists topo_rein.rein_kode_reinbeiteomr(
  omrkode varchar(1) unique not null,
  beskrivelse varchar
);




create table if not exists topo_rein.rein_kode_gjerderanlegg(
  kode integer not null,
  kodenavn varchar,
  definisjon varchar
  );




-- Should we have one table for all årstidsbeite thems or 5 different tables as today ?
-- We go for the solution with 5 tables now because then it's probably more easy to handle non overlap rules
-- and logically two and two thems form one single map. The only differemse between the 5 tables will be the table name.
-- But if Sandro Santoli says this is easy to use a view to handle toplogy we may need to discuss this again
-- We could also use inheritance but then we aslo get mix rows from different maps.


-- clear out old data added to make testing more easy
-- drop table topo_rein.arstidsbeite_var_flate;
-- drop table topo_rein.arstidsbeite_var_grense;
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'arstidsbeite_var_flate', 'omrade');
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'arstidsbeite_var_grense', 'grense');


-- Do we want attributtes on the borders or only on the surface ?
-- If yes is it only felles_egenskaper ? 
-- If yes should we felles_egenskaper remove from the surface ?
-- If yes should how should we get value from the old data, 
-- do we then have use the sosi files and not org_rein tables ?

-- If yes then we need the table arstidsbeite_var_grense
CREATE TABLE topo_rein.arstidsbeite_var_grense(

-- a internal id will that can be changed when ver needed
-- may be used by the update client when reffering to a certain row when we do a update
-- We could here use indefikajons from the composite type felles_egenskaper, but I am not sure how to use this a primary key ?
-- We could also define this as UUID and use a copy from felles_egenskaper
id serial PRIMARY KEY NOT NULL,
-- gjøres om til lokalid

-- objtype VARCHAR(40) from sosi and what should the value be ????

-- contains felles egenskaper for rein
-- may be null because it is updated after id is set because it this id is used a localid
felles_egenskaper topo_rein.sosi_felles_egenskaper NOT NULL


);

-- add a topogeometry column to get a ref to the borders
-- should this be called grense or geo ?
SELECT topology.AddTopoGeometryColumn('topo_rein_sysdata', 'topo_rein', 'arstidsbeite_var_grense', 'grense', 'LINESTRING') As new_layer_id;

-- What should with do with linestrings that are not used form any surface ?
-- What should wihh linestrings that form a surface but are not reffered to by the topo_rein.arstidsbeite_var_flate ?


CREATE TABLE topo_rein.arstidsbeite_var_flate(

-- a internal id will that can be changed when ver needed
-- may be used by the update client when reffering to a certain row when we do a update
-- We could here use indefikajons from the composite type felles_egenskaper, but I am not sure how to use this a primary key ?
-- We could also define this as UUID and use a copy from felles_egenskaper.indefikajons
id serial PRIMARY KEY not null,
-- gjøres om til lokalid

-- objtype VARCHAR(40) from sosi
-- removed because this is equal for all rows the value are 'Årstidsbeite'.

-- column område 
-- is added later and may renamed to geo
-- Should we call this geo, omrade or område ?
-- use omrade 

-- column posisjon point from sosi
-- removed because we don't need it, we can generate it if we need id.
-- all rows here should be of type surface and no rows with point only

-- angir hvilket reinbeitedistrikt som bruker beiteområdet 
-- Definition -- indicates which reindeer pasture district uses the pasture area
reinbeitebruker_id varchar(3) CHECK (reinbeitebruker_id IN ('XI','ZA','ZB','ZC','ZD','ZE','ZF','ØG','UW','UX','UY','UZ','ØA','ØB','ØC','ØE','ØF','ZG','ZH','ZJ','ZS','ZL','ZÅ','YA','YB','YC','YD','YE','YF','YG','XM','XR','XT','YH','YI','YJ','YK','YL','YM','YN','YP','YX','YR','YS','YT','YU','YV','YW','YY','XA','XD','XE','XG','XH','XJ','XK','XL','XM','XR','XS','XT','XN','XØ','XP','XU','XV','XW','XZ','XX','XY','WA','WB','WD','WF','WK','WL','WN','WP','WR','WS','WX','WZ','VA','VF','VG','VJ','VM','VR','YQA','YQB','YQC','ZZ','RR','ZQA')), 


-- identifiserer hvorvidt reinbeiteområdet er egnet og brukes til vårbeite, høstbeite, etc 
-- Definition -- identifies whether the reindeer pasture area is suitable and is being used for spring grazing, autumn grazing, etc.
-- Reduces this to only vårbeite I og vårbeite II, because this types form one single map
-- reindrift_sesongomrade_id int CHECK ( reindrift_sesongomrade_id > 0 AND reindrift_sesongomrade_id < 3) 
-- CONSTRAINT fk_arstidsbeite_var_flate_reindrift_sesongomrade_id REFERENCES topo_rein.rein_kode_sesomr(kode) ,

-- it's better to use a code here, because that is what is descrbeied in the spec
reindrift_sesongomrade_kode int CHECK ( reindrift_sesongomrade_kode > 0 AND reindrift_sesongomrade_kode < 3), 

-- contains felles egenskaper for rein
-- should this be moved to the border, because the is just a result drawing border lines ??
-- what about the value the for indentfikajons ?
-- may be null because it is updated after id is set because it this id is used a localid
felles_egenskaper topo_rein.sosi_felles_egenskaper,

-- added because of performance, used by wms and sp on
-- update in the same transaction as the topo objekt
simple_geo geometry(MultiPolygon,4258) 



);

-- add a topogeometry column that is a ref to polygpn surface
-- should this be called område/omrade or geo ?
SELECT topology.AddTopoGeometryColumn('topo_rein_sysdata', 'topo_rein', 'arstidsbeite_var_flate', 'omrade', 'POLYGON'
	-- get parrentid
	--,(SELECT layer_id FROM topology.layer l, topology.topology t 
	--WHERE t.name = 'topo_rein_sysdata' AND t.id = l. topology_id AND l.schema_name = 'topo_rein' AND l.table_name = 'arstidsbeite_var_grense' AND l.feature_column = 'grense')::int
) As new_layer_id;




COMMENT ON TABLE topo_rein.arstidsbeite_var_flate IS 'Contains attributtes for rein and ref. to topo surface data. For more info see http://www.statkart.no/Documents/Standard/SOSI kap3 Produktspesifikasjoner/FKB 4.5/4-rein-2014-03-01.pdf';

COMMENT ON COLUMN topo_rein.arstidsbeite_var_flate.id IS 'Unique identifier of a surface';

COMMENT ON COLUMN topo_rein.arstidsbeite_var_flate.felles_egenskaper IS 'Sosi common meta attribute part of kvaliet TODO create user defined type ?';

-- COMMENT ON COLUMN topo_rein.arstidsbeite_var_flate.geo IS 'This holds the ref to topo_rein_sysdata.relation table, where we find pointers needed top build the the topo surface';

-- create function basded index to get performance
CREATE INDEX topo_rein_arstidsbeite_var_flate_geo_relation_id_idx ON topo_rein.arstidsbeite_var_flate(topo_rein.get_relation_id(omrade));	

COMMENT ON INDEX topo_rein.topo_rein_arstidsbeite_var_flate_geo_relation_id_idx IS 'A function based index to faster find the topo rows for in the relation table';


-- create index on topo_rein_sysdata.edge
CREATE INDEX topo_rein_sysdata_edge_simple_geo_idx ON topo_rein.arstidsbeite_var_flate USING GIST (simple_geo); 


--COMMENT ON INDEX topo_rein.topo_rein_sysdata_edge_simple_geo_idx IS 'A index created to avoid building topo when the data is used for wms like mapserver which do no use the topo geometry';

-- Should we have one table for all årstidsbeite thems or 5 different tables as today ?
-- We go for the solution with 5 tables now because then it's probably more easy to handle non overlap rules
-- and logically two and two thems form one single map. The only differemse between the 5 tables will be the table name.
-- But if Sandro Santoli says this is easy to use a view to handle toplogy we may need to discuss this again
-- We could also use inheritance but then we aslo get mix rows from different maps.


-- clear out old data added to make testing more easy
-- drop table topo_rein.arstidsbeite_var_flate;
-- drop table topo_rein.reindrift_anlegg_linje;
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'arstidsbeite_var_flate', 'omrade');
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'reindrift_anlegg_linje', 'grense');


-- Do we want attributtes on the borders or only on the surface ?
-- If yes is it only felles_egenskaper ? 
-- If yes should we felles_egenskaper remove from the surface ?
-- If yes should how should we get value from the old data, 
-- do we then have use the sosi files and not org_rein tables ?

-- If yes then we need the table reindrift_anlegg_linje
CREATE TABLE topo_rein.reindrift_anlegg_linje(

-- a internal id will that can be changed when ver needed
-- may be used by the update client when reffering to a certain row when we do a update
-- We could here use indefikajons from the composite type felles_egenskaper, but I am not sure how to use this a primary key ?
-- We could also define this as UUID and use a copy from felles_egenskaper
id serial PRIMARY KEY NOT NULL,
-- gjøres om til lokalid

-- objtype VARCHAR(40) from sosi and what should the value be ????

-- contains felles egenskaper for rein
-- may be null because it is updated after id is set because it this id is used a localid
felles_egenskaper topo_rein.sosi_felles_egenskaper,

-- angir hvilket reinbeitedistrikt som bruker beiteområdet 
-- Definition -- indicates which reindeer pasture district uses the pasture area
-- TODO add not null
reinbeitebruker_id varchar(3) CHECK (reinbeitebruker_id IN ('XI','ZA','ZB','ZC','ZD','ZE','ZF','ØG','UW','UX','UY','UZ','ØA','ØB','ØC','ØE','ØF','ZG','ZH','ZJ','ZS','ZL','ZÅ','YA','YB','YC','YD','YE','YF','YG','XM','XR','XT','YH','YI','YJ','YK','YL','YM','YN','YP','YX','YR','YS','YT','YU','YV','YW','YY','XA','XD','XE','XG','XH','XJ','XK','XL','XM','XR','XS','XT','XN','XØ','XP','XU','XV','XW','XZ','XX','XY','WA','WB','WD','WF','WK','WL','WN','WP','WR','WS','WX','WZ','VA','VF','VG','VJ','VM','VR','YQA','YQB','YQC','ZZ','RR','ZQA')), 

-- spesifikasjon av type teknisk anlegg som er etablert i forbindelse med utmarksbeite 
-- TODO add not null
reindriftsanleggstype int CHECK ( (reindriftsanleggstype > 0 AND reindriftsanleggstype < 8) or (reindriftsanleggstype=12)) 


);

-- add a topogeometry column to get a ref to the borders
-- should this be called grense or geo ?
SELECT topology.AddTopoGeometryColumn('topo_rein_sysdata', 'topo_rein', 'reindrift_anlegg_linje', 'linje', 'LINESTRING') As new_layer_id;


-- create function basded index to get performance
CREATE INDEX topo_rein_reindrift_anlegg_linje_geo_relation_id_idx ON topo_rein.reindrift_anlegg_linje(topo_rein.get_relation_id(linje));	

-- Should we have one table for all årstidsbeite thems or 5 different tables as today ?
-- We go for the solution with 5 tables now because then it's probably more easy to handle non overlap rules
-- and logically two and two thems form one single map. The only differemse between the 5 tables will be the table name.
-- But if Sandro Santoli says this is easy to use a view to handle toplogy we may need to discuss this again
-- We could also use inheritance but then we aslo get mix rows from different maps.


-- clear out old data added to make testing more easy
-- drop table topo_rein.arstidsbeite_var_flate;
-- drop table topo_rein.reindrift_anlegg_punkt;
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'arstidsbeite_var_flate', 'omrade');
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'reindrift_anlegg_punkt', 'grense');


-- Do we want attributtes on the borders or only on the surface ?
-- If yes is it only felles_egenskaper ? 
-- If yes should we felles_egenskaper remove from the surface ?
-- If yes should how should we get value from the old data, 
-- do we then have use the sosi files and not org_rein tables ?

-- If yes then we need the table reindrift_anlegg_punkt
CREATE TABLE topo_rein.reindrift_anlegg_punkt(

-- a internal id will that can be changed when ver needed
-- may be used by the update client when reffering to a certain row when we do a update
-- We could here use indefikajons from the composite type felles_egenskaper, but I am not sure how to use this a primary key ?
-- We could also define this as UUID and use a copy from felles_egenskaper
id serial PRIMARY KEY NOT NULL,
-- gjøres om til lokalid

-- objtype VARCHAR(40) from sosi and what should the value be ????

-- contains felles egenskaper for rein
-- may be null because it is updated after id is set because it this id is used a localid
felles_egenskaper topo_rein.sosi_felles_egenskaper,

-- angir hvilket reinbeitedistrikt som bruker beiteområdet 
-- Definition -- indicates which reindeer pasture district uses the pasture area
reinbeitebruker_id varchar(3) CHECK (reinbeitebruker_id IN ('XI','ZA','ZB','ZC','ZD','ZE','ZF','ØG','UW','UX','UY','UZ','ØA','ØB','ØC','ØE','ØF','ZG','ZH','ZJ','ZS','ZL','ZÅ','YA','YB','YC','YD','YE','YF','YG','XM','XR','XT','YH','YI','YJ','YK','YL','YM','YN','YP','YX','YR','YS','YT','YU','YV','YW','YY','XA','XD','XE','XG','XH','XJ','XK','XL','XM','XR','XS','XT','XN','XØ','XP','XU','XV','XW','XZ','XX','XY','WA','WB','WD','WF','WK','WL','WN','WP','WR','WS','WX','WZ','VA','VF','VG','VJ','VM','VR','YQA','YQB','YQC','ZZ','RR','ZQA')), 

-- spesifikasjon av type teknisk anlegg som er etablert i forbindelse med utmarksbeite 
reindriftsanleggstype int CHECK (reindriftsanleggstype > 9 AND reindriftsanleggstype < 21) 


);

-- add a topogeometry column to get a ref to the borders
-- should this be called grense or geo ?
SELECT topology.AddTopoGeometryColumn('topo_rein_sysdata', 'topo_rein', 'reindrift_anlegg_punkt', 'punkt', 'POINT') As new_layer_id;


-- create function basded index to get performance
CREATE INDEX topo_rein_reindrift_anlegg_punkt_geo_relation_id_idx ON topo_rein.reindrift_anlegg_punkt(topo_rein.get_relation_id(punkt));	

-- Should we have one table for all årstidsbeite thems or 5 different tables as today ?
-- We go for the solution with 5 tables now because then it's probably more easy to handle non overlap rules
-- and logically two and two thems form one single map. The only differemse between the 5 tables will be the table name.
-- But if Sandro Santoli says this is easy to use a view to handle toplogy we may need to discuss this again
-- We could also use inheritance but then we aslo get mix rows from different maps.


-- clear out old data added to make testing more easy
-- drop table topo_rein.arstidsbeite_var_flate;
-- drop table topo_rein.rein_trekklei_linje;
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'arstidsbeite_var_flate', 'omrade');
-- SELECT topology.DropTopoGeometryColumn('topo_rein', 'rein_trekklei_linje', 'grense');


-- Do we want attributtes on the borders or only on the surface ?
-- If yes is it only felles_egenskaper ? 
-- If yes should we felles_egenskaper remove from the surface ?
-- If yes should how should we get value from the old data, 
-- do we then have use the sosi files and not org_rein tables ?

-- If yes then we need the table rein_trekklei_linje
CREATE TABLE topo_rein.rein_trekklei_linje(

-- a internal id will that can be changed when ver needed
-- may be used by the update client when reffering to a certain row when we do a update
-- We could here use indefikajons from the composite type felles_egenskaper, but I am not sure how to use this a primary key ?
-- We could also define this as UUID and use a copy from felles_egenskaper
id serial PRIMARY KEY NOT NULL,
-- gjøres om til lokalid

-- objtype VARCHAR(40) from sosi and what should the value be ????

-- contains felles egenskaper for rein
-- may be null because it is updated after id is set because it this id is used a localid
felles_egenskaper topo_rein.sosi_felles_egenskaper,

-- angir hvilket reinbeitedistrikt som bruker beiteområdet 
-- Definition -- indicates which reindeer pasture district uses the pasture area
-- TODO add not null
reinbeitebruker_id varchar(3) CHECK (reinbeitebruker_id IN ('XI','ZA','ZB','ZC','ZD','ZE','ZF','ØG','UW','UX','UY','UZ','ØA','ØB','ØC','ØE','ØF','ZG','ZH','ZJ','ZS','ZL','ZÅ','YA','YB','YC','YD','YE','YF','YG','XM','XR','XT','YH','YI','YJ','YK','YL','YM','YN','YP','YX','YR','YS','YT','YU','YV','YW','YY','XA','XD','XE','XG','XH','XJ','XK','XL','XM','XR','XS','XT','XN','XØ','XP','XU','XV','XW','XZ','XX','XY','WA','WB','WD','WF','WK','WL','WN','WP','WR','WS','WX','WZ','VA','VF','VG','VJ','VM','VR','YQA','YQB','YQC','ZZ','RR','ZQA'))

);

-- add a topogeometry column to get a ref to the borders
-- should this be called grense or geo ?
SELECT topology.AddTopoGeometryColumn('topo_rein_sysdata', 'topo_rein', 'rein_trekklei_linje', 'linje', 'LINESTRING') As new_layer_id;


-- create function basded index to get performance
CREATE INDEX topo_rein_rein_trekklei_linje_geo_relation_id_idx ON topo_rein.rein_trekklei_linje(topo_rein.get_relation_id(linje));	
-- DROP VIEW topo_rein.arstidsbeite_var_flate_v cascade ;


CREATE OR REPLACE VIEW topo_rein.arstidsbeite_var_flate_v 
AS
select 
id,
--((al.felles_egenskaper).kvalitet).maalemetode,
--((al.felles_egenskaper).kvalitet).noyaktighet,
--((al.felles_egenskaper).kvalitet).synbarhet,
--(al.felles_egenskaper).verifiseringsdato, 
--(al.felles_egenskaper).opphav, 
--(al.felles_egenskaper).informasjon::varchar as informasjon, 
reindrift_sesongomrade_kode,
omrade::geometry(MultiPolygon,4258) as geo 
from topo_rein.arstidsbeite_var_flate al;

-- DROP VIEW IF EXISTS topo_rein.arstidsbeite_var_topojson_flate_v cascade ;


CREATE OR REPLACE VIEW topo_rein.arstidsbeite_var_topojson_flate_v 
AS
select 
id,
reindrift_sesongomrade_kode,
reinbeitebruker_id,
(al.felles_egenskaper).forstedatafangstdato AS "fellesegenskaper.forstedatafangsdato", 
(al.felles_egenskaper).verifiseringsdato AS "fellesegenskaper.verifiseringsdato",
(al.felles_egenskaper).oppdateringsdato AS "fellesegenskaper.oppdateringsdato",
(al.felles_egenskaper).opphav AS "fellesegenskaper.opphav", 
omrade 
from topo_rein.arstidsbeite_var_flate al;

--select * from topo_rein.arstidsbeite_var_topojson_flate_v-- DROP VIEW topo_rein.reindrift_anlegg_linje_v cascade ;


CREATE OR REPLACE VIEW topo_rein.reindrift_anlegg_linje_v 
AS
select 
id,
--((al.felles_egenskaper).kvalitet).maalemetode,
--((al.felles_egenskaper).kvalitet).noyaktighet,
--((al.felles_egenskaper).kvalitet).synbarhet,
--(al.felles_egenskaper).verifiseringsdato, 
--(al.felles_egenskaper).opphav, 
--(al.felles_egenskaper).informasjon::varchar as informasjon, 
reinbeitebruker_id,
reindriftsanleggstype,
linje::geometry(MultiLineString,4258) as geo 
from topo_rein.reindrift_anlegg_linje al;

-- select * from topo_rein.reindrift_anlegg_linje_v ;


--DROP VIEW topo_rein.reindrift_anlegg_punkt_v cascade ;


CREATE OR REPLACE VIEW topo_rein.reindrift_anlegg_punkt_v 
AS
select 
id,
--((al.felles_egenskaper).kvalitet).maalemetode,
--((al.felles_egenskaper).kvalitet).noyaktighet,
--((al.felles_egenskaper).kvalitet).synbarhet,
--(al.felles_egenskaper).verifiseringsdato, 
--(al.felles_egenskaper).opphav, 
--(al.felles_egenskaper).informasjon::varchar as informasjon, 
reinbeitebruker_id,
reindriftsanleggstype,
punkt::geometry(MultiPoint,4258) as geo 
from topo_rein.reindrift_anlegg_punkt al;

-- select * from topo_rein.reindrift_anlegg_punkt_v ;


 DROP VIEW IF EXISTS topo_rein.reindrift_anlegg_topojson_linje_v cascade ;


CREATE OR REPLACE VIEW topo_rein.reindrift_anlegg_topojson_linje_v 
AS
select 
id,
reinbeitebruker_id,
reindriftsanleggstype,
(al.felles_egenskaper).forstedatafangstdato AS "fellesegenskaper.forstedatafangsdato", 
(al.felles_egenskaper).verifiseringsdato AS "fellesegenskaper.verifiseringsdato",
(al.felles_egenskaper).oppdateringsdato AS "fellesegenskaper.oppdateringsdato",
(al.felles_egenskaper).opphav AS "fellesegenskaper.opphav", 
((al.felles_egenskaper).kvalitet).maalemetode AS "fellesegenskaper.maalemetode",
linje
from topo_rein.reindrift_anlegg_linje al;

-- select * from topo_rein.reindrift_anlegg_topojson_linje_v ;


DROP VIEW IF EXISTS topo_rein.reindrift_anlegg_topojson_punkt_v cascade ;


CREATE OR REPLACE VIEW topo_rein.reindrift_anlegg_topojson_punkt_v 
AS
select 
id,
reinbeitebruker_id,
reindriftsanleggstype,
(al.felles_egenskaper).forstedatafangstdato AS "fellesegenskaper.forstedatafangsdato", 
(al.felles_egenskaper).verifiseringsdato AS "fellesegenskaper.verifiseringsdato",
(al.felles_egenskaper).oppdateringsdato AS "fellesegenskaper.oppdateringsdato",
(al.felles_egenskaper).opphav AS "fellesegenskaper.opphav", 
((al.felles_egenskaper).kvalitet).maalemetode AS "fellesegenskaper.maalemetode",
punkt
from topo_rein.reindrift_anlegg_punkt al;

--select * from topo_rein.reindrift_anlegg_topojson_punkt_v ;

