<%-- 
    Document   : list-assignment
    Created on : Mar 16, 2026, 5:49:00 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create Assignment - POET</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${ctx}/assets/css/create-assignment.css">
    </head>

    <body class="ca-page">
        <div class="ca-shell">

            <header class="ca-hero">
                <div class="ca-hero__inner">
                    <div>
                        <div class="ca-hero__eyebrow">Teacher tools</div>
                        <h1 class="ca-hero__title">Create Assignment</h1>
                        <p class="ca-hero__sub">Build an assignment from your question bank using Auto mode or Manual mode.</p>
                    </div>

                    <a href="${ctx}/account/dashboard" class="ca-btn ca-btn--ghost">
                        <i class="bi bi-arrow-left"></i>
                        <span>Back</span>
                    </a>
                </div>
            </header>

            <main class="ca-panel">
                <div class="ca-mode-switch">
                    <button type="button" class="ca-mode-btn is-active" data-mode="auto">Auto Mode</button>
                    <button type="button" class="ca-mode-btn" data-mode="manual">Manual Mode</button>
                </div>

                <div class="ca-layout">
                    <section class="ca-board">
                        <form id="assignmentForm" action="#" method="post">
                            <input type="hidden" id="activeMode" value="auto">

                            <!-- Assignment details -->
                            <div class="ca-section">
                                <div class="ca-section__head">
                                    <div class="ca-section__title">
                                        <i class="bi bi-journal-text"></i>
                                        <span>Assignment Details</span>
                                    </div>
                                </div>

                                <div class="ca-grid ca-grid--2">
                                    <div class="ca-field">
                                        <label for="assignmentTitle">Assignment Title</label>
                                        <input id="assignmentTitle" name="title" class="ca-control" type="text" placeholder="Enter assignment title">
                                        <input type="text" name="classId" value="${requestScope.classId}" hidden readonly>
                                    </div>
                                    <div class="ca-field">
                                        <label for="assignmentTitle">Assignment Description</label>
                                        <input id="assignmentTitle" name="description" class="ca-control" type="text" placeholder="Enter assignment description">
                                    </div>
                                    <div class="ca-field">
                                        <label for="subjectReadonly">Subject</label>
                                        <input id="subjectReadonly" class="ca-control" type="text" value="${subject.name}" readonly>

                                    </div>

                                    <div class="ca-field">
                                        <label for="totalPoints">Total Points (1 - 100)</label>
                                        <input id="totalPoints" class="ca-control" name="maxPoint" type="number" min="1" max="100" value="100">
                                    </div>

                                    <div class="ca-field">
                                        <label for="attemptCount">Number of Attempts</label>
                                        <input id="attemptCount" name="maxAttempts" class="ca-control" type="number" min="1" value="1">
                                    </div>

                                    <div class="ca-field">
                                        <label for="openTime">Open Time</label>
                                        <input id="openTime" name="openAt" class="ca-control" type="datetime-local">
                                    </div>

                                    <div class="ca-field">
                                        <label for="closeTime">Close Time</label>
                                        <input id="closeTime" name="closeAt" class="ca-control" type="datetime-local">
                                    </div>

                                    <div class="ca-field">
                                        <label for="durationMinutes">Duration (minutes)</label>
                                        <input id="durationMinutes" name="durationMinutes" class="ca-control" type="number" min="1" value="45">
                                    </div>
                                </div>
                            </div>

                            <!-- AUTO MODE -->
                            <div class="ca-mode-panel" id="autoModePanel">
                                <div class="ca-section">
                                    <div class="ca-section__head">
                                        <div class="ca-section__title">
                                            <i class="bi bi-magic"></i>
                                            <span>Auto Question Groups</span>
                                        </div>

                                        <button type="button" class="ca-btn ca-btn--soft" id="addAutoGroupBtn">
                                            <i class="bi bi-plus-circle"></i>
                                            <span>Add Question Group</span>
                                        </button>
                                    </div>

                                    <div id="autoGroupsWrap" class="ca-auto-groups"></div>

                                    <div class="ca-hint-box">
                                        Each group is unique by <b>Question Type + Chapter Set</b>. Groups with exactly the same type and same selected chapters are not allowed.
                                    </div>
                                </div>
                            </div>

                            <!-- MANUAL MODE -->
                            <div class="ca-mode-panel is-hidden" id="manualModePanel">
                                <div class="ca-section">
                                    <div class="ca-section__head">
                                        <div class="ca-section__title">
                                            <i class="bi bi-funnel"></i>
                                            <span>Manual Filters</span>
                                        </div>
                                    </div>

                                    <div class="ca-grid ca-grid--3">
                                        <div class="ca-field">
                                            <label for="manualType">Question Type</label>
                                            <select id="manualType" name="typeQuestionGroupManual" class="ca-control">
                                                <option value="all">All</option>
                                                <option value="SCQ">SCQ</option>
                                                <option value="MCQ">MCQ</option>
                                                <option value="Essay">Essay</option>
                                            </select>
                                        </div>

                                        <div class="ca-field">
                                            <div class="ca-chapter-box__head">
                                                <label>Chapter Filter</label>
                                                <button type="button" class="ca-chapter-toggle" id="manualChapterToggle">Expand</button>
                                            </div>
                                            <div class="ca-chip-filter-wrap ca-group-chapters ca-group-chapters--limited" id="manualChapterFilters"></div>
                                        </div>

                                        <div class="ca-field">
                                            <label for="manualSearch">Search</label>
                                            <input id="manualSearch" class="ca-control" type="text" placeholder="Search question content...">
                                        </div>
                                    </div>
                                </div>

                                <div class="ca-section">
                                    <div class="ca-section__head">
                                        <div class="ca-section__title">
                                            <i class="bi bi-check2-square"></i>
                                            <span>Selected Questions</span>
                                        </div>
                                    </div>

                                    <div id="manualSelectedWrap" class="ca-selected-list">
                                        <div class="ca-empty-inline">No questions selected yet.</div>
                                    </div>
                                </div>

                                <div class="ca-section">
                                    <div class="ca-section__head">
                                        <div class="ca-section__title">
                                            <i class="bi bi-collection"></i>
                                            <span>Question Bank Results</span>
                                        </div>
                                    </div>

                                    <div id="manualQuestionList" class="ca-question-list"></div>
                                </div>
                            </div>

                            <div class="ca-form-error" id="formErrorBox"></div>

                            <div class="ca-actions">
                                <a href="${ctx}/account/dashboard" class="ca-btn ca-btn--soft">Cancel</a>
                                <button type="button" class="ca-btn ca-btn--primary" id="createAssignmentBtn">
                                    <i class="bi bi-check2-circle"></i>
                                    <span>Create Assignment</span>
                                </button>
                            </div>
                        </form>
                    </section>

                    <!-- Sidebar -->
                    <aside class="ca-side">
                        <div class="ca-side-card ca-side-card--highlight">
                            <div class="ca-side-card__title">
                                <i class="bi bi-calculator"></i>
                                Points Summary
                            </div>

                            <div class="ca-points-widget">
                                <div class="ca-points-widget__top">
                                    <div class="ca-points-stat">
                                        <span>Current Total</span>
                                        <strong id="summaryCurrentPoints">0</strong>
                                    </div>

                                    <div class="ca-points-stat">
                                        <span>Max Points</span>
                                        <strong id="summaryMaxPoints">100</strong>
                                    </div>
                                </div>

                                <div class="ca-points-progress">
                                    <div class="ca-points-progress__track">
                                        <div class="ca-points-progress__bar" id="summaryProgressBar" style="width:0%"></div>
                                    </div>
                                    <div class="ca-points-progress__label" id="summaryProgressLabel">0%</div>
                                </div>

                                <div class="ca-summary-status" id="summaryStatusBox">
                                    Waiting for input
                                </div>
                            </div>
                        </div>

                        <div class="ca-side-card">
                            <div class="ca-side-card__title">
                                <i class="bi bi-list-stars"></i>
                                Selection Summary
                            </div>

                            <div class="ca-summary-list">
                                <div class="ca-summary-row">
                                    <span>Mode</span>
                                    <strong id="summaryMode">Auto</strong>
                                </div>
                                <div class="ca-summary-row">
                                    <span>Question Groups</span>
                                    <strong id="summaryGroupCount">0</strong>
                                </div>
                                <div class="ca-summary-row">
                                    <span>Selected Questions</span>
                                    <strong id="summarySelectedQuestions">0</strong>
                                </div>
                                <div class="ca-summary-row">
                                    <span>Estimated Questions</span>
                                    <strong id="summaryEstimatedQuestions">0</strong>
                                </div>
                            </div>
                        </div>

                        <div class="ca-side-card">
                            <div class="ca-side-card__title">
                                <i class="bi bi-info-circle"></i>
                                Validation Rules
                            </div>

                            <ul class="ca-rules">
                                <li>Title is required.</li>
                                <li>Total points must be between 1 and 100.</li>
                                <li>Close time must be later than open time.</li>
                                <li>Attempts and duration must be greater than 0.</li>
                                <li>Total configured points must equal max points before creation.</li>
                                <li>Auto groups cannot duplicate the same type + exact same chapter set.</li>
                            </ul>
                        </div>
                    </aside>
                </div>
            </main>
        </div>

        <!-- MOCK QUESTION BANK for current subject -->
        <div class="d-none" id="questionSeeds">
            <c:forEach items="${listQuestion}" var="question">
                <div class="ca-seed" data-id="${question.id}" 
                     data-type="
                     <c:choose>
                         <c:when test='${question.type == 1}'>SCQ</c:when>
                         <c:when test='${question.type == 2}'>MCQ</c:when>
                         <c:when test='${question.type == 3}'>Essay</c:when>
                     </c:choose>
                     "
                     data-chapter="${question.chapter}" data-subject="${subject.name}" data-prompt="${question.prompt}"></div>
            </c:forEach>
<!--            <div class="ca-seed" data-id="202" data-type="MCQ" data-chapter="1" data-subject="${subject.name}" data-prompt="Select all countable nouns in the list."></div>
            <div class="ca-seed" data-id="203" data-type="Essay" data-chapter="1" data-subject="${subject.name}" data-prompt="Write a short paragraph about your best friend."></div>
            <div class="ca-seed" data-id="204" data-type="SCQ" data-chapter="2" data-subject="${subject.name}" data-prompt="Choose the correct passive voice sentence."></div>
            <div class="ca-seed" data-id="205" data-type="MCQ" data-chapter="2" data-subject="${subject.name}" data-prompt="Select all correct relative pronouns for the blanks."></div>
            <div class="ca-seed" data-id="206" data-type="Essay" data-chapter="2" data-subject="Tiếng Anh" data-prompt="Explain the structure of a formal email."></div>
            <div class="ca-seed" data-id="207" data-type="SCQ" data-chapter="3" data-subject="Tiếng Anh" data-prompt="Choose the best title for the reading passage."></div>
            <div class="ca-seed" data-id="208" data-type="MCQ" data-chapter="3" data-subject="Tiếng Anh" data-prompt="Select the statements that are true according to the passage."></div>
            <div class="ca-seed" data-id="210" data-type="SCQ" data-chapter="4" data-subject="Tiếng Anh" data-prompt="Choose the correctly punctuated sentence."></div>
            <div class="ca-seed" data-id="211" data-type="MCQ" data-chapter="4" data-subject="Tiếng Anh" data-prompt="Select all topic sentences suitable for the paragraph."></div>
            <div class="ca-seed" data-id="212" data-type="Essay" data-chapter="4" data-subject="Tiếng Anh" data-prompt="Write an opinion paragraph about school uniforms."></div>
            <div class="ca-seed" data-id="213" data-type="SCQ" data-chapter="5" data-subject="Tiếng Anh" data-prompt="Choose the word with the different stress pattern."></div>
            <div class="ca-seed" data-id="214" data-type="MCQ" data-chapter="5" data-subject="Tiếng Anh" data-prompt="Select all transition signals for contrast."></div>
            <div class="ca-seed" data-id="215" data-type="Essay" data-chapter="5" data-subject="Tiếng Anh" data-prompt="Write a letter inviting your friend to a birthday party."></div>-->
        </div>

        <script>
            (function () {
                const modeButtons = Array.from(document.querySelectorAll('.ca-mode-btn'));
                const activeModeInput = document.getElementById('activeMode');
                const autoModePanel = document.getElementById('autoModePanel');
                const manualModePanel = document.getElementById('manualModePanel');

                const assignmentTitle = document.getElementById('assignmentTitle');
                const totalPoints = document.getElementById('totalPoints');
                const attemptCount = document.getElementById('attemptCount');
                const openTime = document.getElementById('openTime');
                const closeTime = document.getElementById('closeTime');
                const durationMinutes = document.getElementById('durationMinutes');

                const addAutoGroupBtn = document.getElementById('addAutoGroupBtn');
                const autoGroupsWrap = document.getElementById('autoGroupsWrap');

                const manualType = document.getElementById('manualType');
                const manualSearch = document.getElementById('manualSearch');
                const manualChapterFilters = document.getElementById('manualChapterFilters');
                const manualSelectedWrap = document.getElementById('manualSelectedWrap');
                const manualQuestionList = document.getElementById('manualQuestionList');
                const manualChapterToggle = document.getElementById('manualChapterToggle');

                const summaryCurrentPoints = document.getElementById('summaryCurrentPoints');
                const summaryMaxPoints = document.getElementById('summaryMaxPoints');
                const summaryStatusBox = document.getElementById('summaryStatusBox');
                const summaryMode = document.getElementById('summaryMode');
                const summaryGroupCount = document.getElementById('summaryGroupCount');
                const summarySelectedQuestions = document.getElementById('summarySelectedQuestions');
                const summaryEstimatedQuestions = document.getElementById('summaryEstimatedQuestions');

                const formErrorBox = document.getElementById('formErrorBox');
                const createAssignmentBtn = document.getElementById('createAssignmentBtn');

                const seeds = Array.from(document.querySelectorAll('.ca-seed')).map(el => ({
                        id: Number(el.dataset.id),
                        type: el.dataset.type,
                        chapter: Number(el.dataset.chapter),
                        subject: el.dataset.subject,
                        prompt: el.dataset.prompt
                    }));

                const currentSubject = document.getElementById('subjectReadonly').value;
                const subjectQuestions = seeds.filter(q => q.subject === currentSubject);
                const chapterList = [...new Set(subjectQuestions.map(q => q.chapter))].sort((a, b) => a - b);

                let autoGroupCounter = 0;
                let selectedManualQuestionIds = [];
                let manualSelectedChapters = [];

                function escapeHtml(value) {
                    return String(value || '')
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#39;');
                }

                function setMode(mode) {
                    activeModeInput.value = mode;
                    modeButtons.forEach(btn => btn.classList.toggle('is-active', btn.dataset.mode === mode));
                    autoModePanel.classList.toggle('is-hidden', mode !== 'auto');
                    manualModePanel.classList.toggle('is-hidden', mode !== 'manual');
                    summaryMode.textContent = mode === 'auto' ? 'Auto' : 'Manual';
                    updateSummary();
                    validateForm(false);
                }

                modeButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        setMode(btn.dataset.mode);
                    });
                });

                function buildChapterChips(container, selectedArray, onChange) {
                    container.innerHTML = '';
                    chapterList.forEach(ch => {
                        const btn = document.createElement('button');
                        btn.type = 'button';
                        btn.className = 'ca-chip-filter' + (selectedArray.includes(ch) ? ' is-active' : '');
                        btn.textContent = 'Chapter ' + ch;
                        btn.addEventListener('click', function () {
                            if (selectedArray.includes(ch)) {
                                selectedArray.splice(selectedArray.indexOf(ch), 1);
                            } else {
                                selectedArray.push(ch);
                            }
                            onChange();
                        });
                        container.appendChild(btn);
                    });
                }

                function createAutoGroup(initial) {
                    autoGroupCounter++;
                    const groupId = autoGroupCounter;

                    const wrapper = document.createElement('div');
                    wrapper.className = 'ca-auto-group';
                    wrapper.dataset.groupId = groupId;
                    wrapper.dataset.selectedChapters = '';

                    wrapper.innerHTML =
                            '<input type="hidden" class="ca-group-chapters-hidden" name="chapterQuestionGroup">' +
                            '<div class="ca-auto-group__head">' +
                            '   <div class="ca-auto-group__title">Question Group #' + groupId + '</div>' +
                            '   <button type="button" class="ca-remove-btn">Remove</button>' +
                            '</div>' +
                            '<div class="ca-grid ca-grid--4">' +
                            '   <div class="ca-field">' +
                            '       <label>Question Type</label>' +
                            '       <select name="typeQuestionGroup" class="ca-control ca-group-type">' +
                            '           <option value="">Select type</option>' +
                            '           <option value="1">SCQ</option>' +
                            '           <option value="2">MCQ</option>' +
                            '           <option value="3">Essay</option>' +
                            '       </select>' +
                            '   </div>' +
                            '   <div class="ca-field">' +
                            '       <label>Number of Questions</label>' +
                            '       <input name="numberQuestionGroup" class="ca-control ca-group-count" type="number" min="1" value="">' +
                            '   </div>' +
                            '   <div class="ca-field">' +
                            '       <label>Points per Question</label>' +
                            '       <input name="pointPerQuestion" class="ca-control ca-group-points" type="number" min="1" value="">' +
                            '   </div>' +
                            '   <div class="ca-field">' +
                            '       <label>Estimated Matched</label>' +
                            '       <input class="ca-control ca-group-match" type="text" value="0" readonly>' +
                            '   </div>' +
                            '</div>' +
                            '<div class="ca-field ca-field--full">' +
                            '   <div class="ca-chapter-box__head">' +
                            '       <label>Select Chapters</label>' +
                            '       <button type="button" class="ca-chapter-toggle">Expand</button>' +
                            '   </div>' +
                            '   <div class="ca-chip-filter-wrap ca-group-chapters ca-group-chapters--limited"></div>' +
                            '</div>' +
                            '<div class="ca-group-summary">Waiting for configuration.</div>';

                    autoGroupsWrap.appendChild(wrapper);

                    const typeEl = wrapper.querySelector('.ca-group-type');
                    const countEl = wrapper.querySelector('.ca-group-count');
                    const pointsEl = wrapper.querySelector('.ca-group-points');
                    const matchEl = wrapper.querySelector('.ca-group-match');
                    const chapterWrap = wrapper.querySelector('.ca-group-chapters');
                    const summaryEl = wrapper.querySelector('.ca-group-summary');
                    const chapterToggleBtn = wrapper.querySelector('.ca-chapter-toggle');

                    const selectedChapters = [];

                    function updateGroup() {
                        const hiddenInput = wrapper.querySelector('.ca-group-chapters-hidden');
                        hiddenInput.value = selectedChapters.join(',');
                        wrapper.dataset.selectedChapters = selectedChapters.slice().sort((a, b) => a - b).join(',');

                        const type = typeEl.value;
                        const count = Number(countEl.value || 0);
                        const pts = Number(pointsEl.value || 0);

                        const matched = subjectQuestions.filter(q => {
                            const typeOk = !type || q.type === type;
                            const chapterOk = selectedChapters.length === 0 || selectedChapters.includes(q.chapter);
                            return typeOk && chapterOk;
                        }).length;

                        matchEl.value = matched;

                        if (type && count > 0 && pts > 0 && selectedChapters.length > 0) {
                            summaryEl.innerHTML = count + ' question(s) × ' + pts + ' point(s) = <b>' + (count * pts) + ' pts</b>';
                        } else {
                            summaryEl.textContent = 'Waiting for configuration.';
                        }

                        updateSummary();
                        validateForm(false);
                    }

                    chapterToggleBtn.addEventListener('click', function () {
                        const expanded = chapterWrap.classList.toggle('is-expanded');
                        chapterToggleBtn.textContent = expanded ? 'Collapse' : 'Expand';
                    });

                    buildChapterChips(chapterWrap, selectedChapters, function () {
                        buildChapterChips(chapterWrap, selectedChapters, arguments.callee);
                        updateGroup();
                    });

                    typeEl.addEventListener('change', updateGroup);
                    countEl.addEventListener('input', updateGroup);
                    pointsEl.addEventListener('input', updateGroup);

                    wrapper.querySelector('.ca-remove-btn').addEventListener('click', function () {
                        wrapper.remove();
                        updateSummary();
                        validateForm(false);
                    });

                    if (initial) {
                        typeEl.value = initial.type || '';
                        countEl.value = initial.count || '';
                        pointsEl.value = initial.points || '';
                        (initial.chapters || []).forEach(ch => selectedChapters.push(ch));
                        buildChapterChips(chapterWrap, selectedChapters, function () {
                            buildChapterChips(chapterWrap, selectedChapters, arguments.callee);
                            updateGroup();
                        });
                        updateGroup();
                    }
                    updateGroup()
                    return wrapper;
                }

                addAutoGroupBtn.addEventListener('click', function () {
                    createAutoGroup();
                });

                function getAutoGroupsData() {
                    return Array.from(autoGroupsWrap.querySelectorAll('.ca-auto-group')).map(group => {
                        return {
                            id: group.dataset.groupId,
                            type: group.querySelector('.ca-group-type').value,
                            count: Number(group.querySelector('.ca-group-count').value || 0),
                            points: Number(group.querySelector('.ca-group-points').value || 0),
                            chapters: (group.dataset.selectedChapters || '')
                                    .split(',')
                                    .filter(Boolean)
                                    .map(Number)
                                    .sort((a, b) => a - b)
                        };
                    });
                }

                function renderManualChapterFilters() {
                    buildChapterChips(manualChapterFilters, manualSelectedChapters, function () {
                        renderManualChapterFilters();
                        renderManualQuestionArea();
                        updateSummary();
                        validateForm(false);
                    });
                }

                function getManualFilteredQuestions() {
                    const type = manualType.value;
                    const keyword = (manualSearch.value || '').trim().toLowerCase();

                    return subjectQuestions.filter(q => {
                        const typeOk = type === 'all' || q.type === type;
                        const chapterOk = manualSelectedChapters.length === 0 || manualSelectedChapters.includes(q.chapter);
                        const searchOk = !keyword || q.prompt.toLowerCase().includes(keyword);
                        return typeOk && chapterOk && searchOk;
                    });
                }

                function getSelectedManualQuestions() {
                    return subjectQuestions
                            .filter(q => selectedManualQuestionIds.includes(q.id))
                            .map(q => {
                                const pointsInput = document.querySelector('.ca-manual-point[data-question-id="' + q.id + '"]');
                                return {
                                    ...q,
                                    points: Number(pointsInput ? pointsInput.value || 0 : 0)
                                };
                            });
                }

                function renderManualSelected() {
                    const selected = getSelectedManualQuestions();

                    if (!selected.length) {
                        manualSelectedWrap.innerHTML = '<div class="ca-empty-inline">No questions selected yet.</div>';
                        return;
                    }

                    manualSelectedWrap.innerHTML = selected.map(q =>
                        '<div class="ca-selected-card">' +
                                '   <div class="ca-selected-card__main">' +
                                '       <div class="ca-selected-card__title">' + escapeHtml(q.prompt) + '</div>' +
                                '       <div class="ca-selected-card__meta">' +
                                '           <span class="ca-mini-badge">' + escapeHtml(q.type) + '</span>' +
                                '           <span>Chapter ' + q.chapter + '</span>' +
                                '       </div>' +
                                '   </div>' +
                                '   <div class="ca-selected-card__side">' +
                                '       <label>Points</label>' +
                                '       <input class="ca-control ca-manual-point" data-question-id="' + q.id + '" type="number" min="1" value="' + (q.points || '') + '">' +
                                '       <button type="button" class="ca-icon-btn" data-remove-question="' + q.id + '">' +
                                '           <i class="bi bi-trash3"></i>' +
                                '       </button>' +
                                '   </div>' +
                                '</div>'
                    ).join('');

                    manualSelectedWrap.querySelectorAll('.ca-manual-point').forEach(input => {
                        input.addEventListener('input', function () {
                            updateSummary();
                            validateForm(false);
                        });
                    });

                    manualSelectedWrap.querySelectorAll('[data-remove-question]').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const id = Number(btn.dataset.removeQuestion);
                            selectedManualQuestionIds = selectedManualQuestionIds.filter(x => x !== id);
                            renderManualSelected();
                            renderManualQuestionArea();
                            updateSummary();
                            validateForm(false);
                        });
                    });
                }

                function renderManualQuestionArea() {
                    const list = getManualFilteredQuestions();

                    if (!list.length) {
                        manualQuestionList.innerHTML = '<div class="ca-empty-inline">No matching questions found.</div>';
                        return;
                    }

                    manualQuestionList.innerHTML = list.map(q => {
                        const checked = selectedManualQuestionIds.includes(q.id);
                        return '<label class="ca-question-card">' +
                                '   <div class="ca-question-card__left">' +
                                '       <input type="checkbox" class="ca-question-check" data-question-id="' + q.id + '"' + (checked ? ' checked' : '') + '>' +
                                '   </div>' +
                                '   <div class="ca-question-card__main">' +
                                '       <div class="ca-question-card__title">' + escapeHtml(q.prompt) + '</div>' +
                                '       <div class="ca-question-card__meta">' +
                                '           <span class="ca-mini-badge">' + escapeHtml(q.type) + '</span>' +
                                '           <span>Chapter ' + q.chapter + '</span>' +
                                '       </div>' +
                                '   </div>' +
                                '   <div class="ca-question-card__side">' +
                                '       <div class="ca-question-card__side-label">Points</div>' +
                                '       <input class="ca-control ca-manual-point-inline" data-inline-question-id="' + q.id + '" type="number" min="1" value="">' +
                                '   </div>' +
                                '</label>';
                    }).join('');

                    manualQuestionList.querySelectorAll('.ca-question-check').forEach(chk => {
                        chk.addEventListener('change', function () {
                            const id = Number(chk.dataset.questionId);
                            if (chk.checked) {
                                if (!selectedManualQuestionIds.includes(id)) {
                                    selectedManualQuestionIds.push(id);
                                }
                            } else {
                                selectedManualQuestionIds = selectedManualQuestionIds.filter(x => x !== id);
                            }
                            renderManualSelected();
                            renderManualQuestionArea();
                            updateSummary();
                            validateForm(false);
                        });
                    });

                    manualQuestionList.querySelectorAll('.ca-manual-point-inline').forEach(input => {
                        const id = Number(input.dataset.inlineQuestionId);
                        const selectedInput = document.querySelector('.ca-manual-point[data-question-id="' + id + '"]');
                        if (selectedInput) {
                            input.value = selectedInput.value;
                        }

                        input.addEventListener('input', function () {
                            const target = document.querySelector('.ca-manual-point[data-question-id="' + id + '"]');
                            if (target) {
                                target.value = input.value;
                            }
                            updateSummary();
                            validateForm(false);
                        });
                    });
                }

                manualType.addEventListener('change', function () {
                    renderManualQuestionArea();
                });

                manualSearch.addEventListener('input', function () {
                    renderManualQuestionArea();
                });

                manualChapterToggle.addEventListener('click', function () {
                    const expanded = manualChapterFilters.classList.toggle('is-expanded');
                    manualChapterToggle.textContent = expanded ? 'Collapse' : 'Expand';
                });

                function getCurrentConfiguredPoints() {
                    const mode = activeModeInput.value;

                    if (mode === 'auto') {
                        return getAutoGroupsData().reduce((sum, g) => sum + (g.count * g.points), 0);
                    }

                    return getSelectedManualQuestions().reduce((sum, q) => sum + q.points, 0);
                }

                function getEstimatedQuestionCount() {
                    const mode = activeModeInput.value;

                    if (mode === 'auto') {
                        return getAutoGroupsData().reduce((sum, g) => sum + g.count, 0);
                    }

                    return getSelectedManualQuestions().length;
                }

                function updateSummary() {
                    const maxPoints = Number(totalPoints.value || 0);
                    const current = getCurrentConfiguredPoints();
                    const mode = activeModeInput.value;
                    const summaryProgressBar = document.getElementById('summaryProgressBar');
                    const summaryProgressLabel = document.getElementById('summaryProgressLabel');

                    summaryCurrentPoints.textContent = current;
                    summaryMaxPoints.textContent = maxPoints || 0;
                    summaryGroupCount.textContent = mode === 'auto' ? getAutoGroupsData().length : 0;
                    summarySelectedQuestions.textContent = mode === 'manual' ? getSelectedManualQuestions().length : 0;
                    summaryEstimatedQuestions.textContent = getEstimatedQuestionCount();

                    let percent = 0;
                    if (maxPoints > 0) {
                        percent = Math.round((current / maxPoints) * 100);
                    }
                    if (percent < 0)
                        percent = 0;
                    if (percent > 100)
                        percent = 100;

                    summaryProgressBar.style.width = percent + '%';
                    summaryProgressLabel.textContent = percent + '%';

                    summaryProgressBar.classList.remove('is-ok', 'is-warn', 'is-error');

                    if (!maxPoints || current === 0) {
                        // default
                    } else if (current === maxPoints) {
                        summaryProgressBar.classList.add('is-ok');
                    } else if (current < maxPoints) {
                        summaryProgressBar.classList.add('is-warn');
                    } else {
                        summaryProgressBar.classList.add('is-error');
                    }
                }

                function validateForm(showError) {
                    const errors = [];
                    const mode = activeModeInput.value;
                    const title = assignmentTitle.value.trim();
                    const maxPoints = Number(totalPoints.value || 0);
                    const attempts = Number(attemptCount.value || 0);
                    const duration = Number(durationMinutes.value || 0);
                    const open = openTime.value;
                    const close = closeTime.value;
                    const configuredPoints = getCurrentConfiguredPoints();

                    if (!title) {
                        errors.push('Assignment title is required.');
                    }

                    if (!maxPoints || maxPoints < 1 || maxPoints > 100) {
                        errors.push('Total points must be between 1 and 100.');
                    }

                    if (!attempts || attempts < 1) {
                        errors.push('Number of attempts must be greater than 0.');
                    }

                    if (!duration || duration < 1) {
                        errors.push('Duration must be greater than 0.');
                    }

                    if (!open || !close) {
                        errors.push('Open time and close time are required.');
                    } else if (new Date(close).getTime() <= new Date(open).getTime()) {
                        errors.push('Close time must be later than open time.');
                    }

                    if (mode === 'auto') {
                        const groups = getAutoGroupsData();

                        if (!groups.length) {
                            errors.push('At least one auto question group is required.');
                        }

                        groups.forEach((g, idx) => {
                            if (!g.type)
                                errors.push('Group #' + (idx + 1) + ': question type is required.');
                            if (!g.chapters.length)
                                errors.push('Group #' + (idx + 1) + ': choose at least one chapter.');
                            if (!g.count || g.count < 1)
                                errors.push('Group #' + (idx + 1) + ': number of questions must be greater than 0.');
                            if (!g.points || g.points < 1)
                                errors.push('Group #' + (idx + 1) + ': points per question must be greater than 0.');
                        });

                        const signatures = groups.map(g => g.type + '|' + g.chapters.join(','));
                        const duplicateExists = signatures.some((sig, idx) => signatures.indexOf(sig) !== idx);
                        if (duplicateExists) {
                            errors.push('Auto groups cannot have the same exact type and same exact chapter set.');
                        }
                    } else {
                        const selected = getSelectedManualQuestions();

                        if (!selected.length) {
                            errors.push('Choose at least one question in Manual mode.');
                        }

                        selected.forEach(q => {
                            if (!q.points || q.points < 1) {
                                errors.push('Each selected manual question must have points greater than 0.');
                            }
                        });
                    }

                    if (maxPoints && configuredPoints !== maxPoints) {
                        errors.push('Configured question points must exactly equal total points.');
                    }

                    if (showError) {
                        if (errors.length) {
                            formErrorBox.style.display = 'block';
                            formErrorBox.innerHTML = errors.map(e => '<div>• ' + escapeHtml(e) + '</div>').join('');
                        } else {
                            formErrorBox.style.display = 'none';
                            formErrorBox.innerHTML = '';
                        }
                    }

                    return errors.length === 0;
                }

                createAssignmentBtn.addEventListener('click', function () {
                    updateSummary();
                    const valid = validateForm(true);

                    if (!valid) {
                        return;
                    }

                    alert('Frontend validation passed. Backend create-assignment flow will be connected later.');
                    if (valid) {
                        document.getElementById('assignmentForm').submit();
                    }
                });

                [
                    assignmentTitle,
                    totalPoints,
                    attemptCount,
                    openTime,
                    closeTime,
                    durationMinutes
                ].forEach(el => {
                    el.addEventListener('input', function () {
                        updateSummary();
                        validateForm(false);
                    });
                    el.addEventListener('change', function () {
                        updateSummary();
                        validateForm(false);
                    });
                });

                renderManualChapterFilters();
                renderManualSelected();
                renderManualQuestionArea();
                createAutoGroup({
                    type: 'MCQ',
                    chapters: [1],
                    count: 10,
                    points: 10
                });
                setMode('auto');
                updateSummary();
            })();
        </script>
    </body>
</html>