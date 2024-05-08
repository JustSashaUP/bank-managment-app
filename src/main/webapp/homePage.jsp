<%@ page language="java"
contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="user.database.User"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title>
<style>
    body {
        margin: 0;
        padding: 0;
        }
    .container {
        width: 65%;
        margin: 0 auto;
        padding: 20px;
        background-color: #f0f0f0;
        }
</style>
</head>
<body>
<%
String userSession = null;
User currentUser = (User) session.getAttribute("currentUserSession");
if(currentUser == null)
{
	response.sendRedirect("login.jsp");
}
String userId = null;
String sessionID = null;
Cookie[] cookies = request.getCookies();
if(cookies !=null){
for(Cookie cookie : cookies){
	if(cookie.getName().equals("auntId")) userId = cookie.getValue();
	if(cookie.getName().equals("JSESSIONID")) sessionID = cookie.getValue();
}
}
%>
<div class="container">
<h3>Hi <%=userId %>, Login successful. Your Session ID=<%=sessionID %></h3>
<div>
    First Name: <%=currentUser.getFirstName()%>
</div>
<div>
    Last Name: <%=currentUser.getLastName()%>
</div>
<div>
    Phone Number: <%=currentUser.getPhoneNumber()%>
</div>
<div>
    Email: <%=currentUser.getEmail()%>
</div>
<div>
    Birth Date: <%=currentUser.getBirthDate()%>
</div>
<div>
    <a href="accountPage.jsp">show accounts</a>
</div>
<br>
        <button onclick="openAccountForm()">Update</button>
    <form id="logoutForm" action="logoutServlet" method="post">
        <input type="submit" value="Logout">
    </form>
</div>
<script>
    function openAccountForm() {
        var width = 400;
        var height = 300;
        window.open("clientForm.jsp", "_blank", "width=" + width + ", height=" + height);
    }
</script>
</body>
</html>