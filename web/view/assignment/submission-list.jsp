<%--
    Document   : submission-list
    Created on : Mar 17, 2026, 9:06:07 PM
    Author     : BINH
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet" href="${ctx}/assets/css/submission-list.css"/>

<div class="container-fluid px-0">

    <%-- HERO --%>
    <div class="page-hero mb-3" style="background: linear-gradient(135deg, #4f46e5 0%, #0891b2 100%);">
        <div class="d-flex align-items-center justify-content-between page-hero__inner text-white">
            <div>
                <div class="small opacity-75">Submissions</div>
                <h4 class="mb-0">${assignmentTitle}</h4>
            </div>
            <div class="d-flex gap-2">
                <a href="${ctx}/assignment/view/list-assignment?classId=${classId}"
                   class="btn btn-light btn-sm">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
            </div>
        </div>
    </div>

    <%-- TOOLBAR --%>
    <div class="toolbar card border-0 shadow-sm mb-3">
        <div class="card-body d-flex align-items-center justify-content-between py-2" style="flex-wrap:wrap;gap:10px;">

            <form action="${ctx}/assignment/view/submission" method="get" class="rs-search">
                <span class="rs-search__icon"><i class="bi bi-search"></i></span>
                <input class="rs-search__input" type="text" name="search"
                       value="<c:out value='${search}'/>"
                       placeholder="Search by student name or email…">
                <input type="hidden" name="assignmentId" value="${assignmentId}">
                <input type="hidden" name="classId" value="${classId}">
                <button class="rs-search__submit" type="submit"><i class="bi bi-box-arrow-up-right"></i></button>
            </form>

            <div class="filter-pills" id="filterPills">
                <button type="button" class="fpill ${param.status == '' || empty param.status ? 'is-active' : ''}" data-status="">All</button>
                <button type="button" class="fpill fpill-inprogress ${fn:contains(param.status, '1') ? 'is-active' : ''}" data-status="1"><i class="bi bi-hourglass-split"></i> In Progress</button>
                <button type="button" class="fpill fpill-submitted  ${fn:contains(param.status, '2') ? 'is-active' : ''}"  data-status="2"><i class="bi bi-check-circle"></i> Submitted</button>
                <button type="button" class="fpill fpill-graded    ${fn:contains(param.status, '3') ? 'is-active' : ''}"  data-status="3"><i class="bi bi-patch-check"></i> Graded</button>
                <button type="button" class="fpill fpill-late      ${fn:contains(param.status, '4') ? 'is-active' : ''}"  data-status="4"><i class="bi bi-alarm"></i> Late</button>
                <button type="button" class="fpill fpill-violated  ${fn:contains(param.status, '5') ? 'is-active' : ''}"  data-status="5"><i class="bi bi-x-octagon"></i> Violated</button>
            </div>

        </div>
    </div>

    <%-- TABLE --%>
    <div class="card shadow-sm border-0 section-shell">
        <div class="table-responsive submissions-table-wrap">
            <table class="table table-hover align-middle mb-0" id="submissionsTable">
                <thead class="table-light sticky-top shadow-sm">
                    <tr>
                        <th style="min-width: 220px;">Student</th>
                        <th style="width: 110px;">Attempt</th>
                        <th style="width: 140px;" class="text-nowrap">Started</th>
                        <th style="width: 140px;" class="text-nowrap">Submitted</th>
                        <th style="width: 200px;" class="text-end">MCQ</th>
                        <th style="width: 200px;" class="text-end">Essay</th>
                        <th style="width: 200px;" class="text-end">Final</th>
                        <th style="width: 96px;"></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="it" items="${items}" begin="${page.start}" end="${page.end}">

                        <%-- Status badge class --%>
                        <c:choose>
                            <c:when test="${it.status == 'Graded'}">
                                <c:set var="statusCls" value="badge-soft-success"/>
                            </c:when>
                            <c:when test="${it.status == 'Submitted'}">
                                <c:set var="statusCls" value="badge-soft-primary"/>
                            </c:when>
                            <c:when test="${it.status == 'InProgress'}">
                                <c:set var="statusCls" value="badge-soft-secondary"/>
                            </c:when>
                            <c:when test="${it.status == 'Late'}">
                                <c:set var="statusCls" value="badge-soft-warning"/>
                            </c:when>
                            <c:when test="${it.status == 'Violated'}">
                                <c:set var="statusCls" value="badge-soft-danger"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="statusCls" value="badge-soft-warning"/>
                            </c:otherwise>
                        </c:choose>

                        <tr data-name="${fn:toLowerCase(it.studentName)}"
                            data-email="${fn:toLowerCase(it.studentEmail)}">

                            <%-- Student --%>
                            <td>
                                <div class="fw-semibold">${it.studentName}</div>
                                <div class="text-muted small text-truncate" style="max-width:260px"
                                     title="${it.studentEmail}">
                                    ${it.studentEmail}
                                </div>
                            </td>

                            <%-- Attempt + Status --%>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-light text-dark">#${it.attemptNumber}</span>
                                    <span class="badge ${statusCls}">${it.status}</span>
                                </div>
                            </td>

                            <%-- Dates --%>
                            <td class="text-nowrap">${it.startedAtStr}</td>
                            <td class="text-nowrap">${it.submittedAtStr}</td>

                            <%-- MCQ --%>
                            <td class="text-end">
                                <div class="score-cell">
                                    <div class="score-line">
                                        <span class="score-badge score-mcq">${it.mcqScoreFmt}</span>
                                        <span class="score-denom">/ ${it.mcqMaxFmt}</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar bg-mcq" role="progressbar"
                                             style="width:${it.mcqPercent}%"></div>
                                    </div>
                                    <div class="mini-hint">auto</div>
                                </div>
                            </td>

                            <%-- Essay --%>
                            <td class="text-end">
                                <div class="score-cell">
                                    <div class="score-line">
                                        <span class="score-badge ${it.essayScoreAvailable ? 'score-essay' : 'score-pending'}">
                                            ${it.essayScoreFmt}
                                        </span>
                                        <span class="score-denom">/ ${it.essayMaxFmt}</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <c:choose>
                                            <c:when test="${it.essayScoreAvailable}">
                                                <div class="progress-bar bg-essay" role="progressbar"
                                                     style="width:${it.essayPercent}%"></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="progress-bar bg-essay" role="progressbar"
                                                     style="width:0%"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mini-hint">
                                        <c:choose>
                                            <c:when test="${it.requiresManual}">manual</c:when>
                                            <c:otherwise>n/a</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </td>

                            <%-- Final --%>
                            <td class="text-end">
                                <div class="score-cell">
                                    <div class="score-line">
                                        <span class="score-badge ${it.finalScoreAvailable ? 'score-final' : 'score-pending'}">
                                            ${it.finalScoreFmt}
                                        </span>
                                        <span class="score-denom">/ ${it.finalMaxFmt}</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <c:choose>
                                            <c:when test="${it.finalScoreAvailable}">
                                                <div class="progress-bar bg-final" role="progressbar"
                                                     style="width:${it.finalPercent}%"></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="progress-bar bg-final" role="progressbar"
                                                     style="width:0%"></div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mini-hint">total</div>
                                </div>
                            </td>

                            <%-- Actions --%>
                            <td class="text-end">
                                <c:if test="${it.requiresManual && userRole != 'Student'}">
                                    <a href="#"
                                       class="btn btn-outline-primary btn-sm d-inline-flex align-items-center gap-1">
                                        <i class="bi bi-pencil-square"></i>
                                        <span class="d-none d-xl-inline">Grade</span>
                                    </a>
                                </c:if>
                                <a href="#"
                                   class="btn btn-sm btn-outline-secondary">
                                    View
                                </a>
                            </td>

                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>


    </div>
    <!-- PAGING -->
    <c:if test="${not empty items}">
        <div class="pager">                    
            <c:url var="basePath" value="/assignment/view/submission">
                <c:if test="${not empty search}">
                    <c:param name="search" value="${search}"/>
                </c:if>
                <c:if test="${not empty status}">
                    <c:param name="status" value="${status}"/>
                </c:if>
                <c:param name="assignmentId" value="${assignmentId}"/>
                <c:param name="classId" value="${classId}"/>
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

<%-- Status filter (multi-select) script --%>
<script>
    (function () {
        const pills = Array.from(document.querySelectorAll('#filterPills .fpill'));

        function buildUrl(activeTypes) {
            const url = new URL(window.location.href);
            if (activeTypes.size === 0 || (activeTypes.size === 1 && activeTypes.has(''))) {
                url.searchParams.delete('status');
            } else {
                url.searchParams.set('status', Array.from(activeTypes).filter(function (t) { return t !== ''; }).join(','));
            }
            url.searchParams.delete('index');
            return url.toString();
        }

        function updatePills() {
            pills.forEach(function (p) {
                p.classList.toggle('is-active', activeTypes.has(p.dataset.status));
            });
        }

        // Init active set from URL
        const activeTypes = new Set();
        const paramVal = new URL(window.location.href).searchParams.get('status') || '';
        if (!paramVal) {
            activeTypes.add('');
        } else {
            paramVal.split(',').forEach(function (s) { activeTypes.add(s.trim()); });
        }
        updatePills();

        pills.forEach(function (pill) {
            pill.addEventListener('click', function () {
                const t = pill.dataset.status;
                if (t === '') {
                    activeTypes.clear();
                    activeTypes.add('');
                } else {
                    activeTypes.delete('');
                    if (activeTypes.has(t)) {
                        activeTypes.delete(t);
                    } else {
                        activeTypes.add(t);
                    }
                    if (activeTypes.size === 0) activeTypes.add('');
                }
                updatePills();
                window.location.href = buildUrl(activeTypes);
            });
        });
    })();
</script>

