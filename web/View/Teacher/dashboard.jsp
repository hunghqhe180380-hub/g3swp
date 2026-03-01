<%-- 
    Document   : user
    Created on : Jan 21, 2026, 11:53:10 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Page</title>
    </head>
    <body>

        <jsp:include page="/view/common/header.jsp" />

        <br>
        <h1>You are ${sessionScope.user.role}!</h1>
        <a href="${pageContext.request.contextPath}/home">Home</a> ||
        <a href="${pageContext.request.contextPath}/account/profile">View Profile</a> ||
        <a href="${pageContext.request.contextPath}/logout">Logout</a>  
        <a href="${pageContext.request.contextPath}/classroom/manage/edit?classId=22">Edit</a>  
        
    </body>
</html>
