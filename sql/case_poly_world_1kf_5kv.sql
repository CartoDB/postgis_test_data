-- poly_low_density_small_set_little_vertex
DROP TABLE IF EXISTS case_poly_world_1kf_5kv;
CREATE TABLE case_poly_world_1kf_5kv (
  cartodb_id serial primary key, the_geom_webmercator geometry
);
INSERT INTO case_poly_world_1kf_5kv (the_geom_webmercator)
WITH curve AS (
  SELECT ST_SetSRID(
    ST_Difference(
      ST_Rotate(
        ST_Scale(
          ST_Buffer(ST_MakePoint(0, 0), 10000, 32),
          55, 40
        ),
        PI()/3.1,
        ST_MakePoint(0, 0)
      ),
      ST_Buffer(ST_MakePoint(180000, 14000), 200000, 32)
    ), 3857) g
)
SELECT
  ST_Translate(g, x, y) as the_geom_webmercator
FROM 
   curve,
   --generate_series(-20037500, -2003750, 2003750) x, generate_series(-20037500, -2003750, 2003750) y
   generate_series(-20037500, -2003750, 1203750) x, generate_series(-20037500, -2003750, 2003750) y
;

INSERT INTO case_poly_world_1kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 0, 20037500)
FROM case_poly_world_1kf_5kv;

INSERT INTO case_poly_world_1kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 20037500, 0)
FROM case_poly_world_1kf_5kv;

INSERT INTO case_poly_world_1kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 1001820, 0)
FROM case_poly_world_1kf_5kv;

--INSERT INTO case_poly_world_1kf_5kv(the_geom_webmercator)
--SELECT ST_Translate(the_geom_webmercator, 0, 1001820)
--FROM case_poly_world_1kf_5kv;

CREATE INDEX ON case_poly_world_1kf_5kv USING GiST (the_geom_webmercator);

SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_poly_world_1kf_5kv;



