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
        <div class="card-body d-flex align-items-center justify-content-between py-2" style="flex-wrap:wrap;gap:10px;">

            <form action="${ctx}/assignment/view/submission" method="get" class="rs-search">
                <span class="rs-search__icon"><i class="bi bi-search"></i></span>
                <input class="rs-search__input" type="text" name="search"
                       value="<c:out value='${search}'/>"
                       placeholder="Search by name or email…">
                <input type="hidden" name="assignmentId" value="${assignmentId}">
                <input type="hidden" name="classId" value="${classId}">
                <button class="rs-search__submit" type="submit"><i class="bi bi-arrow-right"></i></button>
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

    <div class="card border-0 shadow-sm mb-3 p-3">

        <div class="d-flex flex-wrap gap-3 align-items-center justify-content-between">

            <!-- QUICK STATS -->
            <div id="stats" class="small">
                Total: <b id="stTotal">0</b> |
                Graded: <b id="stGraded">0</b> |
                Not graded: <b id="stNot">0</b> |
                Violated: <b id="stViolated">0</b>
            </div>

            <!-- SORT -->
            <div class="d-flex gap-4">
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
                        <th style="width: 160px;" class="text-end">SCQ</th>
                        <th style="width: 160px;" class="text-end">MCQ</th>
                        <th style="width: 160px;" class="text-end">Essay</th>
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
                            data-submitted="${it.submittedAt}"
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
                            <td class="text-nowrap">${it.startedAt}</td>
                            <td class="text-nowrap">${it.submittedAt}</td>

                            <%-- SCQ --%>
                            <td class="text-end">
                                <div class="score-cell">
                                    <div class="score-line">
                                        <span class="score-badge score-scq">${it.scqScoreFmt}</span>
                                        <span class="score-denom">/ ${it.scqMaxFmt}</span>
                                    </div>
                                    <div class="progress progress-thin">
                                        <div class="progress-bar bg-scq" role="progressbar"
                                             style="width:${it.scqPercent}%"></div>
                                    </div>
                                    <div class="mini-hint">auto</div>
                                </div>
                            </td>

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
                                <a href="${ctx}/assignment/review?attemptId=${it.attemptId}"
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
    <!-- JS-managed paging container -->
    <div id="jsPaging" class="pager"></div>
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

<script>
    (function () {

        // FIX: use correct selector - input has name="search", not id="q"
        const q = document.querySelector('input[name="search"]');
        const sort = document.getElementById('sortBy');

        const table = document.getElementById('submissionsTable');
        const tbody = table.querySelector('tbody');

        // Collect ALL rows once (including those hidden by server-side paging)
        // Since server-side paging hides rows via c:forEach begin/end,
        // we need all visible rows in the tbody
        let rows = Array.from(tbody.querySelectorAll('tr'));

        let currentPage = 1;
        const pageSize = 15;

        // FIX: parse "dd/MM/yyyy HH:mm" string to comparable timestamp
        function parseSubmittedDate(str) {
            if (!str || str === '—') return 0;
            // format: "19/11/2025 22:47"
            const parts = str.split(' ');
            if (parts.length < 2) return 0;
            const dateParts = parts[0].split('/');
            const timeParts = parts[1].split(':');
            if (dateParts.length < 3) return 0;
            // new Date(year, month-1, day, hour, min)
            return new Date(
                parseInt(dateParts[2]),
                parseInt(dateParts[1]) - 1,
                parseInt(dateParts[0]),
                parseInt(timeParts[0] || 0),
                parseInt(timeParts[1] || 0)
            ).getTime();
        }

        function getFilteredRows() {
            const term = (q ? q.value : '').toLowerCase();

            return rows.filter(r => {
                const name = r.dataset.name || '';
                const email = r.dataset.email || '';
                const matchSearch = !term || name.includes(term) || email.includes(term);
                return matchSearch;
            });
        }

        function sortRows(list) {
            const type = sort.value;

            list.sort((a, b) => {
                if (type === "name") {
                    return (a.dataset.name || '').localeCompare(b.dataset.name || '');
                }
                if (type === "score") {
                    return parseFloat(b.dataset.score || 0) - parseFloat(a.dataset.score || 0);
                }
                if (type === "submitted") {
                    // FIX: parse date string properly
                    return parseSubmittedDate(b.dataset.submitted) - parseSubmittedDate(a.dataset.submitted);
                }
                return 0;
            });

            return list;
        }

        function render() {
            let filtered = getFilteredRows();
            filtered = sortRows(filtered);

            updateStats(filtered);

            const totalPage = Math.ceil(filtered.length / pageSize) || 1;
            if (currentPage > totalPage) currentPage = 1;

            const start = (currentPage - 1) * pageSize;
            const pageRows = filtered.slice(start, start + pageSize);

            tbody.innerHTML = "";
            pageRows.forEach(r => tbody.appendChild(r));

            renderPaging(totalPage);
        }

        function updateStats(list) {
            let graded = 0, notGraded = 0, violated = 0;

            list.forEach(r => {
                const s = r.dataset.status;
                if (s === "Graded")
                    graded++;
                else if (s === "Violated")
                    violated++;
                else
                    notGraded++;
            });

            document.getElementById('stTotal').innerText = list.length;
            document.getElementById('stGraded').innerText = graded;
            document.getElementById('stNot').innerText = notGraded;
            document.getElementById('stViolated').innerText = violated;
        }

        function renderPaging(totalPage) {
            const paging = document.getElementById('jsPaging');
            paging.innerHTML = "";

            // Helper to create paging button
            function mkBtn(label, page, disabled, active) {
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'pg' + (active ? ' is-active' : '') + (disabled ? ' disabled' : '');
                btn.innerHTML = label;
                btn.disabled = disabled;
                if (!disabled) {
                    btn.onclick = () => { currentPage = page; render(); };
                }
                return btn;
            }

            // First & Prev
            paging.appendChild(mkBtn('&laquo;', 1, currentPage === 1, false));
            paging.appendChild(mkBtn('&lsaquo;', currentPage - 1, currentPage === 1, false));

            // Page numbers: show at most 5 around current page
            const delta = 2;
            const rangeStart = Math.max(1, currentPage - delta);
            const rangeEnd   = Math.min(totalPage, currentPage + delta);

            if (rangeStart > 1) {
                paging.appendChild(mkBtn('1', 1, false, false));
                if (rangeStart > 2) {
                    const ellipsis = document.createElement('span');
                    ellipsis.className = 'pg-ellipsis';
                    ellipsis.innerText = '…';
                    paging.appendChild(ellipsis);
                }
            }

            for (let i = rangeStart; i <= rangeEnd; i++) {
                paging.appendChild(mkBtn(i, i, false, i === currentPage));
            }

            if (rangeEnd < totalPage) {
                if (rangeEnd < totalPage - 1) {
                    const ellipsis = document.createElement('span');
                    ellipsis.className = 'pg-ellipsis';
                    ellipsis.innerText = '…';
                    paging.appendChild(ellipsis);
                }
                paging.appendChild(mkBtn(totalPage, totalPage, false, false));
            }

            // Next & Last
            paging.appendChild(mkBtn('&rsaquo;', currentPage + 1, currentPage === totalPage, false));
            paging.appendChild(mkBtn('&raquo;', totalPage, currentPage === totalPage, false));
        }

        // EVENTS
        if (q) {
            q.addEventListener('input', () => {
                currentPage = 1;
                render();
            });
        }

        sort.addEventListener('change', () => {
            currentPage = 1;
            render();
        });

        // Initial render
        render();

    })();
</script>

