package account.operations.deposit.database;

import account.database.AccountDAO;
import account.operations.credit.database.Credit;
import database.DBWorker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import utils.fileutil.LoggerUtils;

import javax.servlet.http.HttpServlet;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

public class DepositDAO extends HttpServlet {
    private static final String INSERT_DEPOSIT_SQL = "INSERT INTO `deposit`" +
            "(`account_id`, `deposit_size`, `deposit_enddate`) \n"
            + "VALUES \n"
            + "(?,?,?);";
    private static final String GET_PROCEDURE_DEPOSIT_DATA = "call getDepositDataByAccountId(?)";
    private static DBWorker worker;
    private static Deposit deposit;
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(AccountDAO.class);
        LoggerUtils.setLogger(logger);
    }
    public static List<Deposit> getDepositsDataByAccountId(int id)
    {
        List<Deposit> depositList = new ArrayList<>();
        deposit = new Deposit();
        worker = new DBWorker();

        logger.info("GET deposit data from database✔️");

        try (PreparedStatement statement = worker.getConnection().prepareStatement(GET_PROCEDURE_DEPOSIT_DATA)) {
            statement.setString(1, String.valueOf(id));
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                deposit = new Deposit();
                deposit.setId(resultSet.getInt("deposit_id"));
                deposit.setAccountId(resultSet.getInt("account_id"));
                deposit.setDepositSize(resultSet.getDouble("deposit_size"));
                deposit.setDepositStartDate(resultSet.getString("deposit_startdate"));
                deposit.setDepositEndDate(resultSet.getString("deposit_enddate"));
                deposit.setDepositStatus(resultSet.getString("deposit_status"));
                deposit.setDepositPercent(resultSet.getDouble("deposit_percent"));
                depositList.add(deposit);
            }
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("GET deposit data from database ERROR❌!");
            logger.error("SQLState: " + e.getSQLState());
            logger.error("Error code: " + e.getErrorCode());
            logger.error("Message: " + e.getMessage());
        } catch (ParseException e) {
            logger.error("GET deposit date from database ERROR❌!");
            logger.error("Message: " + e.getMessage());
        }
        return depositList;
    }

    public static int createDeposit(int accountId, double amount, String endDepositDate)
    {
        deposit = new Deposit();
        worker = new DBWorker();

        logger.info("INSERT deposit data to database✔️");

        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(INSERT_DEPOSIT_SQL))
        {
            deposit.setAccountId(accountId);
            deposit.setDepositSize(amount);
            deposit.setDepositEndDate(endDepositDate);

            preparedStatement.setInt(1, deposit.getAccountId());
            preparedStatement.setDouble(2, deposit.getDepositSize());
            preparedStatement.setDate(3, deposit.getDepositEndDate());
            logger.info(preparedStatement);

            result = preparedStatement.executeUpdate();
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("INSERT deposit data to database ERROR❌!");
            logger.error("SQLState: " + e.getSQLState());
            logger.error("Error code: " + e.getErrorCode());
            logger.error("Message: " + e.getMessage());
        } catch (ParseException e) {
            logger.error("INSERT deposit date to database ERROR❌!");
            logger.error("Message: " + e.getMessage());
        }
        return result;
    }
}
