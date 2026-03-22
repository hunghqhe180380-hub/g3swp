<%--
    Document   : submission-list
    Created on : Mar 17, 2026, 9:06:07 PM
    Author     : BINH
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isTeacher" value="${fn:toUpperCase(sessionScope.user.role) == 'TEACHER'}" />
<c:set var="isAdmin" value="${fn:toUpperCase(sessionScope.user.role) == 'ADMIN'}" />

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
        <div class="card-body d-flex align-items-center justify-content-between py-2">
            <div class="flex-grow-1 me-3" style="max-width:640px;">
                <div class="input-group">
                    <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                    <input id="q" type="text" autocomplete="off" class="form-control"
                           placeholder="Search by student name or email…">
                </div>
            </div>
            <div class="small text-muted d-none d-md-block">
                List of all attempts. MCQ is auto-graded. Essay/Mixed may require grading.
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm mb-3 p-3">

        <div class="d-flex flex-wrap gap-3 align-items-center justify-content-between">

            <!-- QUICK STATS -->
            <div id="stats" class="small">
                Total: <b id="stTotal">0</b> |
                Graded: <b id="stGraded">0</b> |
                Not graded: <b id="stNot">0</b> |
                Violated: <b id="stViolated">0</b>
            </div>

            <!-- FILTER -->
            <div class="d-flex gap-4">
                <select id="filterStatus" class="form-select form-select-sm">
                    <option value="All">All</option>
                    <option value="Graded">Graded</option>
                    <option value="NotGraded">Not graded</option>
                    <option value="Violated">Violated</option>
                </select>

                <!-- SORT -->
                <select id="sortBy" class="form-select form-select-sm">
                    <option value="submitted">Submitted time</option>
                    <option value="score">Score</option>
                    <option value="name">Name</option>
                </select>
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
                    <c:forEach var="it" items="${items}">

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

                        <tr 
                            data-name="${fn:toLowerCase(it.studentName)}"
                            data-email="${fn:toLowerCase(it.studentEmail)}"
                            data-status="${it.status}"
                            data-score="${it.finalScore != null ? it.finalScore : 0}"
                            data-submitted="${it.submittedAtStr}"
                            >

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
                                    <a href="${ctx}/submission/grade?attemptId=${it.attemptId}"
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
</div>

<%-- Search script --%>
<script>
    (function () {
        const q = document.getElementById('q');
        const rows = Array.from(document.querySelectorAll('#submissionsTable tbody tr'));
        if (!q)
            return;

        q.addEventListener('input', function () {
            const term = (q.value || '').trim().toLowerCase();
            rows.forEach(function (r) {
                const name = r.getAttribute('data-name') || '';
                const email = r.getAttribute('data-email') || '';
                const show = !term || name.includes(term) || email.includes(term);
                r.style.display = show ? '' : 'none';
            });
        });
    })();
</script>

<script>
    (function () {

        const q = document.getElementById('q');
        const filter = document.getElementById('filterStatus');
        const sort = document.getElementById('sortBy');

        const table = document.getElementById('submissionsTable');
        const tbody = table.querySelector('tbody');

        let rows = Array.from(tbody.querySelectorAll('tr'));

        let currentPage = 1;
        const pageSize = 15;

        function getFilteredRows() {

            const term = (q.value || '').toLowerCase();
            const f = filter.value;

            return rows.filter(r => {

                const name = r.dataset.name || '';
                const email = r.dataset.email || '';
                const status = r.dataset.status || '';

                const matchSearch = !term || name.includes(term) || email.includes(term);

                let matchFilter = true;

                if (f === "Graded")
                    matchFilter = status === "Graded";
                if (f === "Violated")
                    matchFilter = status === "Violated";
                if (f === "NotGraded")
                    matchFilter = status !== "Graded";

                return matchSearch && matchFilter;
            });
        }

        function sortRows(list) {

            const type = sort.value;

            list.sort((a, b) => {

                if (type === "name") {
                    return a.dataset.name.localeCompare(b.dataset.name);
                }

                if (type === "score") {
                    return parseFloat(b.dataset.score) - parseFloat(a.dataset.score);
                }

                if (type === "submitted") {
                    return parseInt(b.dataset.submitted) - parseInt(a.dataset.submitted);
                }

                return 0;
            });

            return list;
        }

        function render() {

            let filtered = getFilteredRows();
            filtered = sortRows(filtered);

            updateStats(filtered);

            const totalPage = Math.ceil(filtered.length / pageSize);
            if (currentPage > totalPage)
                currentPage = 1;

            const start = (currentPage - 1) * pageSize;
            const pageRows = filtered.slice(start, start + pageSize);

            tbody.innerHTML = "";
            pageRows.forEach(r => tbody.appendChild(r));

            renderPaging(totalPage);
        }

        function updateStats(list) {

            let graded = 0, not = 0, violated = 0;

            list.forEach(r => {
                const s = r.dataset.status;
                if (s === "Graded")
                    graded++;
                else if (s === "Violated")
                    violated++;
                else
                    not++;
            });

            document.getElementById('stTotal').innerText = list.length;
            document.getElementById('stGraded').innerText = graded;
            document.getElementById('stNot').innerText = not;
            document.getElementById('stViolated').innerText = violated;
        }

        function renderPaging(totalPage) {

            let paging = document.getElementById('paging');

            if (!paging) {
                paging = document.createElement('div');
                paging.id = "paging";
                paging.className = "d-flex justify-content-center mt-3 gap-2";
                table.parentElement.appendChild(paging);
            }

            paging.innerHTML = "";

            for (let i = 1; i <= totalPage; i++) {
                const btn = document.createElement('button');
                btn.className = "btn btn-sm " + (i === currentPage ? "btn-primary" : "btn-outline-secondary");
                btn.innerText = i;

                btn.onclick = () => {
                    currentPage = i;
                    render();
                };

                paging.appendChild(btn);
            }
        }

        // EVENTS
        q.addEventListener('input', () => {
            currentPage = 1;
            render();
        });

        filter.addEventListener('change', () => {
            currentPage = 1;
            render();
        });

        sort.addEventListener('change', render);

        render();

    })();
</script>

