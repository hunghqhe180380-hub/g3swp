<%-- 
    Document   : grade
    Created on : Mar 22, 2026, 6:29:19 PM
    Author     : FPT
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    </head>
    <body>

        <div class="container-fluid px-0">

            <!-- HERO -->
            <div class="grade-hero mb-3">
                <div class="container d-flex align-items-center justify-content-between">
                    <div>
                        <div class="small opacity-75">Grade</div>
                        <h4 class="mb-0">${vm.assignmentTitle}</h4>
                        <div class="small mt-1">
                            ${vm.studentName} (${vm.studentEmail}) • Attempt #${vm.attemptNumber}
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/assignment/view/submission?assignmentId=${vm.assignmentId}&classId=${vm.classId}"
                       class="btn btn-light btn-sm">
                        ← Back
                    </a>
                </div>
            </div>

            <div class="container">

                <div class="row g-3">

                    <!-- ===== LEFT SUMMARY ===== -->
                    <div class="col-lg-4">

                        <div class="card shadow-sm border-0">
                            <div class="card-body">

                                <div class="mb-2 d-flex justify-content-between">
                                    <span>Status</span>
                                    <span class="badge bg-primary">Submitted</span>
                                </div>

                                <!-- Thêm StartAt -->
                                <div class="mb-2 d-flex justify-content-between small">
                                    <span class="text-muted">Started</span>
                                    <span class="fw-bold">${vm.startedAt != null ? vm.startedAt.toString().replace('T', ' ') : 'N/A'}</span>
                                </div>

                                <!-- Thêm SubmittedAt -->
                                <div class="mb-2 d-flex justify-content-between small">
                                    <span class="text-muted">Submitted</span>
                                    <span class="fw-bold">${vm.submittedAt != null ? vm.submittedAt.toString().replace('T', ' ') : 'N/A'}</span>
                                </div>

                                <!-- Time taken (teacher only) -->
                                <div class="mb-2 d-flex justify-content-between small">
                                    <span class="text-muted">⏱ Time taken</span>
                                    <span class="fw-bold text-primary">${vm.timeTaken}</span>
                                </div>

                                <hr>


                                <hr>

                                <div class="score-row">
                                    <div class="chip scq">${vm.mcqScore}</div>
                                    <div>/ ${vm.scqMax} SCQ</div>
                                </div>

                                <div class="score-row mt-2">
                                    <div class="chip mcq">${vm.mcqScore}</div>
                                    <div>/ ${vm.mcqMax} MCQ</div>
                                </div>

                                <div class="score-row mt-2">
                                    <div class="chip essay" id="essayChip">0</div>
                                    <div>/ ${vm.essayMax} Essay</div>
                                </div>

                                <div class="progress progress-thin mt-1">
                                    <div id="essayBar" class="progress-bar bg-essay"></div>
                                </div>

                                <div class="score-row mt-2">
                                    <div class="chip final" id="finalChip">0</div>
                                    <div>/ ${vm.finalMax} Final</div>
                                </div>

                                <div class="progress progress-thin mt-1">
                                    <div id="finalBar" class="progress-bar bg-final"></div>
                                </div>

                            </div>
                        </div>

                    </div>

                    <!-- ===== RIGHT CONTENT ===== -->
                    <div class="col-lg-8">

                        <form method="post" id="gradeForm" action="/POET/submission/grade">

                            <input type="hidden" name="attemptId" value="${vm.attemptId}" />
                            <input type="hidden" name="assignmentId" value="${vm.assignmentId}" />
                            <input type="hidden" name="classId" value="${vm.classId}"/>

                            <%-- ===== SCQ SECTION =====--%>
                            <c:if test="${not empty vm.scqs}">
                            <div class="card shadow-sm border-0 mb-3">
                                <div class="card-header fw-semibold">Single Choice Questions <span class="badge bg-secondary ms-2">${vm.scqs.size()}</span></div>
                                <div class="card-body">
                                    <c:forEach var="q" items="${vm.scqs}" varStatus="i">
                                        <div class="mcq-block">
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="badge bg-primary-subtle text-primary me-2">SCQ</span>
                                                <span class="fw-bold">Question ${i.index + 1}</span>
                                                <span class="ms-2 text-muted small">(${q.points} pts)</span>
                                            </div>
                                            <div class="fw-semibold mb-3">${q.prompt}</div>
                                            <div class="choices-container">
                                                <c:forEach var="c" items="${q.choices}">
                                                    <c:choose>
                                                        <c:when test="${c.cssClass == 'choice-correct'}">
                                                            <div class="choice choice-correct"><span class="choice-icon">✓</span><span class="choice-text">${c.content}</span><span class="choice-label correct-label">Student chose · Correct</span></div>
                                                        </c:when>
                                                        <c:when test="${c.cssClass == 'choice-correct-unselected'}">
                                                            <div class="choice choice-correct-unselected"><span class="choice-icon">○</span><span class="choice-text">${c.content}</span><span class="choice-label missed-label">Correct · Not chosen</span></div>
                                                        </c:when>
                                                        <c:when test="${c.cssClass == 'choice-wrong'}">
                                                            <div class="choice choice-wrong"><span class="choice-icon">✗</span><span class="choice-text">${c.content}</span><span class="choice-label wrong-label">Student chose · Wrong</span></div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="choice"><span class="choice-icon neutral-dot"></span><span class="choice-text">${c.content}</span></div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            </c:if>

                            <%-- ===== MCQ SECTION =====--%>
                            <c:if test="${not empty vm.mcqs}">
                            <div class="card shadow-sm border-0 mb-3">
                                <div class="card-header fw-semibold">Multiple Choice Questions <span class="badge bg-secondary ms-2">${vm.mcqs.size()}</span></div>
                                <div class="card-body">
                                    <c:forEach var="q" items="${vm.mcqs}" varStatus="i">
                                        <div class="mcq-block">
                                            <!-- Header câu hỏi -->
                                            <div class="d-flex align-items-center mb-2">
                                                <span class="badge bg-info-subtle text-info me-2">MCQ</span>
                                                <span class="fw-bold">Question ${i.index + 1}</span>
                                                <span class="ms-2 text-muted small">(${q.points} pts)</span>
                                            </div>

                                            <div class="fw-semibold mb-3">
                                                ${q.prompt}
                                            </div>

                                            <!-- Container chia 2 cột -->
                                            <div class="choices-container">
                                                <c:forEach var="c" items="${q.choices}">
                                                    <c:choose>
                                                        <%-- Đúng VÀ sinh viên đã chọn → xanh đậm --%>
                                                        <c:when test="${c.cssClass == 'choice-correct'}">
                                                            <div class="choice choice-correct">
                                                                <span class="choice-icon">✓</span>
                                                                <span class="choice-text">${c.content}</span>
                                                                <span class="choice-label correct-label">Student chose · Correct</span>
                                                            </div>
                                                        </c:when>
                                                        <%-- Đúng nhưng sinh viên KHÔNG chọn → xanh nhạt dashed --%>
                                                        <c:when test="${c.cssClass == 'choice-correct-unselected'}">
                                                            <div class="choice choice-correct-unselected">
                                                                <span class="choice-icon">○</span>
                                                                <span class="choice-text">${c.content}</span>
                                                                <span class="choice-label missed-label">Correct · Not chosen</span>
                                                            </div>
                                                        </c:when>
                                                        <%-- Sai nhưng sinh viên đã chọn → đỏ --%>
                                                        <c:when test="${c.cssClass == 'choice-wrong'}">
                                                            <div class="choice choice-wrong">
                                                                <span class="choice-icon">✗</span>
                                                                <span class="choice-text">${c.content}</span>
                                                                <span class="choice-label wrong-label">Student chose · Wrong</span>
                                                            </div>
                                                        </c:when>
                                                        <%-- Sai và không chọn → xám bình thường --%>
                                                        <c:otherwise>
                                                            <div class="choice">
                                                                <span class="choice-icon neutral-dot"></span>
                                                                <span class="choice-text">${c.content}</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            </c:if>


                            <%-- ===== ESSAY SECTION =====--%>
                            <c:if test="${not empty vm.essays}">
                            <div class="card shadow-sm border-0">
                                <div class="card-header fw-semibold">Essay Questions <span class="badge bg-secondary ms-2">${vm.essays.size()}</span></div>

                                <div class="card-body">

                                    <c:forEach var="e" items="${vm.essays}" varStatus="i">
                                        <div class="essay-block mb-4">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="fw-semibold text-primary">Q${i.index + 1}</div>
                                                <div class="text-muted small">Max ${e.maxPoints}</div>
                                            </div>

                                            <div class="fw-bold mt-1">${e.prompt}</div>

                                            <div class="text-muted small mt-3">Student answer</div>
                                            <div class="essay-answer mt-1 mb-3 border-start ps-3 py-2 bg-light">
                                                ${(e.studentAnswer == null || e.studentAnswer.trim() == "") ? "<i>No answer provided.</i>" : e.studentAnswer}
                                            </div>

                                            <input type="hidden" name="questionId" value="${e.questionId}" />

                                            <div class="row g-3">
                                                <div class="col-md-4">
                                                    <label class="form-label small fw-semibold text-secondary">Score</label>
                                                    <input type="number" 
                                                           step="0.5" 
                                                           min="0" 
                                                           max="${e.maxPoints}"
                                                           name="score" 
                                                           value="${e.score}"
                                                           class="form-control score-input" 
                                                           data-max="${e.maxPoints}" />
                                                </div>
                                                <div class="col-md-8">
                                                    <label class="form-label small fw-semibold text-secondary">Comment</label>
                                                    <textarea name="comment" 
                                                              class="form-control" 
                                                              rows="1" 
                                                              placeholder="Optional feedback for the student">${e.comment}</textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                </div>
                            </div>
                            </c:if>

                            <div class="mt-3 text-end">
                                <!-- Overall Comment Section -->
                                <div class="mt-4">
                                    <label class="fw-semibold mb-1">Overall comment</label>
                                    <textarea name="teacherComment" class="form-control" rows="3" 
                                              placeholder="General feedback for this attempt">${vm.teacherComment}</textarea>
                                </div>

                                <!-- Action Buttons -->
                                <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                                    <a href="/POET/assignment/view/submission?assignmentId=${vm.assignmentId}&classId=${vm.classId}" class="btn btn-light border">
                                        Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary d-flex align-items-center gap-2">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16">
                                        <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
                                        <path d="m10.97 4.97-.02.022-3.473 4.425-2.093-2.094a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                                        </svg>
                                        Save grade
                                    </button>
                                </div>
                            </div>

                        </form>

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<style>
    .grade-hero {
        background: linear-gradient(90deg,#6366f1,#22d3ee);
        color: white;
        padding: 10px;
    }

    .score-row {
        display: flex;
        gap: 8px;
        align-items: center;
    }

    .chip {
        padding: 3px 8px;
        border-radius: 6px;
        font-weight: bold;
    }

    .chip.scq {
        background: #ede9fe;
        color: #7c3aed;
    }

    .chip.mcq {
        background: #e0f2fe;
        color: #0369a1;
    }

    .chip.essay {
        background: #f5ecff;
        color: #6d28d9;
    }

    .chip.final {
        background: #e9ffe9;
        color: #0f766e;
    }

    .progress-thin {
        height: 6px;
        background: #eee;
    }

    .bg-essay {
        background: linear-gradient(90deg,#8b5cf6,#a78bfa);
    }

    .bg-final {
        background: linear-gradient(90deg,#34d399,#10b981);
    }

    /* ===== Choice States ===== */

    /* Layout chung cho mỗi choice */
    .choice {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 14px;
        border: 1.5px solid #e5e7eb;
        border-radius: 10px;
        background: #fff;
        font-size: 0.93rem;
        position: relative;
        transition: border-color .15s, background .15s;
    }

    /* Icon bên trái */
    .choice-icon {
        flex-shrink: 0;
        font-size: 1rem;
        width: 22px;
        text-align: center;
        font-weight: bold;
    }

    /* Dấu chấm cho neutral */
    .neutral-dot {
        display: inline-block;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background: #d1d5db;
    }

    /* Text của choice */
    .choice-text {
        flex: 1;
    }

    /* Label góc phải */
    .choice-label {
        font-size: 0.72rem;
        font-weight: 700;
        white-space: nowrap;
        padding: 2px 7px;
        border-radius: 20px;
    }

    /* ✅ ĐÚNG + CHỌN → Xanh đậm */
    .choice-correct {
        border-color: #16a34a;
        background: #f0fdf4;
    }
    .choice-correct .choice-icon {
        color: #16a34a;
    }
    .choice-correct .choice-text {
        color: #14532d;
        font-weight: 600;
    }
    .correct-label {
        background: #dcfce7;
        color: #15803d;
        border: 1px solid #86efac;
    }

    /* ⭕ ĐÚNG + KHÔNG CHỌN → Xanh nhạt dashed (missed) */
    .choice-correct-unselected {
        border-color: #86efac;
        border-style: dashed;
        background: #f7fef9;
    }
    .choice-correct-unselected .choice-icon {
        color: #4ade80;
    }
    .choice-correct-unselected .choice-text {
        color: #166534;
    }
    .missed-label {
        background: #f0fdf4;
        color: #16a34a;
        border: 1px solid #86efac;
    }

    /* ❌ SAI + CHỌN → Đỏ */
    .choice-wrong {
        border-color: #ef4444;
        background: #fef2f2;
    }
    .choice-wrong .choice-icon {
        color: #dc2626;
    }
    .choice-wrong .choice-text {
        color: #7f1d1d;
        font-weight: 600;
    }
    .wrong-label {
        background: #fee2e2;
        color: #dc2626;
        border: 1px solid #fca5a5;
    }

    /* ===== MCQ Layout ===== */
    .mcq-block {
        margin-bottom: 2rem;
        padding: 12px 0;
        border-bottom: 1px solid #f3f4f6;
    }
    .mcq-block:last-child { border-bottom: none; }

    .choices-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
        margin-top: 12px;
    }

    /* ===== Essay Layout ===== */
    .essay-block {
        border: 1px solid #e5e7eb;
        border-radius: 10px;
        padding: 14px;
        margin-bottom: 14px;
    }

    .essay-answer {
        background: #f9fafb;
        padding: 10px;
        border-radius: 6px;
    }

</style>

<script>
    const inputs = document.querySelectorAll('.score-input');

    const essayChip = document.getElementById('essayChip');
    const finalChip = document.getElementById('finalChip');

    const essayBar = document.getElementById('essayBar');
    const finalBar = document.getElementById('finalBar');

    const mcq = ${vm.mcqScore};
    const scqMax = ${vm.scqMax};
    const essayMax = ${vm.essayMax};
    const finalMax = ${vm.finalMax};

    function calc() {
        let essay = 0;

        inputs.forEach(i => {
            let v = parseFloat(i.value);
            if (!isNaN(v))
                essay += v;
        });

        essayChip.innerText = essay;
        essayBar.style.width = (essay / essayMax * 100) + "%";

        let final = mcq + essay;

        finalChip.innerText = final;
        finalBar.style.width = (final / finalMax * 100) + "%";
    }

    inputs.forEach(i => i.addEventListener('input', calc));
    calc();
</script>