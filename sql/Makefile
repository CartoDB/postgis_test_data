CASES = \
  case_lines_world_100kf_10v.sql \
  case_lines_world_100kf_5kv.sql \
  case_poly_world_1kf_5kv.sql \
  case_poly_world_1kf_10v.sql \
  case_poly_world_100kf_10v.sql \
  case_poly_world_100kf_5kv.sql \
  case_poly_world_10f_1mv.sql \
  cases.sql

allcases.sql: $(CASES)
	cat cases.sql | sed 's/\\i \(.*\)/#include "\1"/' | cpp -P -traditional-cpp -I. /dev/stdin > $@
