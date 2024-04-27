package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBWorker {
    private static final String HOST = "jdbc:mysql://localhost:3306/bank";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    private Connection connection;

    public DBWorker()
    {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(HOST, USERNAME, PASSWORD);
        }
        catch(SQLException e)
        {
            System.err.println("database connection failed!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public Connection getConnection() {
        return connection;
    }
}
