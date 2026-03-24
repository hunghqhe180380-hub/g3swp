<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="base" value="${ctx}/question/manage/accept-question"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Question Requests – POET Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: #f0f4f8;
            color: #1e293b;
            min-height: 100vh;
        }

        /* ── TOPBAR ── */
        .topbar {
            background: linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%);
            padding: 20px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 4px 20px rgba(99,102,241,0.25);
        }
        .topbar__eyebrow { font-size: 12px; color: rgba(255,255,255,0.75); font-weight: 500; margin-bottom: 3px; letter-spacing: .5px; }
        .topbar__title   { font-size: 26px; font-weight: 800; color: #fff; }
        .btn-back {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 10px 20px; border-radius: 12px;
            border: 1.5px solid rgba(255,255,255,0.35);
            color: #fff; font-weight: 700; font-size: 14px;
            background: rgba(255,255,255,0.10); backdrop-filter: blur(8px);
            text-decoration: none; transition: .15s ease;
        }
        .btn-back:hover { background: rgba(255,255,255,0.20); }

        /* ── LAYOUT ── */
        .page { max-width: 1280px; margin: 0 auto; padding: 28px 24px 60px; }

        /* ── STATS CARDS ── */
        .stats-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card {
            background: #fff; border-radius: 16px; padding: 18px 20px;
            display: flex; align-items: center; gap: 14px;
            box-shadow: 0 1px 6px rgba(0,0,0,.07);
            border: 1.5px solid #e8edf3; transition: .15s ease;
        }
        .stat-card:hover { box-shadow: 0 4px 18px rgba(0,0,0,.10); transform: translateY(-1px); }
        .stat-card__icon {
            width: 46px; height: 46px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; flex-shrink: 0;
        }
        .stat-card__icon--total    { background: #ede9fe; color: #6d28d9; }
        .stat-card__icon--pending  { background: #fef3c7; color: #d97706; }
        .stat-card__icon--approved { background: #dcfce7; color: #16a34a; }
        .stat-card__icon--rejected { background: #fee2e2; color: #dc2626; }
        .stat-card__label { font-size: 12px; color: #64748b; font-weight: 500; }
        .stat-card__value { font-size: 26px; font-weight: 800; color: #1e293b; line-height: 1.1; }

        /* ── CONTROLS ── */
        .controls {
            background: #fff; border-radius: 16px; padding: 16px 20px;
            box-shadow: 0 1px 6px rgba(0,0,0,.07); border: 1.5px solid #e8edf3;
            margin-bottom: 18px;
            display: flex; flex-wrap: wrap; gap: 10px; align-items: center;
        }
        .search-wrap {
            display: flex; align-items: center; gap: 8px;
            background: #f8fafc; border: 1.5px solid #e2e8f0;
            border-radius: 10px; padding: 8px 12px; flex: 1; min-width: 200px;
        }
        .search-wrap i { color: #94a3b8; font-size: 15px; }
        .search-wrap input {
            border: none; background: transparent; outline: none;
            font-size: 14px; color: #1e293b; width: 100%; font-family: inherit;
        }
        .filter-select {
            padding: 9px 14px; border-radius: 10px; border: 1.5px solid #e2e8f0;
            font-size: 13px; font-family: inherit; background: #f8fafc; color: #334155;
            cursor: pointer; outline: none;
        }
        .filter-select:focus { border-color: #6366f1; }
        .btn-search {
            padding: 9px 20px; border-radius: 10px; border: none;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: #fff; font-weight: 700; font-size: 13px; cursor: pointer;
            transition: .15s ease; display: flex; align-items: center; gap: 6px;
        }
        .btn-search:hover { opacity: .9; }
        .btn-clear {
            padding: 9px 16px; border-radius: 10px; border: 1.5px solid #e2e8f0;
            background: #fff; color: #64748b; font-weight: 600; font-size: 13px;
            cursor: pointer; text-decoration: none; display: flex; align-items: center; gap: 5px;
        }
        .btn-clear:hover { border-color: #94a3b8; color: #334155; }

        /* ── BULK ACTIONS ── */
        .bulk-bar {
            display: none; align-items: center; gap: 10px;
            background: #eff6ff; border: 1.5px solid #bfdbfe;
            border-radius: 12px; padding: 10px 16px;
            margin-bottom: 12px; font-size: 14px; font-weight: 600; color: #1d4ed8;
        }
        .bulk-bar.visible { display: flex; }
        .bulk-bar span { flex: 1; }
        .btn-bulk-approve, .btn-bulk-reject {
            padding: 7px 16px; border-radius: 8px; border: none;
            font-weight: 700; font-size: 13px; cursor: pointer; transition: .15s;
        }
        .btn-bulk-approve { background: #16a34a; color: #fff; }
        .btn-bulk-approve:hover { background: #15803d; }
        .btn-bulk-reject  { background: #dc2626; color: #fff; }
        .btn-bulk-reject:hover  { background: #b91c1c; }

        /* ── RESULT SUMMARY ── */
        .result-summary {
            font-size: 13px; color: #64748b; margin-bottom: 10px;
            display: flex; align-items: center; gap: 8px;
        }
        .result-summary strong { color: #1e293b; }

        /* ── TABLE ── */
        .card {
            background: #fff; border-radius: 16px;
            box-shadow: 0 1px 6px rgba(0,0,0,.07); border: 1.5px solid #e8edf3;
            overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #f8fafc; border-bottom: 2px solid #e2e8f0; }
        th {
            padding: 12px 14px; font-size: 12px; font-weight: 700;
            text-transform: uppercase; letter-spacing: .5px; color: #64748b;
            white-space: nowrap;
        }
        th.sortable { cursor: pointer; user-select: none; }
        th.sortable:hover { color: #4f46e5; }
        th .sort-icon { margin-left: 4px; font-size: 11px; }
        td {
            padding: 13px 14px; font-size: 14px; color: #334155;
            border-bottom: 1px solid #f1f5f9; vertical-align: middle;
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafbff; }
        .prompt-cell { max-width: 320px; }
        .prompt-text {
            display: -webkit-box; -webkit-line-clamp: 2;
            -webkit-box-orient: vertical; overflow: hidden;
            line-height: 1.5;
        }

        /* ── STATUS BADGE ── */
        .badge {
            display: inline-flex; align-items: center; gap: 4px;
            padding: 3px 10px; border-radius: 999px; font-size: 12px; font-weight: 700;
        }
        .badge--pending  { background: #fef3c7; color: #b45309; }
        .badge--approved { background: #dcfce7; color: #16a34a; }
        .badge--rejected { background: #fee2e2; color: #dc2626; }
        .type-badge {
            padding: 2px 9px; border-radius: 6px; font-size: 12px; font-weight: 700;
        }
        .type-scq   { background: #dbeafe; color: #1d4ed8; }
        .type-mcq   { background: #fae8ff; color: #7e22ce; }
        .type-essay { background: #fef3c7; color: #b45309; }

        /* ── ACTION BUTTONS ── */
        .btn-approve, .btn-reject {
            padding: 5px 13px; border-radius: 7px; border: none;
            font-size: 12px; font-weight: 700; cursor: pointer; transition: .15s;
            display: inline-block;
        }
        .btn-approve { background: #dcfce7; color: #16a34a; }
        .btn-approve:hover { background: #16a34a; color: #fff; }
        .btn-reject  { background: #fee2e2; color: #dc2626; }
        .btn-reject:hover  { background: #dc2626; color: #fff; }
        .action-col { display: flex; gap: 6px; align-items: center; }

        /* ── EMPTY ── */
        .empty-row td { text-align: center; padding: 48px; color: #94a3b8; font-size: 15px; }
        .empty-row td i { display: block; font-size: 36px; margin-bottom: 10px; }

        /* ── PAGINATION ── */
        .pager { display: flex; align-items: center; gap: 4px; padding: 18px 0 0; flex-wrap: wrap; }
        .pg {
            min-width: 34px; height: 34px; display: inline-flex; align-items: center;
            justify-content: center; border-radius: 8px; font-size: 13px; font-weight: 600;
            color: #475569; text-decoration: none; background: #fff;
            border: 1.5px solid #e2e8f0; transition: .15s;
        }
        .pg:hover    { border-color: #6366f1; color: #4f46e5; }
        .pg.is-active { background: linear-gradient(135deg,#6366f1,#4f46e5); color:#fff; border-color: transparent; }

        /* ── CHECKBOX ── */
        input[type=checkbox] { width: 16px; height: 16px; cursor: pointer; accent-color: #4f46e5; }

        @media(max-width:768px){
            .stats-row { grid-template-columns: 1fr 1fr; }
            .controls  { flex-direction: column; }
            .search-wrap { min-width: 100%; }
        }
    </style>
</head>
<body>

<!-- TOPBAR -->
<header class="topbar">
    <div>
        <div class="topbar__eyebrow">Administration</div>
        <div class="topbar__title">Question Requests</div>
    </div>
    <a href="${ctx}/account/dashboard" class="btn-back">
        <i class="bi bi-arrow-left"></i> Back
    </a>
</header>

<main class="page">

    <!-- STATS CARDS -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-card__icon stat-card__icon--total"><i class="bi bi-patch-question"></i></div>
            <div>
                <div class="stat-card__label">Total Questions</div>
                <div class="stat-card__value">${statTotal}</div>
            </div>
        </div>
        <div class="stat-card" style="cursor:pointer" onclick="applyFilter('status','0')">
            <div class="stat-card__icon stat-card__icon--pending"><i class="bi bi-hourglass-split"></i></div>
            <div>
                <div class="stat-card__label">Pending Review</div>
                <div class="stat-card__value">${statPending}</div>
            </div>
        </div>
        <div class="stat-card" style="cursor:pointer" onclick="applyFilter('status','1')">
            <div class="stat-card__icon stat-card__icon--approved"><i class="bi bi-check-circle"></i></div>
            <div>
                <div class="stat-card__label">Approved</div>
                <div class="stat-card__value">${statApproved}</div>
            </div>
        </div>
        <div class="stat-card" style="cursor:pointer" onclick="applyFilter('status','2')">
            <div class="stat-card__icon stat-card__icon--rejected"><i class="bi bi-x-circle"></i></div>
            <div>
                <div class="stat-card__label">Rejected</div>
                <div class="stat-card__value">${statRejected}</div>
            </div>
        </div>
    </div>

    <!-- SEARCH & FILTER CONTROLS -->
    <form id="filterForm" method="get" action="${base}">
        <input type="hidden" name="sort" id="sortInput" value="${sort}">
        <input type="hidden" name="dir"  id="dirInput"  value="${dir}">
        <input type="hidden" name="index" value="0">

        <div class="controls">
            <div class="search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" name="search" id="searchInput"
                       value="${fn:escapeXml(search)}"
                       placeholder="Search by prompt or subject name…"
                       autocomplete="off">
            </div>

            <select name="status" class="filter-select" onchange="this.form.submit()">
                <option value="">All Status</option>
                <option value="0" ${status == '0' ? 'selected' : ''}>Pending</option>
                <option value="1" ${status == '1' ? 'selected' : ''}>Approved</option>
                <option value="2" ${status == '2' ? 'selected' : ''}>Rejected</option>
            </select>

            <select name="type" class="filter-select" onchange="this.form.submit()">
                <option value="">All Types</option>
                <option value="1" ${type == '1' ? 'selected' : ''}>SCQ</option>
                <option value="2" ${type == '2' ? 'selected' : ''}>MCQ</option>
                <option value="3" ${type == '3' ? 'selected' : ''}>Essay</option>
            </select>

            <button type="submit" class="btn-search">
                <i class="bi bi-search"></i> Search
            </button>

            <a href="${base}" class="btn-clear">
                <i class="bi bi-arrow-counterclockwise"></i> Reset
            </a>
        </div>
    </form>

    <!-- BULK ACTION BAR -->
    <div class="bulk-bar" id="bulkBar">
        <span id="bulkCount">0 selected</span>
        <form method="post" action="${base}" id="bulkForm">
            <input type="hidden" name="action" id="bulkAction" value="">
            <input type="hidden" name="filterStatus" value="${status}">
            <input type="hidden" name="filterType" value="${type}">
            <input type="hidden" name="search" value="${fn:escapeXml(search)}">
            <input type="hidden" name="sort" value="${sort}">
            <input type="hidden" name="dir" value="${dir}">
            <input type="hidden" name="index" value="${page.index}">
            <div id="bulkIds"></div>
            <button type="button" class="btn-bulk-approve" onclick="submitBulk('bulk-approve')">
                <i class="bi bi-check-all"></i> Approve Selected
            </button>
            <button type="button" class="btn-bulk-reject" onclick="submitBulk('bulk-reject')">
                <i class="bi bi-x-lg"></i> Reject Selected
            </button>
        </form>
    </div>

    <!-- RESULT SUMMARY -->
    <div class="result-summary">
        <i class="bi bi-list-ul"></i>
        Showing <strong>${fn:length(listQuestion)}</strong> question(s)
        <c:if test="${not empty search}"> matching "<strong>${fn:escapeXml(search)}</strong>"</c:if>
        <c:if test="${not empty status}">
            &nbsp;·&nbsp;
            <c:choose>
                <c:when test="${status == '0'}">Status: <strong>Pending</strong></c:when>
                <c:when test="${status == '1'}">Status: <strong>Approved</strong></c:when>
                <c:when test="${status == '2'}">Status: <strong>Rejected</strong></c:when>
            </c:choose>
        </c:if>
        <c:if test="${not empty type}">
            &nbsp;·&nbsp; Type:
            <c:choose>
                <c:when test="${type == '1'}"><strong>SCQ</strong></c:when>
                <c:when test="${type == '2'}"><strong>MCQ</strong></c:when>
                <c:when test="${type == '3'}"><strong>Essay</strong></c:when>
            </c:choose>
        </c:if>
    </div>

    <!-- TABLE -->
    <div class="card">
        <table>
            <thead>
                <tr>
                    <th><input type="checkbox" id="selectAll" title="Select all on this page"></th>
                    <th class="sortable" onclick="sortBy('id')">#ID <span class="sort-icon">${sort=='id'?(dir=='asc'?'▲':'▼'):'⇅'}</span></th>
                    <th class="sortable" onclick="sortBy('subject')">Subject <span class="sort-icon">${sort=='subject'?(dir=='asc'?'▲':'▼'):'⇅'}</span></th>
                    <th class="sortable" onclick="sortBy('type')">Type <span class="sort-icon">${sort=='type'?(dir=='asc'?'▲':'▼'):'⇅'}</span></th>
                    <th class="sortable" onclick="sortBy('chapter')">Chapter <span class="sort-icon">${sort=='chapter'?(dir=='asc'?'▲':'▼'):'⇅'}</span></th>
                    <th>Prompt</th>
                    <th class="sortable" onclick="sortBy('status')">Status <span class="sort-icon">${sort=='status'?(dir=='asc'?'▲':'▼'):'⇅'}</span></th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty listSubject}">
                        <tr class="empty-row">
                            <td colspan="8">
                                <i class="bi bi-inbox"></i>
                                No questions found. Try adjusting your filters.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${listSubject}" var="q" begin="${page.start}" end="${page.end}">
                            <tr>
                                <td><input type="checkbox" class="row-check" data-id="${q.id}"></td>
                                <td style="color:#6366f1;font-weight:700">#${q.id}</td>
                                <td>${fn:escapeXml(q.subjectName)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.type == 1}"><span class="type-badge type-scq">SCQ</span></c:when>
                                        <c:when test="${q.type == 2}"><span class="type-badge type-mcq">MCQ</span></c:when>
                                        <c:when test="${q.type == 3}"><span class="type-badge type-essay">Essay</span></c:when>
                                        <c:otherwise>${q.type}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>Ch. ${q.chapter}</td>
                                <td class="prompt-cell">
                                    <div class="prompt-text" title="${fn:escapeXml(q.prompt)}">${fn:escapeXml(q.prompt)}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${q.status == 0}"><span class="badge badge--pending"><i class="bi bi-clock"></i>Pending</span></c:when>
                                        <c:when test="${q.status == 1}"><span class="badge badge--approved"><i class="bi bi-check"></i>Approved</span></c:when>
                                        <c:when test="${q.status == 2}"><span class="badge badge--rejected"><i class="bi bi-x"></i>Rejected</span></c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-col">
                                        <c:if test="${q.status != 1}">
                                            <form method="post" action="${base}">
                                                <input type="hidden" name="action"     value="approve">
                                                <input type="hidden" name="questionId" value="${q.id}">
                                                <input type="hidden" name="filterStatus" value="${status}">
                                                <input type="hidden" name="filterType"   value="${type}">
                                                <input type="hidden" name="search"       value="${fn:escapeXml(search)}">
                                                <input type="hidden" name="sort"         value="${sort}">
                                                <input type="hidden" name="dir"          value="${dir}">
                                                <input type="hidden" name="index"        value="${page.index}">
                                                <button class="btn-approve" type="submit"><i class="bi bi-check"></i> Approve</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${q.status != 2}">
                                            <form method="post" action="${base}">
                                                <input type="hidden" name="action"     value="reject">
                                                <input type="hidden" name="questionId" value="${q.id}">
                                                <input type="hidden" name="filterStatus" value="${status}">
                                                <input type="hidden" name="filterType"   value="${type}">
                                                <input type="hidden" name="search"       value="${fn:escapeXml(search)}">
                                                <input type="hidden" name="sort"         value="${sort}">
                                                <input type="hidden" name="dir"          value="${dir}">
                                                <input type="hidden" name="index"        value="${page.index}">
                                                <button class="btn-reject"  type="submit"><i class="bi bi-x"></i> Reject</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- PAGINATION -->
    <c:if test="${page.totalPage > 1}">
        <div class="pager">
            <c:set var="bp" value="${base}?search=${search}&status=${status}&type=${type}&sort=${sort}&dir=${dir}"/>
            <c:if test="${page.index > 0}">
                <a class="pg" href="${bp}&index=0"><i class="bi bi-chevron-double-left"></i></a>
                <a class="pg" href="${bp}&index=${page.index - 1}"><i class="bi bi-chevron-left"></i></a>
            </c:if>
            <c:forEach var="i" begin="${page.pageStart}" end="${page.pageEnd}">
                <a class="pg ${i == page.index ? 'is-active' : ''}" href="${bp}&index=${i}">${i + 1}</a>
            </c:forEach>
            <c:if test="${page.index < page.totalPage - 1}">
                <a class="pg" href="${bp}&index=${page.index + 1}"><i class="bi bi-chevron-right"></i></a>
                <a class="pg" href="${bp}&index=${page.totalPage - 1}"><i class="bi bi-chevron-double-right"></i></a>
            </c:if>
        </div>
    </c:if>

</main>

<script>
    // ── Sort ────────────────────────────────────────────────────────────────
    function sortBy(col) {
        const curSort = document.getElementById('sortInput').value;
        const curDir  = document.getElementById('dirInput').value;
        document.getElementById('sortInput').value = col;
        document.getElementById('dirInput').value  = (curSort === col && curDir === 'asc') ? 'desc' : 'asc';
        document.getElementById('filterForm').submit();
    }

    // ── Quick filter from stat cards ────────────────────────────────────────
    function applyFilter(name, value) {
        const form = document.getElementById('filterForm');
        const sel = form.querySelector('[name="' + name + '"]');
        if (sel) { sel.value = value; form.submit(); }
    }

    // ── Select All / Bulk ───────────────────────────────────────────────────
    const selectAll  = document.getElementById('selectAll');
    const bulkBar    = document.getElementById('bulkBar');
    const bulkCount  = document.getElementById('bulkCount');
    const bulkIds    = document.getElementById('bulkIds');

    function updateBulkBar() {
        const checked = document.querySelectorAll('.row-check:checked');
        if (checked.length > 0) {
            bulkBar.classList.add('visible');
            bulkCount.textContent = checked.length + ' selected';
        } else {
            bulkBar.classList.remove('visible');
        }
    }

    selectAll.addEventListener('change', function () {
        document.querySelectorAll('.row-check').forEach(cb => cb.checked = this.checked);
        updateBulkBar();
    });

    document.addEventListener('change', function (e) {
        if (e.target.classList.contains('row-check')) updateBulkBar();
    });

    function submitBulk(action) {
        const checked = document.querySelectorAll('.row-check:checked');
        if (checked.length === 0) return;
        document.getElementById('bulkAction').value = action;
        bulkIds.innerHTML = '';
        checked.forEach(cb => {
            const inp = document.createElement('input');
            inp.type  = 'hidden';
            inp.name  = 'questionIds[]';
            inp.value = cb.dataset.id;
            bulkIds.appendChild(inp);
        });
        document.getElementById('bulkForm').submit();
    }

    // ── Live search on Enter ────────────────────────────────────────────────
    document.getElementById('searchInput').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') document.getElementById('filterForm').submit();
    });
</script>
</body>
</html>