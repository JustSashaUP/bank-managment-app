package account.database;

import database.DBWorker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import user.database.UserDAO;
import user.servlet.LoginServlet;
import utils.fileutil.LoggerUtils;

import javax.servlet.http.HttpSession;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {
    private static final String INSERT_ACCOUNT_SQL = "INSERT INTO `account`" +
            "(`client_id`, `account_title`, `account_number`, `account_balance`, `account_status`, `account_startDate`) \n"
            + "VALUES \n"
            + "(?,?,?,?,?,?);";
    private static final String INSERT_NEW_ACCOUNT_SQL = "INSERT INTO `account`" + "\n"
            + "(`client_id`, `account_title`, `account_number`, `account_balance`, `account_status`, `account_startdate`) \n"
            + "VALUES \n"
            + "(?, ?, generateCardNumber(), 0.00, 'online', NOW());";
    private static final String GET_PROCEDURE_ACCOUNT_SQL = "call getAccountDataByClientId(?)";
    private static Account account;
    private static DBWorker worker;
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(AccountDAO.class);
        LoggerUtils.setLogger(logger);
    }
    public static List<Account> getAccountsDataByClientId(int id)
    {
        List<Account> accountList = new ArrayList<>();
        account = new Account();
        worker = new DBWorker();

        logger.info("GET account data from database✔️");

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(GET_PROCEDURE_ACCOUNT_SQL))
        {
            preparedStatement.setString(1, String.valueOf(id));
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next())
            {
                account = new Account();
                account.setUserId(resultSet.getInt("client_id"));
                account.setId(resultSet.getInt("account_id"));
                account.setTitle(resultSet.getString("account_title"));
                account.setNumber(resultSet.getString("account_number"));
                account.setBalance(resultSet.getDouble("account_balance"));
                account.setStatus(resultSet.getString("account_status"));
                account.setStartDate(resultSet.getString("account_startDate"));
                accountList.add(account);
            }
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("GET client data from database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        } catch (ParseException e) {
            logger.error("GET account data from database ERROR❌!");
            System.err.println("Message: " + e.getMessage());
        }
        return accountList;
    }

    public static int createAccount(User currentUserFromSession, String currency)
    {
        worker = new DBWorker();

        logger.info("INSERT account data to database✔️");

        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(INSERT_NEW_ACCOUNT_SQL)) {
            preparedStatement.setInt(1, currentUserFromSession.getId());
            preparedStatement.setString(2, currency);

            result = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("INSERT account data to database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return result;
    }
}