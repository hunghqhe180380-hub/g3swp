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
        <h1>===Profile=== ${requestScope.user.fullName}, You are: ${requestScope.user.role}!</h1>
        <br>
        <h1>You are ${sessionScope.user.role}!</h1>
        <a href="${pageContext.request.contextPath}/home">Home</a> ||
        <a href="${pageContext.request.contextPath}/account/dashboard">Dashboard</a> ||
        <a href="${pageContext.request.contextPath}/logout">Logout</a>  

        <div style="display: flex;  justify-content: center; gap: 16px;"">
            <!-- SIDE BAR -->
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
            <!-- INFORMATION -->
            <div>
                <table border="0">
                    <form method="POST">
                        <tbody>
                            <tr>
                                <td>User Name</td>
                                <td>
                                    Account Code
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="text" name="userName" value="${requestScope.user.userName}">
                                </td>
                                <td>
                                    <input type="text" name="accountCode" value="${requestScope.user.accountCode}">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">Full Name</td>
                            </tr>
                            <tr>
                                <td colspan="2" >
                                    <input style="width: 100%" type="text" name="fullName" value="${requestScope.user.fullName}">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">Phone Number</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type="text" name="phoneNumber" value="${requestScope.user.phoneNumber}">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">Avatar</td>
                            </tr>
                            <tr>
                                <td colspan="2">Upload file</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <input type="file" name="image" >
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="submit" value="Save">
                                </td>
                                <td>
                                    <input type="reset" value="Reset">
                                </td>
                            </tr>
                        </tbody>
                </table>
                </form>
            </div>       
            <!-- PREVIEW -->
            <div>
                <table border="1">
                    <tbody>
                        <tr>
                            <td colspan="2">Preview</td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <img src="${pageContext.request.contextPath}${requestScope.user.urlImgProfile}" 
                                     style="width: 50%; height: auto;"
                                     alt="avatar"/>
                            </td>
                        </tr>
                        <tr>
                            <td>User:</td>
                            <td>
                                ${requestScope.user.userName}
                            </td>
                        </tr>
                        <tr>
                            <td>Account Code:</td>
                            <td>
                                ${requestScope.user.accountCode}
                            </td>
                        </tr>
                        <tr>
                            <td>Name:</td>
                            <td>
                                ${requestScope.user.fullName}
                            </td>
                        </tr>
                        <tr>
                            <td>Phone:</td>
                            <td>
                                ${requestScope.user.phoneNumber}
                            </td>
                        </tr>
                    </tbody>
                </table>

            </div>
        </div>


    </body>
</html>
