CREATE OR REPLACE FUNCTION get_total_records(schema_name IN VARCHAR2) RETURN NUMBER IS
  v_table_name VARCHAR2(50);
  v_row_count NUMBER;
  v_total_count NUMBER := 0;
  CURSOR table_names IS
    SELECT table_name FROM all_tables WHERE owner = schema_name;
BEGIN
  OPEN table_names;
  LOOP
    FETCH table_names INTO v_table_name;
    EXIT WHEN table_names%NOTFOUND;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || schema_name || '.' || v_table_name INTO v_row_count;
    v_total_count := v_total_count + v_row_count;
  END LOOP;
  CLOSE table_names;
  RETURN v_total_count;
END get_total_records;
/
