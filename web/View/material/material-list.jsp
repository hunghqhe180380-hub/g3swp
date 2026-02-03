<%-- 
    Document   : manage-material
    Created on : Jan 31, 2026, 10:18:50 PM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Class Materials - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/admin-materials.css">
    </head>

    <body>
        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar__inner">
                <div class="topbar__title">
                    <div class="topbar__small">Admin • Materials</div>
                    <h1 class="topbar__big"><c:out value="${classes.name}"/></h1>
                    <div class="topbar__meta"><c:out value="${classes.sum}"/> items</div>
                </div>

                <a class="btn-back" href="${ctx}/classroom/manage/class-list">← Back</a>
            </div>
        </header>

        <!-- PAGE -->
        <main class="page">
            <div class="wrap">
                <!-- TOOLBAR -->
                <div class="toolbar">
                    <form class="search" action="${ctx}/material/view/material-list" method="get">
                        <span class="search__icon" aria-hidden="true">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                                <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                                <path d="M20 20l-3.5-3.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </span>

                        <input class="search__input" type="search" name="search"
                               value="<c:out value='${search}'/>"
                               placeholder="Search by title, kind...">

                        <input type="hidden" name="classId" value="<c:out value='${classId}'/>">

                        <button class="search__btn" type="submit">Search</button>
                    </form>

                    <div class="showing">
                        Showing <strong><c:out value="${classes.sum}"/></strong> of <c:out value="${classes.sum}"/>
                    </div>
                </div>

                <!-- CONTENT -->
                <div class="card">
                    <c:choose>
                        <c:when test="${empty materials}">
                            <!-- EMPTY STATE -->
                            <div class="empty">
                                <div class="empty__icon" aria-hidden="true">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                                        <path d="M6 4h11a2 2 0 0 1 2 2v14H7a2 2 0 0 0-2 2V6a2 2 0 0 1 2-2Z"
                                              stroke="currentColor" stroke-width="2" stroke-linejoin="round"/>
                                        <path d="M6 18h13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                    </svg>
                                </div>

                                <div class="empty__title">No materials in this class.</div>
                                <div class="empty__sub">Add from teacher side; admin can delete here.</div>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <!-- TABLE -->
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Kind</th>
                                        <th>Created</th>
                                        <th class="th-actions"></th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach items="${materials}" var="material">
                                        <tr>
                                            <td class="cell-title">
                                                <c:out value="${material.title}"/>
                                            </td>

                                            <td>
                                                <span class="badge-kind">
                                                    <c:out value="${material.provider}"/>
                                                </span>
                                            </td>

                                            <td class="muted">
                                                <c:out value="${material.createdAt}"/>
                                            </td>

                                            <td class="actions">
                                                <form action="${ctx}/material/manage/delete-material" method="post">
                                                    <input type="hidden" name="Id" value="<c:out value='${material.id}'/>">
                                                    <input type="hidden" name="classId" value="<c:out value='${classId}'/>">
                                                    <button class="btn-danger" type="submit">Delete</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </body>
</html>

