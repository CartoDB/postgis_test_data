
-- lines_low_density_small_set_many_vertex
DROP TABLE IF EXISTS case_lines_world_1kf_5kv;
CREATE TABLE case_lines_world_1kf_5kv AS
WITH curve AS (
  SELECT
      ST_Segmentize(
        ST_OffsetCurve(
          ST_OffsetCurve(ST_MakeLine(g),100000)
          ,-50000
        ), 750) g
  FROM (
    SELECT ST_SetSRID(ST_MakePoint(n+(100000*cos(n)-500000*sin(n)+n/4), n/2-(n/20*cos(n))), 3857) g
    FROM generate_series(0,2500000,100000) n
  ) pts
)
SELECT
  row_number() over() as cartodb_id,
  ST_Translate(g, x, y) as the_geom_webmercator
FROM 
   curve,
   generate_series(-20037500, 20037500, 1000000) x, generate_series(-20037500, 20037500, 1600000) y;

UPDATE case_lines_world_1kf_5kv SET the_geom_webmercator = ST_Rotate(
  the_geom_webmercator,
  pi()/4,
  ST_MakePoint(
    ST_XMin(the_geom_webmercator),
    ST_YMin(the_geom_webmercator)
  )
);

CREATE INDEX ON case_lines_world_1kf_5kv USING GIST (the_geom_webmercator);
--SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_lines_world_1kf_5kv;
