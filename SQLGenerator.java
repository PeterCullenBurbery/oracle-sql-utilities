public class SQLGenerator {

    public static void main(String[] args) {
        // Check if there are at least two arguments provided
        if (args.length < 2) {
            System.out.println("Usage: java SQLGenerator <mainTable> <table1,table2,table3,...>");
            return;
        }

        // The first argument is the main table name
        String mainTable = args[0];

        // The second argument is the comma-separated list of tables to join
        // Split the second argument to get the individual table names
        String[] tablesToJoin = args[1].split(",");

        // Call the generateSQL method and print the result
        System.out.println(generateSQL(mainTable, tablesToJoin));
    }

    public static String generateSQL(String mainTable, String[] tablesToJoin) {
        if (mainTable == null || tablesToJoin == null) {
            return "Invalid input.";
        }

        StringBuilder sql = new StringBuilder("SELECT\n\t*\nFROM\n\t").append(mainTable);

        for (String table : tablesToJoin) {
            sql.append("\nFULL JOIN ").append(table)
               .append("\n\tUSING(").append(table).append("_id)");
        }

        sql.append(";");
        return sql.toString();
    }
}
