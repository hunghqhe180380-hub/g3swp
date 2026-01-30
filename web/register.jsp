<%-- 
    Document   : register
    Created on : Jan 20, 2026, 11:42:15 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Register.css">
    </head>

    <body>
        <!-- NAV -->
        <header class="nav">
            <div class="container">
                <div class="nav-inner">
                    <a class="brand" href="${ctx}/home">
                        <img src="${ctx}/uploads/Images/LOGO/POETLOGO.png"
                             alt="POET Logo"
                             class="logo-img">
                    </a>

                    <a class="btn btn-outline" href="${ctx}/login">Login</a>
                </div>
            </div>
        </header>

        <!-- BODY -->
        <main class="auth-wrap">
            <div class="card">
                <div class="card-head">
                    <div class="badge" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M15 8a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M4 20c1.7-5.5 14.3-5.5 16 0" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            <path d="M19 8v6M22 11h-6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                    </div>
                    <h1>Create your account</h1>
                    <p>Join POET and start learning or teaching today</p>
                </div>

                <form class="form" action="${ctx}/register" method="POST">
                    <!-- User Name -->
                    <div class="field">
                        <input class="input" type="text" name="userName" value="${requestScope.userName}" placeholder="User Name">
                        <span class="errors">${listMSG.msgUserName}</span>
                    </div>

                    <!-- Full Name -->
                    <div class="field">
                        <input class="input" type="text" name="fullName" value="${requestScope.fullName}" placeholder="Full Name">
                        <span class="errors">${listMSG.msgFullName}</span>
                    </div>

                    <!-- Email -->
                    <div class="field">
                        <input class="input" type="email" name="email" value="${requestScope.email}" placeholder="Email">
                        <span class="errors">${listMSG.msgEmail}</span>
                    </div>

                    <!-- Phone -->
                    <div class="field">
                        <input class="input" type="text" name="phoneNumber" value="${requestScope.phoneNumber}" placeholder="Phone Number">
                        <span class="errors">${listMSG.msgPhoneNumber}</span>
                    </div>

                    <!-- Password -->
                    <div class="field">

                        <div class="pass-wrap">
                            <input id="pw" class="input" type="password" name="password"
                                   value="${requestScope.password}" placeholder="Password">

                            <button type="button" class="pass-btn" aria-label="Toggle password"
                                    aria-pressed="false"
                                    onclick="togglePassword('pw', this)">
                                <svg class="eye eye-open" width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"
                                      stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                                <path d="M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z"
                                      stroke="currentColor" stroke-width="2"/>
                                </svg>

                                <svg class="eye eye-closed" width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <path d="M3 3l18 18" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M10.6 10.6a3 3 0 0 0 4.2 4.2" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M9.9 4.2A10.7 10.7 0 0 1 12 4c6.5 0 10 8 10 8a18.2 18.2 0 0 1-2.5 3.7"
                                      stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M6.4 6.4C3.6 8.6 2 12 2 12s3.5 7 10 7c1 0 1.9-.2 2.8-.5"
                                      stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                </svg>
                            </button>
                        </div>

                        <div class="hint">Must have at least 8 chars, 1 uppercase, 1 number, 1 special character.</div>
                        <span class="errors">${listMSG.msgPassword}</span>
                    </div>

                    <!-- Confirm Password -->
                    <div class="field">
                        <input id="cpw" class="input" type="password" name="confirmPassword" value="${requestScope.confirmPassword}" placeholder="Confirm Password">
                        <span class="errors">${listMSG.msgConfirmPassword}</span>
                    </div>

                    <button class="btn-submit" type="submit">Register</button>

                    <div class="bottom">
                        Already have an account?
                        <a href="${ctx}/login">Login</a>
                    </div>
                </form>

                <div class="page-footer">
                    © 2026 POET. Professional Online Education Technology.
                </div>
            </div>
        </main>

        <script>
            function togglePw(id, btn){
                const el = document.getElementById(id);
                if(!el) return;
                el.type = (el.type === 'password') ? 'text' : 'password';
            }
        </script>
    </body>
</html>

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