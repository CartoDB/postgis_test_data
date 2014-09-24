-- lines_low_density_big_set_many_vertex
DROP TABLE IF EXISTS case_lines_world_100kf_5kv;
CREATE TABLE case_lines_world_100kf_5kv (
  cartodb_id serial primary key, the_geom_webmercator geometry
);
INSERT INTO case_lines_world_100kf_5kv (the_geom_webmercator)
WITH curve AS (
  SELECT ST_Scale(
    ST_Segmentize(
      ST_OffsetCurve(
        ST_OffsetCurve(ST_MakeLine(g),100000)
        ,-50000
      ), 750), 0.4, 0.25
    ) g
  FROM (
    SELECT ST_SetSRID(ST_MakePoint(n+(100000*cos(n)-500000*sin(n)+n/4), n/2-(n/20*cos(n))), 3857) g
    FROM generate_series(0,2500000,100000) n
  ) pts
)
SELECT
  ST_Translate(g, x, y) as the_geom_webmercator
FROM 
   curve,
   generate_series(-20037500, 0, 980000) x, generate_series(-20037500, 0, 18000) y
;
INSERT INTO case_lines_world_100kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 0, 20037500)
FROM case_lines_world_100kf_5kv;
INSERT INTO case_lines_world_100kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 20037500, 0)
FROM case_lines_world_100kf_5kv;
CREATE INDEX ON case_lines_world_100kf_5kv USING GiST (the_geom_webmercator);
--SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_lines_world_1kf_5kv;

