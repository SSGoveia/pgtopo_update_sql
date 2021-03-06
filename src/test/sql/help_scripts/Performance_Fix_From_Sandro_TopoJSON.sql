CREATE OR REPLACE FUNCTION topology.AsTopoJSON(tg topology.TopoGeometry, edgeMapTable regclass)
  RETURNS text AS
$$
DECLARE
  toponame text;
  json text;
  sql text;
  bounds GEOMETRY;
  rec RECORD;
  rec2 RECORD;
  side int;
  arcid int;
  arcs int[];
  ringtxt TEXT[];
  comptxt TEXT[];
  edges_found BOOLEAN;
  old_search_path TEXT;
  all_faces int[];
  faces int[];
  bounding_edges int[];
  visited_face int;
  shell_faces int[];
  visited_edges int[];
  looking_for_holes BOOLEAN;
BEGIN

  IF tg IS NULL THEN
    RETURN NULL;
  END IF;

  -- Get topology name (for subsequent queries)
  SELECT name FROM topology.topology into toponame
              WHERE id = tg.topology_id;

  -- TODO: implement scale ?

  -- Puntal TopoGeometry, simply delegate to AsGeoJSON
  IF tg.type = 1 THEN
    json := ST_AsGeoJSON(topology.Geometry(tg));
    return json;
  ELSIF tg.type = 2 THEN -- lineal

    FOR rec IN SELECT (ST_Dump(topology.Geometry(tg))).geom
    LOOP -- {

      sql := 'SELECT e.*, ST_LineLocatePoint($1'
            || ', ST_LineInterpolatePoint(e.geom, 0.2)) as pos'
            || ', ST_LineLocatePoint($1'
            || ', ST_LineInterpolatePoint(e.geom, 0.8)) as pos2 FROM '
            || quote_ident(toponame)
            || '.edge e WHERE ST_Covers($1'
            || ', e.geom) ORDER BY pos';
            -- TODO: add relation to the conditional, to reduce load ?
      FOR rec2 IN EXECUTE sql USING rec.geom
      LOOP -- {

        IF edgeMapTable IS NOT NULL THEN
          sql := 'SELECT arc_id-1 FROM ' || edgeMapTable::text || ' WHERE edge_id = $1';
          EXECUTE sql INTO arcid USING rec2.edge_id;
          IF arcid IS NULL THEN
            EXECUTE 'INSERT INTO ' || edgeMapTable::text
              || '(edge_id) VALUES ($1) RETURNING arc_id-1'
            INTO arcid USING rec2.edge_id;
          END IF;
        ELSE
          arcid := rec2.edge_id;
        END IF;

        -- edge goes in opposite direction
        IF rec2.pos2 < rec2.pos THEN
          arcid := -(arcid+1);
        END IF;

        arcs := arcs || arcid;

      END LOOP; -- }

      comptxt := comptxt || ( '[' || array_to_string(arcs, ',') || ']' );
      arcs := NULL;

    END LOOP; -- }

    json := '{ "type": "MultiLineString", "arcs": [' || array_to_string(comptxt,',') || ']}';

    return json;

  ELSIF tg.type = 3 THEN -- areal

    json := '{ "type": "MultiPolygon", "arcs": [';

    EXECUTE 'SHOW search_path' INTO old_search_path;
    EXECUTE 'SET search_path TO ' || quote_ident(toponame) || ',' || old_search_path;

    SELECT array_agg(id) as f
    FROM ( SELECT (topology.GetTopoGeomElements(tg))[1] as id ) as f
    INTO all_faces;


    visited_edges := ARRAY[]::int[];
    faces := all_faces;
    looking_for_holes := false;
    shell_faces := ARRAY[]::int[];

    SELECT array_agg(edge_id)
    FROM edge_data e
    WHERE
         ( e.left_face = ANY ( faces ) OR
           e.right_face = ANY ( faces ) )
    INTO bounding_edges;

    LOOP -- {

      arcs := NULL;
      edges_found := false;


      FOR rec in -- {
WITH RECURSIVE
_edges AS (
  SELECT e.*, 
         e.left_face = ANY ( faces ) as lf,
         e.right_face = ANY ( faces ) as rf
  FROM edge e
  WHERE edge_id = ANY (bounding_edges)
          AND NOT e.edge_id = ANY ( visited_edges )
),
_leftmost_non_dangling_edge AS (
  SELECT e.* FROM _edges e WHERE e.lf != e.rf
  ORDER BY geom LIMIT 1
),
_edgepath AS (
  SELECT
    CASE
      WHEN e.lf THEN lme.edge_id
      ELSE -lme.edge_id
    END as signed_edge_id,
    false as back,

    e.lf = e.rf as dangling,
    e.left_face, e.right_face,
    e.lf, e.rf,
    e.next_right_edge, e.next_left_edge

  FROM _edges e, _leftmost_non_dangling_edge lme
  WHERE e.edge_id = abs(lme.edge_id)
    UNION
  SELECT
    CASE
      WHEN p.dangling AND NOT p.back THEN -p.signed_edge_id
      WHEN p.signed_edge_id < 0 THEN p.next_right_edge
      ELSE p.next_left_edge
    END, -- signed_edge_id
    CASE
      WHEN p.dangling AND NOT p.back THEN true
      ELSE false
    END, -- back

    e.lf = e.rf, -- dangling
    e.left_face, e.right_face,
    e.lf, e.rf,
    e.next_right_edge, e.next_left_edge

  FROM _edges e, _edgepath p
  WHERE
    e.edge_id = CASE
      WHEN p.dangling AND NOT p.back THEN abs(p.signed_edge_id)
      WHEN p.signed_edge_id < 0 THEN abs(p.next_right_edge)
      ELSE abs(p.next_left_edge)
    END
)
SELECT abs(signed_edge_id) as edge_id, signed_edge_id, dangling,
        lf, rf, left_face, right_face
FROM _edgepath
      LOOP  -- }{



        IF rec.left_face = ANY (all_faces) AND NOT rec.left_face = ANY (shell_faces) THEN
          shell_faces := shell_faces || rec.left_face;
        END IF;

        IF rec.right_face = ANY (all_faces) AND NOT rec.right_face = ANY (shell_faces) THEN
          shell_faces := shell_faces || rec.right_face;
        END IF;

        visited_edges := visited_edges || rec.edge_id;

        edges_found := true;

        -- TODO: drop ?
        IF rec.dangling THEN
          CONTINUE;
        END IF;

        IF rec.left_face = ANY (all_faces) AND rec.right_face = ANY (all_faces) THEN
          CONTINUE;
        END IF;

        IF edgeMapTable IS NOT NULL THEN
          sql := 'SELECT arc_id-1 FROM ' || edgeMapTable::text || ' WHERE edge_id = $1';
          EXECUTE sql INTO arcid USING rec.edge_id;
          IF arcid IS NULL THEN
            EXECUTE 'INSERT INTO ' || edgeMapTable::text
              || '(edge_id) VALUES ($1) RETURNING arc_id-1'
            INTO arcid USING rec.edge_id;
          END IF;
        ELSE
          arcid := rec.edge_id-1;
        END IF;

        -- Swap sign, use two's complement for negative edges
        IF rec.signed_edge_id >= 0 THEN
          arcid := - ( arcid + 1 );
        END IF;


        arcs := arcid || arcs;

      END LOOP; -- }


      IF NOT edges_found THEN
        IF looking_for_holes THEN
          looking_for_holes := false;
          comptxt := comptxt || ( '[' || array_to_string(ringtxt, ',') || ']' );
          ringtxt := NULL;
          faces := all_faces;
          shell_faces := ARRAY[]::int[];
        ELSE
          EXIT; -- end of loop
        END IF;
      ELSE
        faces := shell_faces;
        IF arcs IS NOT NULL THEN
          ringtxt := ringtxt || ( '[' || array_to_string(arcs,',') || ']' );
        END IF;
        looking_for_holes := true;
      END IF;

    END LOOP; -- }

    json := json || array_to_string(comptxt, ',') || ']}';

    EXECUTE 'SET search_path TO ' || old_search_path;


  ELSIF tg.type = 4 THEN -- collection
    RAISE EXCEPTION 'Collection TopoGeometries are not supported by AsTopoJSON';

  END IF;
	
  RETURN json;
	
END
$$ LANGUAGE 'plpgsql' VOLATILE; -- writes into visited table

