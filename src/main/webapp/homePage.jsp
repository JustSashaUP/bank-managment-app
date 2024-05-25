<%@ page language="java"
contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
    import="user.database.User"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="styles.css">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
<title>Home</title>
<style>
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
    <div class="main-container-low-size">
<h1>Home page</h1>
<div class="text-block" style="background: linear-gradient(50deg, #7ee8fb 0%, #7fffb1 50%);">
<ui style="list-style: none;">
    <li><strong class="text-block-gray">First Name:</strong> <section class="text-block"><%=currentUser.getFirstName()%></section></li>
    <li><strong class="text-block-gray">Last Name:</strong> <section class="text-block"><%=currentUser.getLastName()%></section></li>
    <li><strong class="text-block-gray">Phone Number:</strong> <section class="text-block"><%=currentUser.getPhoneNumber()%></section></li>
    <li><strong class="text-block-gray">Email:</strong> <section class="text-block"><%=currentUser.getEmail()%></section></li>
    <li><strong class="text-block-gray">Birth Date:</strong> <section class="text-block"><%=currentUser.getBirthDate()%></section></li>
</ui>
</div>
<br>
<div style="margin-bottom: 5px;">
        <button class="button-submit" onclick="openClientForm()">Update client data</button>
</div>
    <form id="logoutForm" action="logoutServlet" method="post">
        <button type="submit">Logout</button>
    </form>
</div>
<script>
    function openClientForm() {
        var width = 600;
        var height = 500;
        var left = (screen.width - width) / 2;
        var top = (screen.height - height) / 2;
        window.open("clientForm.jsp", "_blank", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top);
    }
</script>
</body>
</html>