package com.project.database;

import java.sql.*;

public class Main {
    public static void main(String[] args) {
        DBWorker worker = new DBWorker();

        String AllUsersQuery = "select * from client";
        try {
            Statement statement = worker.getConnection().createStatement();
            ResultSet resultSet = statement.executeQuery(AllUsersQuery);

            while(resultSet.next())
            {
                User user = new User();
                user.setId(resultSet.getInt(1));
                user.setFirstName(resultSet.getString(2));
                user.setLastName(resultSet.getString(3));
                user.setPhoneNumber(resultSet.getString(4));
                user.setEmail(resultSet.getString(5));
                user.setBirthDate(resultSet.getDate(6));
                user.setPassword(resultSet.getString(7));
                System.out.println(user.toString());
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}