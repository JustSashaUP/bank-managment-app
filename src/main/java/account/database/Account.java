package account.database;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Account implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String title;
    private String number;
    private double balance;
    private String status;
    private java.sql.Date startDate;

    public Account() {}

    public Account(int id, int userId, String title, String number, double balance, String status, Date startDate) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.number = number;
        this.balance = balance;
        this.status = status;
        this.startDate = startDate;
    }

    public Account(int userId, String title, String number, double balance, String status, Date startDate) {
        this.userId = userId;
        this.title = title;
        this.number = number;
        this.balance = balance;
        this.status = status;
        this.startDate = startDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public java.sql.Date getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) throws ParseException {
        this.startDate = parseDate(startDate);
    }

    private java.sql.Date parseDate(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        java.util.Date utilDate = dateFormat.parse(date);
        return new java.sql.Date(utilDate.getTime());
    }

    @Override
    public String toString() {
        return "Account{" +
                "id=" + id +
                ", userId=" + userId +
                ", title='" + title + '\'' +
                ", number='" + number + '\'' +
                ", balance=" + balance +
                ", status='" + status + '\'' +
                ", startDate=" + startDate +
                '}';
    }
}
