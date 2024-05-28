package user.database;

import account.database.Account;
import account.database.AccountDAO;
import database.DBWorker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.servlet.LoginServlet;
import utils.fileutil.LoggerUtils;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

public class UserDAO {
    private static final String INSERT_CLIENT_SQL = "INSERT INTO `client`" +
            "(`first_name`, `last_name`, `phone_number`, `email`, `birth_date`, `password`) \n"
            + "VALUES \n"
            + "(?,?,?,?,?,?);";
    private static final String SELECT_CLIENT_EMAIL_PASS_SQL = "select * from client where email = ? and password = ?";
    private static final String SELECT_CLIENT_EMAIL_SQL = "select * from client where email = ?";
    private static final String GET_PROCEDURE_CLIENT_DATA = "call getClientData(?)";
    private static final String GET_PROCEDURE_CLIENT_ID = "call getClientIdByEmail(?)";
    private static final String UPDATE_CLIENT_SQL = "call updateClientData(?, ?, ?)";
    private static User user;
    private static DBWorker worker;
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(LoginServlet.class);
        LoggerUtils.setLogger(logger);
    }
    public int registerUser(User user)
    {
        worker = new DBWorker();
        logger.info("INSERT client data to database✔️");

        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(INSERT_CLIENT_SQL)) {
            preparedStatement.setString(1, user.getFirstName());
            preparedStatement.setString(2, user.getLastName());
            preparedStatement.setString(3, user.getPhoneNumber());
            preparedStatement.setString(4, user.getEmail());
            preparedStatement.setDate(5, user.getBirthDate());
            preparedStatement.setString(6, user.getPassword());
            logger.info(preparedStatement);

            result = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("INSERT client data to database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return result;
    }

    public boolean loginValidate(User user)
    {
        worker = new DBWorker();
        logger.info("GET client data from database✔️");

        boolean status = false;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(SELECT_CLIENT_EMAIL_PASS_SQL))
        {
            preparedStatement.setString(1, user.getEmail());
            preparedStatement.setString(2, user.getPassword());

            logger.info("Statement: " + preparedStatement);
            ResultSet resultSet = preparedStatement.executeQuery();
            status = resultSet.next();
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("GET client data from database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return status;
    }

    public boolean registerValidate(User user)
    {
        worker = new DBWorker();
        logger.info("GET client data from database✔️");

        boolean status = false;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(SELECT_CLIENT_EMAIL_SQL))
        {
            preparedStatement.setString(1, user.getEmail());

            logger.info("Statement: " + preparedStatement);
            ResultSet resultSet = preparedStatement.executeQuery();
            status = resultSet.next();
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("GET client data from database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return status;
    }

    public int getUserId(String userEmail)
    {
        worker = new DBWorker();
        user = new User();
        logger.info("GET client_id data from database✔️");

        try (PreparedStatement statement = worker.getConnection().prepareStatement(GET_PROCEDURE_CLIENT_ID)) {
            statement.setString(1, userEmail);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                user.setId(resultSet.getInt(1));
            }
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("GET client_id data from database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return user.getId();
    }

    public User getUser(int id)
    {
        worker = new DBWorker();
        user = new User();
        logger.info("GET client_id data from database✔️");

        try (PreparedStatement statement = worker.getConnection().prepareStatement(GET_PROCEDURE_CLIENT_DATA)) {
            statement.setString(1, String.valueOf(id));
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                user.setId(id);
                user.setFirstName(resultSet.getString("first_name"));
                user.setLastName(resultSet.getString("last_name"));
                user.setEmail(resultSet.getString("email"));
                user.setPhoneNumber(resultSet.getString("phone_number"));
                user.setBirthDate(resultSet.getString("birth_date"));
            }
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("GET client data from database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        } catch (ParseException e) {
            logger.error("GET client data from database ERROR❌!");
            System.err.println("Message: " + e.getMessage());
        }
        return user;
    }

    public static int updateUser(int id, String email, String password)
    {
        worker = new DBWorker();
        logger.info("UPDATE and SET client data to database✔️");

        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(UPDATE_CLIENT_SQL)) {
            preparedStatement.setInt(1, id);
            preparedStatement.setString(2, email);
            preparedStatement.setString(3, password);
            logger.info(preparedStatement);

            result = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("UPDATE and SET client data to database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return result;
    }
}
