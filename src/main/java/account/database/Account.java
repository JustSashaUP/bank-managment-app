package account.database;

import account.operations.credit.database.Credit;
import account.operations.deposit.database.Deposit;
import account.operations.transaction.database.Transaction;

import java.io.Serial;
import java.io.Serializable;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

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
    private List<Credit> creditList;
    private List<Deposit> depositList;
    private List<Transaction> transactionList;

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

    public List<Credit> getCredits() {
        return creditList;
    }

    public void setCredits(List<Credit> credits) {
        this.creditList = credits;
    }

    public void setCredit(int i, Credit credit)
    {
        creditList.set(i, credit);
    }

    public Credit getCredit(int i)
    {
        return creditList.get(i);
    }

    public boolean addCredit(Credit credit)
    {
        if (creditList.contains(credit))
        {
            return false;
        }
        return creditList.add(credit);
    }

    public int creditsCount()
    {
        return creditList.size();
    }

    public List<Deposit> getDeposits() {
        return depositList;
    }

    public void setDeposits(List<Deposit> deposits) {
        this.depositList = deposits;
    }

    public void setDeposit(int i, Deposit deposit)
    {
        depositList.set(i, deposit);
    }

    public Deposit getDeposit(int i)
    {
        return depositList.get(i);
    }

    public boolean addDeposit(Deposit deposit)
    {
        if (depositList.contains(deposit))
        {
            return false;
        }
        return depositList.add(deposit);
    }

    public int depositsCount()
    {
        return depositList.size();
    }

    public List<Transaction> getTransactions() {
        return transactionList;
    }

    public void setTransactions(List<Transaction> transactions) {
        this.transactionList = transactions;
    }

    public void setTransaction(int i, Transaction transaction)
    {
        transactionList.set(i, transaction);
    }

    public Transaction getTransaction(int i)
    {
        return transactionList.get(i);
    }

    public boolean addTransaction(Transaction transaction)
    {
        if (transactionList.contains(transaction))
        {
            return false;
        }
        return transactionList.add(transaction);
    }

    public int transactionsCount()
    {
        return transactionList.size();
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
