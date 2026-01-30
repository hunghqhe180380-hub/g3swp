<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Login.css">
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

                    <a class="btn btn-primary" href="${ctx}/register">Register</a>
                </div>
            </div>
        </header>

        <!-- BODY -->
        <main class="auth-wrap">
            <div class="auth-card">
                <div class="card-head">
                    <div class="badge" aria-hidden="true">
                        <!-- book icon -->
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                        <path d="M6 4h11a2 2 0 0 1 2 2v14H7a2 2 0 0 0-2 2V6a2 2 0 0 1 2-2Z"
                              stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                        <path d="M6 18h13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                    </div>

                    <h1 class="title">POET</h1>
                    <p class="sub">Welcome back — please sign in</p>
                </div>

                <form class="form" action="${ctx}/login" method="POST">
                    <!-- Email / Username -->
                    <div>
                        <input class="input" type="text" name="email"
                               placeholder="Email or Username"
                               value="${requestScope.email}">
                        <span class="errors">${listMSG.msgUserName}</span>
                    </div>

                    <!-- Password -->
                    <div>
                        <div class="pass-wrap">
                            <input id="pw" class="input" type="password" name="password" placeholder="Password">
                            <button type="button" class="pass-btn"
                                    aria-label="Toggle password"
                                    aria-pressed="false"
                                    onclick="togglePassword('pw', this)">
                                <!-- eye closed (default) -->
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
                        <span class="errors">${listMSG.msgPassword}</span>
                    </div>

                    <!-- Remember / Forgot -->
                    <div class="row">
                        <label class="check">
                            <input type="checkbox" name="remember">
                            Remember me?
                        </label>

                        <a class="link" href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a>
                    </div>

                    <button class="btn-submit" type="submit">Log in</button>

                    <div class="bottom">
                        Don&apos;t have an account?
                        <a href="${ctx}/register">Register</a>
                    </div>

                    <c:if test="${not empty requestScope.MSG99}">
                        <div class="msg-global">${requestScope.MSG99}</div>
                    </c:if>
                </form>
                <div>
                    <a href="${pageContext.request.contextPath}/verify-email?action=verify-email">Click here to verify email</a>
                </div>

                <div class="page-footer">
                    © 2026 POET. Professional Online Education Technology.
                </div>
            </div>
        </main>

        <script>
            function togglePassword(inputId, btn) {
                const input = document.getElementById(inputId);
                if (!input)
                    return;

                const willShow = (input.type === 'password');
                input.type = willShow ? 'text' : 'password';

                btn.classList.toggle('is-show', willShow);
                btn.setAttribute('aria-pressed', willShow ? 'true' : 'false');
            }
        </script>
    </body>
</html>