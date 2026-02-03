<%-- 
    Document   : manage-account
    Created on : Jan 26, 2026, 11:35:26 AM
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
        <title>Manage Accounts - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/admin-users.css">
    </head>

    <body>
        <header class="admin-topbar">
            <div class="admin-topbar__inner">
                <div class="admin-title">
                    <div class="admin-title__small">Administration</div>
                    <div class="admin-title__big">Manage Accounts</div>
                </div>

                <a class="btn-top btn-top--ghost" href="${ctx}/account/dashboard">← Back</a>
            </div>
        </header>

        <main class="page">
            <div class="wrap">
                <div class="section-head">
                    <h2 class="section-title">Accounts <span class="count">(${fn:length(users)})</span></h2>

                    <form class="search" action="${ctx}/admin/user-list" method="get">
                        <input class="search__input" type="search" name="search"
                               value="<c:out value="${search}"/>"
                               placeholder="Search name/username/email...">
                        <button class="search__btn" type="submit">Search</button>
                    </form>
                </div>

                <div class="card">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Email</th>
                                <th>Roles</th>
                                <th>Account</th>
                                <th class="th-actions">Status</th>
                                <th class="th-actions"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${users}" var="user" begin="${page.start}" end="${page.end}">
                                <tr>
                                    <td>
                                        <div class="usercell">
                                            <div class="usercell__name"><c:out value="${user.fullName}"/></div>
                                            <div class="usercell__sub"><c:out value="${user.userName}"/></div>
                                        </div>
                                    </td>

                                    <td class="muted"><c:out value="${user.email}"/></td>

                                    <td>
                                        <span class="badge-role badge-role--${user.role}">
                                            <c:out value="${user.role}"/>
                                        </span>
                                    </td>

                                    <td class="code"><c:out value="${user.accountCode}"/></td>
                                    
                                    <td class="actions">
                                        <c:if test="${user.isDeleted == 0}">
                                            <form action="${ctx}/admin/soft-delete-user" method="post">
                                                <input type="hidden" name="userId" value="<c:out value="${user.userID}"/>">
                                                <input type="hidden" name="status" value="<c:out value="${user.isDeleted}"/>">
                                                <input type="hidden" name="pageIndex" value="<c:out value="${page.index}"/>">
                                                <button class="btn-act btn-act--red" type="submit">Deactive</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${user.isDeleted == 1}">
                                            <form action="${ctx}/admin/soft-delete-user" method="post">
                                                <input type="hidden" name="userId" value="<c:out value="${user.userID}"/>">
                                                <input type="hidden" name="status" value="<c:out value="${user.isDeleted}"/>">
                                                <input type="hidden" name="pageIndex" value="<c:out value="${page.index}"/>">
                                                <button class="btn-act btn-act--green" type="submit">Active</button>
                                            </form>
                                        </c:if>

                                    </td>
                                    
                                    <td class="actions">
                                        <c:choose>
                                            <c:when test="${user.role == 'Admin'}">
                                                <span class="badge-role badge-role--Admin">Admin</span>
                                            </c:when>

                                            <c:otherwise>
                                                <div class="btncol">
                                                    <form action="${ctx}/admin/change-role" method="post">
                                                        <input type="hidden" name="userId" value="<c:out value="${user.userID}"/>">
                                                        <input type="hidden" name="pageIndex" value="<c:out value="${page.index}"/>">

                                                        <c:choose>
                                                            <c:when test="${user.role == 'Student'}">
                                                                <button class="btn-act btn-act--blue" type="submit">
                                                                    Promote → Teacher
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${user.role == 'Teacher'}">
                                                                <button class="btn-act btn-act--amber" type="submit">
                                                                    Demote → Student
                                                                </button>
                                                            </c:when>
                                                        </c:choose>
                                                    </form>
                                                    <form action="${ctx}/admin/delete-user" method="post">
                                                        <input type="hidden" name="userId" value="<c:out value="${user.userID}"/>">
                                                        <input type="hidden" name="pageIndex" value="<c:out value="${page.index}"/>">
                                                        <button class="btn-act btn-act--red" type="submit">Delete</button>
                                                    </form>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="5" class="empty">
                                        No accounts yet.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="pager">
                    <c:set var="mark" value="${empty search ? '?': '&'}" />
                    <c:url var="basePath" value="/admin/user-list">
                        <c:if test="${not empty search}">
                            <c:param name="search" value="${search}"/>
                        </c:if>
                    </c:url>

                    <c:if test="${page.index!=0}">
                        <a class="pg" href="${basePath}${mark}index=0">&laquo;</a>
                        <a class="pg" href="${basePath}${mark}index=${page.index-1}">&lsaquo;</a>
                    </c:if>

                    <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
                        <a class="pg ${index==page.index ? 'is-active' : ''}"
                           href="${basePath}${mark}index=${index}">
                            ${index+1}
                        </a>
                    </c:forEach>

                    <c:if test="${page.index!=page.totalPage-1}">
                        <a class="pg" href="${basePath}${mark}index=${page.index+1}">&rsaquo;</a>
                        <a class="pg" href="${basePath}${mark}index=${page.totalPage-1}">&raquo;</a>
                    </c:if>
                </div>
            </div>
        </main>
    </body>
</html>
