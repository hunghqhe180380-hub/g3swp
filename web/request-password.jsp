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
    
        <!-- CSS -->
            <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/main.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/forgot-password.css">
        </head>
        <body>

        <div class="forgot-container">
            <div class="forgot-card">

                <h2>Forgot your password?</h2>
                <p>Enter your email address and we’ll send you a link to reset your password.</p>

                <form action="forgot-password" method="POST">
                    <input
                        type="email"
                        name="email"
                        placeholder="Enter your email"
                        value="${requestScope.email}"
                        required
                    >

                    <button type="submit">Send reset link</button>
                </form>

                <!-- MESSAGE -->
                <c:if test="${not empty requestScope.listMSG}">
                    <c:if test="${not empty listMSG.msgEmail}">
                        <div class="error-msg">${listMSG.msgEmail}</div>
                    </c:if>

                    <c:if test="${not empty listMSG.msgToken}">
                        <div class="success-msg">${listMSG.msgToken}</div>
                    </c:if>
                </c:if>

                <div class="forgot-links">
                    <a href="login.jsp">← Back to login</a>
                </div>

            </div>
        </div>

        </body>
</html>