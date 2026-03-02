<%-- 
    Document   : user
    Created on : Jan 21, 2026, 11:53:10 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Student Dashboard - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/main.css">
        <link rel="stylesheet" href="${ctx}/assets/css/dashboard.css">
    </head>
    <body class="dash-page">

        <jsp:include page="/view/common/header.jsp" />

        <main class="dash-main">
            <div class="dash-container">

                <section class="welcome">
                    <h1>
                        Welcome back,
                        <c:out value="${empty sessionScope.user.fullName ? sessionScope.user.userName : sessionScope.user.fullName}" />!
                    </h1>
                    <p>Continue your learning journey</p>
                </section>

                <section class="stats" aria-label="Quick stats">
                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M4 7h16v12H4V7Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M7 7V5h10v2" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">Joined Classes</div>
                            <div class="stat-value">${sessionScope.classList.size()}</div>
                        </div>
                    </div>

                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M7 4h10v16H7V4Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M9 8h6M9 12h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            <path d="M9 16h3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">Assignments Due</div>
                            <div class="stat-value">${empty requestScope.assignmentsDue ? "Error" : requestScope.assignmentsDue}</div>
                        </div>
                    </div>

                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M4 6h16v12H4V6Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M9 10h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            <path d="M9 14h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">Materials</div>
                            <div class="stat-value">${empty session.materials ? "Error" : requestScope.materials}</div>
                        </div>
                    </div>

                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M4 12h7l2-4 3 8 2-4h2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">Classes Active This Week</div>
                            <div class="stat-value">${empty session.activeThisWeek ? "Error" : requestScope.activeThisWeek}</div>
                        </div>
                    </div>
                </section>

                <section>
                    <div class="section-top">
                        <h2>My Classes</h2>
                        <form action="join" method="POST">
                            <div class="class-tools">
                                <div class="searchbox">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                    <path d="M10 18a8 8 0 1 1 0-16 8 8 0 0 1 0 16Z" stroke="currentColor" stroke-width="2"/>
                                    <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                    </svg>
                                    <input type="text" name="classCode" value="${requestScope.classCode}" placeholder="Search classes..." />
                                    <span>${requestScope.listMSG.msgClassCode}</span>
                                    <span>${requestScope.msgClassCode}</span>
                                </div>
                                <button class="btn btn-primary join-btn" type="submit" name="action" value="searchClass">+ Search Class</button>
                                <button class="btn btn-primary join-btn" type="submit" name="action" value="joinClass">+ Join Class</button>
                            </div>
                        </form>
                        <button class="btn btn-primary join-btn">
                            <a href="${ctx}/route">+ Show My Classes</a>
                        </button>
                    </div>

                    <!-- Class List -->
                    <c:if test="${not empty sessionScope.classList}">
                        <c:forEach items="${sessionScope.classList}" var="cls">
                            <div class="classes">
                                <!-- Demo cards -->
                                <a class="class-card" href="#">
                                    <div class="class-banner"></div>
                                    <div class="class-body">
                                        <h3 class="class-title">${cls.name}</h3>
                                        <div class="class-meta">
                                            Subject : ${cls.subject}<br>
                                            Student : ${cls.sum}/${cls.maxStudent}
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty sessionScope.classList}">
                        <h1>Have not joined any class yet!</h1>
                    </c:if>
                </section>

            </div>
        </main>
    </body>
</html>