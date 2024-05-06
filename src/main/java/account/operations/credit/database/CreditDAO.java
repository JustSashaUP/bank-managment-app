package account.operations.credit.database;

import account.database.Account;
import database.DBWorker;
import org.apache.logging.log4j.Logger;
import user.database.User;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

public class CreditDAO implements Serializable {
    private static final String INSERT_CREDIT_SQL = "INSERT INTO `credit`" +
            "(`account_id`, `credit_size`, `credit_startdate`, `credit_enddate`, `credit_status`, `credit_percent`, `credit_limit`) \n"
            + "VALUES \n"
            + "(?,?,?,?,?,?,?);";
    private static final String GET_PROCEDURE_CREDIT_DATA = "call getCreditDataByAccountId(?)";
    private static DBWorker worker;
    private static Credit credit;
    private static Logger logger;
    public List<Credit> getCreditDataByAccountId(int id)
    {
        List<Credit> creditList = new ArrayList<>();
        credit = new Credit();
        worker = new DBWorker();

        logger.info("GET credit data from database");

        try (PreparedStatement statement = worker.getConnection().prepareStatement(GET_PROCEDURE_CREDIT_DATA)) {
            statement.setString(1, String.valueOf(id));
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
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
            logger.error("GET client data from database ERROR!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        } catch (ParseException e) {
            logger.error("GET client data from database ERROR!");
            System.err.println("Message: " + e.getMessage());
        }
        return creditList;
    }
    // where we get data?
    public static int setCreditDataByAccountId(int accountId)
    {
        credit = new Credit();
        worker = new DBWorker();

        logger.info("SET account data from database");

        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(INSERT_CREDIT_SQL))
        {
            preparedStatement.setInt(1, credit.getAccountId());
            preparedStatement.setDouble(2, credit.getCreditSize());
            preparedStatement.setDate(3, credit.getCreditStartDate());
            preparedStatement.setDate(4, credit.getCreditEndDate());// end date must be calculated
            preparedStatement.setString(5, credit.getCreditStatus());
            preparedStatement.setDouble(6, credit.getCreditPercent());
            preparedStatement.setDouble(7, credit.getCreditLimit());
            logger.info(preparedStatement);

            result = preparedStatement.executeUpdate();
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("GET client data from database ERROR!");
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return result;
    }
}
