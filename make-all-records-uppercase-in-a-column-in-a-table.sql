CREATE OR REPLACE PROCEDURE uppercase_column_entries (
    p_table_name  IN VARCHAR2,
    p_column_name IN VARCHAR2
) AS
    l_sql_statement VARCHAR2(1000);
BEGIN
    l_sql_statement := 'UPDATE '
                       || p_table_name
                       || ' SET '
                       || p_column_name
                       || ' = UPPER('
                       || p_column_name
                       || ')';

    EXECUTE IMMEDIATE l_sql_statement;
    COMMIT;
END uppercase_column_entries;
/

BEGIN
    uppercase_column_entries(
                            'your_table_name',
                            'your_column_name'
    );
END;