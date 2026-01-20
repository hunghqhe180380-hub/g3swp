<%-- 
    Document   : home
    Created on : Jan 20, 2026, 11:31:19 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Home Page</h1>
        <h2>${requestScope.email}</h2>
        <a href="${pageContext.request.contextPath}/Account/Login">Login</a>
        ||||
        <a href="${pageContext.request.contextPath}/Account/Register">Register</a>
    </body>
</html>
