<%@ page language="java"
contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="account.database.Account, user.database.User, account.operations.credit.database.Credit, account.operations.deposit.database.Deposit, account.operations.transaction.database.Transaction"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="styles.css">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<title>Account</title>
    <style>
        .account-info {
            margin-bottom: 20px;
        }

        .navigation {
            text-align: center;
        }

        .arrow-button {
            padding: 5px;
            margin: 0 5px;
            cursor: pointer;
            border: none;
            background: none;
            font-size: 50px;
            color: green;
        }

        .arrow-button:hover {
            padding: 5px;
            margin: 0 5px;
            cursor: pointer;
            border: none;
            background: gray;
            font-size: 50px;
            color: green;
        }
    </style>
</head>
<body>
<%
    request.getRequestDispatcher("/updateAccountServlet").include(request, response);
    request.getRequestDispatcher("/updateCreditServlet").include(request, response);
    request.getRequestDispatcher("/updateDepositServlet").include(request, response);
    request.getRequestDispatcher("/updateTransactionServlet").include(request, response);
    User currentUser = (User) session.getAttribute("currentUserSession");

    if (currentUser.getAccounts() == null || currentUser.accountsCount() == 0) {
        response.sendRedirect("homepage.jsp");
    }

    int currentAccountIndex = 0;
    int currentCreditIndex = 0;
    int currentDepositIndex = 0;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("currentAccountIndex")) {
                currentAccountIndex = Integer.parseInt(cookie.getValue());
            }
            if (cookie.getName().equals("currentCreditIndex")) {
                currentCreditIndex = Integer.parseInt(cookie.getValue());
            }
            if (cookie.getName().equals("currentDepositIndex")) {
                currentDepositIndex = Integer.parseInt(cookie.getValue());
            }
        }
    }
    Account currentAccount = currentUser.getAccounts().get(currentAccountIndex);
%>
<div class="main-container-low-nav">
    <header>
        <div class="container">
            <div class="logo-container">
                <img src="sources/logo.png" alt="🏦" class="logo">
                <h1>Bank</h1>
            </div>
            <nav>
                <ul>
                    <li><a href="index.jsp">Main Page</a></li>
                    <li><a href="homePage.jsp">Home Page</a></li>
                    <li><a href="accountPage.jsp">Account Page</a></li>
                </ul>
            </nav>
        </div>
    </header>
    </div>
    <div class="main-container-low-size">
<div class="container">
<h1>Accounts page</h1>
<h1 class="text-block-green"><%= currentAccount.getTitle() %> &#128184</h1>
    <div class="text-block" style="background: linear-gradient(100deg, #7ee8fb 0%, #7fffb1 100%);">
        <div class="text-block">
            Title: <%= currentAccount.getTitle() %>
        </div><br/>
        <div class="text-block">
            Number: <%= currentAccount.getNumber() %>
        </div><br/>
        <div class="balance-container">
            Balance: <%= currentAccount.getBalance() %>
        </div>
    </div><br/>
        <%
        // checking the number of accounts,
        // if the number is maximum, then the button is hidden

            if (currentUser.accountsCount() < 3)
            {
        %>
            <button class="button-submit" onclick="openAccountForm()">New Account</button>
        <%
            }
        %>
        <button class="button-submit" onclick="redirectToTransactionPage()">Send funds</button>
        <button class="button-submit" onclick="redirectToTransactionTopUpPage()">Add funds</button>
    <div class="account-info">
        <h2>Credit</h2>
<%
boolean creditFound = false;
boolean isCreditHistoryEmpty = true;
for (Credit credit : currentAccount.getCredits()) {
    if (credit.getCreditStatus().equals("open") || credit.getCreditStatus().equals("overdue")) {
        creditFound = true;
%>
<div class="text-block">
        <div>
            Amount: <%= credit.getCreditSize() %>
        </div>
        <div>
            Percent: <%= credit.getCreditPercent() %>
        </div>
        <div>
            Start date: <%= credit.getCreditStartDate() %>
        </div>
        <div>
            End date: <%= credit.getCreditEndDate() %>
        </div>
        <div>
            Status: <%= credit.getCreditStatus() %>
        </div>
        </div>
<%
    }
}
if (!creditFound) {
%>
<div class="text-block">
        <div>No open or overdue credit data available</div>
        </div><br/>
<%
}
%>

    <%
    // checking the number of credits,
    // if the number is maximum, then the button is hidden

        if (!creditFound)
        {
    %>
        <button class="button-submit" onclick="openCreditForm()">New Credit</button>
    <%
        }
    %>

        <h2>Deposit</h2>
<%
boolean depositFound = false;
boolean isDepositHistoryEmpty = true;
for (Deposit deposit : currentAccount.getDeposits()) {
    if (deposit.getDepositStatus().equals("open")) {
        depositFound = true;
%>
<div class="text-block">
        <div>
            Amount: <%= deposit.getDepositSize() %>
        </div>
        <div>
            Percent: <%= deposit.getDepositPercent() %>
        </div>
        <div>
            Start date: <%= deposit.getDepositStartDate() %>
        </div>
        <div>
            End date: <%= deposit.getDepositEndDate() %>
        </div>
        <div>
            Status: <%= deposit.getDepositStatus() %>
        </div>
        </div><br/>
<%
    }
}
if (!depositFound) {
%>
<div class="text-block">
        <div>No open deposit data available</div>
</div><br/>
<%
}

%>
    <%
    // checking the number of deposits,
    // if the number is maximum, then the button is hidden

        if (!depositFound)
        {
    %>
        <button class="button-submit" onclick="openDepositForm()">New Deposit</button><br/>
    <%
        }
    %>

    <%-- Navigation if more than one account --%>
<div class="navigation">
    <%
    if (currentUser.accountsCount() > 1) {
        if (currentAccountIndex != 0) {
    %>
    <button onclick="changeAccount(<%= currentAccountIndex - 1 %>)" class="arrow-button">&#8249;</button>
    <%
        }
        if (currentAccountIndex != currentUser.accountsCount() - 1) {
    %>
    <button onclick="changeAccount(<%= currentAccountIndex + 1 %>)" class="arrow-button">&#8250;</button>
    <%
        }
    }
    %>
</div><br/>
<div class="text-block">
    <h2>Credit History</h2>
<%
for (Credit credit : currentAccount.getCredits()) {
    if (credit.getCreditStatus().equals("paid")) {
    isCreditHistoryEmpty = false;
%>
<div class="text-block-gray">
        <div>
            Amount: <%= credit.getCreditSize() %>
        </div>
        <div>
            Percent: <%= credit.getCreditPercent() %>
        </div>
        <div>
            Start date: <%= credit.getCreditStartDate() %>
        </div>
        <div>
            End date: <%= credit.getCreditEndDate() %>
        </div>
        <div>
            Status: <%= credit.getCreditStatus() %>
        </div>
        </div>
        <br/>
<%
    }
}
if (isCreditHistoryEmpty)
{
    %>
            <div>No credit history available</div>
    <%
}
%>
    <h2>Deposit History</h2>
<%
for (Deposit deposit : currentAccount.getDeposits()) {
    if (deposit.getDepositStatus().equals("closed")) {
    isDepositHistoryEmpty = false;
%>
<div class="text-block-gray">
        <div>
            Amount: <%= deposit.getDepositSize() %>
        </div>
        <div>
            Percent: <%= deposit.getDepositPercent() %>
        </div>
        <div>
            Start date: <%= deposit.getDepositStartDate() %>
        </div>
        <div>
            End date: <%= deposit.getDepositEndDate() %>
        </div>
        <div>
            Status: <%= deposit.getDepositStatus() %>
        </div>
        </div>
        <br/>
<%
    }
}
if (isDepositHistoryEmpty)
{
    %>
            <div>No deposit history available</div>
    <%
}
%>
    <h2>Transaction History</h2>
<%
boolean isTransactionHistoryEmpty = currentAccount.getTransactions().isEmpty();
if (isTransactionHistoryEmpty) {
%>
    <div>No transaction history available</div>
<%
} else {
    for (Transaction transaction : currentAccount.getTransactions()) {
%>
<div class="text-block-gray">
        <div>
            Amount: <%= transaction.getTransactionSize() %>
        </div>
        <div>
            Type: <%= transaction.getTransactionType() %>
        </div>
        <div>
            Status: <%= transaction.getTransactionStatus() %>
        </div>
        <div>
            Date: <%= transaction.getTransactionDateTime() %>
        </div>
        </div>
        <br/>
<%
    }
}
%>
</div>
     </div>
    <div>
    </div>
</div>
<script type="text/javascript">
    function redirectToTransactionPage() {
        window.location.href = 'transactionPage.jsp';
    }
    function redirectToTransactionTopUpPage() {
        window.location.href = 'topupPage.jsp';
    }
</script>
<script>
    function changeAccount(index) {
        document.cookie = "currentAccountIndex=" + index;
        document.cookie = "currentCreditIndex=" + index;
        document.cookie = "currentDepositIndex=" + index;
        location.reload();
    }
</script>
<script>
    function openAccountForm() {
        var width = 300;
        var height = 400;
        var left = (screen.width - width) / 2;
        var top = (screen.height - height) / 2;
        var features = "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top + ", resizable=yes, scrollbars=yes";
        window.open("accountForm.jsp", "_blank", features);
    }
        function openCreditForm() {
            window.location.href = "creditForm.jsp";
        }

        function openDepositForm() {
            window.location.href = "depositForm.jsp";
        }
</script>
</body>
<script src="scripts.js"></script>
</html>