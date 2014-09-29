-- points_low_density_small_set
DROP TABLE IF EXISTS case_points_world_10kf;
CREATE TABLE case_points_world_10kf AS SELECT
   row_number() over() as cartodb_id,
   ST_SetSRID(ST_MakePoint(x,y), 3857) as the_geom_webmercator
FROM 
   generate_series(-20037500, 20037500, 1300000) x,
   generate_series(-20037500, 20037500, 120000) y;
CREATE INDEX ON case_points_world_10kf USING GIST (the_geom_webmercator);

-- points_high_density_small_set
DROP TABLE IF EXISTS case_points_city_10kf;
CREATE TABLE case_points_city_10kf AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_points_world_10kf;
CREATE INDEX ON case_points_city_10kf USING GIST (the_geom_webmercator);

-- points_low_density_big_set
DROP TABLE IF EXISTS case_points_world_2mf;
CREATE TABLE case_points_world_2mf AS SELECT
   row_number() over() as cartodb_id,
   ST_SetSRID(ST_MakePoint(x,y), 3857) as the_geom_webmercator
FROM 
   generate_series(-20037500, 20037500, 28000) x,
   generate_series(-20037500, 20037500, 28000) y;
CREATE INDEX ON case_points_world_2mf USING GIST (the_geom_webmercator);

-- points_high_density_big_set
DROP TABLE IF EXISTS case_points_city_2mf;
CREATE TABLE case_points_city_2mf AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_points_world_2mf;
CREATE INDEX ON case_points_city_2mf USING GIST (the_geom_webmercator);

-- lines_low_density_small_set_little_vertex
\i case_lines_world_1kf_10v.sql

-- lines_high_density_small_set_little_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_10v;
CREATE TABLE case_lines_city_1kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_1kf_10v;
CREATE INDEX ON case_lines_city_1kf_10v USING GIST (the_geom_webmercator);

-- lines_low_density_small_set_many_vertex
\i case_lines_world_1kf_5kv.sql

-- lines_high_density_small_set_many_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_5kv;
CREATE TABLE case_lines_city_1kf_5kv AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_1kf_5kv;
CREATE INDEX ON case_lines_city_1kf_5kv USING GIST (the_geom_webmercator);


-- lines_low_density_big_set_many_vertex
\i case_lines_world_100kf_5kv.sql

-- lines_high_density_big_set_many_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_5kv;
CREATE TABLE case_lines_city_100kf_5kv AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_100kf_5kv;
CREATE INDEX ON case_lines_city_100kf_5kv USING GiST (the_geom_webmercator);

-- lines_low_density_big_set_little_vertex
\i case_lines_world_100kf_10v.sql

-- lines_high_density_big_set_little_vertex
DROP TABLE IF EXISTS case_lines_city_1kf_10v;
CREATE TABLE case_lines_city_100kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_lines_world_100kf_10v;
CREATE INDEX ON case_lines_city_100kf_10v USING GiST (the_geom_webmercator);

-- poly_low_density_small_set_little_vertex
\i case_poly_world_1kf_10v.sql

-- poly_high_density_small_set_little_vertex
DROP TABLE IF EXISTS case_poly_city_1kf_10v;
CREATE TABLE case_poly_city_1kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_1kf_10v;
CREATE INDEX ON case_poly_city_1kf_10v USING GiST (the_geom_webmercator);

-- poly_low_density_big_set_little_vertex
\i case_poly_world_100kf_10v.sql

-- poly_high_density_big_set_little_vertex
DROP TABLE IF EXISTS case_poly_city_100kf_10v;
CREATE TABLE case_poly_city_100kf_10v AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_100kf_10v;
CREATE INDEX ON case_poly_city_100kf_10v USING GiST (the_geom_webmercator);

-- poly_low_density_small_set_many_vertex
\i case_poly_world_1kf_5kv.sql

-- poly_high_density_small_set_many_vertex  
DROP TABLE IF EXISTS case_poly_city_1kf_5kv;
CREATE TABLE case_poly_city_1kf_5kv AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_1kf_5kv;
CREATE INDEX ON case_poly_city_1kf_5kv USING GiST (the_geom_webmercator);

-- poly_low_density_big_set_many_vertex
\i case_poly_world_100kf_5kv.sql

-- poly_high_density_big_set_many_vertex  
DROP TABLE IF EXISTS case_poly_city_100kf_5kv;
CREATE TABLE case_poly_city_100kf_5kv AS SELECT
  cartodb_id,
  -- City is 1/1000 the world's size
  ST_Scale(the_geom_webmercator, 0.001, 0.001) as the_geom_webmercator
FROM case_poly_world_100kf_5kv;
CREATE INDEX ON case_poly_city_100kf_5kv USING GiST (the_geom_webmercator);

-- polygons_small_set_1M_vertex
\i case_poly_world_10f_1mv.sql
