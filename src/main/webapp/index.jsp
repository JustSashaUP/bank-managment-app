<%@ page language="java"
contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="account.database.Account, user.database.User, account.operations.credit.database.Credit, account.operations.deposit.database.Deposit, account.operations.transaction.database.Transaction"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="styles.css">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<title>Green bank</title>
</head>
<style>
    .join-us {
        font-size: 24px;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        color: #333;
        text-align: center;
        margin-top: 20px;
    }
</style>
<body>
<div class="main-container">
    <header>
        <div class="container">
            <div class="logo-container">
                <img src="sources/logo.png" alt="🏦" class="logo">
                <h1>Bank</h1>
            </div>
            <nav>
                <ul>
                    <%
                        User currentUser = (User) session.getAttribute("currentUserSession");

                        if (currentUser == null) {
                    %>
                        <li><a href="login.jsp" class="active">Log in</a></li>
                        <li><a href="register.jsp" class="active">Sign in</a></li>
                    <%
                        }
                    %>
                    <li><a href="index.jsp">Main Page</a></li>
                    <%
                        if (currentUser != null) {
                    %>
                            <li><a href="homePage.jsp">Home Page</a></li>
                    <%
                        }
                    %>
                </ul>
            </nav>
        </div>
    </header>
</body>
        <div class="main-container-bg">
            <h1>Welcome <img src="sources/waving-hand.gif" alt="there!" style="vertical-align: middle;"> to <strong style="color: #abe99b;">Green</strong> Bank! </h1>
            <p class="main-text-block">Welcome to our bank! We offer the best financial services for all your needs.
            Our bank strives to provide a high level of service and favorable conditions for each client.
            Here are a few reasons why you should choose us:</p>

            <h3>Our Advantages</h3>
            <ul class="main-text-block">
                <li><strong>Reliability and security &#128272;:</strong> We guarantee complete security of your funds and confidentiality of personal data.</li>
                <li><strong>Favorable conditions &#127775;:</strong> Our banking products include low interest rates on loans and high interest rates on deposits.</li>
                <li><strong>Convenience of service &#128187;:</strong> We offer modern online services to manage your finances anytime and from anywhere.</li>
                <li><strong>Individual approach &#128100;:</strong> Our specialists are always ready to provide personal consultations and assistance in choosing the best financial solutions.</li>
                <li><strong>Wide range of services &#127975;:</strong> Account opening, loans, deposits, insurance, and other financial products - all available at our bank.</li>
            </ul>


            <p class="join-us">Join us today and discover new opportunities with our bank!</p>
        </div>

    <footer>
        <div class="container">
            <p>&copy; 2024 Bank. All rights reserved.</p>
        </div>
    </footer>
</div>
</html>
