------- Handle Årstidsbeiter - Vårbeite
-- from: org_rein_korr.rein_korr_arstidsbeite_var_flate 
-- to: topo_rein.arstidsbeite_var_grense and topo_rein.arstidsbeite_var_flate

-- Add surface with no attributtes


SELECT topo_update.create_surface_edge_domain_obj(ST_setSrid(ST_transform(geo,4258),4258))  FROM 
--SELECT ST_AsText(ST_setSrid(ST_transform(geo,4258),4258))  FROM 
( 
	SELECT ST_ExteriorRing(b.geo) AS geo, objectid, 1 as type_geo 
	FROM org_rein_korr.rein_korr_arstidsbeite_var_flate b
--	WHERE ST_NumInteriorRings(b.geo) > 1
	UNION
	SELECT ST_InteriorRingN(c.geo,generate_series(1,ST_NumInteriorRings(c.geo))) as geo, objectid, 2 as type_geo
	FROM org_rein_korr.rein_korr_arstidsbeite_var_flate c
--	WHERE ST_NumInteriorRings(c.geo) > 1
) as r 
--where objectid = 964;
ORDER BY objectid, type_geo;

-- Pick up surface attributtes  and set them by using json
SELECT topo_update.apply_attr_on_topo_surface(f.a) 
FROM (
 	SELECT 
 	'{"type": "Feature",' || 
-- 	'"geometry":' || ST_AsGeoJSON(geo,10,2)::json || ',' ||
 	'"properties":' || row_to_json((SELECT l FROM (SELECT id,reinbeitebruker_id, reindrift_sesongomrade_kode) As l )) || '}' as a
FROM 	
( 
SELECT
r.id,
k.beitebrukerid AS reinbeitebruker_id, 
k.sesomr AS reindrift_sesongomrade_kode, 
ST_setSrid(ST_transform(ST_PointOnSurface(k.geo),4258),4258) AS geo 
FROM 
org_rein_korr.rein_korr_arstidsbeite_var_flate k , 
topo_rein.arstidsbeite_var_flate r
WHERE ST_Intersects(r.omrade::geometry,ST_setSrid(ST_transform(ST_PointOnSurface(k.geo),4258),4258)) 
) as lg
) as f

-- delete holes
delete from topo_rein.arstidsbeite_var_flate where reinbeitebruker_id is null;

------- Gjerder og Anlegg linje
-- from: org_rein_korr.rein_korr_drift_anlegg_linje 
-- to: topo_rein.reindrift_anlegg_linje

SELECT topo_update.create_line_edge_domain_obj(f.a) 
select f.a
FROM (
 	SELECT 
 	'{"type": "Feature",' || 
 	'"geometry":' || ST_AsGeoJSON(ST_setSrid(ST_transform(geo,4258),4258),10,2)::json || ',' ||
 	'"properties":' || row_to_json((SELECT l FROM (SELECT reinbeitebruker_id, reindriftsanleggstype) As l )) || '}' as a,
 	ST_setSrid(ST_transform(geo,4258),4258) as geo
FROM 
( 
SELECT beitebrukerid AS reinbeitebruker_id, reindriftanltyp AS reindriftsanleggstype, geo 
FROM org_rein_korr.rein_korr_drift_anlegg_linje
where reindriftanltyp != 99
ORDER BY objectid
) 
AS lg
) As f;


------- Gjerder og Anlegg punkt
-- from: org_rein_korr.rein_korr_drift_anlegg_punkt 
-- to: topo_rein.reindrift_anlegg_punkt

SELECT topo_update.create_point_point_domain_obj(f.a) 
SELECT f.a
FROM (
 	SELECT 
 	'{"type": "Feature",' || 
 	'"geometry":' || ST_AsGeoJSON(ST_setSrid(ST_transform(geo,4258),4258),10,2)::json || ',' ||
 	'"properties":' || row_to_json((SELECT l FROM (SELECT reinbeitebruker_id, reindriftsanleggstype) As l )) || '}' as a,
 	ST_setSrid(ST_transform(geo,4258),4258) as geo
FROM 
( 
SELECT beitebrukerid AS reinbeitebruker_id, reindriftanltyp AS reindriftsanleggstype, geo 
FROM org_rein_korr.rein_korr_drift_anlegg_punkt
where reindriftanltyp != 99 and length(beitebrukerid) < 4
ORDER BY objectid
) 
AS lg
) As f;