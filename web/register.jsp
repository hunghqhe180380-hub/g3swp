<%-- 
    Document   : register
    Created on : Jan 20, 2026, 11:42:15 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>
    </head>
    <body>
        <h1>Register</h1>
        <a href="${pageContext.request.contextPath}/home"><-Back to home page</a>
        <form action="${pageContext.request.contextPath}/register" method="POST">

            <table border="1">
                <tbody>
                    <tr>
                        <td>User Name: </td>
                        <td>
                            <input type="text" name="userName">
                            <span class="errors">${listMSG.msgUserName}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Full Name: </td>
                        <td>
                            <input type="text" name="fullName">
                            <span class="errors">${listMSG.msgFullName}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Email: </td>
                        <td>
                            <input type="email" name="email">
                            <span class="errors">${listMSG.msgEmail}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Phone number:</td>
                        <td>
                            <input type="text" name="phoneNumber">
                            <span class="errors">${listMSG.msgPhoneNumber}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Password: </td>
                        <td>
                            <input type="password" name="password">
                            <span class="errors">${listMSG.msgPassword}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Confirm Password: </td>
                        <td>
                            <input type="password" name="confirmPassword">
                            <span class="errors">${listMSG.msgConfirmPassword}</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="Register">
                        </td>
                    </tr>
                </tbody>
            </table>

        </form>
    </body>
</html>
