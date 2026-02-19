<%-- 
    Document   : student-list
    Created on : Jan 29, 2026, 10:49:35 PM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="fnState" value="${param.txtFullName != null ? param.txtFullName : '0'}"/>
<c:set var="tiState" value="${param.txtJoined != null ? param.txtJoined : '0'}"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Class Students - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/admin-students.css">
    </head>

    <body>
        <!-- TOPBAR -->
        <header class="topbar">
            <div class="topbar__inner">
                <div class="topbar__title">
                    <div class="topbar__small">Admin • Students</div>
                    <h1 class="topbar__big"><c:out value="${classes.name}"/></h1>
                    <div class="topbar__meta"><c:out value="${classes.sum}"/> students</div>
                </div>

                <a class="btn-back" href="${ctx}/classroom/manage/class-list">← Back</a>
            </div>
        </header>

        <!-- PAGE -->
        <main class="page">
            <div class="wrap">
                <div class="toolbar">
                    <form class="search" action="${ctx}/classroom/view/student-list" method="get">
                        <span class="search__icon" aria-hidden="true">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                            <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                            <path d="M20 20l-3.5-3.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </span>

                        <input class="search__input" type="search" name="search"
                               value="<c:out value='${search}'/>"
                               placeholder="Search name, username, email...">

                        <input type="hidden" name="classId" value="<c:out value='${classId}'/>">
                        <button class="search__btn" type="submit">Search</button>
                    </form>

                    <form action="${ctx}/classroom/view/student-list" method="get" id="frmSort" hidden>                        
                        <input type="hidden" id="txtFullName" name="txtFullName" value="<c:out value="${param.txtFullName != null ? param.txtFullName : 0}"/>">                        
                        <input type="hidden" id="txtJoined" name="txtJoined" value="<c:out value="${param.txtJoined != null ? param.txtJoined : '0'}"/>">                        
                        <input type="hidden" name="search" value="<c:out value="${search}"/>">
                        <input type="hidden" name="classId" value="<c:out value='${classId}'/>">
                        <!--  <c:forEach items="${roleList}" var="r">
                            <input type="hidden" name="txtRole" value="${r}">
                        </c:forEach>        -->                                     
                    </form>

                    <div class="showing">
                        <c:set var="shown" value="${empty enrolls ? 0 : fn:length(enrolls)}"/>
                        Showing <strong><c:out value="${shown}"/></strong> of <c:out value="${classes.sum}"/>
                    </div>
                </div>

                <!-- TABLE CARD -->
                <div class="card">
                    <table class="table">
                        <thead>
                            <tr>                                
                                <th onclick="sort('FullName')" style="cursor:pointer">
                                    Name
                                    <span id="iconFullName">
                                        <c:choose>
                                            <c:when test="${fnState == '1'}">▲</c:when>
                                            <c:when test="${fnState == '2'}">▼</c:when>
                                            <c:otherwise>⇅</c:otherwise>
                                        </c:choose>
                                    </span>
                                </th>
                                <th>User</th>
                                <th>Email</th>                                
                                <th onclick="sort('Joined')" style="cursor:pointer">
                                    Joined
                                    <span id="iconJoined">
                                        <c:choose>
                                            <c:when test="${tiState == '1'}">▲</c:when>
                                            <c:when test="${tiState == '2'}">▼</c:when>
                                            <c:otherwise>⇅</c:otherwise>
                                        </c:choose>
                                    </span>
                                </th>
                                <th class="th-actions">Status</th>
                                <th class="th-actions"></th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${enrolls}" var="enroll">
                                <tr>
                                    <td class="name">
                                        <c:out value="${enroll.user.fullName}"/>
                                    </td>

                                    <td class="mono">
                                        <c:out value="${enroll.user.userName}"/>
                                    </td>

                                    <td class="email">
                                        <a class="email__link" href="mailto:<c:out value='${enroll.user.email}'/>">
                                            <c:out value="${enroll.user.email}"/>
                                        </a>
                                    </td>

                                    <td class="muted">
                                        <c:out value="${enroll.joinedAt}"/>
                                    </td>

                                    <td class="actions">
                                        <c:if test="${enroll.status == 0}">
                                            <form action="${ctx}/classroom/manage/soft-kick-student" method="post"
                                                  onsubmit="return confirm('Deactive this student from the class?');">
                                                <input type="hidden" name="userId" value="<c:out value='${enroll.userId}'/>">
                                                <input type="hidden" name="status" value="<c:out value="${enroll.status}"/>">
                                                <input type="hidden" name="classId" value="<c:out value='${classId}'/>">

                                                <button class="btn-deactive" type="submit" title="Kick">
                                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"
                                                          stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                                    <circle cx="9" cy="7" r="4" stroke="currentColor" stroke-width="2"/>
                                                    <path d="M19 8l4 4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                                    <path d="M23 8l-4 4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                                    </svg>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${enroll.status == 1}">
                                            <form action="${ctx}/classroom/manage/soft-kick-student" method="post"
                                                  onsubmit="return confirm('Restore this student to the class?');">
                                                <input type="hidden" name="userId" value="<c:out value='${enroll.userId}'/>">
                                                <input type="hidden" name="status" value="<c:out value="${enroll.status}"/>">
                                                <input type="hidden" name="classId" value="<c:out value='${classId}'/>">

                                                <button class="btn-restore" type="submit" title="Restore / Re-activate">
                                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" 
                                                         stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                                                    <circle cx="9" cy="7" r="4" />
                                                    <polyline points="16 11 18 13 22 9" />
                                                    </svg>
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                    <td class="actions">
                                        <form action="${ctx}/classroom/manage/kick-student" method="post"
                                              onsubmit="return confirm('WARNING: Are you sure you want to PERMANENTLY delete this student? This action cannot be undone.');">
                                            <input type="hidden" name="userId" value="<c:out value='${enroll.userId}'/>">
                                            <input type="hidden" name="classId" value="<c:out value='${classId}'/>">

                                            <button class="btn-kick" type="submit" title="Delete Permanently">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" 
                                                     stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <polyline points="3 6 5 6 21 6"></polyline>
                                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                <line x1="10" y1="11" x2="10" y2="17"></line>
                                                <line x1="14" y1="11" x2="14" y2="17"></line>
                                                </svg>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty enrolls}">
                                <tr>
                                    <td colspan="5" class="empty">
                                        No students in this class yet.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </body>
</html>
<style>
    th:hover {
        background-color: #f3f3f3;
    }
    th span {
        font-size: 12px;
        margin-left: 4px;
    }
</style>
<script>
    function sort(x) {
        reset(x);

        let el = document.getElementById("txt" + x);
        let state = parseInt(el.value);
        if (isNaN(state))
            state = 0;

        let newState = (state + 1) % 3;
        el.value = newState;

        updateIcon(x, newState);
        document.getElementById("frmSort").submit();
    }

    function reset(x) {
        ["FullName", "Joined"].forEach(f => {
            if (f !== x) {
                document.getElementById("txt" + f).value = 0;
                updateIcon(f, 0);
            }
        });
    }
    function updateIcon(field, state) {
        const icon = document.getElementById("icon" + field);
        if (!icon)
            return;
        switch (state) {
            case 1:
                icon.textContent = "▲";
                break;
            case 2:
                icon.textContent = "▼";
                break;
            default:
                icon.textContent = "⇅";
        }
    }
    function filter() {
        document.getElementById("frmFilter").submit();
    }
</script>