<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Question - POET</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${ctx}/assets/css/add-question.css">
    </head>

    <body class="aq-page">
        <div class="aq-shell">

            <header class="aq-hero">
                <div class="aq-hero__inner">
                    <div>
                        <div class="aq-hero__eyebrow">Teacher tools</div>
                        <h1 class="aq-hero__title">Add Question Request</h1>
                        <p class="aq-hero__sub">
                            Create one or many question requests and submit them for admin approval before they enter the Question Bank.
                        </p>
                    </div>

                    <div class="aq-hero__actions">
                        <button type="button" class="aq-btn aq-btn--soft-light" id="openStatusModalBtn">
                            <i class="bi bi-card-checklist"></i>
                            <span>Check Questions Status</span>
                        </button>

                        <a href="${ctx}/question/view/list-question-bank" class="aq-btn aq-btn--ghost">
                            <i class="bi bi-arrow-left"></i>
                            <span>Back to Question Bank</span>
                        </a>
                    </div>
                </div>
            </header>

            <main class="aq-panel">
                <div class="aq-layout">

                    <section class="aq-board">
                        <div class="aq-board__head">
                            <div>
                                <h2 class="aq-board__title">Question submission form</h2>
                                <p class="aq-board__sub">
                                    Choose subject, chapter, and type first. Then add as many question items as needed and submit them together.
                                </p>
                            </div>

                            <div class="aq-status-chip">
                                <i class="bi bi-hourglass-split"></i>
                                Pending admin approval
                            </div>
                        </div>

                        <form id="questionForm" class="aq-form" action="${ctx}/question/view/add-question" method="post" enctype="multipart/form-data">
                            <div class="aq-section">
                                <div class="aq-section__head">
                                    <div class="aq-section__title">
                                        <i class="bi bi-diagram-3"></i>
                                        <span>Question hierarchy</span>
                                    </div>
                                </div>

                                <div class="aq-grid aq-grid--3">
                                    <div class="aq-field">
                                        <label for="subjectSelect">Subject</label>
                                        <select id="subjectSelect" name="subject" class="aq-control" required>
                                            <option value="">Select subject</option>
                                            <c:forEach items="${requestScope.listSubject}" var="s">
                                                <option value="${s.id}">${s.name}</option>
                                            </c:forEach>

                                            <!--                                            <option>Sinh học</option>
                                                                                        <option>Tin học</option>
                                                                                        <option>Tiếng Anh</option>
                                                                                        <option>Địa lý</option>
                                                                                        <option>Ngữ văn</option>
                                                                                        <option>Hóa học</option>
                                                                                        <option>Vật lý</option>
                                                                                        <option>Giáo dục công dân</option>
                                                                                        <option>Lịch sử</option>
                                                                                        <option>Thể dục</option>
                                                                                        <option>Kinh tế</option>-->
                                        </select>
                                    </div>

                                    <div class="aq-field">
                                        <label for="chapterSelect">Chapter</label>
                                        <input type="text" name="chapter" id="chapterSelect" class="aq-control">
                                        <!--                                        <select id="chapterSelect" name="chapter" class="aq-control" required>
                                                                                    <option value="">Select chapter</option>
                                                                                </select>-->
                                    </div>

                                    <div class="aq-field">
                                        <label for="typeSelect">Question type</label>
                                        <select id="typeSelect" name="questionType" class="aq-control" required>
                                            <option value="">Select type</option>
                                            <option value="1">SCQ</option>
                                            <option value="2">MCQ</option>
                                            <option value="3">Essay</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="aq-section">
                                <div class="aq-section__head">
                                    <div class="aq-section__title">
                                        <i class="bi bi-ui-radios-grid"></i>
                                        <span>Input method</span>
                                    </div>
                                </div>

                                <div class="aq-methods">
                                    <label class="aq-method-card is-active">
                                        <input type="radio" name="inputMethod" value="manual" checked>
                                        <div class="aq-method-card__icon"><i class="bi bi-pencil-square"></i></div>
                                        <div class="aq-method-card__title">Manual entry</div>
                                        <div class="aq-method-card__text">Create multiple question items directly in the form.</div>
                                    </label>

                                    <label class="aq-method-card">
                                        <input type="radio" name="inputMethod" value="txt">
                                        <div class="aq-method-card__icon"><i class="bi bi-filetype-txt"></i></div>
                                        <div class="aq-method-card__title">Import TXT</div>
                                        <div class="aq-method-card__text">Upload a TXT file, review the raw content, and submit later.</div>
                                    </label>
                                </div>
                            </div>

                            <div class="aq-section" id="manualSection">
                                <div class="aq-section__head">
                                    <div class="aq-section__title">
                                        <i class="bi bi-card-text"></i>
                                        <span>Manual question items</span>
                                    </div>

                                    <button type="button" class="aq-btn aq-btn--soft" id="addQuestionItemBtn">
                                        <i class="bi bi-plus-circle"></i>
                                        <span>Add another question</span>
                                    </button>
                                </div>

                                <div id="questionItemsWrap" class="aq-question-items"></div>
                            </div>

                            <div class="aq-section is-hidden" id="txtSection">
                                <div class="aq-section__head">
                                    <div class="aq-section__title">
                                        <i class="bi bi-upload"></i>
                                        <span>TXT import</span>
                                    </div>
                                </div>

                                <div class="aq-import-box">
                                    <div class="aq-import-box__left">
                                        <label for="txtFile" class="aq-upload">
                                            <i class="bi bi-cloud-arrow-up"></i>
                                            <span>Choose TXT file</span>
                                        </label>
                                        <input type="file" id="txtFile" accept=".txt" hidden>

                                        <div class="aq-upload__hint">
                                            Accepted format: <b>.txt</b>
                                        </div>
                                    </div>

                                    <div class="aq-import-box__right">
                                        <div class="aq-format-guide">
                                            <div class="aq-format-guide__title">Suggested TXT format</div>
                                            <pre class="aq-format-guide__code">PROMPT: ...
TYPE: SCQ | MCQ | Essay
SUBJECT: Tiếng Anh
CHAPTER: 3

OPTION A: ...
OPTION B: ...
OPTION C: ...
OPTION D: ...
CORRECT: B</pre>
                                        </div>
                                    </div>
                                </div>

                                <div class="aq-file-meta" id="fileMeta">
                                    No file selected.
                                </div>

                                <div class="aq-field aq-field--full">
                                    <label for="txtRawPreview">Raw TXT preview</label>
                                    <textarea id="txtRawPreview" class="aq-control aq-control--textarea aq-control--textarea-md" readonly placeholder="Imported TXT content will appear here..."></textarea>
                                </div>
                            </div>

                            <div class="aq-form-error" id="formErrorBox"></div>

                            <div class="aq-actions">
                                <a href="${ctx}/question/view/list-question-bank" class="aq-btn aq-btn--soft">
                                    Cancel
                                </a>

                                <button type="button" class="aq-btn aq-btn--primary" id="submitQuestionsBtn">
                                    <i class="bi bi-send-check"></i>
                                    <span>Submit for approval</span>
                                </button>
                            </div>
                        </form>
                    </section>

                    <aside class="aq-side">
                        <div class="aq-side-card">
                            <div class="aq-side-card__title">
                                <i class="bi bi-list-ol"></i>
                                Step summary
                            </div>

                            <div class="aq-step-list">
                                <div class="aq-step-item" id="stepSubject">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">1. Choose subject</div>
                                        <div class="aq-step-item__desc">Select the correct subject group.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepChapter">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">2. Choose chapter</div>
                                        <div class="aq-step-item__desc">Select the chapter inside that subject.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepType">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">3. Choose type</div>
                                        <div class="aq-step-item__desc">Pick SCQ, MCQ, or Essay.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepContent">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">4. Add content</div>
                                        <div class="aq-step-item__desc">Create multiple questions or import from TXT.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepSubmit">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">5. Submit</div>
                                        <div class="aq-step-item__desc">Send request to admin for approval.</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="aq-side-card">
                            <div class="aq-side-card__title">
                                <i class="bi bi-grid-1x2"></i>
                                Draft summary
                            </div>

                            <div class="aq-draft-summary">
                                <div class="aq-draft-summary__row">
                                    <span>Total draft questions</span>
                                    <strong id="summaryTotalQuestions">0</strong>
                                </div>
                                <div class="aq-draft-summary__row">
                                    <span>SCQ</span>
                                    <strong id="summaryScq">0</strong>
                                </div>
                                <div class="aq-draft-summary__row">
                                    <span>MCQ</span>
                                    <strong id="summaryMcq">0</strong>
                                </div>
                                <div class="aq-draft-summary__row">
                                    <span>Essay</span>
                                    <strong id="summaryEssay">0</strong>
                                </div>
                                <div class="aq-draft-summary__status" id="summaryReadyBox">
                                    Waiting for question data
                                </div>
                            </div>
                        </div>

                        <div class="aq-side-card">
                            <div class="aq-side-card__title">
                                <i class="bi bi-info-circle"></i>
                                Review flow
                            </div>

                            <div class="aq-review-flow">
                                <div class="aq-flow-pill">Teacher submits question request</div>
                                <div class="aq-flow-arrow"><i class="bi bi-arrow-down"></i></div>
                                <div class="aq-flow-pill">Admin reviews content</div>
                                <div class="aq-flow-arrow"><i class="bi bi-arrow-down"></i></div>
                                <div class="aq-flow-pill">Approved questions enter Question Bank</div>
                            </div>
                        </div>
                    </aside>
                </div>
            </main>
        </div>

        <div class="aq-modal" id="statusModal">
            <div class="aq-modal__dialog aq-modal__dialog--lg">
                <div class="aq-modal__header">
                    <div>
                        <h3 class="aq-modal__title">Check Questions Status</h3>
                        <p class="aq-modal__sub">Review submitted questions and their approval status.</p>
                    </div>
                    <button type="button" class="aq-modal__close" id="closeStatusModalBtn">&times;</button>
                </div>

                <div class="aq-modal__body">
                    <div class="aq-status-toolbar">
                        <div class="aq-search">
                            <i class="bi bi-search"></i>
                            <input type="text" id="statusSearchInput" placeholder="Search question, answer, subject, type...">
                        </div>

                        <div class="aq-status-filters">
                            <button type="button" class="aq-status-chip-filter is-active" data-status-filter="all">All</button>
                            <!--                            <button type="button" class="aq-status-chip-filter" data-status-filter="approved">Approved</button>-->
                            <button type="button" class="aq-status-chip-filter" data-status-filter="pending">Pending</button>
                            <button type="button" class="aq-status-chip-filter" data-status-filter="rejected">Rejected</button>
                        </div>
                    </div>

                    <div class="aq-status-table-wrap">
                        <table class="aq-status-table">
                            <thead>
                                <tr>
                                    <th>Question</th>
                                    <th>Answer</th>
                                    <th>Type</th>
                                    <th>Subject</th>
                                    <th>Chapter</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody id="statusTableBody"></tbody>
                        </table>
                    </div>

                    <div class="aq-empty-inline is-hidden" id="statusEmptyBox">
                        No submitted questions match the current filter.
                    </div>
                </div>
            </div>
        </div>

        <div class="d-none" id="statusSeeds">
            <c:forEach items="${requestScope.listQuestion}" var="q" varStatus="loop">

                <c:set var="answer" value="" />
                <c:set var="hasCorrect" value="false" />

                <!-- build answer bằng 1 vòng duy nhất -->
                <c:forEach items="${q.listQuestionBankChoice}" var="choice">

                    <c:if test="${choice.isCorrect}">
                        <c:set var="hasCorrect" value="true" />

                        <c:choose>
                            <c:when test="${empty answer}">
                                <c:set var="answer" value="${choice.text}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="answer" value="${answer} || ${choice.text}" />
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                </c:forEach>

                <!-- xử lý render an toàn cả khi list null / rỗng -->
                <div class="aq-status-seed"
                     data-question="${fn:escapeXml(q.prompt)}"
                     data-answer="${hasCorrect ? fn:escapeXml(answer) : 'This teacher not upload choice'}"
                     data-type="${q.type == 1 ? 'SCQ' : q.type == 2 ? 'MCQ' : 'Essay'}"
                     data-subject="${fn:escapeXml(q.subjectName)}"
                     data-chapter="${q.chapter}"
                     data-status="${q.status == 0 ? 'Rejected' : 'Pending'}">
                </div>

            </c:forEach>
            <!--            <div class="aq-status-seed" data-question="Select all countable nouns in the list." data-answer="book, apple, student" data-type="MCQ" data-subject="Tiếng Anh" data-chapter="1" data-status="Pending"></div>
                        <div class="aq-status-seed" data-question="Write a short paragraph about your hometown." data-answer="Free text answer" data-type="Essay" data-subject="Tiếng Anh" data-chapter="3" data-status="Pending"></div>
                        <div class="aq-status-seed" data-question="Chọn đáp án đúng cho phép cộng phân số." data-answer="B" data-type="SCQ" data-subject="Toán học" data-chapter="1" data-status="Rejected"></div>
                        <div class="aq-status-seed" data-question="Phân tích hình tượng người lính trong đoạn thơ." data-answer="Free text answer" data-type="Essay" data-subject="Ngữ văn" data-chapter="4" data-status="Approved"></div>-->
        </div>

        <script>
            (function () {
                const subjectSelect = document.getElementById('subjectSelect');
                const chapterSelect = document.getElementById('chapterSelect');
                const typeSelect = document.getElementById('typeSelect');

                const manualSection = document.getElementById('manualSection');
                const txtSection = document.getElementById('txtSection');
                const methodCards = Array.from(document.querySelectorAll('.aq-method-card'));
                const methodInputs = Array.from(document.querySelectorAll('input[name="inputMethod"]'));

                const questionItemsWrap = document.getElementById('questionItemsWrap');
                const addQuestionItemBtn = document.getElementById('addQuestionItemBtn');

                const txtFile = document.getElementById('txtFile');
                const txtRawPreview = document.getElementById('txtRawPreview');
                const fileMeta = document.getElementById('fileMeta');

                const stepSubject = document.getElementById('stepSubject');
                const stepChapter = document.getElementById('stepChapter');
                const stepType = document.getElementById('stepType');
                const stepContent = document.getElementById('stepContent');
                const stepSubmit = document.getElementById('stepSubmit');

                const summaryTotalQuestions = document.getElementById('summaryTotalQuestions');
                const summaryScq = document.getElementById('summaryScq');
                const summaryMcq = document.getElementById('summaryMcq');
                const summaryEssay = document.getElementById('summaryEssay');
                const summaryReadyBox = document.getElementById('summaryReadyBox');

                const formErrorBox = document.getElementById('formErrorBox');
                const submitQuestionsBtn = document.getElementById('submitQuestionsBtn');

                const openStatusModalBtn = document.getElementById('openStatusModalBtn');
                const closeStatusModalBtn = document.getElementById('closeStatusModalBtn');
                const statusModal = document.getElementById('statusModal');
                const statusSearchInput = document.getElementById('statusSearchInput');
                const statusTableBody = document.getElementById('statusTableBody');
                const statusEmptyBox = document.getElementById('statusEmptyBox');
                const statusFilterButtons = Array.from(document.querySelectorAll('[data-status-filter]'));

                let questionCounter = 0;
                let activeStatusFilter = 'all';

                const chapterMap = {
                    "Toán học": [1, 2, 3, 4, 5, 6, 7],
                    "Sinh học": [1, 2, 3, 4, 5, 6, 7],
                    "Tin học": [1, 2, 3, 4, 5, 6, 7],
                    "Tiếng Anh": [1, 2, 3, 4, 5, 6, 7],
                    "Địa lý": [1, 2, 3, 4, 5, 6, 7],
                    "Ngữ văn": [1, 2, 3, 4, 5, 6, 7],
                    "Hóa học": [1, 2, 3, 4, 5, 6, 7],
                    "Vật lý": [1, 2, 3, 4, 5, 6, 7],
                    "Giáo dục công dân": [1, 2, 3, 4, 5, 6, 7],
                    "Lịch sử": [1, 2, 3, 4, 5, 6, 7],
                    "Thể dục": [1, 2, 3, 4, 5, 6, 7],
                    "Kinh tế": [1, 2, 3, 4, 5, 6, 7]
                };

                const statusData = Array.from(document.querySelectorAll('.aq-status-seed')).map(el => ({
                        question: el.dataset.question || '',
                        answer: el.dataset.answer || '',
                        type: el.dataset.type || '',
                        subject: el.dataset.subject || '',
                        chapter: el.dataset.chapter || '',
                        status: el.dataset.status || ''
                    }));

                function escapeHtml(value) {
                    return String(value || '')
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#39;');
                }

                function setStepDone(el, done) {
                    el.classList.toggle('is-done', done);
                }

                function getCurrentMethod() {
                    const checked = document.querySelector('input[name="inputMethod"]:checked');
                    return checked ? checked.value : 'manual';
                }

                function rebuildChapterOptions() {
                    const subject = subjectSelect.value;
                    chapterSelect.innerHTML = '<option value="">Select chapter</option>';

                    if (!subject || !chapterMap[subject]) {
                        refreshSummary();
                        refreshSteps();
                        return;
                    }

                    chapterMap[subject].forEach(ch => {
                        const opt = document.createElement('option');
                        opt.value = ch;
                        opt.textContent = 'Chapter ' + ch;
                        chapterSelect.appendChild(opt);
                    });

                    refreshSummary();
                    refreshSteps();
                }

                function updateMethodUI() {
                    const method = getCurrentMethod();

                    methodCards.forEach(card => {
                        const input = card.querySelector('input');
                        card.classList.toggle('is-active', input.checked);
                    });

                    manualSection.classList.toggle('is-hidden', method !== 'manual');
                    txtSection.classList.toggle('is-hidden', method !== 'txt');

                    refreshSummary();
                    refreshSteps();
                }

                function refreshSteps() {
                    const method = getCurrentMethod();
                    const questionItems = Array.from(questionItemsWrap.querySelectorAll('.aq-question-item'));

                    setStepDone(stepSubject, !!subjectSelect.value);
                    setStepDone(stepChapter, !!chapterSelect.value);
                    setStepDone(stepType, !!typeSelect.value);

                    const hasManualContent = questionItems.some(item => {
                        const prompt = item.querySelector('.aq-question-prompt');
                        return prompt && prompt.value.trim();
                    });

                    const hasTxtContent = txtRawPreview.value.trim();

                    setStepDone(stepContent, method === 'manual' ? hasManualContent : !!hasTxtContent);
                    setStepDone(stepSubmit, validateForm(false, true));
                }

                function createOptionRow(questionIndex, questionType, optionIndex) {
                    const row = document.createElement('div');
                    row.className = 'aq-option-row';

                    row.innerHTML =
                            '<div class="aq-option-row__left">' +
                            '   <input class="aq-option-correct" type="' + (questionType === 'SCQ' ? 'radio' : 'checkbox') + '">' +
                            '</div>' +
                            '<div class="aq-option-row__main">' +
                            '   <input type="text" class="aq-control aq-option-input" placeholder="Option ' + String.fromCharCode(65 + optionIndex) + '">' +
                            '</div>' +
                            '<button type="button" class="aq-option-remove">' +
                            '   <i class="bi bi-x-lg"></i>' +
                            '</button>';

                    // 👉 SET NAME ĐỘNG
                    const correctInput = row.querySelector('.aq-option-correct');
                    const optionInput = row.querySelector('.aq-option-input');

                    correctInput.name = 'correct_' + questionIndex;
                    correctInput.value = optionIndex;

                    optionInput.name = 'option_' + questionIndex + '[]';


                    row.querySelector('.aq-option-remove').addEventListener('click', function () {
                        row.remove();
                        refreshSummary();
                        refreshSteps();
                    });

                    row.querySelector('.aq-option-input').addEventListener('input', function () {
                        refreshSummary();
                        refreshSteps();
                    });

                    row.querySelector('.aq-option-correct').addEventListener('change', function () {
                        if (questionType === 'SCQ') {
                            row.closest('.aq-options-list').querySelectorAll('.aq-option-correct').forEach(cb => {
                                if (cb !== this)
                                    cb.checked = false;
                            });
                        }
                        refreshSummary();
                        refreshSteps();
                    });
                    return row;
                }

                function buildQuestionBody(item) {
                    const type = typeSelect.value;
                    const body = item.querySelector('.aq-question-body');
                    body.innerHTML = '';

                    if (!type) {
                        body.innerHTML = '<div class="aq-empty-inline">Choose question type first.</div>';
                        return;
                    }

                    if (type === 'Essay') {
                        body.innerHTML =
                                '<div class="aq-field aq-field--full">' +
                                '   <label>Essay answer</label>' +
                                '   <div class="aq-empty-inline">Essay question only requires the prompt. No answer option block is needed.</div>' +
                                '</div>';
                        return;
                    }

                    const block = document.createElement('div');
                    block.className = 'aq-options-block';
                    block.innerHTML =
                            '<div class="aq-options-block__head">' +
                            '   <div class="aq-options-block__title">Answer options</div>' +
                            '   <button type="button" class="aq-btn aq-btn--soft aq-btn--sm aq-add-option-btn">' +
                            '       <i class="bi bi-plus-circle"></i><span>Add option</span>' +
                            '   </button>' +
                            '</div>' +
                            '<div class="aq-options-list"></div>';

                    body.appendChild(block);

                    const optionsList = block.querySelector('.aq-options-list');
                    //Tối đa 6 lựa chọn thôi
                    for (let i = 0; i < 6; i++) {
                        const qIndex = item.dataset.questionId;

                        optionsList.appendChild(
                                createOptionRow(qIndex, type, i)
                                );
                    }

                    block.querySelector('.aq-add-option-btn').addEventListener('click', function () {
                        optionsList.appendChild(createOptionRow(type, optionsList.children.length));
                        refreshSummary();
                        refreshSteps();
                    });
                }

                function createQuestionItem(initialPrompt) {
                    questionCounter++;

                    const item = document.createElement('div');
                    item.className = 'aq-question-item';
                    item.dataset.questionId = questionCounter;

                    item.innerHTML =
                            '<div class="aq-question-item__head">' +
                            '   <div class="aq-question-item__title">Question #' + questionCounter + '</div>' +
                            '   <button type="button" class="aq-remove-question-btn">Remove</button>' +
                            '</div>' +
                            '<div class="aq-grid aq-grid--1">' +
                            '   <div class="aq-field aq-field--full">' +
                            '       <label>Question prompt</label>' +
                            '       <textarea name="prompt[]" class="aq-control aq-control--textarea aq-question-prompt" placeholder="Enter the question content here...">' + (initialPrompt ? escapeHtml(initialPrompt) : '') + '</textarea>' +
                            '   </div>' +
                            '</div>' +
                            '<div class="aq-question-body"></div>';

                    questionItemsWrap.appendChild(item);

                    item.querySelector('.aq-remove-question-btn').addEventListener('click', function () {
                        item.remove();
                        refreshSummary();
                        refreshSteps();
                    });

                    item.querySelector('.aq-question-prompt').addEventListener('input', function () {
                        refreshSummary();
                        refreshSteps();
                    });

                    buildQuestionBody(item);
                    refreshSummary();
                    refreshSteps();
                }

                function rebuildAllQuestionBodies() {
                    Array.from(questionItemsWrap.querySelectorAll('.aq-question-item')).forEach(item => {
                        buildQuestionBody(item);
                    });
                    refreshSummary();
                    refreshSteps();
                }

                function refreshSummary() {
                    const items = Array.from(questionItemsWrap.querySelectorAll('.aq-question-item'));
                    const type = typeSelect.value;
                    const method = getCurrentMethod();

                    const manualCount = items.filter(item => {
                        const prompt = item.querySelector('.aq-question-prompt');
                        return prompt && prompt.value.trim();
                    }).length;

                    let scq = 0;
                    let mcq = 0;
                    let essay = 0;

                    if (method === 'manual') {
                        if (type === 'SCQ')
                            scq = manualCount;
                        if (type === 'MCQ')
                            mcq = manualCount;
                        if (type === 'Essay')
                            essay = manualCount;
                    }

                    summaryTotalQuestions.textContent = method === 'manual' ? manualCount : (txtRawPreview.value.trim() ? 1 : 0);
                    summaryScq.textContent = scq;
                    summaryMcq.textContent = mcq;
                    summaryEssay.textContent = essay;

                    if (method === 'txt') {
                        summaryReadyBox.className = 'aq-draft-summary__status';
                        summaryReadyBox.textContent = txtRawPreview.value.trim() ? 'TXT content loaded and ready for later processing.' : 'Waiting for TXT import.';
                    } else if (!type) {
                        summaryReadyBox.className = 'aq-draft-summary__status';
                        summaryReadyBox.textContent = 'Choose question type first.';
                    } else if (manualCount === 0) {
                        summaryReadyBox.className = 'aq-draft-summary__status';
                        summaryReadyBox.textContent = 'Waiting for question content.';
                    } else {
                        summaryReadyBox.className = 'aq-draft-summary__status is-ok';
                        summaryReadyBox.textContent = manualCount + ' question(s) ready in current draft.';
                    }
                }

                function validateForm(showError, silentCheck) {
                    const errors = [];
                    const method = getCurrentMethod();
                    const subject = subjectSelect.value;
                    const chapter = chapterSelect.value;
                    const type = typeSelect.value;

                    if (!subject)
                        errors.push('Subject is required.');
                    if (!chapter)
                        errors.push('Chapter is required.');
                    if (!type)
                        errors.push('Question type is required.');

                    if (method === 'manual') {
                        const items = Array.from(questionItemsWrap.querySelectorAll('.aq-question-item'));

                        if (!items.length) {
                            errors.push('Add at least one question item.');
                        }

                        items.forEach((item, idx) => {
                            const prompt = item.querySelector('.aq-question-prompt').value.trim();

                            if (!prompt) {
                                errors.push('Question #' + (idx + 1) + ': prompt is required.');
                            }

                            if (type === 'SCQ' || type === 'MCQ') {
                                const optionRows = Array.from(item.querySelectorAll('.aq-option-row'));
                                const filledOptions = optionRows.filter(row => row.querySelector('.aq-option-input').value.trim());
                                const correctCount = optionRows.filter(row => row.querySelector('.aq-option-correct').checked).length;

                                if (filledOptions.length < 2) {
                                    errors.push('Question #' + (idx + 1) + ': at least 2 answer options are required.');
                                }

                                if (type === 'SCQ' && correctCount !== 1) {
                                    errors.push('Question #' + (idx + 1) + ': SCQ must have exactly 1 correct answer.');
                                }

                                if (type === 'MCQ' && correctCount < 1) {
                                    errors.push('Question #' + (idx + 1) + ': MCQ must have at least 1 correct answer.');
                                }
                            }
                        });
                    } else {
                        if (!txtRawPreview.value.trim()) {
                            errors.push('Please import a TXT file before submitting.');
                        }
                    }

                    if (!silentCheck) {
                        if (showError && errors.length) {
                            formErrorBox.style.display = 'block';
                            formErrorBox.innerHTML = errors.map(e => '<div>• ' + escapeHtml(e) + '</div>').join('');
                        } else {
                            formErrorBox.style.display = 'none';
                            formErrorBox.innerHTML = '';
                        }
                    }

                    return errors.length === 0;
                }

                addQuestionItemBtn.addEventListener('click', function () {
                    createQuestionItem('');
                });

                methodInputs.forEach(input => {
                    input.addEventListener('change', updateMethodUI);
                });

                subjectSelect.addEventListener('change', function () {
                    chapterSelect.value = '';
                    rebuildChapterOptions();
                });

                chapterSelect.addEventListener('change', function () {
                    refreshSteps();
                    refreshSummary();
                });

                typeSelect.addEventListener('change', function () {
                    rebuildAllQuestionBodies();
                    refreshSummary();
                    refreshSteps();
                });

                txtFile.addEventListener('change', function () {
                    const file = txtFile.files && txtFile.files[0];
                    if (!file) {
                        fileMeta.textContent = 'No file selected.';
                        txtRawPreview.value = '';
                        refreshSummary();
                        refreshSteps();
                        return;
                    }

                    fileMeta.textContent = 'Selected file: ' + file.name + ' (' + Math.round(file.size / 1024) + ' KB)';

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        txtRawPreview.value = e.target.result || '';
                        refreshSummary();
                        refreshSteps();
                    };
                    reader.readAsText(file, 'UTF-8');
                });

                submitQuestionsBtn.addEventListener('click', function () {
                    const valid = validateForm(true, false);
                    refreshSummary();
                    refreshSteps();

                    if (!valid)
                        return;
                    if (valid) {
                        document.getElementById('questionForm').submit();
                    }
                    alert('Frontend validation passed. Backend submit flow will be connected later.');
                });

                function openStatusModal() {
                    statusModal.classList.add('is-open');
                    document.body.classList.add('aq-modal-open');
                }

                function closeStatusModal() {
                    statusModal.classList.remove('is-open');
                    document.body.classList.remove('aq-modal-open');
                }

                function getStatusClass(status) {
                    const s = (status || '').toLowerCase();
                    if (s === 'approved')
                        return 'aq-status-pill aq-status-pill--approved';
                    if (s === 'rejected')
                        return 'aq-status-pill aq-status-pill--rejected';
                    return 'aq-status-pill aq-status-pill--pending';
                }

                function renderStatusTable() {
                    const keyword = (statusSearchInput.value || '').trim().toLowerCase();

                    const filtered = statusData.filter(item => {
                        const matchSearch =
                                !keyword ||
                                item.question.toLowerCase().includes(keyword) ||
                                item.answer.toLowerCase().includes(keyword) ||
                                item.type.toLowerCase().includes(keyword) ||
                                item.subject.toLowerCase().includes(keyword) ||
                                item.status.toLowerCase().includes(keyword);

                        const matchStatus =
                                activeStatusFilter === 'all' ||
                                item.status.toLowerCase() === activeStatusFilter;

                        return matchSearch && matchStatus;
                    });

                    statusTableBody.innerHTML = '';

                    if (!filtered.length) {
                        statusEmptyBox.classList.remove('is-hidden');
                        return;
                    }

                    statusEmptyBox.classList.add('is-hidden');

                    filtered.forEach(item => {
                        const tr = document.createElement('tr');
                        tr.innerHTML =
                                '<td>' + escapeHtml(item.question) + '</td>' +
                                '<td>' + escapeHtml(item.answer) + '</td>' +
                                '<td>' + escapeHtml(item.type) + '</td>' +
                                '<td>' + escapeHtml(item.subject) + '</td>' +
                                '<td>Chapter ' + escapeHtml(item.chapter) + '</td>' +
                                '<td><span class="' + getStatusClass(item.status) + '">' + escapeHtml(item.status) + '</span></td>';
                        statusTableBody.appendChild(tr);
                    });
                }

                openStatusModalBtn.addEventListener('click', function () {
                    renderStatusTable();
                    openStatusModal();
                });

                closeStatusModalBtn.addEventListener('click', closeStatusModal);

                statusModal.addEventListener('click', function (e) {
                    if (e.target === statusModal) {
                        closeStatusModal();
                    }
                });

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && statusModal.classList.contains('is-open')) {
                        closeStatusModal();
                    }
                });

                statusSearchInput.addEventListener('input', renderStatusTable);

                statusFilterButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        statusFilterButtons.forEach(x => x.classList.remove('is-active'));
                        btn.classList.add('is-active');
                        activeStatusFilter = btn.dataset.statusFilter;
                        renderStatusTable();
                    });
                });

                rebuildChapterOptions();
                updateMethodUI();
                createQuestionItem('');
                refreshSummary();
                refreshSteps();
            })();
        </script>
    </body>
</html>
<style>
    :root{
        --aq-bg:#f4f7fb;
        --aq-surface:#ffffff;
        --aq-surface-2:#f8fbff;
        --aq-text:#0f172a;
        --aq-muted:#64748b;
        --aq-line:#e5edf5;
        --aq-primary:#5c6cf8;
        --aq-primary-2:#37c6de;
        --aq-accent:#f59e0b;
        --aq-accent-2:#f97316;
        --aq-soft-shadow:0 10px 30px rgba(15,23,42,.08);
        --aq-card-shadow:0 8px 22px rgba(15,23,42,.06);
    }

    *{
        box-sizing:border-box;
    }

    html{
        scrollbar-gutter:stable;
    }

    body.aq-page{
        margin:0;
        background:var(--aq-bg);
        color:var(--aq-text);
        font-family:"Segoe UI", Arial, sans-serif;
    }

    body.aq-modal-open{
        overflow:hidden;
    }

    .aq-shell{
        min-height:100vh;
    }

    .aq-hero{
        background:linear-gradient(90deg,var(--aq-primary),#4594f1 46%,var(--aq-primary-2));
        color:#fff;
        padding:18px 0 40px;
    }

    .aq-hero__inner{
        max-width:1460px;
        margin:0 auto;
        padding:0 28px;
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:20px;
    }

    .aq-hero__eyebrow{
        font-size:14px;
        opacity:.84;
        margin-bottom:4px;
    }

    .aq-hero__title{
        margin:0;
        font-size:30px;
        font-weight:800;
        line-height:1.05;
        letter-spacing:-.02em;
    }

    .aq-hero__sub{
        margin:8px 0 0;
        font-size:14px;
        opacity:.92;
        max-width:720px;
        line-height:1.6;
    }

    .aq-hero__actions{
        display:flex;
        align-items:center;
        gap:10px;
        flex-wrap:wrap;
    }

    .aq-panel{
        max-width:1460px;
        margin:-22px auto 0;
        padding:0 20px 36px;
        position:relative;
        z-index:2;
    }

    .aq-layout{
        display:grid;
        grid-template-columns:minmax(0, 1.55fr) 360px;
        gap:18px;
    }

    .aq-board{
        background:rgba(255,255,255,.94);
        backdrop-filter:blur(8px);
        border:1px solid rgba(226,232,240,.95);
        border-radius:28px;
        box-shadow:var(--aq-soft-shadow);
        padding:20px;
    }

    .aq-board__head{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:16px;
        flex-wrap:wrap;
        margin-bottom:18px;
    }

    .aq-board__title{
        margin:0;
        font-size:24px;
        font-weight:800;
        color:#14213d;
    }

    .aq-board__sub{
        margin:6px 0 0;
        color:var(--aq-muted);
        font-size:14px;
        line-height:1.6;
        max-width:720px;
    }

    .aq-status-chip{
        display:inline-flex;
        align-items:center;
        gap:8px;
        min-height:40px;
        padding:0 14px;
        border-radius:999px;
        background:#fff7ed;
        color:#c2410c;
        font-size:13px;
        font-weight:800;
        border:1px solid #fed7aa;
    }

    .aq-form{
        display:flex;
        flex-direction:column;
        gap:16px;
    }

    .aq-section{
        background:#fbfdff;
        border:1px solid #e7eef6;
        border-radius:20px;
        padding:16px;
    }

    .aq-section.is-hidden{
        display:none;
    }

    .aq-section__head{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        margin-bottom:14px;
        flex-wrap:wrap;
    }

    .aq-section__title{
        display:flex;
        align-items:center;
        gap:8px;
        font-size:16px;
        font-weight:800;
        color:#24334c;
    }

    .aq-grid{
        display:grid;
        gap:16px;
    }

    .aq-grid--3{
        grid-template-columns:repeat(3, minmax(0,1fr));
    }

    .aq-grid--2{
        grid-template-columns:repeat(2, minmax(0,1fr));
    }

    .aq-grid--1{
        grid-template-columns:1fr;
    }

    .aq-field{
        display:flex;
        flex-direction:column;
        gap:8px;
    }

    .aq-field--full{
        grid-column:1 / -1;
    }

    .aq-field label{
        font-size:14px;
        font-weight:700;
        color:#334155;
    }

    .aq-control{
        width:100%;
        min-height:46px;
        border-radius:14px;
        border:1px solid #dbe5f0;
        background:#fff;
        padding:0 14px;
        outline:none;
        color:#1e293b;
        font-size:15px;
        transition:.18s ease;
    }

    .aq-control:focus{
        border-color:#bfd0ff;
        box-shadow:0 0 0 4px rgba(92,108,248,.08);
    }

    .aq-control--textarea{
        min-height:130px;
        resize:vertical;
        padding:14px;
    }

    .aq-control--textarea-md{
        min-height:220px;
    }

    .aq-methods{
        display:grid;
        grid-template-columns:repeat(2, minmax(0,1fr));
        gap:14px;
    }

    .aq-method-card{
        position:relative;
        border:1px solid #dce6f2;
        border-radius:18px;
        background:#fff;
        padding:18px;
        cursor:pointer;
        transition:.18s ease;
        box-shadow:var(--aq-card-shadow);
    }

    .aq-method-card input{
        position:absolute;
        inset:0;
        opacity:0;
        cursor:pointer;
    }

    .aq-method-card:hover,
    .aq-method-card.is-active{
        border-color:#cad8ff;
        background:#f7f9ff;
    }

    .aq-method-card__icon{
        width:46px;
        height:46px;
        border-radius:14px;
        display:flex;
        align-items:center;
        justify-content:center;
        background:linear-gradient(135deg,rgba(92,108,248,.14),rgba(55,198,222,.14));
        color:#4864f3;
        font-size:22px;
        margin-bottom:12px;
    }

    .aq-method-card__title{
        font-size:16px;
        font-weight:800;
        margin-bottom:6px;
        color:#16233d;
    }

    .aq-method-card__text{
        font-size:14px;
        color:var(--aq-muted);
        line-height:1.6;
    }

    .aq-question-items{
        display:flex;
        flex-direction:column;
        gap:16px;
    }

    .aq-question-item{
        background:#fff;
        border:1px solid #e5edf6;
        border-radius:20px;
        box-shadow:var(--aq-card-shadow);
        padding:16px;
    }

    .aq-question-item__head{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        margin-bottom:14px;
    }

    .aq-question-item__title{
        font-size:16px;
        font-weight:800;
        color:#16233d;
    }

    .aq-remove-question-btn{
        border:none;
        background:#fff1f2;
        color:#e11d48;
        min-height:38px;
        padding:0 12px;
        border-radius:10px;
        font-weight:700;
        cursor:pointer;
        transition:.18s ease;
    }

    .aq-remove-question-btn:hover{
        background:#ffe4e6;
    }

    .aq-question-body{
        margin-top:14px;
    }

    .aq-options-block{
        background:#f8fbff;
        border:1px solid #e3ebf4;
        border-radius:16px;
        padding:14px;
    }

    .aq-options-block__head{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        margin-bottom:12px;
        flex-wrap:wrap;
    }

    .aq-options-block__title{
        font-size:14px;
        font-weight:800;
        color:#24334c;
    }

    .aq-options-list{
        display:flex;
        flex-direction:column;
        gap:10px;
    }

    .aq-option-row{
        display:grid;
        grid-template-columns:40px 1fr 44px;
        gap:10px;
        align-items:center;
    }

    .aq-option-row__left{
        display:flex;
        justify-content:center;
    }

    .aq-option-correct{
        width:18px;
        height:18px;
        cursor:pointer;
    }

    .aq-option-remove{
        border:none;
        background:#fff1f2;
        color:#e11d48;
        width:44px;
        height:44px;
        border-radius:12px;
        cursor:pointer;
    }

    .aq-option-remove:hover{
        background:#ffe4e6;
    }

    .aq-import-box{
        display:grid;
        grid-template-columns:280px 1fr;
        gap:16px;
        align-items:start;
    }

    .aq-upload{
        min-height:120px;
        border:2px dashed #cddbf0;
        border-radius:18px;
        background:#fff;
        display:flex;
        flex-direction:column;
        align-items:center;
        justify-content:center;
        gap:10px;
        cursor:pointer;
        font-weight:800;
        color:#3f58f4;
        text-align:center;
        padding:18px;
    }

    .aq-upload i{
        font-size:30px;
    }

    .aq-upload__hint{
        margin-top:10px;
        color:var(--aq-muted);
        font-size:13px;
    }

    .aq-format-guide{
        background:#fff;
        border:1px solid #e3eaf4;
        border-radius:18px;
        padding:14px;
    }

    .aq-format-guide__title{
        font-size:14px;
        font-weight:800;
        color:#24334c;
        margin-bottom:10px;
    }

    .aq-format-guide__code{
        margin:0;
        white-space:pre-wrap;
        font-size:13px;
        line-height:1.6;
        color:#475569;
        background:#f8fbff;
        border:1px dashed #dbe5f0;
        border-radius:14px;
        padding:12px;
    }

    .aq-file-meta{
        margin-top:14px;
        margin-bottom:14px;
        font-size:14px;
        color:#64748b;
        font-weight:600;
    }

    .aq-form-error{
        display:none;
        background:#fff1f2;
        border:1px solid #fecdd3;
        color:#be123c;
        border-radius:16px;
        padding:14px 16px;
        line-height:1.7;
        font-size:14px;
        font-weight:700;
    }

    .aq-actions{
        display:flex;
        justify-content:flex-end;
        gap:10px;
        flex-wrap:wrap;
    }

    .aq-btn{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        gap:8px;
        min-height:44px;
        border-radius:12px;
        padding:0 16px;
        text-decoration:none;
        font-weight:700;
        transition:.18s ease;
        border:1px solid transparent;
        cursor:pointer;
    }

    .aq-btn:hover{
        text-decoration:none;
    }

    .aq-btn--ghost{
        color:#fff;
        border-color:rgba(255,255,255,.38);
        background:rgba(255,255,255,.08);
    }

    .aq-btn--ghost:hover{
        background:rgba(255,255,255,.14);
        color:#fff;
    }

    .aq-btn--soft{
        color:#42526b;
        background:#f8fbff;
        border:1px solid #dde7f3;
    }

    .aq-btn--soft-light{
        color:#fff;
        background:rgba(255,255,255,.16);
        border:1px solid rgba(255,255,255,.28);
    }

    .aq-btn--soft-light:hover{
        color:#fff;
        background:rgba(255,255,255,.22);
    }

    .aq-btn--primary{
        color:#fff;
        background:linear-gradient(90deg,#f59e0b,#f97316);
        box-shadow:0 10px 24px rgba(249,115,22,.28);
        border:none;
    }

    .aq-btn--primary:hover{
        color:#fff;
        filter:brightness(1.03);
        transform:translateY(-1px);
    }

    .aq-btn--sm{
        min-height:36px;
        padding:0 12px;
        font-size:13px;
    }

    .aq-side{
        display:flex;
        flex-direction:column;
        gap:16px;
    }

    .aq-side-card{
        background:rgba(255,255,255,.94);
        backdrop-filter:blur(8px);
        border:1px solid rgba(226,232,240,.95);
        border-radius:22px;
        box-shadow:var(--aq-soft-shadow);
        padding:18px;
    }

    .aq-side-card__title{
        display:flex;
        align-items:center;
        gap:8px;
        font-size:16px;
        font-weight:800;
        color:#24334c;
        margin-bottom:14px;
    }

    .aq-step-list{
        display:flex;
        flex-direction:column;
        gap:12px;
    }

    .aq-step-item{
        display:grid;
        grid-template-columns:18px 1fr;
        gap:12px;
        align-items:flex-start;
    }

    .aq-step-item__dot{
        width:12px;
        height:12px;
        border-radius:999px;
        background:#dbe5f0;
        margin-top:6px;
    }

    .aq-step-item.is-done .aq-step-item__dot{
        background:linear-gradient(135deg,#22c55e,#16a34a);
        box-shadow:0 0 0 5px rgba(34,197,94,.12);
    }

    .aq-step-item__title{
        font-size:14px;
        font-weight:800;
        color:#24334c;
        margin-bottom:4px;
    }

    .aq-step-item__desc{
        font-size:13px;
        color:#64748b;
        line-height:1.6;
    }

    .aq-draft-summary{
        display:flex;
        flex-direction:column;
        gap:12px;
    }

    .aq-draft-summary__row{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        color:#475569;
        font-size:14px;
    }

    .aq-draft-summary__row strong{
        font-size:16px;
        color:#0f172a;
    }

    .aq-draft-summary__status{
        background:#f8fafc;
        border:1px dashed #dbe5f0;
        border-radius:14px;
        padding:12px 14px;
        color:#475569;
        font-weight:700;
        line-height:1.6;
    }

    .aq-draft-summary__status.is-ok{
        background:#f0fdf4;
        border-color:#bbf7d0;
        color:#15803d;
    }

    .aq-review-flow{
        display:flex;
        flex-direction:column;
        align-items:center;
        gap:8px;
    }

    .aq-flow-pill{
        width:100%;
        text-align:center;
        padding:12px 14px;
        border-radius:14px;
        background:#f8fbff;
        border:1px solid #e3eaf4;
        color:#334155;
        font-weight:700;
    }

    .aq-flow-arrow{
        color:#94a3b8;
        font-size:18px;
    }

    .aq-empty-inline{
        padding:14px;
        border-radius:14px;
        background:#f8fafc;
        color:#64748b;
        border:1px dashed #dbe5f0;
        text-align:center;
    }

    .aq-empty-inline.is-hidden{
        display:none;
    }

    .aq-modal{
        position:fixed;
        inset:0;
        display:none;
        align-items:center;
        justify-content:center;
        background:rgba(15,23,42,.46);
        z-index:1200;
        padding:24px;
    }

    .aq-modal.is-open{
        display:flex;
    }

    .aq-modal__dialog{
        width:min(100%, 920px);
        background:#fff;
        border-radius:22px;
        box-shadow:0 30px 70px rgba(2,8,23,.28);
        overflow:hidden;
        border:1px solid #e5edf6;
    }

    .aq-modal__dialog--lg{
        width:min(100%, 1180px);
    }

    .aq-modal__header{
        background:linear-gradient(90deg,var(--aq-primary),#4594f1 46%,var(--aq-primary-2));
        color:#fff;
        padding:18px 22px 16px;
        display:flex;
        justify-content:space-between;
        gap:12px;
        align-items:flex-start;
    }

    .aq-modal__title{
        margin:0 0 4px;
        font-size:22px;
        font-weight:800;
    }

    .aq-modal__sub{
        margin:0;
        font-size:14px;
        opacity:.92;
    }

    .aq-modal__close{
        border:none;
        background:transparent;
        color:#fff;
        font-size:34px;
        line-height:1;
        cursor:pointer;
        padding:0;
    }

    .aq-modal__body{
        padding:18px;
    }

    .aq-status-toolbar{
        display:flex;
        justify-content:space-between;
        gap:14px;
        flex-wrap:wrap;
        margin-bottom:16px;
    }

    .aq-search{
        flex:1;
        min-width:300px;
        display:flex;
        align-items:center;
        gap:12px;
        min-height:50px;
        background:#fff;
        border:1px solid #dbe5f0;
        border-radius:14px;
        padding:0 14px;
    }

    .aq-search i{
        color:#94a3b8;
        font-size:20px;
    }

    .aq-search input{
        border:none;
        outline:none;
        background:transparent;
        width:100%;
        font-size:15px;
        color:#1e293b;
    }

    .aq-status-filters{
        display:flex;
        gap:8px;
        flex-wrap:wrap;
    }

    .aq-status-chip-filter{
        border:1px solid #dbe5f2;
        background:#fff;
        color:#475569;
        border-radius:999px;
        min-height:38px;
        padding:0 14px;
        font-size:14px;
        font-weight:700;
        cursor:pointer;
        transition:.18s ease;
    }

    .aq-status-chip-filter:hover,
    .aq-status-chip-filter.is-active{
        color:#3e59f5;
        border-color:#cdd8ff;
        background:#f3f6ff;
    }

    .aq-status-table-wrap{
        overflow:auto;
        border:1px solid #e5edf6;
        border-radius:16px;
        max-height: 560px;
        background: #fff;
    }

    .aq-status-table{
        width:100%;
        border-collapse:collapse;
        min-width:920px;
        background:#fff;
    }

    .aq-status-table th,
    .aq-status-table td{
        padding:14px 12px;
        border-bottom:1px solid #edf2f7;
        text-align:left;
        vertical-align:top;
    }

    .aq-status-table th{
        background:#f8fbff;
        color:#24334c;
        font-size:14px;
        font-weight:800;
    }

    .aq-status-table td{
        color:#475569;
        font-size:14px;
        line-height:1.6;
    }

    .aq-status-pill{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        min-height:30px;
        padding:0 10px;
        border-radius:999px;
        font-size:12px;
        font-weight:800;
    }

    .aq-status-pill--approved{
        background:#dcfce7;
        color:#15803d;
    }

    .aq-status-pill--pending{
        background:#fef3c7;
        color:#b45309;
    }

    .aq-status-pill--rejected{
        background:#ffe4e6;
        color:#be123c;
    }
    /*fix*/
    .aq-status-table-wrap::-webkit-scrollbar{
        width: 10px;
        height: 10px;
    }

    .aq-status-table-wrap::-webkit-scrollbar-track{
        background:#f1f5f9;
        border-radius:999px;
    }

    .aq-status-table-wrap::-webkit-scrollbar-thumb{
        background:#cbd5e1;
        border-radius:999px;
        border:2px solid #f1f5f9;
    }

    .aq-status-table-wrap::-webkit-scrollbar-thumb:hover{
        background:#94a3b8;
    }

    @media (max-width: 1180px){
        .aq-layout{
            grid-template-columns:1fr;
        }

        .aq-side{
            order:-1;
        }
    }

    @media (max-width: 860px){
        .aq-grid--3,
        .aq-grid--2,
        .aq-import-box,
        .aq-methods{
            grid-template-columns:1fr;
        }

        .aq-option-row{
            grid-template-columns:34px 1fr 40px;
        }
    }

    @media (max-width: 768px){
        .aq-hero{
            padding:16px 0 30px;
        }

        .aq-hero__inner{
            padding:0 18px;
            flex-direction:column;
            align-items:flex-start;
        }

        .aq-hero__title{
            font-size:24px;
        }

        .aq-panel{
            padding:0 14px 26px;
        }

        .aq-board,
        .aq-side-card{
            padding:16px;
        }

        .aq-modal{
            padding:14px;
        }

        .aq-modal__body{
            padding:14px;
        }

        .aq-search{
            min-width:0;
        }
    }
</style>