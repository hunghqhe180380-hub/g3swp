<%-- 
    Document   : reset-password
    Created on : Jan 29, 2026, 3:28:21 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Reset Password</h1>
        <form action="reset-password" method="POST">

            <table border="1">
                <thead>
                    <tr>
                        <th>Email: </th>
                        <th>
                            <input type="email" name="email" value="${requestScope.email}">
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>New password: </td>
                        <td>
                            <input type="password" name="newPassword">
                        </td>
                    </tr>
                    <tr>
                        <td>Confirm password: </td>
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
        </form>
    </body>
</html>
