package account.operations.transaction.database;

import account.database.AccountDAO;
import database.DBWorker;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import utils.fileutil.LoggerUtils;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {
    private static final String GET_PROCEDURE_TRANSACTION_DATA = "call getTransactionDataByAccountId(?)";
    private static final String CREATE_PROCEDURE_TOPUP_TRANSACTION_DATA = "call topUp(?, ?)";
    private static final String CREATE_PROCEDURE_TRANSACTION_DATA = "call transfer(?, ?, ?)";
    private static DBWorker worker;
    private static Transaction transaction;
    private static Logger logger;
    static
    {
        logger = LogManager.getLogger(AccountDAO.class);
        LoggerUtils.setLogger(logger);
    }
    public static List<Transaction> getTransactionsDataByAccountId(int id)
    {
        List<Transaction> transactionList = new ArrayList<>();
        transaction = new Transaction();
        worker = new DBWorker();

        logger.info("GET transaction data from database✔️");

        try (PreparedStatement statement = worker.getConnection().prepareStatement(GET_PROCEDURE_TRANSACTION_DATA)) {
            statement.setString(1, String.valueOf(id));
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                transaction = new Transaction();
                transaction.setId(resultSet.getInt("transaction_id"));
                transaction.setSenderAccountId(resultSet.getInt("sender_id"));
                transaction.setRecipientAccountId(resultSet.getInt("resipient_id"));
                transaction.setTransactionSize(resultSet.getDouble("transaction_size"));
                transaction.setTransactionDateTime(resultSet.getString("transaction_date"));
                transaction.setTransactionStatus(resultSet.getString("transaction_status"));
                transaction.setTransactionType(resultSet.getString("transaction_type"));
                transactionList.add(transaction);
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
        return transactionList;
    }

    public static int transfer(int senderId, double amount, String cardNumber)
    {
        transaction = new Transaction();
        worker = new DBWorker();

        logger.info("INSERT transaction data to database✔️");

        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(CREATE_PROCEDURE_TRANSACTION_DATA))
        {
            transaction.setSenderAccountId(senderId);
            transaction.setTransactionSize(amount);
            transaction.setRecipientCardNumber(cardNumber);
            preparedStatement.setDouble(1, transaction.getTransactionSize());
            preparedStatement.setInt(2, transaction.getSenderAccountId());
            preparedStatement.setString(3, transaction.getRecipientCardNumber());
            logger.info(preparedStatement);

            result = preparedStatement.executeUpdate();
        }
        catch(SQLException e)
        {
            e.printStackTrace(System.err);
            logger.error("INSERT transaction data to database ERROR❌!");
            logger.error("SQLState: " + e.getSQLState());
            logger.error("Error code: " + e.getErrorCode());
            logger.error("Message: " + e.getMessage());
        }
        return result;
    }

    public static int accountTopUp(int recipientId, double amount)
    {
        transaction = new Transaction();
        worker = new DBWorker();

        logger.info("INSERT transaction data to database✔️");

        int result = 0;

        try(PreparedStatement preparedStatement = worker.getConnection().prepareStatement(CREATE_PROCEDURE_TOPUP_TRANSACTION_DATA))
        {
            transaction.setRecipientAccountId(recipientId);
            transaction.setTransactionSize(amount);
            preparedStatement.setInt(1, transaction.getRecipientAccountId());
            preparedStatement.setDouble(2, transaction.getTransactionSize());
            logger.info(preparedStatement);

            result = preparedStatement.executeUpdate();
        }
        catch(SQLException e)
        {
            logger.error("INSERT transaction data to database ERROR❌!");
            logger.error("SQLState: " + e.getSQLState());
            logger.error("Error code: " + e.getErrorCode());
            logger.error("Message: " + e.getMessage());
        }
        return result;
    }
}
