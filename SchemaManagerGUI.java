import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class SchemaManagerGUI extends JFrame {
    // Database credentials
    private static final String DEFAULT_USERNAME = "C##PETER";
    private static final String DEFAULT_PASSWORD = "1234";
    private static final String DEFAULT_SERVER = "orcl";

    // GUI components
    private JTextField usernameField, passwordField, serverField;
    private JButton submitButton, sortButton;
    private JTextArea tableDisplayArea, messageArea;
    private boolean sortAscending = true;

    public SchemaManagerGUI() {
        // Initialize components
        usernameField = new JTextField(DEFAULT_USERNAME);
        passwordField = new JPasswordField(DEFAULT_PASSWORD);
        serverField = new JTextField(DEFAULT_SERVER);
        submitButton = new JButton("Submit");
        sortButton = new JButton("Sort");
        tableDisplayArea = new JTextArea(10, 30);
        messageArea = new JTextArea(5, 30);
        tableDisplayArea.setEditable(false);
        messageArea.setEditable(false);

        // Layout setup
        setLayout(new BorderLayout());
        JPanel inputPanel = new JPanel(new GridLayout(3, 2));
        inputPanel.add(new JLabel("Username:"));
        inputPanel.add(usernameField);
        inputPanel.add(new JLabel("Password:"));
        inputPanel.add(passwordField);
        inputPanel.add(new JLabel("Server:"));
        inputPanel.add(serverField);
        add(inputPanel, BorderLayout.NORTH);

        JPanel tablePanel = new JPanel();
        tablePanel.add(new JScrollPane(tableDisplayArea));
        add(tablePanel, BorderLayout.CENTER);

        JPanel buttonPanel = new JPanel();
        buttonPanel.add(submitButton);
        buttonPanel.add(sortButton);
        add(buttonPanel, BorderLayout.SOUTH);

        JPanel messagePanel = new JPanel();
        messagePanel.add(new JScrollPane(messageArea));
        add(messagePanel, BorderLayout.SOUTH);

        // Action listeners
        submitButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                createAndExecuteDropProcedure();
            }
        });

        sortButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                sortTableList();
            }
        });

        // Retrieve and display tables
        retrieveTables();

        // Frame settings
        setTitle("Schema Manager");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        pack();
        setVisible(true);
    }

    // Method to connect to the database and retrieve table names
    private void retrieveTables() {
        try (Connection conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@" + serverField.getText(),
                usernameField.getText(),
                new String(passwordField.getPassword()))) {
            DatabaseMetaData dbMetaData = conn.getMetaData();
            try (ResultSet rs = dbMetaData.getTables(null, usernameField.getText().toUpperCase(), "%", new String[]{"TABLE"})) {
                tableDisplayArea.setText("");
                while (rs.next()) {
                    tableDisplayArea.append(rs.getString("TABLE_NAME") + "\n");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            messageArea.setText("Error retrieving tables: " + e.getMessage());
        }
    }

    // Method to sort the table list
    private void sortTableList() {
        String[] tables = tableDisplayArea.getText().split("\\n");
        List<String> tableList = new ArrayList<>(Arrays.asList(tables));

        Collections.sort(tableList);
        if (!sortAscending) {
            Collections.reverse(tableList);
        }
        sortAscending = !sortAscending;

        tableDisplayArea.setText(String.join("\n", tableList));
    }

    // Method to create and execute the Drop_All_Tables procedure
    private void createAndExecuteDropProcedure() {
        String createProcedure = "CREATE OR REPLACE PROCEDURE Drop_All_Tables AUTHID CURRENT_USER IS\n" +
                "BEGIN\n" +
                "  FOR t IN (SELECT table_name FROM user_tables) LOOP\n" +
                "    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';\n" +
                "  END LOOP;\n" +
                "END Drop_All_Tables;";
        String executeProcedure = "BEGIN\n" +
                "  Drop_All_Tables;\n" +
                "END;";

        try (Connection conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@" + serverField.getText(),
                usernameField.getText(),
                new String(passwordField.getPassword()))) {
            try (Statement stmt = conn.createStatement()) {
                // Create the procedure
                stmt.execute(createProcedure);
                // Execute the procedure
                stmt.execute(executeProcedure);
                // After dropping tables, retrieve the table list again to confirm
                retrieveTables();
                messageArea.setText("All tables dropped in schema " + usernameField.getText());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            messageArea.setText("Error dropping tables: " + e.getMessage());
        }
    }

    // Main method to run the GUI
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                new SchemaManagerGUI();
            }
        });
    }
}
