<%@ page language="java"
contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="account.database.Account, user.database.User"
%>
<%@ page import="java.util.Set" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="styles.css">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<title>Account Form</title>
</head>
<%
    User currentUser = (User) session.getAttribute("currentUserSession");
    Set<String> availableTitles = currentUser.getAvailableTitles();
%>
    <style>
      .container-account {
        max-width: 250px;
        padding: 20px;
        margin: auto;
        height: 125px;
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
      #create-button {
        background-color: rgb(252, 220, 9);
        padding: 10px;
        color:black;
        margin: 5px;
        width: 100px;
        border: none;
        font-size: large;
        font-family: system-ui;
      }
      #create-button:hover {
        background-color: rgb(247, 231, 128);
      }

      #title {
        padding: 10px;
        width: 225px;
        color: black;
        background-color: #CEF6CE;
        border: none;
        margin: 5px;
        border-radius: 7px;
      }
    </style>
<body>
      <form class="container-account" action="createAccountServlet" method="post">
        <table>
          <tr>
          <td>
            <select id="title" name="title" required>
                <% for (String title : availableTitles) { %>
                    <option value="<%= title %>"><%= title %></option>
                <% } %>
            </select>
            </td>
          </tr>
        </table>
        <input type="submit" value="Create" id="create-button" />
      </form>
</body>
</html>