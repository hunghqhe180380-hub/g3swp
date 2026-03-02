<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <c:set var="ctx" value="${pageContext.request.contextPath}" />
            <c:set var="clState" value="${not empty param.txtClassName   ? param.txtClassName   : '0'}" />
            <c:set var="teState" value="${not empty param.txtTeacherName ? param.txtTeacherName : '0'}" />
            <c:set var="tiState" value="${not empty param.txtCreateAt    ? param.txtCreateAt    : '0'}" />

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Manage Classes – POET</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${ctx}/assets/css/admin-classes.css">
            </head>

            <body>

                <header class="admin-topbar">
                    <div class="admin-topbar__inner">
                        <div class="admin-title">
                            <div class="admin-title__small">Administration</div>
                            <div class="admin-title__big">Manage Classes</div>
                        </div>
                        <a class="btn-top btn-top--ghost" href="${ctx}/account/dashboard">← Back</a>
                    </div>
                </header>

                <main class="page">
                    <div class="wrap">

                        <div class="section-head">
                            <h2 class="section-title">
                                Classes <span class="count">(${fn:length(classes)})</span>
                            </h2>

                            <form class="search" action="${ctx}/classroom/manage/class-list" method="get">
                                <input class="search__input" type="search" name="search"
                                    value="<c:out value='${search}'/>" placeholder="Search class / teacher / code..."
                                    autocomplete="off">
                                <button class="search__btn search__btn--primary" type="submit">Search</button>
                            </form>

                            <%-- Hidden form submitted by JS sortBy() --%>
                                <form action="${ctx}/classroom/manage/class-list" method="get" id="frmSort" hidden>
                                    <input type="hidden" id="txtClassName" name="txtClassName"
                                        value="<c:out value='${clState}'/>">
                                    <input type="hidden" id="txtTeacherName" name="txtTeacherName"
                                        value="<c:out value='${teState}'/>">
                                    <input type="hidden" id="txtCreateAt" name="txtCreateAt"
                                        value="<c:out value='${tiState}'/>">
                                    <input type="hidden" name="search" value="<c:out value='${search}'/>">
                                    <input type="hidden" name="index" id="pageIndex"
                                        value="<c:out value='${page.index}'/>">
                                </form>
                        </div>

                        <div class="card">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th onclick="sortBy('ClassName')" style="cursor:pointer">
                                            Class
                                            <span id="iconClassName">
                                                <c:choose>
                                                    <c:when test="${clState == '1'}">▲</c:when>
                                                    <c:when test="${clState == '2'}">▼</c:when>
                                                    <c:otherwise>⇅</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </th>
                                        <th>Code</th>
                                        <th onclick="sortBy('TeacherName')" style="cursor:pointer">
                                            Teacher
                                            <span id="iconTeacherName">
                                                <c:choose>
                                                    <c:when test="${teState == '1'}">▲</c:when>
                                                    <c:when test="${teState == '2'}">▼</c:when>
                                                    <c:otherwise>⇅</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </th>
                                        <th>Students</th>
                                        <th onclick="sortBy('CreateAt')" style="cursor:pointer">
                                            Created
                                            <span id="iconCreateAt">
                                                <c:choose>
                                                    <c:when test="${tiState == '1'}">▲</c:when>
                                                    <c:when test="${tiState == '2'}">▼</c:when>
                                                    <c:otherwise>⇅</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </th>
                                        <th class="th-actions"></th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach items="${classes}" var="cl" begin="${page.start}" end="${page.end}">
                                        <tr>
                                            <td>
                                                <div class="classcell">
                                                    <div class="classcell__name">
                                                        <c:out value="${cl.name}" />
                                                    </div>
                                                    <div class="classcell__sub">
                                                        <c:out value="${cl.subject}" />
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="code">
                                                <c:out value="${cl.classCode}" />
                                            </td>
                                            <td class="muted">
                                                <c:out value="${cl.teacherName}" />
                                            </td>
                                            <td><span class="num">
                                                    <c:out value="${cl.sum}" />
                                                </span></td>
                                            <td class="muted">
                                                <c:out value="${cl.createdAt}" />
                                            </td>
                                            <td class="actions">
                                                <div class="btnstack">
                                                    <a class="btn-mini"
                                                        href="${ctx}/material/view/material-list?classId=${cl.id}&index=${page.index}">Materials</a>
                                                    <a class="btn-mini"
                                                        href="${ctx}/admin/assignment-list?classId=${cl.id}">Assignments</a>
                                                    <a class="btn-mini"
                                                        href="${ctx}/classroom/view/student-list?classId=${cl.id}">Students</a>
                                                    <form action="${ctx}/classroom/manage/delete-class" method="post"
                                                        onsubmit="return confirm('Delete this class and all its data?')">
                                                        <input type="hidden" name="classId"
                                                            value="<c:out value='${cl.id}'/>">
                                                        <input type="hidden" name="index"
                                                            value="<c:out value='${page.index}'/>">
                                                        <button class="btn-mini btn-mini--danger"
                                                            type="submit">Delete</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty classes}">
                                        <tr>
                                            <td colspan="6" class="empty">No classes found.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <%-- Pagination --%>
                            <c:url var="basePath" value="/classroom/manage/class-list">
                                <c:if test="${not empty search}">
                                    <c:param name="search" value="${search}" />
                                </c:if>
                                <c:param name="txtClassName" value="${clState}" />
                                <c:param name="txtTeacherName" value="${teState}" />
                                <c:param name="txtCreateAt" value="${tiState}" />
                            </c:url>

                            <div class="pager">
                                <c:if test="${page.index != 0}">
                                    <a class="pg" href="${basePath}&index=0">&laquo;</a>
                                    <a class="pg" href="${basePath}&index=${page.index - 1}">&lsaquo;</a>
                                </c:if>

                                <c:forEach var="i" begin="${page.pageStart}" end="${page.pageEnd}">
                                    <a class="pg ${i == page.index ? 'is-active' : ''}"
                                        href="${basePath}&index=${i}">${i + 1}</a>
                                </c:forEach>

                                <c:if test="${page.index != page.totalPage - 1 && page.totalPage > 0}">
                                    <a class="pg" href="${basePath}&index=${page.index + 1}">&rsaquo;</a>
                                    <a class="pg" href="${basePath}&index=${page.totalPage - 1}">&raquo;</a>
                                </c:if>
                            </div>

                    </div>
                </main>

                <style>
                    th {
                        user-select: none;
                    }

                    th:hover {
                        background-color: #f3f3f3;
                    }

                    th span {
                        font-size: 12px;
                        margin-left: 4px;
                    }
                </style>

                <script>
                    function sortBy(col) {
                        ["ClassName", "TeacherName", "CreateAt"].forEach(function (f) {
                            if (f !== col) {
                                document.getElementById("txt" + f).value = 0;
                                updateIcon(f, 0);
                            }
                        });
                        const el = document.getElementById("txt" + col);
                        const next = (parseInt(el.value) || 0 + 1) % 3;
                        el.value = next;
                        updateIcon(col, next);
                        document.getElementById("pageIndex").value = 0;
                        document.getElementById("frmSort").submit();
                    }

                    function updateIcon(field, state) {
                        const icon = document.getElementById("icon" + field);
                        if (icon) icon.textContent = state === 1 ? "▲" : state === 2 ? "▼" : "⇅";
                    }
                </script>

            </body>

            </html>