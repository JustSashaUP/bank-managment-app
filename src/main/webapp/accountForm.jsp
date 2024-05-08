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
<title>Account Form</title>
<style>
    body {
        margin: 0;
        padding: 0;
    }

    .container {
        width: 400px;
        height: 300px;
        margin: 0 auto;
        padding: 20px;
        background-color: #f0f0f0;
    }
</style>
</head>
<%
    User currentUser = (User) session.getAttribute("currentUserSession");
    Set<String> availableTitles = currentUser.getAvailableTitles();
%>
<body>
    <div class="container">
      <form class="container" action="createAccountServlet" method="post">
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
    </div>
</body>
</html>