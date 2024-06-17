CREATE OR REPLACE FUNCTION create_sorted_views_for_schema(
    schema_name IN VARCHAR2,
    sort_column IN VARCHAR2 DEFAULT 'DATE_CREATED',
    sort_order IN VARCHAR2 DEFAULT 'ASC'
)
RETURN VARCHAR2
IS
    v_table_name VARCHAR2(200);
    v_view_name VARCHAR2(200);
    v_sql VARCHAR2(1000);
    v_owner VARCHAR2(200);
    cursor tables_cursor IS
        SELECT table_name
        FROM all_tables
        WHERE owner = schema_name;
BEGIN
    -- Loop through each table in the schema
    FOR table_rec IN tables_cursor LOOP
        v_table_name := table_rec.table_name;
        v_view_name := v_table_name || '_' || sort_column || '_' || sort_order;

        -- Check if the view already exists
        BEGIN
            SELECT owner INTO v_owner
            FROM all_views
            WHERE view_name = v_view_name
              AND owner = schema_name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- If the view does not exist, create it
                v_sql := 'CREATE OR REPLACE VIEW ' || schema_name || '.' || v_view_name ||
                         ' AS SELECT * FROM ' || schema_name || '.' || v_table_name ||
                         ' ORDER BY ' || sort_column || ' ' || sort_order;
                EXECUTE IMMEDIATE v_sql;
        END;
    END LOOP;
    RETURN 'Views created successfully';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END create_sorted_views_for_schema;
/


/*how to use this*
DECLARE
    result CLOB;
BEGIN
    result := create_sorted_views_for_schema('YOUR_SCHEMA_NAME');
    DBMS_OUTPUT.PUT_LINE(result);
END;
/
*/
