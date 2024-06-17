CREATE OR REPLACE PROCEDURE drop_all_tables_in_schema(schema_name IN VARCHAR2) IS
    cursor c1 is
        select table_name
        from all_tables
        where owner = UPPER(schema_name);
        
    sql_stmt VARCHAR2(1000);
BEGIN
    FOR r1 IN c1 LOOP
        sql_stmt := 'DROP TABLE ' || schema_name || '.' || r1.table_name || ' CASCADE CONSTRAINTS';
        EXECUTE IMMEDIATE sql_stmt;
    END LOOP;
    
    dbms_output.put_line('All tables in schema ' || schema_name || ' have been dropped.');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('An error occurred: ' || SQLERRM);
END;
/
/*
BEGIN
    drop_all_tables_in_schema('YOUR_SCHEMA_NAME');
END;
/
*/