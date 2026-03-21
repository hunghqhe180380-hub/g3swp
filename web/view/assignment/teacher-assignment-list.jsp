<%-- 
    Document   : list-assignment
    Created on : Mar 16, 2026, 5:49:00 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isTeacher" value="${fn:toUpperCase(sessionScope.user.role) == 'TEACHER'}" />
<c:set var="isAdmin" value="${fn:toUpperCase(sessionScope.user.role) == 'ADMIN'}" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Assignment Management</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

        <link rel="stylesheet" href="${ctx}/assets/css/teacher-assignment-list.css">

    </head>

    <body>

        <div class="header d-flex justify-content-between align-items-center">

            <div>
                <div style="font-size:14px">Assignment</div>
                <h3>Assignments • ${classroom.name}</h3>
            </div>

            <div>
                <c:if test="${isTeacher}">
                    <a href="${ctx}/assignment/manage/create?classId=${requestScope.classId}" class="btn btn-light me-2">
                        <i class="bi bi-plus-lg"></i> Create assignment
                    </a>

                    <a href="${ctx}/account/dashboard" class="btn btn-outline-light">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                </c:if>
                <c:if test="${isAdmin}">                    
                    <a href="${ctx}/classroom/view/class-list" class="btn btn-outline-light">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                </c:if>
            </div>

        </div>

        <div class="container mt-4">

            <div class="mb-3">
                <strong>Class ID:</strong> ${classId}
            </div>

            <!-- Toolbar: search + type filter + total -->
            <div class="d-flex align-items-center gap-3 mb-3" style="flex-wrap:wrap;">
                <div style="flex:1;">
                    <form class="rs-search" style="min-width:500px;"
                          action="${ctx}/assignment/view/list-assignment" method="get" id="frmSearch">
                        <i class="bi bi-search rs-search__icon"></i>
                        <input class="rs-search__input" type="search" name="search" id="searchInput"
                               value="<c:out value='${search}'/>"
                               placeholder="Search by title…" autocomplete="off">
                        <input type="hidden" name="classId" value="${classroom.id}">
                        <button class="rs-search__submit" type="submit">
                            <i class="bi bi-arrow-right"></i>
                        </button>
                    </form>
                </div>
                <!-- Multi-type pill filters (client-side) -->
                <div class="filter-pills" id="filterPills">
                    <button type="button" class="fpill is-active" data-type="">All</button>
                    <button type="button" class="fpill fpill-scq"   data-type="1"><i class="bi bi-check2-square"></i> SCQ</button>
                    <button type="button" class="fpill fpill-mcq"   data-type="2"><i class="bi bi-list-ul"></i> MCQ</button>
                    <button type="button" class="fpill fpill-essay"  data-type="3"><i class="bi bi-card-text"></i> Essay</button>
                </div>

                <div style="font-size:14px;color:#6c757d;white-space:nowrap;">
                    Total: <strong id="totalCount"><c:out value="${fn:length(listAssignment)}"/></strong>
                </div>
            </div>

            <c:choose>

                <c:when test="${empty listAssignment}">

                    <div class="empty-wrapper">

                        <div class="empty-screen">

                            <div class="empty-icon">
                                <i class="bi bi-clipboard-check"></i>
                            </div>

                            <h5>No assignments yet</h5>
                            <c:if test="${isTeacher || isAdmin}">
                                <p class="text-muted">
                                    Create your first assignment for this class
                                </p>
                                
                                <a href="${ctx}/assignment/manage/create?classId=${requestScope.classId}" class="btn btn-primary">
                                    <i class="bi bi-plus-lg"></i>
                                    Create assignment
                                </a>
                            </c:if>
                        </div>

                    </div>


                </c:when>

                <c:otherwise>

                    <!-- bảng assignment thật -->
                    <c:forEach items="${listAssignment}" var="a" begin="${page.start}" end="${page.end}">

                        <div class="card assignment-card p-3"
                             data-type="${a.type}"
                             data-title="${fn:toLowerCase(fn:escapeXml(a.title))}">

                            <div class="d-flex justify-content-between">

                                <div>

                                    <h5 class="fw-bold">${a.title}</h5>

                                    <div class="text-muted mb-2">
                                        ${a.description}
                                    </div>

                                    <div class="assignment-meta">

                                        <i class="bi bi-folder"></i> Class ${classroom.name}
                                        &nbsp;&nbsp;

                                        <i class="bi bi-calendar"></i> Due: ${a.closeAt}
                                        &nbsp;&nbsp;

                                        <i class="bi bi-arrow-repeat"></i> Attempts: ${a.maxAttempts}

                                        <span class="badge badge-type ms-2">                                            
                                            <c:if test="${a.type == 'MCQ'}">
                                                MCQ
                                            </c:if>
                                            <c:if test="${a.type == 'Essay'}">
                                                Essay
                                            </c:if>
                                            <c:if test="${a.type == 'Mixed'}">
                                                Mixed
                                            </c:if>
                                        </span>

                                    </div>

                                </div>

                                <div class="d-flex align-items-center">
                                    <c:if test="${isTeacher}">
                                        <a href="${ctx}/assignment/view/question?classId=${requestScope.classId}&assignmentId=${a.id}" class="btn btn-outline-primary btn-sm me-2">
                                            <i class="bi bi-pencil"></i> Detail
                                        </a>
                                    </c:if>
                                    <a href="${ctx}/assignment/view/submission?classId=${requestScope.classId}&assignmentId=${a.id}" class="btn btn-outline-secondary btn-sm me-2">
                                        <i class="bi bi-people"></i> Submissions
                                    </a>

                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>

                                </div>

                            </div>

                        </div>

                    </c:forEach>

                </c:otherwise>

            </c:choose>

            <!-- PAGING -->
            <c:if test="${not empty listAssignment}">
                <div class="pager">                    
                    <c:url var="basePath" value="/assignment/view/list-assignment">
                        <c:if test="${not empty search}">
                            <c:param name="search" value="${search}"/>
                        </c:if>
                        <c:param name="classId" value="${classroom.id}"/>
                    </c:url>

                    <c:if test="${page.index!=0}">
                        <a class="pg" href="${basePath}&index=0">&laquo;</a>
                        <a class="pg" href="${basePath}&index=${page.index-1}">&lsaquo;</a>
                    </c:if>

                    <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
                        <a class="pg ${index==page.index ? 'is-active' : ''}"
                           href="${basePath}&index=${index}">
                            ${index+1}
                        </a>
                    </c:forEach>

                    <c:if test="${page.index!=page.totalPage-1}">
                        <a class="pg" href="${basePath}&index=${page.index+1}">&rsaquo;</a>
                        <a class="pg" href="${basePath}&index=${page.totalPage-1}">&raquo;</a>
                    </c:if>
                </div>
            </c:if>
        </div>

    <script>
        (function () {
            var pills      = Array.from(document.querySelectorAll('#filterPills .fpill'));
            var allCards   = Array.from(document.querySelectorAll('.assignment-card'));
            var totalEl    = document.getElementById('totalCount');
            var activeTypes = new Set();

            function applyFilter() {
                var types = activeTypes.size > 0 && !activeTypes.has('') ? activeTypes : null;
                var count = 0;

                allCards.forEach(function (card) {
                    var ctype = card.dataset.type || '';
                    var show  = !types || types.has(ctype);
                    card.style.display = show ? '' : 'none';
                    if (show) count++;
                });

                if (totalEl) totalEl.textContent = count;
            }

            function updateActivePills() {
                pills.forEach(function (p) {
                    p.classList.toggle('is-active', activeTypes.has(p.dataset.type));
                });
            }

            pills.forEach(function (pill) {
                pill.addEventListener('click', function () {
                    var t = pill.dataset.type;

                    if (t === '') {
                        activeTypes.clear();
                    } else {
                        activeTypes.delete('');
                        if (activeTypes.has(t)) {
                            activeTypes.delete(t);
                        } else {
                            activeTypes.add(t);
                        }
                        if (activeTypes.size === 0) activeTypes.add('');
                    }

                    updateActivePills();
                    applyFilter();
                });
            });

            updateActivePills();
            applyFilter();
        })();
    </script>

</body>
</html>