import java.sql.*;

public class CompanyDB {
    @SuppressWarnings("CallToPrintStackTrace")
    public static void main(String[] args) {

        String url = "jdbc:mysql://localhost:3306/COMPANY";
        String user = "root"; 
        String pass = "pass"; 

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {

            System.out.println("Connected to COMPANY database!");

            // TASK 1: Retrieve employees working on > 1 project 
            System.out.println("\n--- Employees on multiple projects ---");
            String query1 = "SELECT e.Fname, e.Lname, COUNT(w.Pno) AS ProjectCount " +
                            "FROM EMPLOYEE e " +
                            "JOIN WORKS_ON w ON e.Ssn = w.Essn " +
                            "GROUP BY e.Ssn " +
                            "HAVING ProjectCount > 1";
            
            ResultSet rs = stmt.executeQuery(query1);
            while (rs.next()) {
                System.out.println(rs.getString("Fname") + " " + 
                                   rs.getString("Lname") + " | Projects: " + 
                                   rs.getInt("ProjectCount"));
            }

            // TASK 2: Update DEPARTMENT (Insert 'Health')
            System.out.println("\n--- Updating Department Relation ---");
            
            String updateSQL = "INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) " +
                               "SELECT 'Health', 5, '123456789', '2023-01-01' " +
                               "WHERE NOT EXISTS (SELECT 1 FROM DEPARTMENT WHERE Dnumber = 5)";

            int rows = stmt.executeUpdate(updateSQL);
            
            if (rows > 0) {
                System.out.println("Successfully added 'Health' department.");
            } else {
                System.out.println("Department 'Health' (ID: 5) already exists. Skipping insertion.");
            }

            ResultSet rsDept = stmt.executeQuery("SELECT * FROM DEPARTMENT");
            System.out.println("Current Departments:");
            while (rsDept.next()) {
                System.out.println("ID: " + rsDept.getInt("Dnumber") + " | Name: " + rsDept.getString("Dname"));
            }

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}