package database;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserDAO {
    public int registerUser(User user)
    {
        DBWorker worker = new DBWorker();

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
            System.out.println(preparedStatement);

            result = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(System.err);
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("Error code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return result;
    }
}
