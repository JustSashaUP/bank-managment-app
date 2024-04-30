package user.database;

import database.DBWorker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.servlet.LoginServlet;
import utils.fileutil.LoggerUtils;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(LoginServlet.class);
        LoggerUtils.setLogger(logger);
    }
    public int registerUser(User user)
    {
        DBWorker worker = new DBWorker();
        logger.info("SET client data from database");
        String INSERT_CLIENT_SQL = "INSERT INTO `client`(`first_name`, `last_name`, `phone_number`, `email`, `birth_date`, `password`) \n" +
                "VALUES \n" +
                "(?,?,?,?,?,?);";
        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(INSERT_CLIENT_SQL)) {
            preparedStatement.setString(1, user.getFirstName());
            preparedStatement.setString(2, user.getLastName());
            preparedStatement.setString(3, user.getPhoneNumber());
            preparedStatement.setString(4, user.getEmail());
            preparedStatement.setDate(5, user.getBirthDate());
            preparedStatement.setString(6, user.getPassword());
            logger.info(preparedStatement);
            System.out.println(preparedStatement);

            result = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("SET client data from database ERROR!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return result;
    }

    public boolean validate(User user)
    {
        DBWorker worker = new DBWorker();
        logger.info("GET client data from database");
        String SELECT_CLIENT_SQL = "select * from client where email = ?";

        boolean status = false;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(SELECT_CLIENT_SQL))
        {
            preparedStatement.setString(1, user.getEmail());

            logger.info("Statement: " + preparedStatement);
            ResultSet resultSet = preparedStatement.executeQuery();
            status = resultSet.next();
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("GET client data from database ERROR!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return status;
    }

    public int getUserId(String userEmail)
    {
        DBWorker worker = new DBWorker();
        User user = new User();
        logger.info("GET client_id data from database");
        String query = "call getClientIdByEmail(?)";

        try (PreparedStatement statement = worker.getConnection().prepareStatement(query)) {
            statement.setString(1, userEmail);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                user.setId(resultSet.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("GET client_id data from database ERROR!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return user.getId();
    }
}
