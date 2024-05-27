CREATE OR REPLACE PROCEDURE Uppercase_Column_Entries (
    p_table_name IN VARCHAR2,
    p_column_name IN VARCHAR2
) AS
    l_sql_statement VARCHAR2(1000);
BEGIN
    l_sql_statement := 'UPDATE ' || p_table_name || 
                       ' SET ' || p_column_name || ' = UPPER(' || p_column_name || ')';
    EXECUTE IMMEDIATE l_sql_statement;
    COMMIT;
END Uppercase_Column_Entries;
