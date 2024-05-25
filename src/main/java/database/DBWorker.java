package database;

import account.database.AccountDAO;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import utils.fileutil.LoggerUtils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBWorker {
    private static final String HOST = "jdbc:mysql://localhost:3306/bank";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    private Connection connection;
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(AccountDAO.class);
        LoggerUtils.setLogger(logger);
    }

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
