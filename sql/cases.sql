-- points_low_density_small_set
DROP TABLE IF EXISTS case_points_world_10kf;
CREATE TABLE case_points_world_10kf AS SELECT
   row_number() over() as cartodb_id,
   ST_SetSRID(ST_MakePoint(x,y), 3857) as the_geom_webmercator
FROM 
   generate_series(-20037500, 20037500, 1300000) x,
   generate_series(-20037500, 20037500, 120000) y;

-- points_high_density_small_set
DROP TABLE IF EXISTS case_points_city_10kf;
CREATE TABLE case_points_city_10kf AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_points_world_10kf;

-- points_low_density_big_set
DROP TABLE IF EXISTS case_points_world_2mf;
CREATE TABLE case_points_world_2mf AS SELECT
   row_number() over() as cartodb_id,
   ST_SetSRID(ST_MakePoint(x,y), 3857) as the_geom_webmercator
FROM 
   generate_series(-20037500, 20037500, 28000) x,
   generate_series(-20037500, 20037500, 28000) y;

-- points_high_density_big_set
DROP TABLE IF EXISTS case_points_city_2mf;
CREATE TABLE case_points_city_2mf AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_points_world_2mf;

-- lines_low_density_small_set_little_vertex
DROP TABLE IF EXISTS case_lines_world_1kf_10v;
CREATE TABLE case_lines_world_1kf_10v AS SELECT
  row_number() over() as cartodb_id,
  ST_SetSRID(
    ST_SetPoint(
      ST_SetPoint(
        ST_Segmentize(
          ST_MakeLine(
            ST_MakePoint(x,y),
            ST_MakePoint(x+400000, y+100000)
          ), 50000),
        2, ST_MakePoint(x+1000,y+100000) -- perturbate the line
      ),
      7, ST_MakePoint(x+200000,y) -- perturbate the line
    ),
    3857
  ) as the_geom_webmercator
FROM 
   generate_series(-20037500, 20037500, 1300000) x,
   generate_series(-20037500, 20037500, 1200000) y;

-- lines_high_density_small_set_little_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_10v;
CREATE TABLE case_lines_city_1kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_1kf_10v;

-- lines_low_density_small_set_many_vertex
DROP TABLE IF EXISTS case_lines_world_1kf_5kv;
CREATE TABLE case_lines_world_1kf_5kv AS
WITH curve AS (
  SELECT ST_Segmentize(
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
--SELECT count(*), avg(st_npoints(the_geom_webmercator)) from case_lines_world_1kf_5kv;

-- lines_high_density_small_set_many_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_5kv;
CREATE TABLE case_lines_city_1kf_5kv AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_1kf_5kv;


-- lines_low_density_big_set_many_vertex
\i case_lines_world_100kf_5kv.sql

-- lines_high_density_big_set_many_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_5kv;
CREATE TABLE case_lines_city_100kf_5kv AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_100kf_5kv;

-- lines_low_density_big_set_little_vertex
\i case_lines_world_100kf_10v.sql

-- lines_high_density_big_set_little_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_10v;
CREATE TABLE case_lines_city_100kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_100kf_10v;

-- poly_low_density_small_set_little_vertex
\i case_poly_world_1kf_10v.sql

-- poly_high_density_small_set_little_vertex
DROP TABLE IF EXISTS case_poly_city_1kf_10v;
CREATE TABLE case_poly_city_1kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_1kf_10v;

-- poly_low_density_big_set_little_vertex
\i case_poly_world_100kf_10v.sql

-- poly_high_density_big_set_little_vertex
DROP TABLE IF EXISTS case_poly_city_100kf_10v;
CREATE TABLE case_poly_city_100kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_100kf_10v;

-- poly_low_density_small_set_many_vertex
\i case_poly_world_1kf_5kv.sql

-- poly_high_density_small_set_many_vertex  
DROP TABLE IF EXISTS case_poly_city_1kf_10v;
CREATE TABLE case_poly_city_1kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_1kf_10v;

-- poly_low_density_big_set_many_vertex
\i case_poly_world_100kf_5kv.sql

-- poly_high_density_big_set_many_vertex  
DROP TABLE IF EXISTS case_poly_city_100kf_10v;
CREATE TABLE case_poly_city_100kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_100kf_10v;

-- polygons_small_set_1M_vertex
\i case_poly_world_10f_1mv.sql
