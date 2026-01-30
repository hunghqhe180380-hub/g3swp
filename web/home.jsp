<%-- 
    Document   : home
    Created on : Jan 20, 2026, 11:31:19 PM
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
        <title>POET - Online Teaching Platform</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>

    <body>
        <!-- NAVBAR -->
        <header class="nav">
            <div class="container">
                <div class="nav-inner">
                    <a class="brand" href="${ctx}/home">
                        <img src="${ctx}/uploads/Images/LOGO/POETLOGO.png"
                             alt="POET Logo"
                             class="logo-img">
                    </a>

                    <div class="nav-actions">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a class="btn btn-primary" href="${ctx}/account/dashboard">Dashboard</a>
                                <a class="btn btn-outline" href="${ctx}/logout">Log Out</a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-outline" href="${ctx}/login">Login</a>
                                <a class="btn btn-primary" href="${ctx}/register">Sign Up</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </header>

        <!-- HERO -->
        <section class="hero">
            <div class="container">
                <h1>The Future of Online Teaching</h1>
                <p>
                    POET empowers educators to create engaging classes, manage students, and track progress
                    all in one beautiful platform.
                </p>

                <div class="hero-cta">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a class="btn btn-primary btn-lg" href="${ctx}/account/dashboard">
                                Go to Dashboard <span class="arrow">→</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="btn btn-primary btn-lg" href="${ctx}/register">
                                Get Started Free <span class="arrow">→</span>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <!-- FEATURES -->
        <section class="section">
            <div class="container">
                <div class="section-title">
                    <h2>Powerful Features for Educators</h2>
                    <p>Everything you need to teach effectively online</p>
                </div>

                <div class="grid">
                    <div class="card">
                        <div class="icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                                <path d="M4 5h16v14H4V5Z" stroke="currentColor" stroke-width="2"/>
                                <path d="M8 9h8M8 13h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <h3>Create Classes</h3>
                        <p>Create comprehensive class with lessons, assignments, and resources in minutes.</p>
                    </div>

                    <div class="card">
                        <div class="icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                                <path d="M16 11a4 4 0 1 0-8 0" stroke="currentColor" stroke-width="2"/>
                                <path d="M4 20c1.5-4 14.5-4 16 0" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M12 12v0" stroke="currentColor" stroke-width="2"/>
                            </svg>
                        </div>
                        <h3>Manage Students</h3>
                        <p>Enroll learners, track attendance, and handle rosters effortlessly.</p>
                    </div>

                    <div class="card">
                        <div class="icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                                <path d="M4 19V5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M8 19V9" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M12 19V13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M16 19V7" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M20 19V11" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <h3>Grade &amp; Assess</h3>
                        <p>Create assignments, grade submissions, and provide feedback all in one place.</p>
                    </div>

                    <div class="card">
                        <div class="icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                                <path d="M10 8l6 4-6 4V8Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                                <path d="M12 22a10 10 0 1 1 0-20 10 10 0 0 1 0 20Z" stroke="currentColor" stroke-width="2"/>
                            </svg>
                        </div>
                        <h3>Video Lessons</h3>
                        <p>Upload and stream video content directly to your students with ease.</p>
                    </div>

                    <div class="card">
                        <div class="icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                                <path d="M13 2L3 14h7l-1 8 10-12h-7l1-8Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                            </svg>
                        </div>
                        <h3>Real-time Analytics</h3>
                        <p>Track student progress with detailed analytics and performance insights.</p>
                    </div>

                    <div class="card">
                        <div class="icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                                <path d="M20 7l-9 10-4-4" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </div>
                        <h3>Easy to Use</h3>
                        <p>Intuitive interface designed for educators, no technical skills required.</p>
                    </div>
                </div>

                <div class="two-col">
                    <div class="why">
                        <h2>Why Choose POET?</h2>
                        <ul class="why-list">
                            <li class="why-item">
                                <span class="tick" aria-hidden="true">✓</span>
                                <div>
                                    <b>For Teachers</b>
                                    <span>Save time on admin, focus on teaching.</span>
                                </div>
                            </li>
                            <li class="why-item">
                                <span class="tick" aria-hidden="true">✓</span>
                                <div>
                                    <b>For Students</b>
                                    <span>Learn anywhere with a seamless experience.</span>
                                </div>
                            </li>
                            <li class="why-item">
                                <span class="tick" aria-hidden="true">✓</span>
                                <div>
                                    <b>Affordable</b>
                                    <span>Flexible plans for any institution size.</span>
                                </div>
                            </li>
                            <li class="why-item">
                                <span class="tick" aria-hidden="true">✓</span>
                                <div>
                                    <b>24/7 Support</b>
                                    <span>We’re here whenever you need us.</span>
                                </div>
                            </li>
                        </ul>
                    </div>

                    <div class="illus">
                        <img src="${ctx}/uploads/Images/whychoosepoet.png" alt="POET Illustration"
                             onerror="this.style.display='none'; this.parentElement.querySelector('.illus-fallback').style.display='block';">
                        <div class="illus-fallback" style="display:none;">
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="cta-gradient">
            <h2>Ready to Transform Your Teaching?</h2>
            <p>Join thousands of educators already using POET</p>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a class="btn btn-white btn-lg" href="${ctx}/account/dashboard">
                        Start Your Work <span class="arrow">→</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-white btn-lg" href="${ctx}/register">
                        Start Your Free Trial <span class="arrow">→</span>
                    </a>
                </c:otherwise>
            </c:choose>
        </section>                             

        <section class="footer">
            <div class="container">
                <div class="footer-inner">
                    <footer>
                        © 2026 POET. Professional Online Education Technology. All rights reserved.
                    </footer>
                </div>
            </div>
        </section>
    </body>
</html>

