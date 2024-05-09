<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" import="account.database.Account, user.database.User"
%> <%@ page import="java.util.Set" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <title>Update Form</title>
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
      <form class="container" action="updateClientServlet" method="post">
        <table>
          <tr>
            <td><label for="email">Email*</label></td>
            <td>
              <input id="email" name="email" type="email" required />
            </td>
          </tr>
          <tr>
            <td><label for="password">Password*</label></td>
            <td>
              <input id="password" name="password" type="password" required />
            </td>
          </tr>
        </table>
        <input type="submit" value="Update" id="update-button" />
      </form>
    </div>
  </body>
</html>