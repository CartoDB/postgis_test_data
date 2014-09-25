-- poly_low_density_small_set_little_vertex
DROP TABLE IF EXISTS case_poly_world_1kf_10v;
CREATE TABLE case_poly_world_1kf_10v (
  cartodb_id serial primary key, the_geom_webmercator geometry
);
INSERT INTO case_poly_world_1kf_10v (the_geom_webmercator)
WITH curve AS (
  SELECT ST_SetSRID(
    ST_Scale(
      ST_Difference(
        ST_Rotate(
          ST_Buffer(ST_MakePoint(0, 0), 10000, 1),
          PI()/2.3,
          ST_MakePoint(0, 0)
        ),
        ST_Buffer(ST_MakePoint(400, 400), 2000, 1)
      ),
      55, 40
    ), 3857) g
)
SELECT
  ST_Translate(g, x, y) as the_geom_webmercator
FROM 
   curve,
   generate_series(-20037500, -600000, 1600000) x, generate_series(-20037500, -2003750, 2003750) y
   --generate_series(0, 0, 980000) x, generate_series(0, 0, 18000) y
;

INSERT INTO case_poly_world_1kf_10v(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 0, 20037500)
FROM case_poly_world_1kf_10v;

INSERT INTO case_poly_world_1kf_10v(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 20037500, 0)
FROM case_poly_world_1kf_10v;

--INSERT INTO case_poly_world_1kf_10v(the_geom_webmercator)
--SELECT ST_Translate(the_geom_webmercator, 1001820, 0)
--FROM case_poly_world_1kf_10v;

INSERT INTO case_poly_world_1kf_10v(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 0, 1001820)
FROM case_poly_world_1kf_10v;

CREATE INDEX ON case_poly_world_1kf_10v USING GiST (the_geom_webmercator);

SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_poly_world_1kf_10v;

