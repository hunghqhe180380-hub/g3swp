<%-- 
    Document   : list-assignment
    Created on : Mar 16, 2026, 5:49:00 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Assignments - POET</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${ctx}/assets/css/student-assignment-list.css">
    </head>

    <body class="assignment-page">
        <div class="assignment-shell">

            <header class="assignment-hero">
                <div class="assignment-hero__inner">
                    <div>
                        <div class="assignment-hero__eyebrow">Assignments</div>
                        <h1 class="assignment-hero__title">${classroom.name}</h1>
                    </div>

                    <a href="${ctx}/account/dashboard" class="assignment-back">
                        <i class="bi bi-arrow-left"></i>
                        <span>Back</span>
                    </a>
                </div>
            </header>

            <main class="assignment-panel">
                <section class="assignment-board">

                    <div class="assignment-toolbar">
                        <div class="assignment-search">
                            <i class="bi bi-search"></i>
                            <input id="assignmentSearch" type="text" placeholder="Search by title or class...">
                        </div>

                        <div class="assignment-toolbar__right">
                            <div class="assignment-filters">
                                <button class="assignment-filter is-active" type="button" data-filter="all">All</button>
                                <button class="assignment-filter" type="button" data-filter="open">
                                    <i class="bi bi-unlock"></i>Open
                                </button>
                                <button class="assignment-filter" type="button" data-filter="closed">
                                    <i class="bi bi-lock"></i>Closed
                                </button>
                            </div>

                            <div class="assignment-total">Total: <span id="assignmentTotal">${fn:length(listAssignment)}</span></div>
                        </div>
                    </div>

                    <div class="assignment-grid" id="assignmentGrid">
                        <c:forEach items="${listAssignment}" var="a" varStatus="loop">
                            <c:set var="progressPercent" value="${a.maxAttempts > 0 ? (a.usedAttempts * 100 / a.maxAttempts) : 0}" />

                            <div class="assignment-card"
                                 data-index="${loop.index}"
                                 data-title="${fn:escapeXml(a.title)}"
                                 data-description="${empty a.description ? '' : fn:escapeXml(a.description)}"
                                 data-type="${a.type}"
                                 data-status="${a.status}"
                                 data-class-name="${fn:escapeXml(classroom.name)}"
                                 data-duration="${a.duration}"
                                 data-max-attempts="${a.maxAttempts}"
                                 data-used-attempts="${a.usedAttempts}"
                                 data-open-at="${a.openAt}"
                                 data-close-at="${a.closeAt}"
                                 data-start-url="${ctx}/assignment/take?assignmentId=${a.id}&classId=${classId}"
                                 data-search-title="${fn:toLowerCase(a.title)}"
                                 data-search-class="${fn:toLowerCase(classroom.name)}"
                                 data-filter-status="${fn:toLowerCase(a.status)}">

                                <div class="assignment-card__topbar"></div>

                                <div class="assignment-card__head">
                                    <h3 class="assignment-card__title">
                                        <i class="bi bi-clipboard-check"></i>
                                        <span>${a.title}</span>
                                    </h3>

                                    <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;justify-content:flex-end;">
                                        <c:choose>
                                            <c:when test="${a.type == 'Mixed'}">
                                                <span class="chip chip--mixed">${a.type}</span>
                                            </c:when>
                                            <c:when test="${a.type == 'MCQ'}">
                                                <span class="chip chip--mcq">${a.type}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="chip chip--essay">${a.type}</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <span class="chip ${a.status == 'Open' ? 'chip--open' : 'chip--closed'}">
                                            ${a.status}
                                        </span>
                                    </div>
                                </div>

                                <div class="assignment-card__meta">
                                    <span><i class="bi bi-folder"></i>${classroom.name}</span>
                                    <span><i class="bi bi-clock"></i>Due: ${a.closeAt}</span>
                                </div>

                                <div class="assignment-card__attempts">
                                    Attempts ${a.usedAttempts} / ${a.maxAttempts}
                                </div>

                                <div class="assignment-progress">
                                    <div class="assignment-progress__bar" style="width:${progressPercent > 100 ? 100 : progressPercent}%"></div>
                                </div>

                                <div class="assignment-history-data d-none">
                                    <c:forEach items="${a.history}" var="h">
                                        <div class="history-item"
                                             data-attempt="Attempt ${h.attemptNumber}"
                                             data-started="${empty h.startedAt ? '' : h.startedAt}"
                                             data-submitted="${empty h.submittedAt ? '' : h.submittedAt}"
                                             data-duration="${a.duration} min"
                                             data-mcq-score="${h.mcqScore == null ? 0 : h.mcqScore}"
                                             data-mcq-max="${h.mcqMax == null ? 0 : h.mcqMax}"
                                             
                                             data-essay-score="${h.essayScore == null ? 0 : h.essayScore}"
                                             data-essay-max="${h.essayMax == null ? 0 : h.essayMax}"
                                             data-final-score="${h.finalScore == null ? 0 : h.finalScore}"
                                             data-final-max="${h.finalMax == null ? 0 : h.finalMax}"
                                             data-status="${h.status}">
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="assignment-empty" id="assignmentEmpty">
                        Không có bài kiểm tra nào phù hợp với bộ lọc hiện tại.
                    </div>
                </section>
            </main>
        </div>

        <!-- DETAIL MODAL -->
        <div class="modal-assignment" id="assignmentDetailModal">
            <div class="modal-assignment__dialog">
                <div class="modal-assignment__header">
                    <div>
                        <h2 class="modal-assignment__title" id="detailTitle">Assignment title</h2>
                        <p class="modal-assignment__subtitle">Preview assignment details</p>
                    </div>
                    <button type="button" class="modal-assignment__close" data-close-detail>&times;</button>
                </div>

                <div class="modal-assignment__body">
                    <div class="assignment-detail__chips">
                        <span class="chip" id="detailTypeChip">Mixed</span>
                        <span class="chip" id="detailStatusChip">Open</span>
                    </div>

                    <div class="assignment-detail__grid">
                        <div class="assignment-detail__box">
                            <div class="assignment-detail__label"><i class="bi bi-folder"></i>Class</div>
                            <div class="assignment-detail__value" id="detailClassName"></div>
                        </div>

                        <div class="assignment-detail__box">
                            <div class="assignment-detail__label"><i class="bi bi-clock"></i>Due</div>
                            <div class="assignment-detail__value" id="detailDue"></div>
                        </div>

                        <div class="assignment-detail__box">
                            <div class="assignment-detail__label"><i class="bi bi-hourglass-split"></i>Duration</div>
                            <div class="assignment-detail__value" id="detailDuration"></div>
                        </div>

                        <div class="assignment-detail__box">
                            <div class="assignment-detail__label"><i class="bi bi-arrow-repeat"></i>Max attempts</div>
                            <div class="assignment-detail__value" id="detailMaxAttempts"></div>
                        </div>
                    </div>

                    <div class="assignment-detail__box assignment-detail__desc">
                        <div class="assignment-detail__label"><i class="bi bi-card-text"></i>Description</div>
                        <div class="assignment-detail__value" id="detailDescription"></div>
                    </div>
                </div>

                <div class="modal-assignment__footer">
                    <div id="detailNote" class="assignment-detail__note"></div>

                    <div class="assignment-actions">
                        <button type="button" class="btn-ui btn-ui--muted" id="openHistoryBtn">
                            <i class="bi bi-card-list"></i>Test history
                        </button>

                        <a href="#" class="btn-ui btn-ui--primary" id="detailStartBtn">
                            <i class="bi bi-play-circle"></i>Start
                        </a>

                        <button type="button" class="btn-ui btn-ui--muted" data-close-detail>Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- HISTORY MODAL -->
        <div class="modal-assignment" id="assignmentHistoryModal">
            <div class="modal-assignment__dialog modal-assignment__dialog--history">
                <div class="modal-assignment__header">
                    <div>
                        <h2 class="modal-assignment__title" id="historyTitle">History</h2>
                        <p class="modal-assignment__subtitle">Test history</p>
                    </div>
                    <button type="button" class="modal-assignment__close" data-close-history>&times;</button>
                </div>

                <div class="modal-assignment__body">
                    <div class="history-summary" id="historySummary">Attempts: 0 / 0</div>

                    <div class="history-table-wrap">
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Started</th>
                                    <th>Submitted</th>
                                    <th>Duration</th>
                                    <th>MCQ</th>
                                    <th>Essay</th>
                                    <th>Final</th>
                                    <th>Status</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="historyTableBody"></tbody>
                        </table>
                    </div>

                    <div class="history-footnote">
                        Phần MCQ sẽ có điểm ngay khi nộp. Essay sẽ hiển thị <b>Pending</b> cho đến khi giáo viên chấm.
                        Final = MCQ + Essay.
                    </div>
                </div>

                <div class="modal-assignment__footer">
                    <div></div>
                    <div class="assignment-actions">
                        <button type="button" class="btn-ui btn-ui--muted" data-close-history>Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            (function () {
                const cards = Array.from(document.querySelectorAll('.assignment-card'));
                const searchInput = document.getElementById('assignmentSearch');
                const filterButtons = Array.from(document.querySelectorAll('.assignment-filter'));
                const totalEl = document.getElementById('assignmentTotal');
                const emptyEl = document.getElementById('assignmentEmpty');

                const detailModal = document.getElementById('assignmentDetailModal');
                const historyModal = document.getElementById('assignmentHistoryModal');

                const detailTitle = document.getElementById('detailTitle');
                const detailTypeChip = document.getElementById('detailTypeChip');
                const detailStatusChip = document.getElementById('detailStatusChip');
                const detailClassName = document.getElementById('detailClassName');
                const detailDue = document.getElementById('detailDue');
                const detailDuration = document.getElementById('detailDuration');
                const detailMaxAttempts = document.getElementById('detailMaxAttempts');
                const detailDescription = document.getElementById('detailDescription');
                const detailNote = document.getElementById('detailNote');
                const detailStartBtn = document.getElementById('detailStartBtn');
                const openHistoryBtn = document.getElementById('openHistoryBtn');

                const historyTitle = document.getElementById('historyTitle');
                const historySummary = document.getElementById('historySummary');
                const historyTableBody = document.getElementById('historyTableBody');

                let activeCard = null;
                let currentFilter = 'all';

                function lockPageScroll() {
                    document.body.classList.add('modal-opened');
                }

                function unlockPageScroll() {
                    document.body.classList.remove('modal-opened');
                }

                function applyChipClass(el, value, kind) {
                    el.className = 'chip';

                    if (kind === 'type') {
                        if (value === 'Mixed')
                            el.classList.add('chip--mixed');
                        else if (value === 'MCQ')
                            el.classList.add('chip--mcq');
                        else
                            el.classList.add('chip--essay');
                    } else {
                        if (value === 'Open')
                            el.classList.add('chip--open');
                        else
                            el.classList.add('chip--closed');
                    }
                }

                function formatStatus(status) {
                    const raw = (status || '').toLowerCase();
                    if (raw === 'graded') {
                        return {text: 'Graded', className: 'status-pill status-pill--graded'};
                    }
                    if (raw === 'violated') {
                        return {text: 'Violated', className: 'status-pill status-pill--violated'};
                    }
                    return {text: 'Pending', className: 'status-pill status-pill--pending'};
                }

                function escapeHtml(value) {
                    return String(value || '')
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#39;');
                }

                function renderHistoryRows(card, maxAttempts) {
                    const items = Array.from(card.querySelectorAll('.history-item'));
                    historyTableBody.innerHTML = '';

                    if (!items.length) {
                        historySummary.textContent = 'Attempts: 0 / ' + maxAttempts;
                        historyTableBody.innerHTML =
                                '<tr><td colspan="9" style="text-align:center;color:#64748b;">Chưa có lịch sử làm bài.</td></tr>';
                        return;
                    }

                    items.sort((a, b) => {
                        const aa = parseInt((a.dataset.attempt || '').replace(/\D/g, '')) || 0;
                        const bb = parseInt((b.dataset.attempt || '').replace(/\D/g, '')) || 0;
                        return bb - aa;
                    });

                    items.forEach(item => {
                        const st = formatStatus(item.dataset.status);
                        const mcqScore = item.dataset.mcqScore || '0';
                        const mcqMax = item.dataset.mcqMax || '0';
                        const essayScore = item.dataset.essayScore || '0';
                        const essayMax = item.dataset.essayMax || '0';
                        const finalScore = item.dataset.finalScore || '0';
                        const finalMax = item.dataset.finalMax || '0';

                        const row = document.createElement('tr');
                        row.innerHTML =
                                '<td>' + escapeHtml(item.dataset.attempt) + '</td>' +
                                '<td>' + escapeHtml(item.dataset.started || '') + '</td>' +
                                '<td>' + escapeHtml(item.dataset.submitted || '') + '</td>' +
                                '<td>' + escapeHtml(item.dataset.duration || '') + '</td>' +
                                '<td>' +
                                '   <div class="score-pill">' + escapeHtml(mcqScore) + ' / ' + escapeHtml(mcqMax) + '</div>' +
//                                '   <div class="score-sub">' + escapeHtml(item.dataset.mcqCorrect || '0') + ' / ' + escapeHtml(item.dataset.mcqTotal || '0') + ' correct</div>' +
                                '</td>' +
                                '<td><div class="score-pill">' + escapeHtml(essayScore) + ' / ' + escapeHtml(essayMax) + '</div></td>' +
                                '<td><div class="score-pill">' + escapeHtml(finalScore) + ' / ' + escapeHtml(finalMax) + '</div></td>' +
                                '<td><span class="' + st.className + '">' + st.text + '</span></td>' +
                                '<td><button type="button" class="btn-ui btn-ui--muted" disabled>View</button></td>';

                        historyTableBody.appendChild(row);
                    });

//                    historySummary.textContent = 'Attempts: ' + items.length + ' / ' + maxAttempts;
                }

                function openDetail(card) {
                    activeCard = card;

                    const data = {
                        title: card.dataset.title || '',
                        description: card.dataset.description || '',
                        type: card.dataset.type || '',
                        status: card.dataset.status || '',
                        className: card.dataset.className || '',
                        duration: card.dataset.duration || '',
                        maxAttempts: card.dataset.maxAttempts || '0',
                        usedAttempts: card.dataset.usedAttempts || '0',
                        closeAt: card.dataset.closeAt || '',
                        startUrl: card.dataset.startUrl || '#'
                    };

                    detailTitle.textContent = data.title;
                    detailClassName.textContent = data.className;
                    detailDue.textContent = data.closeAt;
                    detailDuration.textContent = data.duration + ' min';
                    detailMaxAttempts.textContent = data.maxAttempts;
                    detailDescription.textContent = data.description && data.description.trim() ? data.description : 'No description';

                    detailTypeChip.textContent = data.type;
                    detailStatusChip.textContent = data.status;

                    applyChipClass(detailTypeChip, data.type, 'type');
                    applyChipClass(detailStatusChip, data.status, 'status');

                    detailStartBtn.href = data.startUrl;

                    const used = parseInt(data.usedAttempts || '0');
                    const max = parseInt(data.maxAttempts || '0');

                    if (data.status === 'Closed') {
                        detailNote.textContent = 'This assignment is closed. You cannot start a new attempt.';
                        detailNote.className = 'assignment-detail__note assignment-detail__note--danger';
                        detailStartBtn.setAttribute('disabled', 'disabled');
                        detailStartBtn.classList.add('is-disabled');
                        detailStartBtn.removeAttribute('href');
                    } else if (used >= max) {
                        detailNote.textContent = 'You have used all attempts for this assignment.';
                        detailNote.className = 'assignment-detail__note assignment-detail__note--danger';
                        detailStartBtn.setAttribute('disabled', 'disabled');
                        detailStartBtn.classList.add('is-disabled');
                        detailStartBtn.removeAttribute('href');
                    } else {
                        detailNote.textContent = 'Attempts: ' + used + ' / ' + max + '. Review details before you start.';
                        detailNote.className = 'assignment-detail__note';
                        detailStartBtn.removeAttribute('disabled');
                        detailStartBtn.classList.remove('is-disabled');
                        detailStartBtn.href = data.startUrl;
                    }

                    detailModal.classList.add('is-open');
                    lockPageScroll();
                }

                function closeDetail() {
                    detailModal.classList.remove('is-open');
                    if (!historyModal.classList.contains('is-open')) {
                        unlockPageScroll();
                    }
                }

                function openHistory() {
                    if (!activeCard)
                        return;

                    const data = {
                        title: activeCard.dataset.title || '',
                        maxAttempts: activeCard.dataset.maxAttempts || '0'
                    };

                    historyTitle.textContent = data.title;
                    renderHistoryRows(activeCard, data.maxAttempts);

                    historyModal.classList.add('is-open');
                    lockPageScroll();
                }

                function closeHistory() {
                    historyModal.classList.remove('is-open');
                    if (!detailModal.classList.contains('is-open')) {
                        unlockPageScroll();
                    }
                }

                function applyFilter() {
                    const keyword = (searchInput.value || '').trim().toLowerCase();
                    let visible = 0;

                    cards.forEach(card => {
                        const title = card.dataset.searchTitle || '';
                        const className = card.dataset.searchClass || '';
                        const status = card.dataset.filterStatus || '';

                        const matchKeyword = !keyword || title.includes(keyword) || className.includes(keyword);
                        const matchStatus = currentFilter === 'all' || status === currentFilter;

                        const show = matchKeyword && matchStatus;
                        card.style.display = show ? '' : 'none';

                        if (show)
                            visible++;
                    });

                    totalEl.textContent = visible;
                    emptyEl.style.display = visible === 0 ? 'block' : 'none';
                }

                cards.forEach(card => {
                    card.addEventListener('click', function () {
                        openDetail(card);
                    });
                });

                filterButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        filterButtons.forEach(x => x.classList.remove('is-active'));
                        btn.classList.add('is-active');
                        currentFilter = btn.dataset.filter;
                        applyFilter();
                    });
                });

                searchInput.addEventListener('input', applyFilter);

                document.querySelectorAll('[data-close-detail]').forEach(btn => {
                    btn.addEventListener('click', closeDetail);
                });

                document.querySelectorAll('[data-close-history]').forEach(btn => {
                    btn.addEventListener('click', closeHistory);
                });

                openHistoryBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    openHistory();
                });

                detailStartBtn.addEventListener('click', function (e) {
                    if (detailStartBtn.classList.contains('is-disabled')) {
                        e.preventDefault();
                    }
                });

                detailModal.addEventListener('click', function (e) {
                    if (e.target === detailModal)
                        closeDetail();
                });

                historyModal.addEventListener('click', function (e) {
                    if (e.target === historyModal)
                        closeHistory();
                });

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape') {
                        if (historyModal.classList.contains('is-open')) {
                            closeHistory();
                            return;
                        }
                        if (detailModal.classList.contains('is-open')) {
                            closeDetail();
                        }
                    }
                });

                applyFilter();
            })();
        </script>
    </body>
</html>