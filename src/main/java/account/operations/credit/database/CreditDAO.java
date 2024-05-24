package account.operations.credit.database;

import account.database.Account;
import account.database.AccountDAO;
import com.mysql.cj.protocol.a.LocalDateTimeValueEncoder;
import database.DBWorker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import user.database.User;
import utils.fileutil.LoggerUtils;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class CreditDAO implements Serializable {
    private static final String INSERT_CREDIT_SQL = "INSERT INTO `credit`" +
            "(`account_id`, `credit_size`, credit_enddate) \n"
            + "VALUES \n"
            + "(?,?,?);";
    private static final String GET_PROCEDURE_CREDIT_DATA = "call getCreditDataByAccountId(?)";
    private static DBWorker worker;
    private static Credit credit;
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(AccountDAO.class);
        LoggerUtils.setLogger(logger);
    }
    public static List<Credit> getCreditsDataByAccountId(int id)
    {
        List<Credit> creditList = new ArrayList<>();
        credit = new Credit();
        worker = new DBWorker();

        logger.info("GET credit data from database✔️");

        try (PreparedStatement statement = worker.getConnection().prepareStatement(GET_PROCEDURE_CREDIT_DATA)) {
            statement.setString(1, String.valueOf(id));
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                credit = new Credit();
                credit.setId(resultSet.getInt("credit_id"));
                credit.setAccountId(resultSet.getInt("account_id"));
                credit.setCreditSize(resultSet.getDouble("credit_size"));
                credit.setCreditStartDate(resultSet.getString("credit_startdate"));
                credit.setCreditEndDate(resultSet.getString("credit_enddate"));
                credit.setCreditStatus(resultSet.getString("credit_status"));
                credit.setCreditPercent(resultSet.getDouble("credit_percent"));
                credit.setCreditLimit(resultSet.getDouble("credit_limit"));
                creditList.add(credit);
            }
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            logger.error("GET credit data from database ERROR❌!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        } catch (ParseException e) {
            logger.error("GET credit date from database ERROR❌!");
            System.err.println("Message: " + e.getMessage());
        }
        return creditList;
    }

    public static int createCredit(int accountId, double amount, int term)
    {
        credit = new Credit();
        worker = new DBWorker();

        logger.info("INSERT credit data to database✔️");

        int result = 0;

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime endTermDateTime = now.plusMonths(term);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm:ss");
        String endDate = endTermDateTime.format(formatter);

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(INSERT_CREDIT_SQL))
        {
            credit.setAccountId(accountId);
            credit.setCreditSize(amount);
            credit.setCreditEndDate(endDate);

            preparedStatement.setInt(1, credit.getAccountId());
            preparedStatement.setDouble(2, credit.getCreditSize());
            preparedStatement.setDate(3, credit.getCreditEndDate());
            logger.info(preparedStatement);

            result = preparedStatement.executeUpdate();
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("INSERT credit data to database ERROR❌!");
            logger.error("SQLState: " + e.getSQLState());
            logger.error("Error code: " + e.getErrorCode());
            logger.error("Message: " + e.getMessage());
        } catch (ParseException e) {
            logger.error("INSERT credit data parse ERROR❌!");
            logger.error("Message: " + e.getMessage());
        }
        return result;
    }
}
