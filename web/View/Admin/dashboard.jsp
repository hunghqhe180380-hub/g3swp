<%-- 
    Document   : user
    Created on : Jan 21, 2026, 11:53:10 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <title>Dashboard Page</title>
    </head>
    <body>
        <h1>Dashboard ${sessionScope.user.fullName}!</h1>
        <br>
        <h1>You are ${sessionScope.user.role}!</h1>
        <a href="${pageContext.request.contextPath}/home">Home</a> ||
        <a href="${pageContext.request.contextPath}/account/profile">View Profile</a> ||
        <a href="${pageContext.request.contextPath}/logout">Logout</a>  

    </body>
</html>
