package database;

import user.database.User;

import java.sql.*;
import java.text.ParseException;

public class Main {
    public static void main(String[] args) {
        DBWorker worker = new DBWorker();

        String AllUsersQuery = "call getClient(?);";
        try {
            PreparedStatement statement = worker.getConnection().prepareStatement(AllUsersQuery);
            statement.setInt(1, 14);
            ResultSet resultSet = statement.executeQuery();

            while(resultSet.next())
            {
                User user = new User();
                user.setId(resultSet.getInt(1));
                user.setFirstName(resultSet.getString(2));
                user.setLastName(resultSet.getString(3));
                user.setPhoneNumber(resultSet.getString(4));
                user.setEmail(resultSet.getString(5));
                user.setBirthDate(resultSet.getString(6));
                user.setPassword(resultSet.getString(7));
                System.out.println(user.toString());
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }
}