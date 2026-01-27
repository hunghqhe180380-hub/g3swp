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

        <a href="${pageContext.request.contextPath}/home"><-Back to home page</a>

        <form action="${pageContext.request.contextPath}/login" method="POST">

            <table border="0">
                <tbody>
                    <tr>
                        <td colspan="2">
                            Email:
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input style="width: 100%" type="text" name="email" 
                                   placeholder="Email or Username"
                                   value="${requestScope.email}">
                            <span class="errors">${listMSG.msgUserName}</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Password:
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input style="width: 100%" type="password" name="password" placeholder="Password">
                            <span class="errors">${listMSG.msgPassword}</span>
                            <span class="errors">${requestScope.msgIncorectLogin}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="radio"> Keep me logged in
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/request-password">Forgot password</a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <input type="submit" value="Log In">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Don't have an account? 
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/register">Sig up here</a>
                        </td>
                    </tr>
                    <c:if test="${not empty requestScope.MSG99}">
                        <tr>
                            <td>
                                ${requestScope.MSG99}
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/verify-email">Verify Email</a>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </form>
    </body>
</html>
