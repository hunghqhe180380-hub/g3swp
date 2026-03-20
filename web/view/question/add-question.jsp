<%-- 
    Document   : add-question
    Created on : Mar 20, 2026, 8:18:49 PM
    Author     : tuana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                            Submit a new question request for admin review before it is added to the Question Bank.
                        </p>
                    </div>

                    <div class="aq-hero__actions">
                        <a href="${ctx}/question/view/list-question-bank" class="aq-btn aq-btn--ghost">
                            <i class="bi bi-arrow-left"></i>
                            <span>Back to Question Bank</span>
                        </a>
                    </div>
                </div>
            </header>

            <main class="aq-panel">
                <div class="aq-layout">

                    <!-- Main form -->
                    <section class="aq-board">
                        <div class="aq-board__head">
                            <div>
                                <h2 class="aq-board__title">Question submission form</h2>
                                <p class="aq-board__sub">
                                    Fill in the hierarchy from subject to chapter to type, then complete the question details or import from TXT.
                                </p>
                            </div>

                            <div class="aq-status-chip">
                                <i class="bi bi-hourglass-split"></i>
                                Pending admin approval
                            </div>
                        </div>

                        <form id="questionForm" class="aq-form" action="#" method="post" enctype="multipart/form-data">
                            <!-- hierarchy -->
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
                                            <option>Toán học</option>
                                            <option>Sinh học</option>
                                            <option>Tin học</option>
                                            <option>Tiếng Anh</option>
                                            <option>Địa lý</option>
                                            <option>Ngữ văn</option>
                                            <option>Hóa học</option>
                                            <option>Vật lý</option>
                                            <option>Giáo dục công dân</option>
                                            <option>Lịch sử</option>
                                            <option>Thể dục</option>
                                            <option>Kinh tế</option>
                                        </select>
                                    </div>

                                    <div class="aq-field">
                                        <label for="chapterSelect">Chapter</label>
                                        <select id="chapterSelect" name="chapter" class="aq-control" required>
                                            <option value="">Select chapter</option>
                                        </select>
                                    </div>

                                    <div class="aq-field">
                                        <label for="typeSelect">Question type</label>
                                        <select id="typeSelect" name="type" class="aq-control" required>
                                            <option value="">Select type</option>
                                            <option value="SCQ">SCQ</option>
                                            <option value="MCQ">MCQ</option>
                                            <option value="Essay">Essay</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- method -->
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
                                        <div class="aq-method-card__text">Type question content directly and preview live.</div>
                                    </label>

                                    <label class="aq-method-card">
                                        <input type="radio" name="inputMethod" value="txt">
                                        <div class="aq-method-card__icon"><i class="bi bi-filetype-txt"></i></div>
                                        <div class="aq-method-card__title">Import TXT</div>
                                        <div class="aq-method-card__text">Upload a .txt file and preview its parsed content before sending.</div>
                                    </label>
                                </div>
                            </div>

                            <!-- manual block -->
                            <div class="aq-section" id="manualSection">
                                <div class="aq-section__head">
                                    <div class="aq-section__title">
                                        <i class="bi bi-card-text"></i>
                                        <span>Manual question editor</span>
                                    </div>
                                </div>

                                <div class="aq-grid aq-grid--2">
                                    <div class="aq-field aq-field--full">
                                        <label for="questionPrompt">Question prompt</label>
                                        <textarea id="questionPrompt" name="prompt" class="aq-control aq-control--textarea" placeholder="Enter the question content here..."></textarea>
                                    </div>

                                    <div class="aq-field">
                                        <label for="questionTag">Tags / keywords</label>
                                        <input id="questionTag" name="tags" class="aq-control" type="text" placeholder="e.g. grammar, algebra, reading">
                                    </div>

                                    <div class="aq-field">
                                        <label for="questionNote">Teacher note</label>
                                        <input id="questionNote" name="note" class="aq-control" type="text" placeholder="Optional note for admin reviewer">
                                    </div>
                                </div>

                                <!-- choice based -->
                                <div id="choiceSection" class="aq-dynamic-block is-hidden">
                                    <div class="aq-dynamic-block__title">
                                        <i class="bi bi-list-check"></i>
                                        <span>Answer options</span>
                                    </div>

                                    <div class="aq-choice-tools">
                                        <button type="button" class="aq-btn aq-btn--soft" id="addChoiceBtn">
                                            <i class="bi bi-plus-circle"></i>
                                            <span>Add option</span>
                                        </button>
                                    </div>

                                    <div id="choiceList" class="aq-choice-list"></div>
                                </div>

                                <!-- essay -->
                                <div id="essaySection" class="aq-dynamic-block is-hidden">
                                    <div class="aq-dynamic-block__title">
                                        <i class="bi bi-journal-text"></i>
                                        <span>Essay guidance</span>
                                    </div>

                                    <div class="aq-grid aq-grid--2">
                                        <div class="aq-field aq-field--full">
                                            <label for="essayGuide">Expected answer / marking guide</label>
                                            <textarea id="essayGuide" class="aq-control aq-control--textarea aq-control--textarea-sm" placeholder="Describe the expected answer, rubric, or evaluation note..."></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- txt import -->
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
CHAPTER: 3
SUBJECT: Tiếng Anh

OPTION A: ...
OPTION B: ...
OPTION C: ...
OPTION D: ...
CORRECT: B

GUIDE: ...</pre>
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

                            <!-- shared preview -->
                            <div class="aq-section">
                                <div class="aq-section__head">
                                    <div class="aq-section__title">
                                        <i class="bi bi-eye"></i>
                                        <span>Submission preview</span>
                                    </div>
                                </div>

                                <div class="aq-preview-card">
                                    <div class="aq-preview-card__top">
                                        <div class="aq-preview-card__badges">
                                            <span class="aq-badge aq-badge--subject" id="previewSubject">Subject</span>
                                            <span class="aq-badge aq-badge--chapter" id="previewChapter">Chapter</span>
                                            <span class="aq-badge aq-badge--type" id="previewType">Type</span>
                                        </div>

                                        <div class="aq-preview-card__state">
                                            Waiting for admin approval
                                        </div>
                                    </div>

                                    <div class="aq-preview-card__prompt" id="previewPrompt">
                                        Your question preview will appear here.
                                    </div>

                                    <div class="aq-preview-card__choices" id="previewChoices">
                                        <div class="aq-preview-empty">No answer options yet.</div>
                                    </div>

                                    <div class="aq-preview-card__guide" id="previewGuideWrap">
                                        <div class="aq-preview-card__guide-title">Guide / expected answer</div>
                                        <div class="aq-preview-card__guide-content" id="previewGuide">No guide yet.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="aq-actions">
                                <a href="${ctx}/view/question/question-bank.jsp" class="aq-btn aq-btn--soft">
                                    Cancel
                                </a>

                                <button type="button" class="aq-btn aq-btn--primary" id="submitPreviewBtn">
                                    <i class="bi bi-send-check"></i>
                                    <span>Submit for approval</span>
                                </button>
                            </div>
                        </form>
                    </section>

                    <!-- Sidebar -->
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
                                        <div class="aq-step-item__desc">Pick the subject group of the question.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepChapter">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">2. Choose chapter</div>
                                        <div class="aq-step-item__desc">Select the related chapter inside the subject.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepType">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">3. Choose type</div>
                                        <div class="aq-step-item__desc">SCQ, MCQ, or Essay.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepContent">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">4. Add content</div>
                                        <div class="aq-step-item__desc">Write manually or import from TXT.</div>
                                    </div>
                                </div>

                                <div class="aq-step-item" id="stepPreview">
                                    <div class="aq-step-item__dot"></div>
                                    <div>
                                        <div class="aq-step-item__title">5. Preview & submit</div>
                                        <div class="aq-step-item__desc">Review before sending to admin.</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="aq-side-card">
                            <div class="aq-side-card__title">
                                <i class="bi bi-info-circle"></i>
                                Review flow
                            </div>

                            <div class="aq-review-flow">
                                <div class="aq-flow-pill">Teacher creates request</div>
                                <div class="aq-flow-arrow"><i class="bi bi-arrow-down"></i></div>
                                <div class="aq-flow-pill">Admin reviews content</div>
                                <div class="aq-flow-arrow"><i class="bi bi-arrow-down"></i></div>
                                <div class="aq-flow-pill">Approved question enters Question Bank</div>
                            </div>
                        </div>

                        <div class="aq-side-card">
                            <div class="aq-side-card__title">
                                <i class="bi bi-lightbulb"></i>
                                Tips
                            </div>

                            <ul class="aq-tips">
                                <li>Keep the prompt short, clear, and focused on one learning objective.</li>
                                <li>For SCQ, provide exactly one correct answer.</li>
                                <li>For MCQ, multiple correct answers may be checked.</li>
                                <li>For Essay, add a rubric or expected answer guidance for admin review.</li>
                                <li>Use TXT import when preparing many questions from offline drafts.</li>
                            </ul>
                        </div>
                    </aside>
                </div>
            </main>
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

                const questionPrompt = document.getElementById('questionPrompt');
                const questionTag = document.getElementById('questionTag');
                const questionNote = document.getElementById('questionNote');

                const choiceSection = document.getElementById('choiceSection');
                const essaySection = document.getElementById('essaySection');
                const choiceList = document.getElementById('choiceList');
                const addChoiceBtn = document.getElementById('addChoiceBtn');
                const essayGuide = document.getElementById('essayGuide');

                const txtFile = document.getElementById('txtFile');
                const txtRawPreview = document.getElementById('txtRawPreview');
                const fileMeta = document.getElementById('fileMeta');

                const previewSubject = document.getElementById('previewSubject');
                const previewChapter = document.getElementById('previewChapter');
                const previewType = document.getElementById('previewType');
                const previewPrompt = document.getElementById('previewPrompt');
                const previewChoices = document.getElementById('previewChoices');
                const previewGuideWrap = document.getElementById('previewGuideWrap');
                const previewGuide = document.getElementById('previewGuide');

                const submitPreviewBtn = document.getElementById('submitPreviewBtn');

                const stepSubject = document.getElementById('stepSubject');
                const stepChapter = document.getElementById('stepChapter');
                const stepType = document.getElementById('stepType');
                const stepContent = document.getElementById('stepContent');
                const stepPreview = document.getElementById('stepPreview');

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

                function setStepDone(el, done) {
                    el.classList.toggle('is-done', done);
                }

                function refreshSteps() {
                    setStepDone(stepSubject, !!subjectSelect.value);
                    setStepDone(stepChapter, !!chapterSelect.value);
                    setStepDone(stepType, !!typeSelect.value);

                    const method = getCurrentMethod();
                    const hasManualContent =
                            questionPrompt.value.trim() ||
                            choiceList.querySelectorAll('.aq-choice-item').length > 0 ||
                            essayGuide.value.trim();

                    const hasTxtContent = txtRawPreview.value.trim();

                    setStepDone(stepContent, method === 'manual' ? !!hasManualContent : !!hasTxtContent);

                    const readyPreview = subjectSelect.value && chapterSelect.value && typeSelect.value;
                    setStepDone(stepPreview, !!readyPreview);
                }

                function getCurrentMethod() {
                    const checked = document.querySelector('input[name="inputMethod"]:checked');
                    return checked ? checked.value : 'manual';
                }

                function rebuildChapterOptions() {
                    const subject = subjectSelect.value;
                    chapterSelect.innerHTML = '<option value="">Select chapter</option>';

                    if (!subject || !chapterMap[subject]) {
                        refreshPreview();
                        refreshSteps();
                        return;
                    }

                    chapterMap[subject].forEach(ch => {
                        const opt = document.createElement('option');
                        opt.value = ch;
                        opt.textContent = 'Chapter ' + ch;
                        chapterSelect.appendChild(opt);
                    });

                    refreshPreview();
                    refreshSteps();
                }

                function refreshTypeBlocks() {
                    const type = typeSelect.value;

                    choiceSection.classList.add('is-hidden');
                    essaySection.classList.add('is-hidden');

                    if (type === 'SCQ' || type === 'MCQ') {
                        choiceSection.classList.remove('is-hidden');
                        if (!choiceList.children.length) {
                            addChoiceRow();
                            addChoiceRow();
                            addChoiceRow();
                            addChoiceRow();
                        }
                    } else if (type === 'Essay') {
                        essaySection.classList.remove('is-hidden');
                    }

                    refreshPreview();
                    refreshSteps();
                }

                function createChoiceRow(index) {
                    const wrapper = document.createElement('div');
                    wrapper.className = 'aq-choice-item';

                    wrapper.innerHTML =
                            '<div class="aq-choice-item__left">' +
                            '   <input class="aq-choice-check" type="' + (typeSelect.value === 'SCQ' ? 'radio' : 'checkbox') + '" name="choiceCorrect">' +
                            '</div>' +
                            '<div class="aq-choice-item__main">' +
                            '   <input type="text" class="aq-control aq-choice-input" placeholder="Option ' + String.fromCharCode(65 + index) + '">' +
                            '</div>' +
                            '<button type="button" class="aq-choice-remove">' +
                            '   <i class="bi bi-x-lg"></i>' +
                            '</button>';

                    wrapper.querySelector('.aq-choice-input').addEventListener('input', refreshPreview);
                    wrapper.querySelector('.aq-choice-check').addEventListener('change', function () {
                        if (typeSelect.value === 'SCQ') {
                            choiceList.querySelectorAll('.aq-choice-check').forEach(cb => {
                                if (cb !== this) cb.checked = false;
                            });
                        }
                        refreshPreview();
                    });

                    wrapper.querySelector('.aq-choice-remove').addEventListener('click', function () {
                        wrapper.remove();
                        resetChoiceLabels();
                        refreshPreview();
                        refreshSteps();
                    });

                    return wrapper;
                }

                function addChoiceRow() {
                    const row = createChoiceRow(choiceList.children.length);
                    choiceList.appendChild(row);
                    resetChoiceLabels();
                    refreshPreview();
                    refreshSteps();
                }

                function resetChoiceLabels() {
                    choiceList.querySelectorAll('.aq-choice-item').forEach((row, index) => {
                        const input = row.querySelector('.aq-choice-input');
                        if (input && !input.value.trim()) {
                            input.placeholder = 'Option ' + String.fromCharCode(65 + index);
                        }

                        const check = row.querySelector('.aq-choice-check');
                        if (check) {
                            check.type = (typeSelect.value === 'SCQ') ? 'radio' : 'checkbox';
                            check.name = 'choiceCorrect';
                        }
                    });
                }

                function escapeHtml(value) {
                    return String(value || '')
                            .replace(/&/g, '&amp;')
                            .replace(/</g, '&lt;')
                            .replace(/>/g, '&gt;')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#39;');
                }

                function refreshPreview() {
                    previewSubject.textContent = subjectSelect.value || 'Subject';
                    previewChapter.textContent = chapterSelect.value ? ('Chapter ' + chapterSelect.value) : 'Chapter';
                    previewType.textContent = typeSelect.value || 'Type';

                    const method = getCurrentMethod();

                    if (method === 'manual') {
                        previewPrompt.textContent = questionPrompt.value.trim() || 'Your question preview will appear here.';
                    } else {
                        previewPrompt.textContent = txtRawPreview.value.trim() || 'Imported TXT preview will appear here.';
                    }

                    if (typeSelect.value === 'SCQ' || typeSelect.value === 'MCQ') {
                        previewGuideWrap.classList.add('is-hidden');

                        const rows = Array.from(choiceList.querySelectorAll('.aq-choice-item'));
                        const filled = rows
                                .map((row, idx) => ({
                                        label: String.fromCharCode(65 + idx),
                                        text: row.querySelector('.aq-choice-input').value.trim(),
                                        checked: row.querySelector('.aq-choice-check').checked
                                    }))
                                .filter(x => x.text);

                        if (!filled.length) {
                            previewChoices.innerHTML = '<div class="aq-preview-empty">No answer options yet.</div>';
                        } else {
                            previewChoices.innerHTML = filled.map(item =>
                                '<div class="aq-preview-choice ' + (item.checked ? 'is-correct' : '') + '">' +
                                '   <div class="aq-preview-choice__label">' + item.label + '</div>' +
                                '   <div class="aq-preview-choice__text">' + escapeHtml(item.text) + '</div>' +
                                '</div>'
                            ).join('');
                        }
                    } else if (typeSelect.value === 'Essay') {
                        previewChoices.innerHTML = '<div class="aq-preview-empty">Essay question does not require multiple options.</div>';
                        previewGuideWrap.classList.remove('is-hidden');
                        previewGuide.textContent = essayGuide.value.trim() || 'No guide yet.';
                    } else {
                        previewChoices.innerHTML = '<div class="aq-preview-empty">Choose a question type to preview its structure.</div>';
                        previewGuideWrap.classList.add('is-hidden');
                    }

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

                    refreshPreview();
                    refreshSteps();
                }

                subjectSelect.addEventListener('change', function () {
                    chapterSelect.value = '';
                    rebuildChapterOptions();
                });

                chapterSelect.addEventListener('change', function () {
                    refreshPreview();
                    refreshSteps();
                });

                typeSelect.addEventListener('change', function () {
                    choiceList.innerHTML = '';
                    refreshTypeBlocks();
                });

                methodInputs.forEach(input => {
                    input.addEventListener('change', updateMethodUI);
                });

                questionPrompt.addEventListener('input', refreshPreview);
                questionTag.addEventListener('input', refreshPreview);
                questionNote.addEventListener('input', refreshPreview);
                essayGuide.addEventListener('input', refreshPreview);

                addChoiceBtn.addEventListener('click', function () {
                    addChoiceRow();
                });

                txtFile.addEventListener('change', function () {
                    const file = txtFile.files && txtFile.files[0];
                    if (!file) {
                        fileMeta.textContent = 'No file selected.';
                        txtRawPreview.value = '';
                        refreshPreview();
                        return;
                    }

                    fileMeta.textContent = 'Selected file: ' + file.name + ' (' + Math.round(file.size / 1024) + ' KB)';

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        txtRawPreview.value = e.target.result || '';
                        refreshPreview();
                    };
                    reader.readAsText(file, 'UTF-8');
                });

                submitPreviewBtn.addEventListener('click', function () {
                    alert('Các ehm vào làm backend hộ a nhé:)');
                });

                rebuildChapterOptions();
                updateMethodUI();
                refreshPreview();
            })();
        </script>
    </body>
</html>
