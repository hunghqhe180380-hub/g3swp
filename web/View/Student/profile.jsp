<%-- 
    Document   : profile
    Created on : Jan 25, 2026, 12:55:18 AM
    Author     : hung2
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
        <h1>===Profile=== ${sessionScope.user.fullName}!</h1>
        <br>
        <h1>You are ${sessionScope.user.role}!</h1>
        <a href="${pageContext.request.contextPath}/home">Home</a> ||
        <a href="${pageContext.request.contextPath}/account/dashboard">Dashboard</a> ||
        <a href="${pageContext.request.contextPath}/logout">Logout</a>  

        <div style="display: flex">
            <div>
                <table border="1">
                    <tbody>
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/account/profile">Profile</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a href="#">Email</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a href="#">Password</a>
                            </td>
                        </tr>
                    </tbody>
                </table>

            </div>
            <div>

            </div>
        </div>


    </body>
</html>
