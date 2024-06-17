CREATE OR REPLACE FUNCTION drop_all_views_in_schema(
    schema_name IN VARCHAR2
) RETURN CLOB IS
    CURSOR views_to_drop IS
        SELECT view_name
        FROM all_views
        WHERE owner = UPPER(schema_name);

    ddl_query VARCHAR2(4000);
    view_name VARCHAR2(255);
    error_message CLOB;
    result_message CLOB := EMPTY_CLOB();
BEGIN
    FOR view_rec IN views_to_drop LOOP
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

