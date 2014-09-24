DROP TABLE IF EXISTS case_poly_world_10f_1mv;
CREATE TABLE case_poly_world_10f_1mv (
  cartodb_id serial primary key, the_geom_webmercator geometry
);
INSERT INTO case_poly_world_10f_1mv (the_geom_webmercator)
WITH curve AS (
  SELECT ST_SetSRID(
      ST_Scale(
    ST_Difference(
      ST_Rotate(
        ST_Scale(
          ST_Buffer(ST_MakePoint(0, 0), 10, 1),
          6, 5
        ),
        PI()/2.4,
        ST_MakePoint(0, 0)
      ),
      ST_Buffer(ST_MakePoint(8, 8), 30, 1)
    ),
      0.01, 0.02),
  3857) g
),
mcurve AS (
  SELECT ST_Scale(st_collect(g), 3e4, 3e4) as g FROM
  ( SELECT st_translate(g, x, y) g
      from curve,
        generate_series(0, 1200, 7) x,
        generate_series(0, 1200, 2) y
  ) foo
)
SELECT
  ST_Translate(g, x, 0) as the_geom_webmercator
FROM 
   mcurve,
   generate_series(-20037500, -19850000, 30000) x
;

CREATE INDEX ON case_poly_world_10f_1mv USING GiST (the_geom_webmercator);

SELECT count(*),
 st_extent(the_geom_webmercator),
 avg(st_npoints(the_geom_webmercator))
from case_poly_world_10f_1mv;
