<%-- 
    Document   : email-change
    Created on : Mar 3, 2026, 3:06:43 AM
    Author     : tuana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Email Change</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/main.css">
        <link rel="stylesheet" href="${ctx}/assets/css/email-change.css"/>
    </head>
    <body>

        <c:set var="hideTeacherCTA" value="true" scope="request"/>
        <jsp:include page="/view/common/header.jsp"/>

        <div class="page">
            <div class="card">
                <c:choose>
                    <c:when test="${status == 'success'}">
                        <h2>Email changed successfully</h2>
                        <p>Your email has been updated<c:if test="${not empty newEmail}"> to <b>${newEmail}</b></c:if>.</p>
                            <div class="actions">
                                <a class="btn primary" href="${ctx}/account/profile?tab=email">Back to settings</a>
                            <a class="btn" href="${ctx}/home">Go home</a>
                        </div>
                    </c:when>

                    <c:when test="${status == 'exists'}">
                        <h2>Email already in use</h2>
                        <p>The email you’re trying to confirm is already used by another account.</p>
                        <div class="actions">
                            <a class="btn primary" href="${ctx}/account/profile?tab=email">Try another email</a>
                            <a class="btn" href="${ctx}/home">Go home</a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <h2>Invalid or expired link</h2>
                        <p>This confirmation link is invalid, expired, or has already been used.</p>
                        <div class="actions">
                            <a class="btn primary" href="${ctx}/account/profile?tab=email">Request a new link</a>
                            <a class="btn" href="${ctx}/login">Login</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </body>
</html>