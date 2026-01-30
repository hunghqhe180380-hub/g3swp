<%-- 
    Document   : request-password
    Created on : Jan 31, 2026, 12:14:47 AM
    Author     : hung2
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Forgot Password</h1>
        <h3>Enter your email address and we’ll send you a link to reset your password.</h3>
        <form action="forgot-password" method="POST">
            <table border="1">
                <tbody>
                    <tr>
                        <td>Email: </td>
                        <td>
                            <input type="email" name="email"
                                   placeholder="Enter your email..."
                                   value="${requestScope.email}">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="Reset Password">
                        </td>
                    </tr>
                    <c:if test="${not empty requestScope.listMSG}">
                        <tr>
                            <c:if test="${not empty listMSG.msgEmail}">
                                <td colspan="2">
                                    ${listMSG.msgEmail}
                                </td>
                            </c:if>
                            <c:if test="${not empty listMSG.msgToken}">
                                <td colspan="2">
                                    ${listMSG.msgToken}
                                </td>
                            </c:if>
                        </tr>
                    </c:if>
                </tbody>
            </table>

        </form>
    </body>
</html>
