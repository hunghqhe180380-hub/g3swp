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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/admin.css">
    </head>

    <body>
        <header class="admin-topbar">
            <div class="admin-topbar__inner">
                <div class="admin-title">
                    <div class="admin-title__small">Administration</div>
                    <div class="admin-title__big">Control Panel</div>
                </div>

                <a class="btn-logout" href="${ctx}/logout">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                        <path d="M10 7V5a2 2 0 0 1 2-2h7a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-7a2 2 0 0 1-2-2v-2"
                              stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                        <path d="M15 12H3m0 0 3-3m-3 3 3 3"
                              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    Log out
                </a>
            </div>
        </header>

        <main class="admin-main">
            <div class="admin-container">
                <div class="admin-grid">
                    <!-- Card 1 -->
                    <section class="admin-card">
                        <div class="admin-card__icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                <path d="M16 11a4 4 0 1 0-8 0 4 4 0 0 0 8 0Z" stroke="currentColor" stroke-width="2"/>
                                <path d="M4 21c1.6-4 14.4-4 16 0" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>

                        <div class="admin-card__body">
                            <h3>Manage Accounts</h3>
                            <p>Promote, remove, or search users across the system.</p>

                            <a class="btn-open" href="${ctx}/admin/user-list">Open</a>
                        </div>
                    </section>

                    <!-- Card 2 -->
                    <section class="admin-card">
                        <div class="admin-card__icon">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                <path d="M9 5h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                <path d="M9 3h6a2 2 0 0 1 2 2v16H7V5a2 2 0 0 1 2-2Z"
                                      stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                                <path d="M9 11h6M9 15h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>

                        <div class="admin-card__body">
                            <h3>Manage Classes</h3>
                            <p>View, delete classes and manage materials, assignments, students.</p>

                            <a class="btn-open" href="${ctx}/classroom/manage/class-list">Open</a>
                        </div>
                    </section>
                </div>
            </div>
        </main>
    </body>
</html>

