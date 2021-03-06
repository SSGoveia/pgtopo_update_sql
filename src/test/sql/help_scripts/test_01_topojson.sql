SELECT  topo_rein.query_to_topojson('select reinbeitebruker_id,omrade from topo_rein.arstidsbeite_var_flate', 32632, 0, 20);


SELECT row_to_json(f) As feature \
     FROM (SELECT 'Feature' As type \
     , ST_AsGeoJSON(ST_transform(geo,32632),0)::json As geometry \
     , row_to_json((SELECT l FROM (SELECT id AS feat_id) As l)) As properties \
     FROM topo_rein.arstidsbeite_var_flate_v) As f;

psql -t -q sl -c"SELECT  topo_rein.query_to_topojson('select id,omrade from topo_rein.arstidsbeite_var_flate where id = 520', 32632, 0, 0)" > /tmp/t1.topojson

psql -t -q sl -c"SELECT row_to_json(f) As feature 
     FROM (SELECT 'Feature' As type 
     , ST_AsGeoJSON(ST_transform(geo,32632),0)::json As geometry 
     , row_to_json((SELECT l FROM (SELECT id AS feat_id) As l)) As properties
     FROM topo_rein.arstidsbeite_var_flate_v) As f" > /tmp/t1.geojson

     
     ST_SimplifyPreserveTopology(edge,0.01)

psql -t -q sl -c     "SELECT row_to_json(fc)
 FROM ( SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features
    FROM (SELECT 'Feature' As type 
     , ST_AsGeoJSON(ST_transform( ST_SimplifyPreserveTopology(geo,0.01),32632),0)::json As geometry 
     , row_to_json((SELECT l FROM (SELECT id AS feat_id) As l)) As properties
     FROM topo_rein.arstidsbeite_var_flate_v) As f   
   )  As fc" > /tmp/t1.geojson
     
     
http://www.mapshaper.org
     
--- fails 

select ST_AsGeoJSON('geo')
     
SELECT  length(topo_rein.query_to_topojson('select * from topo_rein.arstidsbeite_var_grense', 32632, 0))::text;


select reinbeitebruker_id,reindrift_sesongomrade_kode,omrade from topo_rein.arstidsbeite_var_flate a WHERE a.omrade::geometry &&   (\x010300000001000000050000004280810eca0525400c2ba72efe4d413f3980810eca052540104548712d4e413fd8a9420fca052540ef934a712d4e413fe1a9420fca052540eb79a92efe4d413f4280810eca0525400c2ba72efe4d413f)::geometry)

SELECT  topo_rein.query_to_topojson('select reinbeitebruker_id, (felles_egenskaper).opphav, punkt from topo_rein.reindrift_anlegg_punkt', 32632, 0);



SELECT  topo_rein.query_to_topojson('select * from topo_rein.arstidsbeite_var_topojson_flate_v ', 32632, 0);



SELECT  topo_rein.query_to_topojson('select reinbeitebruker_id, reindrift_sesongomrade_kode, omrade from topo_rein.arstidsbeite_var_flate', 4258, 7);

SELECT  topo_rein.query_to_topojson('select surface_topo from topo_rein.new_surface_data_for_edge', 4258,5);

select reinbeitebruker_id,omrade from topo_rein.arstidsbeite_var_flate

SELECT  topo_rein.query_to_topojson('select reinbeitebruker_id, reindrift_sesongomrade_kode, omrade from topo_rein.arstidsbeite_var_flate', 32632, 0);

select ST_AsBinary(ST_GeomFromEWKT('POLYGON ((10.511307195003727 0.0005280963062487, 10.511307195003711 0.0005281183135272, 10.511307217490796 0.0005281183135436, 10.511307217490812 0.0005280963062651, 10.511307195003727 0.0005280963062487))'))

select reinbeitebruker_id,reindrift_sesongomrade_kode,omrade from topo_rein.arstidsbeite_var_flate a WHERE a.omrade::geometry &&  ST_GeomFromEWKT('POLYGON ((10.511307195003727 0.0005280963062487, 10.511307195003711 0.0005281183135272, 10.511307217490796 0.0005281183135436, 10.511307217490812 0.0005280963062651, 10.511307195003727 0.0005280963062487))')

SELECT reinbeitebruker_id,reindrift_sesongomrade_kode,omrade from topo_rein.arstidsbeite_var_flate WHERE id in (1,2)

select ST_AsText(ST_Union(ST_Intersection(ST_GeomFromEWKT('SRID=4258;LINESTRING(19.3549069163725 69.8825496452282,19.4303545452396 69.8669515977129)'),e.geom))) FROM topo_rein_sysdata.edge_data e WHERE ST_Intersects(ST_GeomFromEWKT('SRID=4258;LINESTRING(19.3549069163725 69.8825496452282,19.4303545452396 69.8669515977129)'),e.geom);

select ST_Union(ST_Intersection(ST_GeomFromEWKT('SRID=4258;LINESTRING(19.3549069163725 69.8825496452282,19.4303545452396 69.8669515977129)'),e.geom)) FROM topo_rein_sysdata.edge_data e WHERE ST_Intersects(ST_GeomFromEWKT('SRID=4258;LINESTRING(19.3549069163725 69.8825496452282,19.4303545452396 69.8669515977129)'),e.geom);

select ST_NumGeometries(ST_Union(ST_Intersection(ST_GeomFromEWKT('SRID=4258;LINESTRING(19.3549069163725 69.8825496452282,19.4303545452396 69.8669515977129)'),e.geom))) FROM topo_rein_sysdata.edge_data e WHERE ST_Intersects(ST_GeomFromEWKT('SRID=4258;LINESTRING(19.3549069163725 69.8825496452282,19.4303545452396 69.8669515977129)'),e.geom);

select id, reinbeitebruker_id,reindrift_sesongomrade_kode,omrade from topo_rein.arstidsbeite_var_flate a WHERE a.omrade::geometry &&  ST_GeomFromEWKT('POLYGON ((16.97999564191308 68.43998066893752, 16.984891883715484 68.49584255933902, 17.283282372748236 68.4920466014126, 17.27765152643165 68.4361955000773, 16.97999564191308 68.43998066893752))') 


select id, reinbeitebruker_id,reindrift_sesongomrade_kode,omrade from topo_rein.arstidsbeite_var_flate a WHERE a.omrade::geometry &&  ST_GeomFromEWKT('POLYGON ((16.97999564191308 68.43998066893752, 16.984891883715484 68.49584255933902, 17.283282372748236 68.4920466014126, 17.27765152643165 68.4361955000773, 16.97999564191308 68.43998066893752))') 


db01utv postgres@sl=# 
select id 
from topo_rein.arstidsbeite_var_flate a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl
WHERE fa.mbr && ST_GeomFromEWKT('POLYGON ((16.97999564191308 68.43998066893752, 16.984891883715484 68.49584255933902, 17.283282372748236 68.4920466014126, 17.27765152643165 68.4361955000773, 16.97999564191308 68.43998066893752))') AND
topo_rein.get_relation_id(a.omrade) = re.topogeo_id and re.layer_id = tl.layer_id and tl.schema_name = 'topo_rein' and tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id ; 
 id  
-----
 222
 223
 228
 229
 210
 211
(6 rows)

Time: 1.856 ms

db01utv postgres@sl=# select id 
from topo_rein.arstidsbeite_var_flate a 
WHERE a.omrade::geometry &&  ST_GeomFromEWKT('POLYGON ((16.97999564191308 68.43998066893752, 16.984891883715484 68.49584255933902, 17.283282372748236 68.4920466014126, 17.27765152643165 68.4361955000773, 16.97999564191308 68.43998066893752))') ;
 id  
-----
 222
 223
 210
 211
 229
 228
(6 rows)

Time: 251.583 ms
db01utv postgres@sl=# 



getTopoJson with length 276011, in 201 milli. secs. using select id, reinbeitebruker_id,reindrift_sesongomrade_kode,omrade from topo_rein.arstidsbeite_var_flate a,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl WHERE fa.mbr && ST_GeomFromEWKT('POLYGON ((15.453222761463891 68.2518400245376, 15.471719965769845 69.14611185788299, 20.37691389397668 69.06249543521308, 20.16722849705953 68.1719678307436, 15.453222761463891 68.2518400245376))') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id and re.layer_id = tl.layer_id and tl.schema_name = 'topo_rein' and tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id - 


select count(id)
from topo_rein.arstidsbeite_var_flate a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl
WHERE fa.mbr && ST_MakeEnvelope('-Infinity', '-Infinity', 'Infinity', 'Infinity') AND
topo_rein.get_relation_id(a.omrade) = re.topogeo_id and re.layer_id = tl.layer_id and tl.schema_name = 'topo_rein' and tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id ; 


selecy 



SELECT topo_update.create_point_point_domain_obj('{"type": "Feature","crs":{"type":"name","properties":{"name":"EPSG:4258"}},"geometry":{"type":"Point","coordinates":[17.4122416312598,68.6013397740665]},"properties":{"reinbeitebruker_id":"XG","reindriftsanleggstype":18}}');

SELECT  topo_rein.query_to_topojson('select * from topo_rein.arstidsbeite_var_topojson_flate_v a,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl WHERE fa.mbr && ST_GeomFromEWKT('POLYGON ((14.735846527644538 68.47480084203315, 14.72497285460664 69.3663294046479, 21.743013907320826 69.23493735782012, 21.47872605109315 68.34931141681955, 14.735846527644538 68.47480084203315))') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = 'topo_rein' AND tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id', 32632, 0);




CREATE TYPE trans_line AS (
     description text,
     amount numeric,
     account_id int
);

CREATE TYPE journal_entry AS(
      reference text,
      description text,
      post_date date,
      lines trans_line[]
);

/* make some test data */
SELECT row('a', 'b', now(), array[row('c', 1.0, 2), row('d', 3.0, 4)]::trans_line[])::journal_entry;
                       row
--------------------------------------------------
 (a,b,2013-09-13,"{""(c,1.0,2)"",""(d,3.0,4)""}")

select row_to_json((SELECT l FROM (SELECT id,felles_egenskaper from topo_rein.arstidsbeite_var_grense limit 1 ) As l ));

-[ RECORD 1 ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
row_to_json | {"id":1,"felles_egenskaper":{"forstedatafangstdato":"2015-11-01","identifikasjon":"NO_LDIR_REINDRIFT_VAARBEITE 0 0","kvalitet":{"maalemetode":99,"noyaktighet":200,"synbarhet":0},"oppdateringsdato":null,"opphav":"komnr","verifiseringsdato":"2015-11-01","informasjon":null,"registreringsversjon":{"produkt":null,"versjon":"4.5"}}}


create table test (id serial primary key, name varchar(50));

insert into test(name) select name from json_populate_record(NULL::test, '{"name": "John","name2": "John"}');


drop table test;

create table test (
reinbeitebruker_id varchar(3), 
reindriftsanleggstype int,
"fellesegenskaper.forstedatafangsdato" date default now(), 
"fellesegenskaper.verifiseringsdato" date default now(),
"fellesegenskaper.oppdateringsdato" date default now(),
"felles_egenskaper.opphav" varchar, 
"felles_egenskaper.kvalitet.maalemetode" int 
);

insert into test(reinbeitebruker_id,reindriftsanleggstype,"felles_egenskaper.opphav","felles_egenskaper.kvalitet.maalemetode")
values('eee',2,'EX',82);

select row_to_json((SELECT l FROM (SELECT * from test limit 1 ) As l ));



select null as geom, * from json_populate_record(NULL::topo_rein.simple_sosi_felles_egenskaper, '{"reinbeitebruker_id":"eee","reindriftsanleggstype":2,"fellesegenskaper.forsteDatafangsdato":"2015-11-02","fellesegenskaper.verifiseringsdato":"2015-11-02","fellesegenskaper.oppdateringsdato":"2015-11-02","felles_egenskaper.opphav":"EX","felles_egenskaper.kvalitet.maalemetode":82}');

select json_populate_record(NULL::test, '{"type": "Feature","geometry":{"type":"LineString","crs":{"type":"name","properties":{"name":"EPSG:4258"}},"coordinates":[[18.2968143053,69.2487191414],[18.300482121,69.2500232984],[18.3033027731,69.25623823],[18.3000566291,69.2604319704],[18.2955963015,69.2645776875],[18.289870294,69.2683436731],[18.2880743318,69.2697550773],[18.2879922858,69.2727485469],[18.288102813,69.2743611448],[18.2894379697,69.2760928398],[18.2911630945,69.2786244977],[18.3002841539,69.2848143943],[18.3091026595,69.2889912546],[18.314431421,69.2905038971],[18.3203146114,69.2930029758],[18.3222104436,69.2948662991],[18.3223703095,69.2959080543],[18.321913175,69.2990512266],[18.3196033453,69.3006153177],[18.316225876,69.301345025],[18.3129093267,69.3015985862],[18.3120438234,69.3015608388],[18.3123091508,69.3023540973],[18.3135462775,69.3060505711],[18.3126620739,69.3134286428],[18.3082304749,69.3239615658],[18.3078331762,69.3330715817],[18.3092226103,69.3392189151],[18.3120865546,69.3447444533],[18.3157069815,69.3493451835],[18.3240068085,69.355201804],[18.3349744735,69.3594236557],[18.3502790116,69.3655401028],[18.3581399931,69.3684749879],[18.3732860915,69.37205964],[18.3823949745,69.3757608856],[18.3894436384,69.3777605421],[18.3921410679,69.3806366294],[18.3968417437,69.3833943676],[18.4001502469,69.3844377525],[18.4076127606,69.3847662965],[18.42176498,69.383379574],[18.4296604182,69.3821945795],[18.4350550891,69.3808213143],[18.4375144233,69.3793477432],[18.4385369113,69.3744986553],[18.4382546058,69.3699130393],[18.4377539304,69.3681814717],[18.4353887481,69.3660118148],[18.4346513414,69.3653352341],[18.4306618645,69.364952202],[18.42628723,69.3641213202],[18.4236035665,69.3635949524],[18.4193594431,69.3635821791],[18.4057174031,69.3638507074],[18.3993285063,69.364120938],[18.3928937629,69.3641021427],[18.3862544586,69.3636524889],[18.3709985808,69.3632255909],[18.3693465596,69.363161175],[18.3676341691,69.362711617],[18.3650210551,69.3617484806],[18.3640224574,69.3606090563],[18.3628739228,69.3585069715],[18.3648409462,69.3553304592],[18.3693670861,69.3527801557],[18.3726029601,69.3516067976],[18.3780878581,69.3508239764],[18.3815112701,69.3507827061],[18.3828462505,69.3500263352],[18.3881995307,69.3469929284],[18.3964439096,69.3281503106],[18.3972627051,69.3176854854],[18.4006339175,69.3078037301],[18.4067024345,69.2980269546],[18.4082323499,69.2850148936],[18.4102488233,69.282204554],[18.4116967209,69.28146351],[18.4125068899,69.281048895],[18.410576339,69.2798820889],[18.4154931061,69.2672312193],[18.4207578024,69.2646789928],[18.4280337147,69.2636559247],[18.4363402649,69.2635535914],[18.4414417728,69.2644563287],[18.4481278654,69.267524285],[18.4489689089,69.2684519345],[18.4502097845,69.2678746897],[18.4612293169,69.2627462163],[18.4688320973,69.2502442816],[18.4694018851,69.2468288379],[18.4685867851,69.2431245892],[18.458433567,69.23541223],[18.446265543,69.2261960717],[18.4344032251,69.2202582312],[18.4132545567,69.2133164302],[18.4105639874,69.2117865364],[18.4215881491,69.205393525],[18.4305132015,69.1970229747],[18.4471459654,69.1853707791],[18.4540422027,69.1783454959],[18.4605574598,69.1731481875],[18.4793519636,69.1627153604],[18.4936540898,69.1562505755],[18.4947681644,69.1557468462],[18.4637670218,69.1510897695],[18.4253431467,69.1437094219],[18.4096086318,69.1408917882],[18.4058600797,69.1401564902],[18.4026650556,69.1390863387],[18.400585695,69.1383718419],[18.3907174462,69.1372175418],[18.3730135176,69.1343276314],[18.354644689,69.1310171316],[18.3511354252,69.129844288],[18.3483725253,69.1286028644],[18.3475629947,69.1272693755],[18.3468134927,69.1253409868],[18.3476714461,69.1240289653],[18.3512772203,69.122879206],[18.3592148256,69.1213747532],[18.4247896826,69.1121990923],[18.4547599208,69.1076042358],[18.4840889563,69.102855031],[18.4919928606,69.1012368956],[18.5008772304,69.1019734815],[18.50575003,69.102197918],[18.5169071318,69.1020235572],[18.520040738,69.1017703399],[18.5245581392,69.0997883046],[18.5269628595,69.0987672475],[18.5287300162,69.0975433694],[18.5424127727,69.0961817563],[18.5489699424,69.0956144064],[18.551750543,69.0959886585],[18.5437474636,69.092524444],[18.5040776549,69.0772689523],[18.4881070475,69.0729238962],[18.4705757331,69.0712611842],[18.4261757965,69.0746876943],[18.4034678186,69.0767232694],[18.3814409386,69.0803255639],[18.3709005354,69.0837785897],[18.3604634381,69.0893661373],[18.355168522,69.0923985089],[18.350081195,69.0953476177],[18.3405974576,69.0985404299],[18.3301906826,69.1015131709],[18.3212139074,69.1022412716],[18.3112090809,69.1020388106],[18.3057618788,69.1011940065],[18.3031997609,69.1003726274],[18.3020353264,69.0999993238],[18.2989326412,69.0941224684],[18.2961626525,69.0933841959],[18.2925923437,69.0932153521],[18.2831877827,69.0940288162],[18.2757824504,69.0948827855],[18.270014582,69.0948344344],[18.2628621486,69.0944166142],[18.2594187156,69.0936113809],[18.2533184794,69.0883450205],[18.2484558045,69.0854294328],[18.245932789,69.0848440139],[18.2414808735,69.0846908201],[18.2323454164,69.0858130325],[18.2250687369,69.0875329819],[18.2116051074,69.0908723977],[18.2056380627,69.0939915844],[18.2039835151,69.0978216134],[18.2047837954,69.100260254],[18.2080619538,69.1029690876],[18.2118766725,69.1047973499],[18.2208928889,69.1073193909],[18.2347468379,69.1110558637],[18.238497251,69.1154175509],[18.2391160363,69.1180969232],[18.2370698375,69.1222513076],[18.2325188105,69.1259778327],[18.226662216,69.1313908815],[18.219264893,69.1354079048],[18.2172023715,69.1364754892],[18.2152438099,69.1397572124],[18.2126177973,69.1490666146],[18.208755713,69.1545206932],[18.2021352157,69.1578496259],[18.1938282857,69.1602992625],[18.1829891719,69.1621622719],[18.1718694276,69.1636339775],[18.1596896336,69.1639373055],[18.1562230279,69.1645548996],[18.1452427961,69.1685549319],[18.134286605,69.1742948853],[18.1298559465,69.1759583519],[18.1196466722,69.177647426],[18.0936318389,69.1808076926],[18.0839281145,69.1829603194],[18.0758101121,69.186904194],[18.0748909271,69.189848782],[18.0764023482,69.1926707798],[18.0800555966,69.1949005582],[18.086267686,69.1963326459],[18.0976713213,69.1982646828],[18.1068226413,69.1999993411],[18.1254375555,69.2025117273],[18.1375881904,69.2033988734],[18.1833987759,69.204537209],[18.1966995642,69.2041326636],[18.2089486301,69.20263863],[18.2240237888,69.2006950539],[18.2393664657,69.2005655307],[18.2501174607,69.2009962201],[18.2622957833,69.2020324163],[18.2677666355,69.2028785257],[18.2799030881,69.2051016004],[18.323313642,69.218121685],[18.3320948908,69.2201684575],[18.3134998513,69.2341412022],[18.2958376212,69.2470647165],[18.2964382663,69.248082162],[18.2968143053,69.2487191414]]},"properties":{"reinbeitebruker_id":"XI","fellesegenskaper.forstedatafangsdato":null,"fellesegenskaper.verifiseringsdato":"2015-01-01","fellesegenskaper.oppdateringsdato":null,"felles_egenskaper.opphav":"Reindriftsforvaltningen"}}');


insert into test(name) select name from json_populate_record(NULL::test, '{"name": "John","name2": "John"}');

drop table tull; 
create table tull (
	geom geometry,
	reinbeitebruker_id varchar(3), 
	"fellesegenskaper.forstedatafangsdato" date default now(), 
	"fellesegenskaper.verifiseringsdato" date default now(),
	"fellesegenskaper.oppdateringsdato" date default now(),
	"felles_egenskaper.opphav" varchar, 
	"felles_egenskaper.kvalitet.maalemetode" int 
);


CREATE TYPE topo_rein.simple_sosi_felles_egenskaper AS (
	"fellesegenskaper.forstedatafangsdato" date , 
	"fellesegenskaper.verifiseringsdato" date ,
	"fellesegenskaper.oppdateringsdato" date ,
	"felles_egenskaper.opphav" varchar, 
	"felles_egenskaper.kvalitet.maalemetode" int 
);

-- recreate a temp table to holde felles egenskaper from the json input
DROP TABLE IF EXISTS topo_rein.json_input_data;
CREATE table topo_rein.json_input_data OF topo_rein.simple_sosi_felles_egenskaper;

-- take the data from json and store 

create table test AS (
	SELECT 
	geom,
	(jp).reinbeitebruker_id,
	(jp)."fellesegenskaper.forstedatafangsdato",
	(jp)."fellesegenskaper.verifiseringsdato",
	(jp)."fellesegenskaper.oppdateringsdato",
	(jp)."felles_egenskaper.opphav",
	(jp)."felles_egenskaper.kvalitet.maalemetode"
	FROM
	(
		SELECT topo_rein.get_rein_felles_egenskaper(json_populate_record(NULL::topo_rein.simple_sosi_felles_egenskaper, e.properties)) as jp
		FROM (
			SELECT 
--				topo_rein.get_geom_from_json(feat,4258) as geom,
				to_json(feat->'properties')::json  as properties
			FROM (
			  	SELECT '{"type": "Feature","geometry":{"type":"LineString","crs":{"type":"name","properties":{"name":"EPSG:4258"}},"coordinates":[[18.2968143053,69.2487191414],[18.300482121,69.2500232984],[18.3033027731,69.25623823],[18.3000566291,69.2604319704],[18.2955963015,69.2645776875],[18.289870294,69.2683436731],[18.2880743318,69.2697550773],[18.2879922858,69.2727485469],[18.288102813,69.2743611448],[18.2894379697,69.2760928398],[18.2911630945,69.2786244977],[18.3002841539,69.2848143943],[18.3091026595,69.2889912546],[18.314431421,69.2905038971],[18.3203146114,69.2930029758],[18.3222104436,69.2948662991],[18.3223703095,69.2959080543],[18.321913175,69.2990512266],[18.3196033453,69.3006153177],[18.316225876,69.301345025],[18.3129093267,69.3015985862],[18.3120438234,69.3015608388],[18.3123091508,69.3023540973],[18.3135462775,69.3060505711],[18.3126620739,69.3134286428],[18.3082304749,69.3239615658],[18.3078331762,69.3330715817],[18.3092226103,69.3392189151],[18.3120865546,69.3447444533],[18.3157069815,69.3493451835],[18.3240068085,69.355201804],[18.3349744735,69.3594236557],[18.3502790116,69.3655401028],[18.3581399931,69.3684749879],[18.3732860915,69.37205964],[18.3823949745,69.3757608856],[18.3894436384,69.3777605421],[18.3921410679,69.3806366294],[18.3968417437,69.3833943676],[18.4001502469,69.3844377525],[18.4076127606,69.3847662965],[18.42176498,69.383379574],[18.4296604182,69.3821945795],[18.4350550891,69.3808213143],[18.4375144233,69.3793477432],[18.4385369113,69.3744986553],[18.4382546058,69.3699130393],[18.4377539304,69.3681814717],[18.4353887481,69.3660118148],[18.4346513414,69.3653352341],[18.4306618645,69.364952202],[18.42628723,69.3641213202],[18.4236035665,69.3635949524],[18.4193594431,69.3635821791],[18.4057174031,69.3638507074],[18.3993285063,69.364120938],[18.3928937629,69.3641021427],[18.3862544586,69.3636524889],[18.3709985808,69.3632255909],[18.3693465596,69.363161175],[18.3676341691,69.362711617],[18.3650210551,69.3617484806],[18.3640224574,69.3606090563],[18.3628739228,69.3585069715],[18.3648409462,69.3553304592],[18.3693670861,69.3527801557],[18.3726029601,69.3516067976],[18.3780878581,69.3508239764],[18.3815112701,69.3507827061],[18.3828462505,69.3500263352],[18.3881995307,69.3469929284],[18.3964439096,69.3281503106],[18.3972627051,69.3176854854],[18.4006339175,69.3078037301],[18.4067024345,69.2980269546],[18.4082323499,69.2850148936],[18.4102488233,69.282204554],[18.4116967209,69.28146351],[18.4125068899,69.281048895],[18.410576339,69.2798820889],[18.4154931061,69.2672312193],[18.4207578024,69.2646789928],[18.4280337147,69.2636559247],[18.4363402649,69.2635535914],[18.4414417728,69.2644563287],[18.4481278654,69.267524285],[18.4489689089,69.2684519345],[18.4502097845,69.2678746897],[18.4612293169,69.2627462163],[18.4688320973,69.2502442816],[18.4694018851,69.2468288379],[18.4685867851,69.2431245892],[18.458433567,69.23541223],[18.446265543,69.2261960717],[18.4344032251,69.2202582312],[18.4132545567,69.2133164302],[18.4105639874,69.2117865364],[18.4215881491,69.205393525],[18.4305132015,69.1970229747],[18.4471459654,69.1853707791],[18.4540422027,69.1783454959],[18.4605574598,69.1731481875],[18.4793519636,69.1627153604],[18.4936540898,69.1562505755],[18.4947681644,69.1557468462],[18.4637670218,69.1510897695],[18.4253431467,69.1437094219],[18.4096086318,69.1408917882],[18.4058600797,69.1401564902],[18.4026650556,69.1390863387],[18.400585695,69.1383718419],[18.3907174462,69.1372175418],[18.3730135176,69.1343276314],[18.354644689,69.1310171316],[18.3511354252,69.129844288],[18.3483725253,69.1286028644],[18.3475629947,69.1272693755],[18.3468134927,69.1253409868],[18.3476714461,69.1240289653],[18.3512772203,69.122879206],[18.3592148256,69.1213747532],[18.4247896826,69.1121990923],[18.4547599208,69.1076042358],[18.4840889563,69.102855031],[18.4919928606,69.1012368956],[18.5008772304,69.1019734815],[18.50575003,69.102197918],[18.5169071318,69.1020235572],[18.520040738,69.1017703399],[18.5245581392,69.0997883046],[18.5269628595,69.0987672475],[18.5287300162,69.0975433694],[18.5424127727,69.0961817563],[18.5489699424,69.0956144064],[18.551750543,69.0959886585],[18.5437474636,69.092524444],[18.5040776549,69.0772689523],[18.4881070475,69.0729238962],[18.4705757331,69.0712611842],[18.4261757965,69.0746876943],[18.4034678186,69.0767232694],[18.3814409386,69.0803255639],[18.3709005354,69.0837785897],[18.3604634381,69.0893661373],[18.355168522,69.0923985089],[18.350081195,69.0953476177],[18.3405974576,69.0985404299],[18.3301906826,69.1015131709],[18.3212139074,69.1022412716],[18.3112090809,69.1020388106],[18.3057618788,69.1011940065],[18.3031997609,69.1003726274],[18.3020353264,69.0999993238],[18.2989326412,69.0941224684],[18.2961626525,69.0933841959],[18.2925923437,69.0932153521],[18.2831877827,69.0940288162],[18.2757824504,69.0948827855],[18.270014582,69.0948344344],[18.2628621486,69.0944166142],[18.2594187156,69.0936113809],[18.2533184794,69.0883450205],[18.2484558045,69.0854294328],[18.245932789,69.0848440139],[18.2414808735,69.0846908201],[18.2323454164,69.0858130325],[18.2250687369,69.0875329819],[18.2116051074,69.0908723977],[18.2056380627,69.0939915844],[18.2039835151,69.0978216134],[18.2047837954,69.100260254],[18.2080619538,69.1029690876],[18.2118766725,69.1047973499],[18.2208928889,69.1073193909],[18.2347468379,69.1110558637],[18.238497251,69.1154175509],[18.2391160363,69.1180969232],[18.2370698375,69.1222513076],[18.2325188105,69.1259778327],[18.226662216,69.1313908815],[18.219264893,69.1354079048],[18.2172023715,69.1364754892],[18.2152438099,69.1397572124],[18.2126177973,69.1490666146],[18.208755713,69.1545206932],[18.2021352157,69.1578496259],[18.1938282857,69.1602992625],[18.1829891719,69.1621622719],[18.1718694276,69.1636339775],[18.1596896336,69.1639373055],[18.1562230279,69.1645548996],[18.1452427961,69.1685549319],[18.134286605,69.1742948853],[18.1298559465,69.1759583519],[18.1196466722,69.177647426],[18.0936318389,69.1808076926],[18.0839281145,69.1829603194],[18.0758101121,69.186904194],[18.0748909271,69.189848782],[18.0764023482,69.1926707798],[18.0800555966,69.1949005582],[18.086267686,69.1963326459],[18.0976713213,69.1982646828],[18.1068226413,69.1999993411],[18.1254375555,69.2025117273],[18.1375881904,69.2033988734],[18.1833987759,69.204537209],[18.1966995642,69.2041326636],[18.2089486301,69.20263863],[18.2240237888,69.2006950539],[18.2393664657,69.2005655307],[18.2501174607,69.2009962201],[18.2622957833,69.2020324163],[18.2677666355,69.2028785257],[18.2799030881,69.2051016004],[18.323313642,69.218121685],[18.3320948908,69.2201684575],[18.3134998513,69.2341412022],[18.2958376212,69.2470647165],[18.2964382663,69.248082162],[18.2968143053,69.2487191414]]},"properties":{"reinbeitebruker_id":"XI","fellesegenskaper.forstedatafangsdato":null,"fellesegenskaper.verifiseringsdato":"2015-01-01","fellesegenskaper.oppdateringsdato":null,"felles_egenskaper.opphav":"Reindriftsforvaltningen"}}'::json AS feat
			) AS f
		) AS e
	) AS g
) ;


SELECT topo_rein.get_rein_felles_egenskaper(json_populate_record(NULL::topo_rein.simple_sosi_felles_egenskaper,'{"reinbeitebruker_id":"XI","fellesegenskaper.forstedatafangsdato":null,"fellesegenskaper.verifiseringsdato":"2015-01-01","fellesegenskaper.oppdateringsdato":null,"felles_egenskaper.opphav":"Reindriftsforvaltningen"}')) as jp

select 	topo_rein.get_rein_felles_egenskaper(json_populate_record(NULL::topo_rein.simple_sosi_felles_egenskaper, properties)) AS felles_egenskaper 
from topo_rein.ttt_new_attributes_values ;

 (2015-01-01,,"(,,)",2015-11-04,Reindriftsforvaltningen,2015-01-01,,"(,)")
 	

select * from (
select o. forstedatafangstdato, k.verifiseringsdato, ST_Area(ST_Intersection(o.geo, k.geo)) area
from 
org_rein_korr.rein_korr_arstidsbeite_var_flate k,
org_rein.rein_arstidsbeite_var_flate o
WHERE ST_Intersects(o.geo, k.geo)
) as e
order by area desc;


select * from (
select o.forstedatafangstdato, k.forstedatafangstdato, ST_Area(ST_Intersection(o.geo, k.geo)) area
from 
org_rein.rein_arstidsbeite_var_flate k,
org_rein.rein_arstidsbeite_var_flate o
WHERE ST_Intersects(o.geo, k.geo) and k.objectid != o.objectid 
) as e
order by area desc;

2016-01-09 09:43:28 CET sl postgres LOG:  duration: 6941.939 ms  execute <unnamed>: select * from topo_rein.query_to_topojson($1,$2,$3,$4) as result
2016-01-09 09:43:28 CET sl postgres DETAIL:  parameters: $1 = 'select distinct a.* from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl WHERE fa.mbr && ST_GeomFromEWKT(''POLYGON ((14.731915357069346 68.73543423032712, 14.706943639062358 70.62514239649883, 26.2961257834157 70.27165556435162, 25.35531311528691 68.41541900203234, 14.731915357069346 68.73543423032712))'') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = ''topo_rein'' AND tl.table_name = ''arstidsbeite_var_flate'' and fa.face_id=re.element_id', $2 = '32633', $3 = '0', $4 = ''


select count(distinct a.*) from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl 
WHERE fa.mbr && ST_GeomFromEWKT('POLYGON ((14.731915357069346 68.73543423032712, 14.706943639062358 70.62514239649883, 26.2961257834157 70.27165556435162, 25.35531311528691 68.41541900203234, 14.731915357069346 68.73543423032712))') AND 
topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = 'topo_rein' AND tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id
count 
-------
   380
(1 row)
Time: 75.910 ms

select count(*) from topo_rein.query_to_topojson('select distinct a.* from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl WHERE fa.mbr && ST_GeomFromEWKT(''POLYGON ((14.731915357069346 68.73543423032712, 14.706943639062358 70.62514239649883, 26.2961257834157 70.27165556435162, 25.35531311528691 68.41541900203234, 14.731915357069346 68.73543423032712))'') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = ''topo_rein'' AND tl.table_name = ''arstidsbeite_var_flate'' and fa.face_id=re.element_id',32633,0);
count 
-------
     1
(1 row)
Time: 7571.697 ms

-- This is how the sql is called from the code execpt that we do not get length but the topJson
select length(topo_rein.query_to_topojson('select distinct a.* from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl WHERE fa.mbr && ST_GeomFromEWKT(''POLYGON ((9.609839108612533 67.70153849237619, 8.564405958195684 71.4611114249892, 32.60829816266885 70.72892872531436, 29.86836714875339 67.09878623581699, 9.609839108612533 67.70153849237619))'') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = ''topo_rein'' AND tl.table_name = ''arstidsbeite_var_flate'' and fa.face_id=re.element_id',32633,0));
 length  
---------
 5949302
(1 row)
Time: 16156.707 ms

-- Here is sql that is used find the rows to be used
select count(distinct a.*) from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl
WHERE fa.mbr && ST_GeomFromEWKT('POLYGON ((9.609839108612533 67.70153849237619, 8.564405958195684 71.4611114249892, 32.60829816266885 70.72892872531436, 29.86836714875339 67.09878623581699, 9.609839108612533 67.70153849237619))') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = 'topo_rein' AND tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id
 count 
-------
   518
(1 row)
Time: 83.224 ms

Lars

SELECT count(*) from  topo_rein.arstidsbeite_var_topojson_flate_v ;
 count 
-------
   669
(1 row)

Time: 5.329 ms

select count(a.*) from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl
WHERE fa.mbr && ST_GeomFromEWKT('POLYGON ((9.609839108612533 67.70153849237619, 8.564405958195684 71.4611114249892, 32.60829816266885 70.72892872531436, 29.86836714875339 67.09878623581699, 9.609839108612533 67.70153849237619))') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = 'topo_rein' AND tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id
count 
-------
  6183
(1 row)

Time: 69.115 ms
select ST_Area(ST_collect(omrade::geometry))
FROM (select distinct a.omrade from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl
WHERE fa.mbr && ST_GeomFromEWKT('POLYGON ((9.609839108612533 67.70153849237619, 8.564405958195684 71.4611114249892, 32.60829816266885 70.72892872531436, 29.86836714875339 67.09878623581699, 9.609839108612533 67.70153849237619))') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = 'topo_rein' AND tl.table_name = 'arstidsbeite_var_flate' and fa.face_id=re.element_id) as e
 st_area      
------------------
 7.85539947401677
(1 row)
Time: 6960.298 ms


LOCATION:  exec_stmt_raise, pl_exec.c:3068
 simplefeature_2_topo_surface 
------------------------------
                         7734
(1 row)


PL/pgSQL function org_rein_sosi_dump.simplefeature_2_topo_surface(text,text,text,text,text,text,text,double precision,geometry) line 61 at EXECUTE statement
LOCATION:  exec_stmt_raise, pl_exec.c:3068
 simplefeature_2_topo_surface 
------------------------------
                          615
(1 row)


 select * from topo_rein.query_to_topojson($1,$2,$3,$4) as result
2016-01-12 10:31:55 CET sl postgres DETAIL:  parameters: $1 = '', $2 = '32633', $3 = '0', $4 = ''

select length(distinct a.*) from 



-- slow point 

select length(topo_rein.query_to_topojson('select distinct a.* from topo_rein.reindrift_anlegg_topojson_punkt_v a WHERE punkt && ST_GeomFromEWKT(''POLYGON ((14.731849535959158 68.74091225084454, 14.707023216094898 70.61966557245924, 26.29313720651251 70.26628453761084, 25.357800597570975 68.42080802992255, 14.731849535959158 68.74091225084454))'') ',32633,0));
length 
--------
 559330
(1 row)

Time: 8605.793 ms

select count(distinct a.*) from topo_rein.reindrift_anlegg_topojson_punkt_v a WHERE punkt && ST_GeomFromEWKT('POLYGON ((14.731849535959158 68.74091225084454, 14.707023216094898 70.61966557245924, 26.29313720651251 70.26628453761084, 25.357800597570975 68.42080802992255, 14.731849535959158 68.74091225084454))');
 count 
-------
  1477
(1 row)

Time: 668.624 ms

select count(distinct a.*) from topo_rein.reindrift_anlegg_topojson_punkt_v a, topo_rein_sysdata_ran.node fa, topo_rein_sysdata_ran.relation re, topology.layer tl[more] - > WHERE fa.geom && ST_GeomFromEWKT('POLYGON ((14.731849535959158 68.74091225084454, 14.707023216094898 70.61966557245924, 26.29313720651251 70.26628453761084, 25.357800597570975 68.42080802992255, 14.731849535959158 68.74091225084454))')
AND topo_rein.get_relation_id(a.punkt) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = 'topo_rein' AND tl.table_name = 'reindrift_anlegg_punkt' AND fa.node_id=re.element_id
 count 
-------
  1477
(1 row)

Time: 19.359 ms


select length(topo_rein.query_to_topojson('select distinct a.* from topo_rein.reindrift_anlegg_topojson_punkt_v a, topo_rein_sysdata_ran.node fa, topo_rein_sysdata_ran.relation re, topology.layer tl WHERE fa.geom && ST_GeomFromEWKT(''POLYGON ((14.731849535959158 68.74091225084454, 14.707023216094898 70.61966557245924, 26.29313720651251 70.26628453761084, 25.357800597570975 68.42080802992255, 14.731849535959158 68.74091225084454))'')AND topo_rein.get_relation_id(a.punkt) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = ''topo_rein'' AND tl.table_name = ''reindrift_anlegg_punkt'' AND fa.node_id=re.element_id',32633,0));
 length 
--------
 559330
(1 row)

Time: 1062.557 ms


select * from topo_rein.query_to_topojson('select distinct a.* from topo_rein.arstidsbeite_var_topojson_flate_v a limit 1',32633,0);


select count(*) from topo_rein.query_to_topojson('select distinct a.* from topo_rein.arstidsbeite_var_topojson_flate_v a ,topo_rein_sysdata.face fa, topo_rein_sysdata.relation re, topology.layer tl WHERE fa.mbr && ST_GeomFromEWKT(''POLYGON ((14.731915357069346 68.73543423032712, 14.706943639062358 70.62514239649883, 26.2961257834157 70.27165556435162, 25.35531311528691 68.41541900203234, 14.731915357069346 68.73543423032712))'') AND topo_rein.get_relation_id(a.omrade) = re.topogeo_id AND re.layer_id = tl.layer_id AND tl.schema_name = ''topo_rein'' AND tl.table_name = ''arstidsbeite_var_flate'' and fa.face_id=re.element_id',32633,0);


