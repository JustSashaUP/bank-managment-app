package account.operations.deposit.database;

import java.io.Serial;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Deposit {
    @Serial
    private static final long serialVersionUID = 1L;
    private int id;
    private int accountId;
    private double depositSize;
    private java.sql.Date depositStartDate;
    private java.sql.Date depositEndDate;
    private String depositStatus;
    private double depositPercent;

    public Deposit() {}

    public Deposit(int id, int accountId, double depositSize, Date depositStartDate, Date depositEndDate, String depositStatus, double depositPercent) {
        this.id = id;
        this.accountId = accountId;
        this.depositSize = depositSize;
        this.depositStartDate = depositStartDate;
        this.depositEndDate = depositEndDate;
        this.depositStatus = depositStatus;
        this.depositPercent = depositPercent;
    }

    public Deposit(int accountId, double depositSize, Date depositStartDate, Date depositEndDate, String depositStatus, double depositPercent) {
        this.accountId = accountId;
        this.depositSize = depositSize;
        this.depositStartDate = depositStartDate;
        this.depositEndDate = depositEndDate;
        this.depositStatus = depositStatus;
        this.depositPercent = depositPercent;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public double getDepositSize() {
        return depositSize;
    }

    public void setDepositSize(double depositSize) {
        this.depositSize = depositSize;
    }

    public String getDepositStatus() {
        return depositStatus;
    }

    public void setDepositStatus(String depositStatus) {
        this.depositStatus = depositStatus;
    }

    public double getDepositPercent() {
        return depositPercent;
    }

    public void setDepositPercent(double depositPercent) {
        this.depositPercent = depositPercent;
    }

    public java.sql.Date getDepositStartDate() {
        return depositStartDate;
    }

    public void setDepositStartDate(String depositStartDate) throws ParseException {
        this.depositStartDate = parseDate(depositStartDate);
    }

    public java.sql.Date getDepositEndDate() {
        return depositEndDate;
    }

    public void setDepositEndDate(String depositEndDate) throws ParseException {
        this.depositEndDate = parseDate(depositEndDate);
    }

    public java.sql.Date parseDate(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilDate = dateFormat.parse(date);
        return new java.sql.Date(utilDate.getTime());
    }

    @Override
    public String toString() {
        return "Deposit{" +
                "id=" + id +
                ", accountId=" + accountId +
                ", depositSize=" + depositSize +
                ", depositStartDate=" + depositStartDate +
                ", depositEndDate=" + depositEndDate +
                ", depositStatus='" + depositStatus + '\'' +
                ", depositPercent=" + depositPercent +
                '}';
    }
}
