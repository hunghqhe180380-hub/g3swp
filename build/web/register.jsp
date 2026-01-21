<%-- 
    Document   : register
    Created on : Jan 20, 2026, 11:42:15 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register Page</title>
    </head>
    <body>
        <h1>Register</h1>
        <form action="${pageContext.request.contextPath}/Account/Register" method="POST">
            <table border="1">
                <tbody>
                    <tr>
                        <td>User Name: </td>
                        <td>
                            <input type="text" name="email">
                        </td>
                    </tr>
                    <tr>
                        <td>Full Name: </td>
                        <td>
                            <input type="text" name="fullName">
                        </td>
                    </tr>
                    <tr>
                        <td>Email: </td>
                        <td>
                            <input type="email" name="email">
                        </td>
                    </tr>
                    <tr>
                        <td>Phone number:</td>
                        <td>
                            <input type="text" name="phoneNumber">
                        </td>
                    </tr>
                    <tr>
                        <td>Password: </td>
                        <td>
                            <input type="password" name="password">
                        </td>
                    </tr>
                    <tr>
                        <td>Confirm Password: </td>
                        <td>
                            <input type="password" name="confirmPassword">
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
