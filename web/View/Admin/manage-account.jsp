<%-- 
    Document   : manage-account
    Created on : Jan 26, 2026, 11:35:26 AM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Manage Account </h1>
        <table>
            <tr>
                <th>User</th>
                <th>Email</th>
                <th>Role</th>
                <th>Account</th>
                <th></th>
            </tr>           
            <c:forEach items="${users}" var="user" begin="${page.start}" end="${page.end}">
                <tr>
                    <td>${user.userName}</td>
                    <td>${user.email}</td>
                    <td>${user.role}</td>
                    <td>${user.account}</td>
                    <td></td>
                </tr>
            </c:forEach>            
        </table>
        <c:if test="${page.index!=0}">
            <a href="DemoPaging?index=0">Home</a>
            <a href="DemoPaging?index=${page.index-1}">Pre</a>
        </c:if>
        <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
            <a href="DemoPaging?index=${index}">${index+1}</a>
        </c:forEach>
        <c:if test="${page.index!=page.totalPage-1}">
            <a href="DemoPaging?index=${page.index+1}">Next</a>
            <a href="DemoPaging?index=${page.totalPage-1}">End</a>
        </c:if>
</body>
</html>
