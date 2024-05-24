<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" import="account.database.Account, user.database.User"
%> <%@ page import="java.util.Set" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <title>Credit Form</title>
    <style>
    body {
        margin: 0;
        padding: 0;
    }

    .container {
        margin: 0 auto;
        padding: 20px;
    }
    </style>
  </head>
  <body>
    <div class="container">
    <a href="homePage.jsp">Home</a>
      <form class="container" action="createTransactionServlet" method="post">
        <table>
          <tr>
            <td><label for="amount">Amount*</label></td>
            <td>
              <input id="amount" name="amount" type="amount" required />
            </td>
          </tr>
          <tr>
            <td><label for="card_number">Card number*</label></td>
            <td>
              <input id="card_number" name="card_number" type="text" required />
            </td>
          </tr>
        </table>
        <input type="submit" value="Send funds" id="update-button" />
      </form>
    </div>
  </body>
</html>