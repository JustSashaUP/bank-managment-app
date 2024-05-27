  <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
      pageEncoding="ISO-8859-1"%>
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
  <html>
  <head>
    <title>Login Form</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
    <style>
      .container {
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
      #login-button {
        background-color: rgb(252, 220, 9);
        padding: 25px;
        color:black;
        margin: 10px;
        width: 150px;
        border: none;
        font-size: large;
        font-family: system-ui;
      }
      #login-button:hover {
        background-color: rgb(247, 231, 128);
      }
    </style>
          <script>
          function passVisibility() {
             var x = document.getElementById("password");
             if (x.type === "password") {
                x.type = "text";
             }
             else {
                x.type = "password";
             }
          }
          </script>
    </head>
    <body style="background-color: rgb(163, 218, 255)">
    <%
        String auntId = null;
        if(session.getAttribute("currentUserSession") != null)
        {
        	response.sendRedirect("homePage.jsp");
        }
    %>
      <form class="container" action="loginServlet" method="post">
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
              <input id="password" name="password" type="password" required pattern=".{6,}" title="Password must be at least 6 characters long" />
              <input type="checkbox" onclick="passVisibility()">show</input>
            </td>
          </tr>
        </table>
        <input type="submit" value="Login" id="login-button" />
      </form>
      <%
        String status = (String) request.getAttribute("errorMessage");
        if (status != null)
        {
      %>
        <script>
            Swal.fire({
                icon: 'error',
                title: 'Login failed!',
                text: '<%= status %>',
            }).then(function() {
                window.location.href = 'login.jsp';
            });
        </script>
      <%
        request.setAttribute("errorMessage", null);
        }
      %>
    </body>
</html>