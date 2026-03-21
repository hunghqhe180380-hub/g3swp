<%--
    Document   : take-assignment
    Created on : Mar 18, 2026, 1:25:49 AM
    Author     : BINH
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx"    value="${pageContext.request.contextPath}" />
<c:set var="qTotal" value="${questions.size()}" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>${assignment.title}</title>

        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />

        <link rel="stylesheet" href="${ctx}/assets/css/take-assignment.css" />
    </head>
    <body>

        <!-- ===== Main Layout ===== -->
        <div class="take-wrap" id="takeRoot">

            <!-- ===== Sidebar: Question Navigator ===== -->
            <aside class="qnav">
                <h6>Questions</h6>
                <div class="small text-muted mb-2">
                    <span id="answeredCount">0</span> of ${qTotal} answered
                </div>
                <ul class="qnav-list" id="qList">
                    <c:forEach var="q" items="${questions}" varStatus="s">
                        <c:set var="activeClass"   value="${s.index == currentIndex ? 'active'   : ''}" />
                        <c:set var="rawPrompt"     value="${q.prompt != null ? q.prompt : ''}" />
                        <c:choose>
                            <c:when test="${rawPrompt.length() <= 24}">
                                <c:set var="shortPrompt" value="${rawPrompt}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="shortPrompt" value="${rawPrompt.substring(0, 24)}" />
                            </c:otherwise>
                        </c:choose>

                        <li class="qitem ${activeClass}" data-index="${s.index}" data-qid="${q.id}">
                            <div class="qtitle">
                                Q${s.index + 1} <span class="text-muted">${shortPrompt}</span>
                            </div>
                            <span class="qdot" aria-hidden="true"></span>
                        </li>
                    </c:forEach>
                </ul>
            </aside>

            <!-- ===== Main Section ===== -->
            <section>
                <!-- Header -->
                <div class="qmain-header">
                    <div class="title" id="qHeaderTitle">${assignment.title}</div>
                    <div class="timer" id="timer"></div>
                </div>

                <!-- Progress bar -->
                <div class="qprogress">
                    <div class="bar" id="qProgBar"></div>
                </div>

                <!-- Question panels -->
                <div class="qcontent">
                    <form id="quizForm" action="${ctx}/assignment/finish" method="post">
                        <input type="hidden" name="assignmentId" value="${assignment.id}" />
                        <input type="hidden" name="classId" value="${classId}" />

                        <c:forEach var="q" items="${questions}" varStatus="s">
                            <div class="qpanel"
                                 data-index="${s.index}"
                                 data-qid="${q.id}"
                                 data-type="${q.type == '1' ? 'MCQ' : 'Essay'}"
                                 <c:if test="${s.index != currentIndex}">style="display:none"</c:if>>

                                <div class="qtitle-row mb-3">
                                    <div class="h5 fw-bold m-0" id="qTitle-${s.index}">${q.prompt}</div>
                                    <span class="q-pts" id="qPts-${s.index}">
                                        <fmt:formatNumber value="${q.points}" maxFractionDigits="0" /> pts
                                    </span>
                                </div>

                                <c:choose>
                                    <%-- MCQ (type = "1") --%>
                                    <c:when test="${q.type == '1'}">
                                        <c:forEach var="choice" items="${q.listAssignmentChoice}">
                                            <c:set var="cid" value="c${s.index}_${choice.id}" />
                                            <label class="opt" for="${cid}">
                                                <input type="radio"
                                                       id="${cid}"
                                                       name="q-${q.id}"
                                                       value="${choice.id}"
                                                       data-qid="${q.id}"
                                                       data-kind="mcq" />
                                                <span>${choice.text}</span>
                                            </label>
                                        </c:forEach>
                                    </c:when>

                                    <%-- Essay (type = "2") --%>
                                    <c:otherwise>
                                        <textarea class="essay-box"
                                                  name="essay-${q.id}"
                                                  data-qid="${q.id}"
                                                  data-kind="essay"
                                                  placeholder="Type your answer here..."></textarea>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </form>
                </div>

                <!-- Bottom navigation bar -->
                <div class="take-bar">
                    <div class="left-slot">
                        <button id="btnPrev" class="btn-soft">Previous</button>
                    </div>
                    <div class="right-slot">
                        <button id="btnNext" class="btn-next">Next</button>
                        <button type="button" id="btnFinish" class="btn-finish">Finish</button>
                    </div>
                </div>
            </section>
        </div>

        <!-- ===== Modal: Confirm Finish ===== -->
        <div class="modal-overlay" id="confirmFinishModal" aria-hidden="true">
            <div class="modal-box">
                <div class="modal-hd modal-warn">
                    <span><i class="bi bi-flag"></i> Submit this attempt?</span>
                    <button class="modal-close" data-close="confirmFinishModal" aria-label="Close">&times;</button>
                </div>
                <div class="modal-bd">
                    <p class="mb-2">Are you sure you want to finish and submit your answers?</p>
                    <div class="small text-muted">You cannot change answers after submission.</div>
                </div>
                <div class="modal-ft">
                    <button class="btn-soft" data-close="confirmFinishModal">Continue working</button>
                    <button id="confirmFinishBtn" class="btn-next">
                        <i class="bi bi-check2-circle"></i> Submit
                    </button>
                </div>
            </div>
        </div>

        <!-- ===== Modal: Time Up (auto-submit) ===== -->
        <div class="modal-overlay" id="timeUpModal" aria-hidden="true">
            <div class="modal-box">
                <div class="modal-hd modal-danger">
                    <span><i class="bi bi-hourglass-split"></i> Time is up</span>
                </div>
                <div class="modal-bd">
                    <p class="mb-1">Your time has ended. The attempt will be submitted automatically.</p>
                    <div class="small text-muted">
                        Submitting in <span id="timeupCountdown">2</span> seconds...
                    </div>
                </div>
                <div class="modal-ft">
                    <button id="submitNowBtn" class="btn-danger-solid">Submit now</button>
                </div>
            </div>
        </div>

        <!-- ===== Modal: Anti-cheat Warning ===== -->
        <div class="modal-overlay" id="antiCheatModal" aria-hidden="true">
            <div class="modal-box">
                <div class="modal-hd modal-warn">
                    <span><i class="bi bi-exclamation-triangle"></i> Suspicious activity detected</span>
                    <button class="modal-close" data-close="antiCheatModal" aria-label="Close">&times;</button>
                </div>
                <div class="modal-bd">
                    <div id="antiCheatMsg" class="mb-2">
                        Please keep the test window focused and avoid taking screenshots.
                    </div>
                    <div class="small text-muted">
                        After <strong>2 confirmations</strong>, your attempt will be auto-submitted.
                    </div>
                </div>
                <div class="modal-ft">
                    <button id="antiCheatConfirmBtn" class="btn-soft">I understand</button>
                </div>
            </div>
        </div>

        <!-- Force Submit Form (anti-cheat) -->
        <form id="forceForm"
              action="${ctx}/assignment/force-submit-violated"
              method="post"
              style="display:none">
            <input type="hidden" name="assignmentId" value="${assignment.id}" />
            <input type="hidden" name="classId" value="${classId}" />
        </form>

        <!-- ===== Application Script (vanilla JS - no Bootstrap JS) ===== -->
        <script>
            (function () {
                /* ===== Plain modal helpers ===== */
                function openModal(id) {
                    var el = document.getElementById(id);
                    if (!el) return;
                    el.setAttribute('aria-hidden', 'false');
                    el.classList.add('is-open');
                    document.body.classList.add('modal-open');
                }

                function closeModal(id) {
                    var el = document.getElementById(id);
                    if (!el) return;
                    el.setAttribute('aria-hidden', 'true');
                    el.classList.remove('is-open');
                    if (!document.querySelector('.modal-overlay.is-open')) {
                        document.body.classList.remove('modal-open');
                    }
                }

                // Wire all [data-close] buttons
                document.querySelectorAll('[data-close]').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        closeModal(btn.dataset.close);
                    });
                });

                /* ===== DOM refs ===== */
                var qPanels = Array.from(document.querySelectorAll('.qpanel'));
                var qItems = Array.from(document.querySelectorAll('.qitem'));
                var total = ${qTotal};
                var index = ${currentIndex};

                /* ===== Timer ===== */
                var dueAt = new Date('${dueIso}');
                var timerEl = document.getElementById('timer');
                var timeUpShown = false;
                var submitted = false;

                function submitAttempt() {
                    if (submitted) return;
                    submitted = true;
                    document.getElementById('quizForm').submit();
                }

                function showTimeUp() {
                    if (timeUpShown) return;
                    timeUpShown = true;
                    openModal('timeUpModal');

                    var t = 2;
                    var cEl = document.getElementById('timeupCountdown');
                    cEl.textContent = String(t);
                    var tickId = setInterval(function () {
                        t -= 1;
                        cEl.textContent = String(Math.max(0, t));
                        if (t <= 0) {
                            clearInterval(tickId);
                            submitAttempt();
                        }
                    }, 1000);

                    document.getElementById('submitNowBtn')
                            .addEventListener('click', submitAttempt, {once: true});
                }

                function tickTimer() {
                    var now = new Date();
                    var s = Math.max(0, Math.floor((dueAt - now) / 1000));
                    var m = String(Math.floor(s / 60)).padStart(2, '0');
                    var ss = String(s % 60).padStart(2, '0');
                    timerEl.textContent = m + ':' + ss;
                    if (s <= 0) {
                        showTimeUp();
                    } else {
                        requestAnimationFrame(tickTimer);
                    }
                }
                requestAnimationFrame(tickTimer);

                /* ===== Progress + Prev / Next ===== */
                var answeredCountEl = document.getElementById('answeredCount');
                var progEl = document.getElementById('qProgBar');
                var btnPrev = document.getElementById('btnPrev');
                var btnNext = document.getElementById('btnNext');

                function updateAnsweredCount() {
                    var cnt = 0;
                    qPanels.forEach(function (panel) {
                        var type = panel.dataset.type;
                        if (type === 'MCQ') {
                            var checked = panel.querySelector('input[type="radio"]:checked');
                            if (checked) cnt++;
                        } else {
                            var textarea = panel.querySelector('textarea');
                            if (textarea && textarea.value.trim().length > 0) cnt++;
                        }
                    });
                    answeredCountEl.textContent = cnt;
                    qItems.forEach(function (li) {
                        var qid = li.dataset.qid;
                        var panel = qPanels.find(function (p) { return p.dataset.qid === qid; });
                        if (panel) {
                            var type = panel.dataset.type;
                            var isAnswered = false;
                            if (type === 'MCQ') {
                                var checked = panel.querySelector('input[type="radio"]:checked');
                                isAnswered = !!checked;
                            } else {
                                var textarea = panel.querySelector('textarea');
                                isAnswered = textarea && textarea.value.trim().length > 0;
                            }
                            li.classList.toggle('answered', isAnswered);
                        }
                    });
                }

                function updateButtons() {
                    btnPrev.disabled = index <= 0;
                    btnNext.disabled = index >= total - 1;
                }

                function updateProgress(i) {
                    var pct = total > 1 ? Math.round((i / (total - 1)) * 100) : 100;
                    progEl.style.width = pct + '%';
                }

                function show(i) {
                    qPanels.forEach(function (p, ix) {
                        p.style.display = ix === i ? 'block' : 'none';
                    });
                    qItems.forEach(function (li, ix) {
                        li.classList.toggle('active', ix === i);
                    });
                    index = i;
                    updateButtons();
                    updateProgress(i);
                }

                updateButtons();
                updateAnsweredCount();

                qItems.forEach(function (li) {
                    li.addEventListener('click', function () {
                        show(Number(li.dataset.index));
                    }, {passive: true});
                });
                btnPrev.addEventListener('click', function () {
                    if (index > 0) show(index - 1);
                }, {passive: true});
                btnNext.addEventListener('click', function () {
                    if (index < total - 1) show(index + 1);
                }, {passive: true});

                // Listen for answer changes
                qPanels.forEach(function (panel) {
                    panel.querySelectorAll('input[type="radio"]').forEach(function (r) {
                        r.addEventListener('change', updateAnsweredCount, {passive: true});
                    });
                    var textarea = panel.querySelector('textarea');
                    if (textarea) {
                        textarea.addEventListener('input', updateAnsweredCount, {passive: true});
                    }
                });

                show(index);
                window.onbeforeunload = null;

                /* ===== Finish confirm modal ===== */
                document.getElementById('btnFinish')
                        .addEventListener('click', function () {
                            openModal('confirmFinishModal');
                        });

                document.getElementById('confirmFinishBtn')
                        .addEventListener('click', function (e) {
                            e.preventDefault();
                            submitAttempt();
                        });

                /* ===== Anti-cheat ===== */
                var warnings = 0;
                var antiOpen = false;
                var antiMsgEl = document.getElementById('antiCheatMsg');
                var antiBtn = document.getElementById('antiCheatConfirmBtn');

                function showAnti(reason) {
                    if (antiOpen) return;
                    antiMsgEl.textContent = reason + (warnings >= 1 ? ' (next confirmation will auto-submit)' : '');
                    openModal('antiCheatModal');
                    antiOpen = true;
                }

                antiBtn.addEventListener('click', function () {
                    closeModal('antiCheatModal');
                    antiOpen = false;
                    warnings++;
                    if (warnings >= 2) {
                        setTimeout(function () {
                            document.getElementById('forceForm').submit();
                        }, 300);
                    }
                });

                /* 1) Tab switch / focus loss */
                document.addEventListener('visibilitychange', function () {
                    if (document.visibilityState === 'hidden')
                        showAnti('We detected the test lost focus / switched tab.');
                });

                window.addEventListener('blur', function () {
                    if (!document.body.classList.contains('modal-open'))
                        showAnti('We detected the window lost focus.');
                });

                /* 2) Screenshot keys */
                document.addEventListener('keydown', function (e) {
                    if (e.key && (e.key.toLowerCase() === 'printscreen' || e.key.toLowerCase() === 'snapshot')) {
                        e.preventDefault();
                        showAnti('Screenshot attempt (PrintScreen) detected.');
                    }
                    if ((e.shiftKey && (e.metaKey || e.ctrlKey)) && e.key.toLowerCase() === 's') {
                        e.preventDefault();
                        showAnti('Screen snip shortcut detected.');
                    }
                });

                /* 3) Right-click & copy protection on question area */
                var qcontent = document.querySelector('.qcontent');

                qcontent.addEventListener('contextmenu', function (e) {
                    if (e.target.closest('.essay-box')) return;
                    e.preventDefault();
                });

                document.addEventListener('copy', function (e) {
                    var sel = window.getSelection();
                    if (!sel) return;
                    var anchor = sel.anchorNode &&
                            (sel.anchorNode.nodeType === 1 ? sel.anchorNode : sel.anchorNode.parentElement);
                    if (anchor && qcontent.contains(anchor) && !anchor.closest('.essay-box')) {
                        e.preventDefault();
                        showAnti('Copy action is not allowed on questions/choices.');
                    }
                });

            })();
        </script>
    </body>
</html>
