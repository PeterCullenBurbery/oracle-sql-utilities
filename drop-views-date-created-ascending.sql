CREATE OR REPLACE FUNCTION drop_sorted_views_for_schema(
    schema_name IN VARCHAR2,
    sort_column IN VARCHAR2 DEFAULT 'date_created',
    sort_order IN VARCHAR2 DEFAULT 'ASC'
) RETURN CLOB IS
    CURSOR pattern_views IS
        SELECT view_name
        FROM all_views
        WHERE owner = UPPER(schema_name)
          AND REGEXP_LIKE(view_name, '.*_' || LOWER(sort_column) || '_' || LOWER(sort_order) || '$', 'i');

    ddl_query VARCHAR2(4000);
    view_name VARCHAR2(255);
    error_message CLOB := EMPTY_CLOB();
    result_message CLOB := EMPTY_CLOB();
BEGIN
    FOR view_rec IN pattern_views LOOP
        view_name := view_rec.view_name;
        ddl_query := 'DROP VIEW "' || schema_name || '"."' || view_name || '"';
        
        BEGIN
            EXECUTE IMMEDIATE ddl_query;
            result_message := result_message || 'View ' || view_name || ' dropped successfully. ' || CHR(10);
        EXCEPTION
            WHEN OTHERS THEN
                error_message := 'Error dropping view ' || view_name || ': ' || SQLERRM;
                result_message := result_message || error_message || CHR(10);
        END;
    END LOOP;

    RETURN result_message;
END;
/



/*
DECLARE
    result CLOB;
BEGIN
    result := drop_sorted_views_for_schema('YOUR_SCHEMA_NAME');
    DBMS_OUTPUT.PUT_LINE(result);
END;
/
*/