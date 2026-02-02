<%--
    Document   : reset-password
    Created on : Jan 29, 2026, 3:28:21 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reset Password - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/ResetPass.css">
    </head>

    <body>
        <!-- NAV -->
        <header class="nav">
            <div class="container">
                <div class="nav-inner">
                    <a class="brand" href="${ctx}/home">
                        <img class="logo-img" src="${ctx}/uploads/Images/LOGO/POETLOGO.png" alt="POET"
                             onerror="this.style.display='none'; this.insertAdjacentHTML('afterend','<span>POET</span>');">
                    </a>

                    <a class="btn btn-outline" href="${ctx}/login">Back to Login</a>
                </div>
            </div>
        </header>

        <!-- BODY -->
        <main class="auth-wrap">
            <div class="auth-card">
                <div class="card-head">
                    <div class="badge" aria-hidden="true">
                        <!-- shield icon -->
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M12 2l8 4v6c0 5-3.4 9.4-8 10-4.6-.6-8-5-8-10V6l8-4Z"
                                  stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                            <path d="M12 11v4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            <path d="M12 8h.01" stroke="currentColor" stroke-width="3" stroke-linecap="round"/>
                        </svg>
                    </div>

                    <h1 class="title">Reset your password</h1>
                    <p class="sub">Set a strong new password for your account</p>
                </div>

                <form class="form" action="${ctx}/reset-password" method="POST">
                    <!-- Email -->
                    <div>
                        <input class="input" type="email" name="email"
                               placeholder="Email address"
                               value="${requestScope.email}">
                        <span class="errors">${listMSG.msgEmail}</span>
                    </div>

                    <!-- New password -->
                    <div>
                        <div class="pass-wrap">
                            <input id="newPw" class="input" type="password" name="newPassword" placeholder="New password">
                            <button type="button" class="pass-btn"
                                    aria-label="Toggle new password"
                                    aria-pressed="false"
                                    onclick="togglePassword('newPw', this)">
                                <!-- eye closed -->
                                <svg class="eye eye-closed" width="18" height="18" viewBox="0 0 24 24" fill="none">
                                    <path d="M3 3l18 18" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                    <path d="M10.6 10.6a3 3 0 0 0 4.2 4.2" stroke="currentColor" stroke-width="2"/>
                                    <path d="M9.9 4.2A10.7 10.7 0 0 1 12 4c6.5 0 10 8 10 8"
                                          stroke="currentColor" stroke-width="2"/>
                                    <path d="M6.4 6.4C3.6 8.6 2 12 2 12s3.5 7 10 7"
                                          stroke="currentColor" stroke-width="2"/>
                                </svg>

                                <!-- eye open -->
                                <svg class="eye eye-open" width="18" height="18" viewBox="0 0 24 24" fill="none">
                                    <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"
                                          stroke="currentColor" stroke-width="2"/>
                                    <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
                                </svg>
                            </button>
                        </div>
                        <div class="hint">At least 8 chars, 1 uppercase, 1 number, 1 special character.</div>
                        <span class="errors">${listMSG.msgPassword}</span>
                    </div>

                    <!-- Confirm password -->
                    <div>
                        <input class="input" type="password" name="confirmPassword" placeholder="Confirm password">
                        <span class="errors">${listMSG.msgConfirmPassword}</span>
                    </div>

                    <button class="btn-submit" type="submit">Reset password</button>

                    <div class="bottom">
                        <a href="${ctx}/login">← Back to login</a>
                    </div>

                    <c:if test="${not empty requestScope.MSG99}">
                        <div class="msg-global">${requestScope.MSG99}</div>
                    </c:if>
                </form>

                <div class="page-footer">
                    © 2025 POET. Professional Online Education Technology.
                </div>
            </div>
        </main>

        <script>
            function togglePassword(inputId, btn){
                const input = document.getElementById(inputId);
                if(!input) return;

                const willShow = (input.type === 'password');
                input.type = willShow ? 'text' : 'password';

                btn.classList.toggle('is-show', willShow);
                btn.setAttribute('aria-pressed', willShow ? 'true' : 'false');
            }
        </script>
    </body>
</html>
