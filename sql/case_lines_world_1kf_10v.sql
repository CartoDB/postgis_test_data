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
            ST_MakePoint(x+800000, y+1000000)
          ), 150000),
        2, ST_MakePoint(x-600000,y-500000) -- perturbate the line
      ),
      7, ST_MakePoint(x+200000,y+600000) -- perturbate the line
    ),
    3857
  ) as the_geom_webmercator
FROM 
   generate_series(-20037500, 20037500, 1300000) x,
   generate_series(-20037500, 20037500, 1200000) y;
SELECT count(*), avg(st_npoints(the_geom_webmercator))
FROM case_lines_world_1kf_10v;
CREATE INDEX ON case_lines_world_1kf_10v USING GIST (the_geom_webmercator);

