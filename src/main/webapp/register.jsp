  <%@ page language="java" contentType="text/html; charset=ISO-8859-1"
      pageEncoding="ISO-8859-1"%>
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
  <html>
  <title>Registration Form</title>
  <html>
  <body>
    <h1>Registration</h1>
    <form action="registerServlet" method="post">
      <table>
        <tr>
          <td><label for="firstName">First name*></label></td>
          <td>
            <input id="firstName" name="firstName" type="text" required />
          </td>
        </tr>
        <tr>
          <td><label for="lastName">Last Name*></label></td>
          <td>
            <input id="lastName" name="lastName" type="text" required />
          </td>
        </tr>
        <tr>
          <td><label for="email">Email*></label></td>
          <td>
            <input id="email" name="email" type="email" required />
          </td>
        </tr>
        <tr>
          <td><label for="phoneNumber">phone Number*></label></td>
          <td>
            <input id="phoneNumber" name="phoneNumber" type="tel" required />
          </td>
        </tr>
        <tr>
          <td><label for="password">Password*></label></td>
          <td>
            <input id="password" name="password" type="password" required />
          </td>
        </tr>
        <tr>
          <td><label for="birthDate">Date of birth</label></td>
          <td><input id="birthDate" name="birthDate" type="date" /></td>
        </tr>
      </table>
      <input type="submit" value="Submit" />
    </form>
  </body>
</html>