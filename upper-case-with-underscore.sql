CREATE OR REPLACE FUNCTION convert_to_uppercase_with_underscore(p_string IN VARCHAR2)
RETURN VARCHAR2
IS
BEGIN
  RETURN UPPER(REGEXP_REPLACE(p_string, ' ', '_'));
END convert_to_uppercase_with_underscore;
/
