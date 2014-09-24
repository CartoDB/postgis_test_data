-- lines_low_density_big_set_little_vertex
DROP TABLE IF EXISTS case_lines_world_100kf_10v;
CREATE TABLE case_lines_world_100kf_10v (
  cartodb_id serial primary key, the_geom_webmercator geometry
);
INSERT INTO case_lines_world_100kf_10v (the_geom_webmercator)
WITH curve AS (
  SELECT ST_SetSRID(
    ST_Scale(
      ST_MakeLine(g),
      0.45,0.2
    ), 3857) g
  FROM (
    SELECT ST_MakePoint(n+100000*cos(n), n+400000*cos(n+10000)) g
    FROM generate_series(0,2500000,250000) n
  ) pts
)
SELECT
  ST_Translate(g, x, y) as the_geom_webmercator
FROM 
   curve,
   generate_series(-20037500, 0, 980000) x, generate_series(-20037500, 0, 18000) y
   --generate_series(0, 0, 980000) x, generate_series(0, 0, 18000) y
;
INSERT INTO case_lines_world_100kf_10v(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 0, 20037500)
FROM case_lines_world_100kf_10v;
INSERT INTO case_lines_world_100kf_10v(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 20037500, 0)
FROM case_lines_world_100kf_10v;
CREATE INDEX ON case_lines_world_100kf_10v USING GiST (the_geom_webmercator);
--SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_lines_world_1kf_10v;


