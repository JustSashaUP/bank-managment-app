package user.database;

import account.database.Account;

import java.io.Serial;
import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class User implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    private String password;
    private java.sql.Date birthDate;
    private List<Account> accountList;

    public User() {}

    public User(int id, String firstName, String lastName, String email, String phoneNumber, String password, String birthDate)
            throws ParseException {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.birthDate = parseDate(birthDate);
    }

    public User(String firstName, String lastName, String email, String phoneNumber, String password, String birthDate)
            throws ParseException {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.password = password;
        this.birthDate = parseDate(birthDate);
    }

    public List<Account> getAccounts() {
        return accountList;
    }

    public void setAccounts(List<Account> accounts) {
        this.accountList = accounts;
    }

    public void setAccount(int i, Account account)
    {
        accountList.set(i, account);
    }

    public Account getAccount(int i)
    {
        return accountList.get(i);
    }

    public boolean addAccount(Account account)
    {
        if (accountList.contains(account))
        {
            return false;
        }
        return accountList.add(account);
    }

    public int accountsCount()
    {
        return accountList.size();
    }

    public java.sql.Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(String birthDate) throws ParseException {
        this.birthDate = parseDate(birthDate);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    private java.sql.Date parseDate(String date) throws ParseException {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date utilDate = dateFormat.parse(date);
        return new java.sql.Date(utilDate.getTime());
    }

    public Set<String> getAvailableTitles() {
        Set<String> availableTitles = new HashSet<>();
        List<Account> accounts = this.getAccounts();

        boolean hasUSD = false;
        boolean hasEUR = false;

        for (Account account : accounts) {
            String title = account.getTitle();
            if ("USD".equals(title)) {
                hasUSD = true;
            } else if ("EUR".equals(title)) {
                hasEUR = true;
            }
        }

        if (hasUSD && !hasEUR) {
            availableTitles.add("EUR");
        } else if (!hasUSD && hasEUR) {
            availableTitles.add("USD");
        } else if (!hasUSD && !hasEUR) {
            availableTitles.add("USD");
            availableTitles.add("EUR");
        }

        return availableTitles;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", password='" + password + '\'' +
                ", birthDate=" + birthDate +
                '}';
    }
}