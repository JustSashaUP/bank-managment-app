package account.operations.credit.database;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Credit {
    private int id;
    private int accountId;
    private double creditSize;
    private java.sql.Date creditStartDate;
    private java.sql.Date creditEndDate;
    private String creditStatus;
    private double creditPercent;
    private double creditLimit;

    public Credit() {}

    public Credit(int id, int accountId, double creditSize, Date creditStartDate, Date creditEndDate,
                  String creditStatus, double creditPercent, double creditLimit) {
        this.id = id;
        this.accountId = accountId;
        this.creditSize = creditSize;
        this.creditStartDate = creditStartDate;
        this.creditEndDate = creditEndDate;
        this.creditStatus = creditStatus;
        this.creditPercent = creditPercent;
        this.creditLimit = creditLimit;
    }

    public Credit(int accountId, double creditSize, Date creditStartDate, Date creditEndDate, String creditStatus, double creditPercent, double creditLimit) {
        this.accountId = accountId;
        this.creditSize = creditSize;
        this.creditStartDate = creditStartDate;
        this.creditEndDate = creditEndDate;
        this.creditStatus = creditStatus;
        this.creditPercent = creditPercent;
        this.creditLimit = creditLimit;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getCreditSize() {
        return creditSize;
    }

    public void setCreditSize(double creditSize) {
        this.creditSize = creditSize;
    }

    public String getCreditStatus() {
        return creditStatus;
    }

    public void setCreditStatus(String creditStatus) {
        this.creditStatus = creditStatus;
    }

    public double getCreditPercent() {
        return creditPercent;
    }

    public void setCreditPercent(double creditPercent) {
        this.creditPercent = creditPercent;
    }

    public double getCreditLimit() {
        return creditLimit;
    }

    public void setCreditLimit(double creditLimit) {
        this.creditLimit = creditLimit;
    }

    public java.sql.Date getCreditStartDate() {
        return creditStartDate;
    }

    public void setCreditStartDate(String creditStartDate) throws ParseException {
        this.creditStartDate = parseDate(creditStartDate);
    }

    public java.sql.Date getCreditEndDate() {
        return creditEndDate;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public void setCreditEndDate(String creditEndDate) throws ParseException {
        this.creditEndDate = parseDate(creditEndDate);
    }

    private java.sql.Date parseDate(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        java.util.Date utilDate = dateFormat.parse(date);
        return new java.sql.Date(utilDate.getTime());
    }

    @Override
    public String toString() {
        return "Credit{" +
                "id=" + id +
                ", accountId=" + accountId +
                ", creditSize=" + creditSize +
                ", creditStartDate=" + creditStartDate +
                ", creditEndDate=" + creditEndDate +
                ", creditStatus='" + creditStatus + '\'' +
                ", creditPercent=" + creditPercent +
                ", creditLimit=" + creditLimit +
                '}';
    }
}