-- poly_low_density_big_set_many_vertex
DROP TABLE IF EXISTS case_poly_world_100kf_5kv;
CREATE TABLE case_poly_world_100kf_5kv (
  cartodb_id serial primary key, the_geom_webmercator geometry
);
INSERT INTO case_poly_world_100kf_5kv (the_geom_webmercator)
WITH curve AS (
  SELECT ST_SetSRID(
    ST_Scale(
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
      ), 0.1, 0.1
    ), 3857) g
)
SELECT
  ST_Translate(g, x, y) as the_geom_webmercator
FROM 
   curve,
   generate_series(-20037500, -133583, 133583) x,
   --generate_series(-20037500, -20037500, 133583) x,

   generate_series(-20037500, -133583, 133583) y
   --generate_series(-20037500, -20037500, 133583) y
;

INSERT INTO case_poly_world_100kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 0, 20037500)
FROM case_poly_world_100kf_5kv;

INSERT INTO case_poly_world_100kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 20037500, 0)
FROM case_poly_world_100kf_5kv
WHERE cartodb_id < 22500;

INSERT INTO case_poly_world_100kf_5kv(the_geom_webmercator)
SELECT ST_Translate(the_geom_webmercator, 20037500, 0)
FROM case_poly_world_100kf_5kv
WHERE cartodb_id >= 22500 and cartodb_id < 45000;

CREATE INDEX ON case_poly_world_100kf_5kv USING GiST (the_geom_webmercator);

SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_poly_world_100kf_5kv;
