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
            connection = DriverManager.getConnection(HOST, USERNAME, PASSWORD);
        }
        catch(SQLException e)
        {
            System.err.println("database connection failed!");
        }
    }

    public Connection getConnection() {
        return connection;
    }
}
