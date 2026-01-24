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
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/account/dashboard">Dashboard</a>||
                <a href="${pageContext.request.contextPath}/logout">Log Out</a>
            </c:when>
            <c:when test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login">Login</a> || 
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </c:when>        
        </c:choose>


    </body>
</html>

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
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/account/dashboard">Dashboard</a>||
                <a href="${pageContext.request.contextPath}/logout">Log Out</a>
            </c:when>
            <c:when test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login">Login</a> || 
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </c:when>        
        </c:choose>


    </body>
</html>