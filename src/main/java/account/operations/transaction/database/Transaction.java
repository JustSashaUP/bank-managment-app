package account.operations.transaction.database;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Transaction {
    private int id;
    private int senderAccountId;
    private int recipientAccountId;
    private String recipientCardNumber;
    private double transactionSize;
    private java.sql.Timestamp transactionDateTime;
    private String transactionStatus;
    private String transactionType;

    public Transaction() {}

    public Transaction(int id, int senderAccountId, int recipientAccountId, double transactionSize,
                       String transactionDateTime, String transactionStatus, String transactionType) throws ParseException {
        this.id = id;
        this.senderAccountId = senderAccountId;
        this.recipientAccountId = recipientAccountId;
        this.transactionSize = transactionSize;
        this.transactionDateTime = parseTimestamp(transactionDateTime);
        this.transactionStatus = transactionStatus;
        this.transactionType = transactionType;
    }

    public Transaction(int senderAccountId, int recipientAccountId, double transactionSize,
                       String transactionDateTime, String transactionStatus, String transactionType) throws ParseException {
        this.senderAccountId = senderAccountId;
        this.recipientAccountId = recipientAccountId;
        this.transactionSize = transactionSize;
        this.transactionDateTime = parseTimestamp(transactionDateTime);
        this.transactionStatus = transactionStatus;
        this.transactionType = transactionType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSenderAccountId() {
        return senderAccountId;
    }

    public void setSenderAccountId(int senderAccountId) {
        this.senderAccountId = senderAccountId;
    }

    public int getRecipientAccountId() {
        return recipientAccountId;
    }

    public void setRecipientAccountId(int recipientAccountId) {
        this.recipientAccountId = recipientAccountId;
    }

    public String getRecipientCardNumber() {
        return recipientCardNumber;
    }

    public void setRecipientCardNumber(String recipientCardNumber) {
        this.recipientCardNumber = recipientCardNumber;
    }

    public double getTransactionSize() {
        return transactionSize;
    }

    public void setTransactionSize(double transactionSize) {
        this.transactionSize = transactionSize;
    }

    public String getTransactionStatus() {
        return transactionStatus;
    }

    public void setTransactionStatus(String transactionStatus) {
        this.transactionStatus = transactionStatus;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public java.sql.Timestamp getTransactionDateTime() {
        return transactionDateTime;
    }

    public void setTransactionDateTime(String transactionDateTime) throws ParseException {
        this.transactionDateTime = parseTimestamp(transactionDateTime);
    }

    public static Timestamp parseTimestamp(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date utilDate = dateFormat.parse(date);
        return new java.sql.Timestamp(utilDate.getTime());
    }

    @Override
    public String toString() {
        return "Transaction{" +
                "id=" + id +
                ", senderAccountId=" + senderAccountId +
                ", recipientAccountId=" + recipientAccountId +
                ", transactionSize=" + transactionSize +
                ", transactionDateTime=" + transactionDateTime +
                ", transactionStatus='" + transactionStatus + '\'' +
                ", transactionType='" + transactionType + '\'' +
                '}';
    }
}
