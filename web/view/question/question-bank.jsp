<%-- 
    Document   : question-bank
    Created on : Mar 20, 2026, 3:10:30 PM
    Author     : tuana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Question Bank - POET</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${ctx}/assets/css/question-bank.css">
    </head>

    <body class="qb-page">
        <div class="qb-shell">

            <header class="qb-hero">
                <div class="qb-hero__inner">
                    <div>
                        <div class="qb-hero__eyebrow">Teacher tools</div>
                        <h1 class="qb-hero__title">Question Bank</h1>
                        <p class="qb-hero__sub">Manage uploaded questions, filter by chapter and subject, and organize your bank for future assignments.</p>
                    </div>

                    <div class="qb-hero__actions">
                        <a href="${ctx}/account/dashboard" class="qb-btn qb-btn--ghost">
                            <i class="bi bi-arrow-left"></i>
                            <span>Back</span>
                        </a>

                        <a href="${ctx}/question/view/add-question" class="qb-btn qb-btn--primary">
                            <i class="bi bi-plus-circle"></i>
                            <span>Add Question</span>
                        </a>
                    </div>
                </div>
            </header>

            <main class="qb-panel">
                <section class="qb-board">

                    <div class="qb-stats">
                        <div class="qb-stat-card">
                            <div class="qb-stat-card__icon"><i class="bi bi-patch-question"></i></div>
                            <div>
                                <div class="qb-stat-card__label">Total questions</div>
                                <div class="qb-stat-card__value" id="statTotal">0</div>
                            </div>
                        </div>

                        <div class="qb-stat-card">
                            <div class="qb-stat-card__icon"><i class="bi bi-eye"></i></div>
                            <div>
                                <div class="qb-stat-card__label">Visible results</div>
                                <div class="qb-stat-card__value" id="statVisible">0</div>
                            </div>
                        </div>

                        <div class="qb-stat-card">
                            <div class="qb-stat-card__icon"><i class="bi bi-journal-bookmark"></i></div>
                            <div>
                                <div class="qb-stat-card__label">Chapters found</div>
                                <div class="qb-stat-card__value" id="statChapterCount">0</div>
                            </div>
                        </div>

                        <div class="qb-stat-card">
                            <div class="qb-stat-card__icon"><i class="bi bi-funnel"></i></div>
                            <div>
                                <div class="qb-stat-card__label">Active filters</div>
                                <div class="qb-stat-card__value" id="statActiveFilters">0</div>
                            </div>
                        </div>
                    </div>

                    <div class="qb-toolbar">
                        <div class="qb-search">
                            <i class="bi bi-search"></i>
                            <input id="searchInput" type="text" placeholder="Search by prompt, chapter, subject, type, or keyword...">
                        </div>

                        <div class="qb-toolbar__right">
                            <div class="qb-select-wrap">
                                <label for="sortSelect">Sort</label>
                                <select id="sortSelect" class="qb-select">
                                    <option value="newest">Newest first</option>
                                    <option value="oldest">Oldest first</option>
                                    <option value="chapter-asc">Chapter ascending</option>
                                    <option value="chapter-desc">Chapter descending</option>
                                    <option value="subject-asc">Subject A → Z</option>
                                    <option value="subject-desc">Subject Z → A</option>
                                    <option value="type-asc">Type A → Z</option>
                                    <option value="type-desc">Type Z → A</option>
                                    <option value="prompt-asc">Prompt A → Z</option>
                                    <option value="prompt-desc">Prompt Z → A</option>
                                </select>
                            </div>

                            <div class="qb-select-wrap">
                                <label for="pageSizeSelect">Per page</label>
                                <select id="pageSizeSelect" class="qb-select">
                                    <option value="6">6</option>
                                    <option value="9" selected>9</option>
                                    <option value="12">12</option>
                                    <option value="18">18</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="qb-filters qb-filters--triple">
                        <div class="qb-filter-box">
                            <div class="qb-filter-box__head">
                                <div class="qb-filter-box__title">
                                    <i class="bi bi-collection"></i>
                                    <span>Chapter filter</span>
                                </div>

                                <div class="qb-filter-box__tools">
                                    <button type="button" class="qb-mini-btn" id="chapterSelectAllBtn">Select all</button>
                                    <button type="button" class="qb-mini-btn" id="chapterClearBtn">Clear</button>
                                </div>
                            </div>

                            <div class="qb-filter-chips" id="chapterFilters"></div>
                        </div>

                        <div class="qb-filter-box">
                            <div class="qb-filter-box__head">
                                <div class="qb-filter-box__title">
                                    <i class="bi bi-book"></i>
                                    <span>Subject filter</span>
                                </div>

                                <div class="qb-filter-box__tools">
                                    <button type="button" class="qb-mini-btn" id="subjectSelectAllBtn">Select all</button>
                                    <button type="button" class="qb-mini-btn" id="subjectClearBtn">Clear</button>
                                </div>
                            </div>

                            <div class="qb-filter-chips" id="subjectFilters"></div>
                        </div>

                        <div class="qb-filter-box">
                            <div class="qb-filter-box__head">
                                <div class="qb-filter-box__title">
                                    <i class="bi bi-sliders"></i>
                                    <span>Question type</span>
                                </div>

                                <div class="qb-filter-box__tools">
                                    <button type="button" class="qb-mini-btn" id="typeResetBtn">Reset</button>
                                </div>
                            </div>

                            <div class="qb-filter-chips">
                                <button type="button" class="qb-chip-filter is-active" data-type-filter="all">All</button>
                                <button type="button" class="qb-chip-filter" data-type-filter="SCQ">SCQ</button>
                                <button type="button" class="qb-chip-filter" data-type-filter="MCQ">MCQ</button>
                                <button type="button" class="qb-chip-filter" data-type-filter="Essay">Essay</button>
                            </div>
                        </div>
                    </div>

                    <div class="qb-results-head">
                        <div class="qb-results-head__left">
                            <div class="qb-results-title">Questions</div>
                            <div class="qb-results-sub" id="resultSummary">Showing 0 results</div>
                        </div>

                        <button type="button" class="qb-btn qb-btn--soft" id="clearAllFiltersBtn">
                            <i class="bi bi-arrow-counterclockwise"></i>
                            <span>Clear all filters</span>
                        </button>
                    </div>

                    <div class="qb-grid" id="questionGrid"></div>

                    <div class="qb-empty" id="emptyState">
                        <div class="qb-empty__icon"><i class="bi bi-search-heart"></i></div>
                        <div class="qb-empty__title">No matching questions</div>
                        <div class="qb-empty__text">Try adjusting your search keyword, selected chapters, selected subjects, or question type.</div>
                    </div>

                    <div class="qb-pagination" id="paginationWrap">
                        <button type="button" class="qb-page-btn" id="prevPageBtn">
                            <i class="bi bi-chevron-left"></i>
                        </button>

                        <div class="qb-page-list" id="pageList"></div>

                        <button type="button" class="qb-page-btn" id="nextPageBtn">
                            <i class="bi bi-chevron-right"></i>
                        </button>
                    </div>
                </section>
            </main>
        </div>

        <!-- Mock data -->
        <div class="qb-seed-list d-none" id="questionSeeds">
            <c:forEach items="${requestScope.listQuestionBank}" var="q" varStatus="loop">
                <div class="qb-seed" data-id="${q.id}" data-prompt="${q.prompt}" data-type="<c:choose><c:when test='${q.type == 1}'>SCQ</c:when><c:when test='${q.type == 2}'>MCQ</c:when><c:when test='${q.type == 3}'>Essay</c:when></c:choose>" data-chapter="${q.chapter}" data-subject="${q.subjectName}" data-created="${q.createdAt}"></div>
            </c:forEach>

            <!--            <div class="qb-seed" data-id="102" data-prompt="Which sentence uses the past perfect tense correctly?" data-type="MCQ" data-chapter="2" data-subject="Tiếng Anh" data-created="2026-03-20 08:20" data-keywords="english grammar tense past perfect"></div>
            -->
        </div>

        <script>
            (function () {
                const seedEls = Array.from(document.querySelectorAll('.qb-seed'));
                const questionGrid = document.getElementById('questionGrid');
                const searchInput = document.getElementById('searchInput');
                const sortSelect = document.getElementById('sortSelect');
                const pageSizeSelect = document.getElementById('pageSizeSelect');
                const chapterFilters = document.getElementById('chapterFilters');
                const subjectFilters = document.getElementById('subjectFilters');
                const emptyState = document.getElementById('emptyState');
                const resultSummary = document.getElementById('resultSummary');
                const paginationWrap = document.getElementById('paginationWrap');
                const pageList = document.getElementById('pageList');
                const prevPageBtn = document.getElementById('prevPageBtn');
                const nextPageBtn = document.getElementById('nextPageBtn');

                const statTotal = document.getElementById('statTotal');
                const statVisible = document.getElementById('statVisible');
                const statChapterCount = document.getElementById('statChapterCount');
                const statActiveFilters = document.getElementById('statActiveFilters');

                const typeButtons = Array.from(document.querySelectorAll('[data-type-filter]'));
                const chapterSelectAllBtn = document.getElementById('chapterSelectAllBtn');
                const chapterClearBtn = document.getElementById('chapterClearBtn');
                const subjectSelectAllBtn = document.getElementById('subjectSelectAllBtn');
                const subjectClearBtn = document.getElementById('subjectClearBtn');
                const typeResetBtn = document.getElementById('typeResetBtn');
                const clearAllFiltersBtn = document.getElementById('clearAllFiltersBtn');

                let selectedType = 'all';
                let selectedChapters = [];
                let selectedSubjects = [];
                let currentPage = 1;

                const allQuestions = seedEls.map(el => ({
                        id: Number(el.dataset.id),
                        prompt: el.dataset.prompt || '',
                        type: el.dataset.type || '',
                        chapter: Number(el.dataset.chapter || 0),
                        subject: el.dataset.subject || '',
                        created: el.dataset.created || '',
                        keywords: el.dataset.keywords || ''
                    }));

                const chapterList = [...new Set(allQuestions.map(q => q.chapter))].sort((a, b) => a - b);
                const subjectList = [...new Set(allQuestions.map(q => q.subject).filter(Boolean))]
                        .sort((a, b) => a.localeCompare(b, 'vi'));

                function escapeHtml(value) {
                    return String(value || '')
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#39;');
                }

                function renderChapterFilters() {
                    chapterFilters.innerHTML = '';

                    chapterList.forEach(chapter => {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'qb-chip-filter';
                        btn.dataset.chapter = chapter;
                        btn.textContent = 'Chapter ' + chapter;

                        btn.addEventListener('click', function () {
                            if (selectedChapters.includes(chapter)) {
                                selectedChapters = selectedChapters.filter(c => c !== chapter);
                                btn.classList.remove('is-active');
                            } else {
                                selectedChapters.push(chapter);
                                btn.classList.add('is-active');
                            }
                            currentPage = 1;
                            render();
                        });

                        chapterFilters.appendChild(btn);
                    });
                }

                function renderSubjectFilters() {
                    subjectFilters.innerHTML = '';

                    subjectList.forEach(subject => {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'qb-chip-filter';
                        btn.dataset.subject = subject;
                        btn.textContent = subject;

                        btn.addEventListener('click', function () {
                            if (selectedSubjects.includes(subject)) {
                                selectedSubjects = selectedSubjects.filter(s => s !== subject);
                                btn.classList.remove('is-active');
                            } else {
                                selectedSubjects.push(subject);
                                btn.classList.add('is-active');
                            }
                            currentPage = 1;
                            render();
                        });

                        subjectFilters.appendChild(btn);
                    });
                }

                function compareValues(a, b, dir) {
                    if (a < b)
                        return dir === 'asc' ? -1 : 1;
                    if (a > b)
                        return dir === 'asc' ? 1 : -1;
                    return 0;
                }

                function getFilteredQuestions() {
                    const keyword = (searchInput.value || '').trim().toLowerCase();

                    let list = allQuestions.filter(q => {
                        const matchKeyword =
                                !keyword ||
                                q.prompt.toLowerCase().includes(keyword) ||
                                q.type.toLowerCase().includes(keyword) ||
                                q.subject.toLowerCase().includes(keyword) ||
                                ('chapter ' + q.chapter).includes(keyword) ||
                                q.keywords.toLowerCase().includes(keyword);

                        const matchType = selectedType === 'all' || q.type === selectedType;
                        const matchChapter = selectedChapters.length === 0 || selectedChapters.includes(q.chapter);
                        const matchSubject = selectedSubjects.length === 0 || selectedSubjects.includes(q.subject);

                        return matchKeyword && matchType && matchChapter && matchSubject;
                    });

                    const sortValue = sortSelect.value;

                    list.sort((a, b) => {
                        switch (sortValue) {
                            case 'oldest':
                                return compareValues(a.created, b.created, 'asc');
                            case 'newest':
                                return compareValues(a.created, b.created, 'desc');
                            case 'chapter-asc':
                                return compareValues(a.chapter, b.chapter, 'asc');
                            case 'chapter-desc':
                                return compareValues(a.chapter, b.chapter, 'desc');
                            case 'subject-asc':
                                return compareValues(a.subject.toLowerCase(), b.subject.toLowerCase(), 'asc');
                            case 'subject-desc':
                                return compareValues(a.subject.toLowerCase(), b.subject.toLowerCase(), 'desc');
                            case 'type-asc':
                                return compareValues(a.type, b.type, 'asc');
                            case 'type-desc':
                                return compareValues(a.type, b.type, 'desc');
                            case 'prompt-asc':
                                return compareValues(a.prompt.toLowerCase(), b.prompt.toLowerCase(), 'asc');
                            case 'prompt-desc':
                                return compareValues(a.prompt.toLowerCase(), b.prompt.toLowerCase(), 'desc');
                            default:
                                return compareValues(a.created, b.created, 'desc');
                        }
                    });

                    return list;
                }

                function getTypeClass(type) {
                    if (type === '1')
                        return 'qb-badge qb-badge--scq';
                    if (type === '2')
                        return 'qb-badge qb-badge--mcq';
                    return 'qb-badge qb-badge--essay';
                }

                function renderCards(list) {
                    questionGrid.innerHTML = '';

                    const pageSize = Number(pageSizeSelect.value || 9);
                    const totalPages = Math.max(1, Math.ceil(list.length / pageSize));

                    if (currentPage > totalPages) {
                        currentPage = totalPages;
                    }

                    const startIndex = (currentPage - 1) * pageSize;
                    const pageItems = list.slice(startIndex, startIndex + pageSize);

                    pageItems.forEach(q => {
                        const card = document.createElement('article');
                        card.className = 'qb-card';
                        card.innerHTML =
                                '<div class="qb-card__topbar"></div>' +
                                '<div class="qb-card__head">' +
                                '   <div class="qb-card__id">#Q' + escapeHtml(q.id) + '</div>' +
                                '   <div class="qb-card__badges">' +
                                '       <span class="' + getTypeClass(q.type) + '">' + escapeHtml(q.type) + '</span>' +
                                '       <span class="qb-badge qb-badge--chapter">Chapter ' + escapeHtml(q.chapter) + '</span>' +
                                '       <span class="qb-badge qb-badge--subject">' + escapeHtml(q.subject) + '</span>' +
                                '   </div>' +
                                '</div>' +
                                '<div class="qb-card__prompt">' + escapeHtml(q.prompt) + '</div>' +
                                '<div class="qb-card__meta">' +
                                '   <span><i class="bi bi-book"></i>' + escapeHtml(q.subject) + '</span>' +
                                '   <span><i class="bi bi-clock-history"></i>' + escapeHtml(q.created) + '</span>' +
                                '</div>' +
                                '<div class="qb-card__keywords">' + escapeHtml(q.keywords) + '</div>' +
                                '<div class="qb-card__footer">' +
                                '   <div class="qb-card__chapter-mark">Question bank item</div>' +
                                '   <button type="button" class="qb-delete-btn" data-id="' + escapeHtml(q.id) + '">' +
                                '       <i class="bi bi-trash3"></i><span>Delete</span>' +
                                '   </button>' +
                                '</div>';

                        questionGrid.appendChild(card);
                    });

                    questionGrid.querySelectorAll('.qb-delete-btn').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const questionId = btn.dataset.id;
                            alert('Delete question #' + questionId + ' (hook backend later)');
                        });
                    });

                    emptyState.style.display = list.length === 0 ? 'flex' : 'none';
                    paginationWrap.style.display = list.length === 0 ? 'none' : 'flex';
                }

                function renderPagination(listLength) {
                    const pageSize = Number(pageSizeSelect.value || 9);
                    const totalPages = Math.max(1, Math.ceil(listLength / pageSize));
                    pageList.innerHTML = '';

                    prevPageBtn.disabled = currentPage <= 1;
                    nextPageBtn.disabled = currentPage >= totalPages;

                    for (let i = 1; i <= totalPages; i++) {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'qb-page-number' + (i === currentPage ? ' is-active' : '');
                        btn.textContent = i;

                        btn.addEventListener('click', function () {
                            currentPage = i;
                            render();
                        });

                        pageList.appendChild(btn);
                    }
                }

                function updateStats(list) {
                    const activeFilters =
                            (selectedType !== 'all' ? 1 : 0) +
                            (selectedChapters.length > 0 ? 1 : 0) +
                            (selectedSubjects.length > 0 ? 1 : 0) +
                            ((searchInput.value || '').trim() ? 1 : 0);

                    statTotal.textContent = allQuestions.length;
                    statVisible.textContent = list.length;
                    statChapterCount.textContent = chapterList.length;
                    statActiveFilters.textContent = activeFilters;

                    resultSummary.textContent =
                            'Showing ' + list.length + ' result' + (list.length === 1 ? '' : 's') +
                            ' across ' + chapterList.length + ' chapter' + (chapterList.length === 1 ? '' : 's') +
                            ' and ' + subjectList.length + ' subject' + (subjectList.length === 1 ? '' : 's') + '.';
                }

                function render() {
                    const list = getFilteredQuestions();
                    updateStats(list);
                    renderCards(list);
                    renderPagination(list.length);
                }

                typeButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        typeButtons.forEach(x => x.classList.remove('is-active'));
                        btn.classList.add('is-active');
                        selectedType = btn.dataset.typeFilter;
                        currentPage = 1;
                        render();
                    });
                });

                searchInput.addEventListener('input', function () {
                    currentPage = 1;
                    render();
                });

                sortSelect.addEventListener('change', function () {
                    currentPage = 1;
                    render();
                });

                pageSizeSelect.addEventListener('change', function () {
                    currentPage = 1;
                    render();
                });

                prevPageBtn.addEventListener('click', function () {
                    if (currentPage > 1) {
                        currentPage--;
                        render();
                    }
                });

                nextPageBtn.addEventListener('click', function () {
                    const pageSize = Number(pageSizeSelect.value || 9);
                    const totalPages = Math.max(1, Math.ceil(getFilteredQuestions().length / pageSize));
                    if (currentPage < totalPages) {
                        currentPage++;
                        render();
                    }
                });

                chapterSelectAllBtn.addEventListener('click', function () {
                    selectedChapters = [...chapterList];
                    chapterFilters.querySelectorAll('.qb-chip-filter').forEach(btn => btn.classList.add('is-active'));
                    currentPage = 1;
                    render();
                });

                chapterClearBtn.addEventListener('click', function () {
                    selectedChapters = [];
                    chapterFilters.querySelectorAll('.qb-chip-filter').forEach(btn => btn.classList.remove('is-active'));
                    currentPage = 1;
                    render();
                });

                subjectSelectAllBtn.addEventListener('click', function () {
                    selectedSubjects = [...subjectList];
                    subjectFilters.querySelectorAll('.qb-chip-filter').forEach(btn => btn.classList.add('is-active'));
                    currentPage = 1;
                    render();
                });

                subjectClearBtn.addEventListener('click', function () {
                    selectedSubjects = [];
                    subjectFilters.querySelectorAll('.qb-chip-filter').forEach(btn => btn.classList.remove('is-active'));
                    currentPage = 1;
                    render();
                });

                typeResetBtn.addEventListener('click', function () {
                    selectedType = 'all';
                    typeButtons.forEach(btn => {
                        btn.classList.toggle('is-active', btn.dataset.typeFilter === 'all');
                    });
                    currentPage = 1;
                    render();
                });

                clearAllFiltersBtn.addEventListener('click', function () {
                    searchInput.value = '';
                    selectedType = 'all';
                    selectedChapters = [];
                    selectedSubjects = [];
                    sortSelect.value = 'newest';
                    pageSizeSelect.value = '9';

                    typeButtons.forEach(btn => {
                        btn.classList.toggle('is-active', btn.dataset.typeFilter === 'all');
                    });

                    chapterFilters.querySelectorAll('.qb-chip-filter').forEach(btn => btn.classList.remove('is-active'));
                    subjectFilters.querySelectorAll('.qb-chip-filter').forEach(btn => btn.classList.remove('is-active'));

                    currentPage = 1;
                    render();
                });

                renderChapterFilters();
                renderSubjectFilters();
                render();
            })();
        </script>
    </body>
</html>
