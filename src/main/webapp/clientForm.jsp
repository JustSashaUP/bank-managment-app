<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" import="account.database.Account, user.database.User"
%> <%@ page import="java.util.Set" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <title>Update Form</title>
    <style>
      .container-client {
        max-width: 500px;
        padding: 20px;
        margin: auto;
        height: 225px;
        margin-top: 100px;
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
      #update-button {
        background-color: rgb(252, 220, 9);
        padding: 25px;
        color:black;
        margin: 10px;
        width: 150px;
        border: none;
        font-size: large;
        font-family: system-ui;
      }
      #update-button:hover {
        background-color: rgb(247, 231, 128);
      }
    </style>
  </head>
  <body>
      <form class="container-client" action="updateClientServlet" method="post">
        <table>
          <tr>
            <td><label for="email">Email*</label></td>
            <td>
              <input id="email" name="email" type="email" placeholder="example@example.com" required />
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
  </body>
</html>