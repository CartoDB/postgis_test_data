-- poly_low_density_small_set_little_vertex
DROP TABLE IF EXISTS case_poly_world_1kf_5kv;
CREATE TABLE case_poly_world_1kf_5kv (
  cartodb_id serial primary key, the_geom_webmercator geometry
);
INSERT INTO case_poly_world_1kf_5kv (the_geom_webmercator)
WITH curve AS (
  SELECT ST_SetSRID(
    ST_Translate(
      ST_Difference(
        ST_Rotate(
          ST_Scale(
            ST_Buffer(ST_MakePoint(0, 0), 10000, 256),
            55, 40
          ),
          PI()/3.1,
          ST_MakePoint(0, 0)
        ),
        ST_Union(
          ST_Union(
            ST_Buffer(ST_MakePoint( 185000, 19000), 200000, 256),
            ST_Buffer(ST_MakePoint(-220000, -4000), 100000, 256)
          ),
          ST_Union(
            ST_Buffer(ST_MakePoint(-60000, -180000),   80000, 236),
            ST_Buffer(ST_MakePoint(-120000, -330000), 120000, 384)
          )
        )
      ),
      1200000, 1200000
    ), 3857) g
)
SELECT
  --ST_Translate(st_symdifference(g, st_translate(g, -180, -140)), x, y) as the_geom_webmercator
  ST_Translate(g, x, y) as the_geom_webmercator
FROM 
   curve,
   --generate_series(-20037500, -2003750, 2003750) x, generate_series(-20037500, -2003750, 2003750) y
   generate_series(-20037500, 18000000, 1203750) x, generate_series(-20037500,  18000000, 2003750) y
;

INSERT INTO case_poly_world_1kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, -400000, 900000)
FROM case_poly_world_1kf_5kv;

--INSERT INTO case_poly_world_1kf_5kv(the_geom_webmercator)
--SELECT ST_Translate(the_geom_webmercator, 0, 1001820)
--FROM case_poly_world_1kf_5kv;

CREATE INDEX ON case_poly_world_1kf_5kv USING GiST (the_geom_webmercator);

SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_poly_world_1kf_5kv;

