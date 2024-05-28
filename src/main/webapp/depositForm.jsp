<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" import="account.database.Account, user.database.User"
%> <%@ page import="java.util.Set" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <title>Deposit Form</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <style>
      .container-deposit {
        max-width: 500px;
        padding: 20px;
        margin: auto;
        height: 225px;
        margin-top: 250px;
        background-color: #A9F5A9;
        border-radius: 5px;
        box-shadow: 0 5px 5px rgba(0, 0, 0, 0.1);
        justify-content: center;
        align-items: center;
      }
      form {
        font-family: system-ui;
        font-size: x-large;
      }
      input {
        padding: 10px;
        color: black;
        background-color: #CEF6CE;
        border: none;
        margin: 5px;
        border-radius: 7px;
      }
      table {
        width: 100%;
      }
      td {
        padding: 10px;
        color: black;
      }
      #create-button {
        background-color: rgb(252, 220, 9);
        padding: 25px;
        color:black;
        margin: 10px;
        width: 150px;
        border: none;
        font-size: large;
        font-family: system-ui;
      }
      #create-button:hover {
        background-color: rgb(247, 231, 128);
      }
    </style>
  </head>
  <body>
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
      <form class="container-deposit" action="createDepositServlet" method="post">
        <table>
          <tr>
            <td><label for="amount">Amount*</label></td>
            <td>
              <input id="amount" name="amount" type="amount" placeholder="1000.00" required />
            </td>
          </tr>
          <tr>
            <td><label for="end_date">End date*</label></td>
            <td>
              <input id="end_date" name="end_date" type="date" required />
            </td>
          </tr>
        </table>
        <input type="submit" value="Create" id="create-button" />
      </form>
      <%
          String status = (String) request.getAttribute("successMessage");
          if (status == null) {
              status = (String) request.getAttribute("errorMessage");
          }

          if ("Successfully!".equals(status)) {
      %>
              <script>
                  Swal.fire({
                      icon: 'success',
                      title: 'Deposit',
                      text: '<%= status %>',
                  }).then(function() {
                      window.location.href = 'depositForm.jsp';
                  });
              </script>
      <%
              request.setAttribute("successMessage", null);
          }

          if ("Failed!".equals(status)) {
      %>
              <script>
                  Swal.fire({
                      icon: 'error',
                      title: 'Deposit',
                      text: '<%= status %>',
                  }).then(function() {
                      window.location.href = 'depositForm.jsp';
                  });
              </script>
      <%
              request.setAttribute("errorMessage", null);
          }
      %>
  </body>
  <script>
    var today = new Date();
    var twoWeeksLater = new Date(today.getTime() + 14 * 24 * 60 * 60 * 1000);
    var minDate = twoWeeksLater.toISOString().split('T')[0];
    document.getElementById("end_date").min = minDate;
  </script>
</html>