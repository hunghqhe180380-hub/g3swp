<%-- 
    Document   : forgot-password
    Created on : Jan 28, 2026, 4:51:39 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reset Password</title>
    </head>
    <body>
        <h1>Reset Password</h1>
        <a href="${pageContext.request.contextPath}/home"><-Back to home page</a>
        <table border="0">
            <tbody>
                <tr>
                    <td>Email:</td>
                    <td>
                        <input type="email" name="email" value="${requestScope.email}" readonly>
                    </td>
                </tr>
                <tr>
                    <td>New password: </td>
                    <td>
                        <input type="password" name="newPassword">
                    </td>
                </tr>
                <tr>
                    <td>Confirm password:</td>
                    <td>
                        <input type="password" name="confirmPassword">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Reset Password">
                    </td>
                </tr>
            </tbody>
        </table>

    </body>
</html>
