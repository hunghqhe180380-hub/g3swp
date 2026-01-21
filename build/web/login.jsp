<%-- 
    Document   : home
    Created on : Jan 20, 2026, 9:14:32 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <h1>Login</h1>
        <form action="${pageContext.request.contextPath}/Account/Login" method="POST">
            <table border="1">
                <tbody>
                    <tr>
                        <td colspan="2">
                            <input type="email" name="email" placeholder="Email or Username">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="password" name="password" placeholder="Password">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="radio"> Remember me?
                        </td>
                        <td>
                            <a href="#">Forgot password</a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="Log In">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            ${requestScope.mess}
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </body>
</html>
