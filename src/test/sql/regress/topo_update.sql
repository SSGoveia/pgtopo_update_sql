-- Repeat all tests with the new function names.
SELECT '1', ST_length(topology.toTopoGeom('SRID=4258;LINESTRING (5.70182 58.55131, 5.70368 58.55134, 5.70403 58.553751)', 'topo_rein_sysdata', (SELECT tl.layer_id FROM topology.layer tl WHERE tl.schema_name = 'topo_rein' AND tl.table_name = 'reindrift_anlegg_linje'), 0.0000000001));
SELECT '2', ST_length(topology.toTopoGeom('SRID=4258;LINESTRING (5.70182 58.55131, 5.70368 58.55134, 5.70403 58.553751, 5.705207 58.552386)', 'topo_rein_sysdata', (SELECT tl.layer_id FROM topology.layer tl WHERE tl.schema_name = 'topo_rein' AND tl.table_name = 'reindrift_anlegg_linje'), 0.0000000001)); 
SELECT '3', topo_update.create_surface_edge_domain_obj('{"type": "Feature","geometry":{"type":"LineString","crs":{"type":"name","properties":{"name":"EPSG:4258"}},"coordinates":[[18.3342803675,69.1937360885],[18.3248972004,69.1926352514],[18.3225223088,69.1928235904],[18.3172506318,69.1941599626],[18.3145519815,69.1957316656],[18.3123602886,69.1980059858],[18.310704822,69.2011722899],[18.3080083628,69.2036461481],[18.3052533657,69.2074983075],[18.3057756447,69.2082956989],[18.3075330509,69.2093067972],[18.3103134457,69.2100132313],[18.3156403748,69.2107656476],[18.3228118186,69.2113399389],[18.3301412606,69.2111984614],[18.3349532259,69.2112004097],[18.3395639862,69.2116335442],[18.3433515794,69.2127948707],[18.3502828982,69.2152724054],[18.3524811669,69.2156570867],[18.3547763375,69.2158024362],[18.3580354423,69.2152640418],[18.3623692173,69.2138971761],[18.3678152295,69.2110837518],[18.3695071064,69.2082009883],[18.3680734909,69.2067092134],[18.3638755844,69.2028967661],[18.355530639,69.1981677188],[18.3471464882,69.1957662158],[18.3342803675,69.1937360885]]}}');
SELECT '4', topo_update.create_line_edge_domain_obj('{"type": "Feature","geometry":{"type":"LineString","crs":{"type":"name","properties":{"name":"EPSG:4258"}},"coordinates":[[5.70182,58.55131],[5.70368,58.55134],[5.70403,58.553751]]}}');
SELECT '5', SUM(ST_Length(geom)), count(*) from topo_rein_sysdata.edge_data;
SELECT '6', SUM(ST_Length(linje::geometry)), count(*) from topo_rein.reindrift_anlegg_linje;
SELECT '7', topo_update.create_line_edge_domain_obj('{"type": "Feature","geometry":{"type":"LineString","crs":{"type":"name","properties":{"name":"EPSG:4258"}},"coordinates":[[5.700371,58.552619],[5.705207,58.552386]]}}');
SELECT '8', SUM(ST_Length(geom)), count(*) from topo_rein_sysdata.edge_data;
SELECT '9', SUM(ST_Length(linje::geometry)), count(*) from topo_rein.reindrift_anlegg_linje;
SELECT '10', topo_update.create_line_edge_domain_obj('{"type": "Feature","geometry":{"type":"LineString","crs":{"type":"name","properties":{"name":"EPSG:4258"}},"coordinates":[[15.9657743158,68.5173276573],[15.967341771,68.5175244919],[15.9707442177,68.5176731338],[15.973023534,68.5173234018],[15.9742820186,68.516710382],[15.9747133486,68.5160684285],[15.974409086,68.5153971067],[15.9733312891,68.5142292209],[15.9727112129,68.5130578708],[15.970050698,68.5124466358],[15.9661982366,68.5122599406],[15.9640955173,68.5121580206]]},"properties":{"reinbeitebruker_id":"XA","reindriftsanleggstype":4,"felles_egenskaper.forstedatafangsdato":null,"felles_egenskaper.verifiseringsdato":"2015-01-01","felles_egenskaper.oppdateringsdato":null,"felles_egenskaper.opphav":"Reindriftsforvaltningen","felles_egenskaper.kvalitet.maalemetode":82}}');
SELECT '11', SUM(ST_Length(geom)), count(*) from topo_rein_sysdata.edge_data;
SELECT '12', id, (md5(t\:\:TEXT)) from topo_rein.reindrift_anlegg_linje t order by id;
