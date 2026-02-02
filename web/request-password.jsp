<%-- 
    Document   : request-password
    Created on : Jan 31, 2026, 12:14:47 AM
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
        <title>Forgot Password - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/Forgot.css">
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

                    <a class="btn btn-primary" href="${ctx}/register">Register</a>
                </div>
            </div>
        </header>

        <!-- BODY -->
        <main class="auth-wrap">
            <div class="auth-card">
                <div class="card-head">
                    <div class="badge" aria-hidden="true">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M6 4h11a2 2 0 0 1 2 2v14H7a2 2 0 0 0-2 2V6a2 2 0 0 1 2-2Z"
                                  stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                            <path d="M6 18h13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                    </div>

                    <h1 class="title">Forgot your password?</h1>
                    <p class="sub">Enter the email associated with your account</p>
                </div>

                <form id="forgotForm" class="form" action="${ctx}/forgot-password" method="POST">
                    <div>
                        <input class="input" type="email" name="email"
                               placeholder="Email address"
                               value="${requestScope.email}"
                               required>
                        <span class="errors">
                            <c:out value="${listMSG.msgEmail}"/>
                        </span>
                    </div>

                    <button class="btn-submit" type="submit">Send reset link</button>


                    <c:if test="${not empty listMSG.msgToken}">
                        <div class="msg msg--warn">
                            <c:out value="${listMSG.msgToken}"/>
                        </div>
                    </c:if>

                    <div class="bottom-links">
                        <a class="link-muted" href="${ctx}/login">← Back to login</a>
                        <a class="link-muted" href="#">Resend email confirmation</a>
                    </div>
                </form>

                <div class="page-footer">
                    © 2025 POET. Professional Online Education Technology.
                </div>
            </div>
        </main>

        <!-- TOAST -->
        <div id="toast" class="toast" role="status" aria-live="polite" aria-atomic="true">
            <div class="toast__icon" aria-hidden="true">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                    <path d="M4 6h16v12H4V6Z" stroke="currentColor" stroke-width="2" />
                    <path d="m4 7 8 6 8-6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </div>
            <div class="toast__text">
                <div class="toast__title">Check your email</div>
                <div class="toast__sub">We’ve sent a password reset link if the address exists.</div>
            </div>
            <button class="toast__close" type="button" aria-label="Close" onclick="hideToast()">×</button>
        </div>

        <script>
            const toast = document.getElementById('toast');
            let toastTimer = null;

            function showToast(){
                if(!toast) return;
                toast.classList.add('is-show');
                clearTimeout(toastTimer);
                toastTimer = setTimeout(hideToast, 3800);
            }

            function hideToast(){
                if(!toast) return;
                toast.classList.remove('is-show');
            }
            <c:if test="${requestScope.toastSuccess == true}">
            showToast();
            </c:if>
        </script>
    </body>
</html>