<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Review</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <style>
            .header-gradient {
                background: linear-gradient(90deg,#6366f1,#22d3ee);
                color: #fff;
                padding: 2rem 0;
            }
            .qcard {
                border: 1px solid #eef2f7;
                border-radius: 16px;
                overflow: hidden;
                background: #fff;
                margin-bottom: 2rem;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
            }
            .qcard-head {
                background-color: #f8fafc;
                border-bottom: 1px solid #f1f5f9;
                padding: 12px 20px;
            }
            .qchip {
                background: #e0f2fe;
                color: #0369a1;
                font-weight: 700;
                border-radius: 8px;
                padding: 4px 12px;
                font-size: 0.7rem;
                text-transform: uppercase;
            }

            /* MCQ Styles */
            .choice {
                display: flex;
                align-items: center;
                gap: 12px;
                border: 1.5px solid #f1f5f9;
                border-radius: 12px;
                padding: 14px 18px;
                transition: all 0.2s;
                height: 100%;
                position: relative;
            }
            .choice-dot {
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #e2e8f0;
                flex-shrink: 0;
            }

            .choice.chosen {
                border-color: #fecaca;
                background: #fffafa;
            } /* Sai */
            .choice.chosen .choice-dot {
                background: #ef4444;
            }

            .choice.correct {
                border-color: #bbf7d0;
                background: #f0fdf4;
            } /* Đúng */
            .choice.correct .choice-dot {
                background: #22c55e;
            }

            .essay-box {
                border: 1px dashed #cbd5e1;
                border-radius: 12px;
                background: #fcfdff;
                padding: 1rem;
            }
            .teacher-comment {
                border-left: 4px solid #6366f1;
                background: #f8fafc;
                padding: 10px;
                border-radius: 0 8px 8px 0;
            }
        </style>
    </head>
    <body class="bg-light">

        <div class="header-gradient mb-4">
            <div class="container d-flex justify-content-between align-items-center">
                <div>
                    <div class="small opacity-75">Reviewing Submission</div>
                    <h2 class="mb-0">Attempt #${attempt.id}</h2>
                </div>
                <a href="javascript:history.back()" class="btn btn-light"><i class="bi bi-arrow-left"></i> Back</a>
            </div>
        </div>

        <div class="container">
            <div class="row">
                <!-- Sidebar Summary -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm sticky-top" style="top: 20px;">
                        <div class="card-body">
                            <h5 class="fw-bold mb-3">Summary</h5>
                            <div class="mb-3">
                                <span class="text-muted small">Final Score</span>
                                <div class="display-6 fw-bold text-primary">${attempt.finalScore}</div>
                                <div class="text-muted">out of max points</div>
                            </div>
                            <hr>
                            <div class="small">
                                <p><strong>Status:</strong> <span class="badge bg-success">Graded</span></p>
                                <p><strong>Submitted:</strong> ${attempt.submittedAt}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Questions List -->
                <div class="col-md-8">
                    <c:forEach var="q" items="${questions}" varStatus="st">
                        <div class="qcard">
                            <div class="qcard-head d-flex justify-content-between">
                                <div>
                                    <span class="qchip">${q.type}</span>
                                    <span class="fw-bold ms-2">Question ${st.index + 1}</span>
                                </div>
                                <span class="text-muted fw-bold">${q.points} pts</span>
                            </div>

                            <div class="qcard-body p-4">
                                <p class="fs-5 mb-4">${q.prompt}</p>

                                <c:choose>
                                    <c:when test="${q.type == 'MCQ'}">
                                        <div class="row g-3">
                                            <c:forEach var="c" items="${q.choices}">
                                                <div class="col-md-6">
                                                    <div class="choice ${c.isCorrect ? 'correct' : ''} ${c.isChosen && !c.isCorrect ? 'chosen' : ''}">
                                                        <div class="choice-dot"></div>
                                                        <div class="flex-grow-1">${c.text}</div>
                                                        <c:if test="${c.isCorrect}">
                                                            <span class="badge bg-success-subtle text-success">Correct</span>
                                                        </c:if>
                                                        <c:if test="${c.isChosen && !c.isCorrect}">
                                                            <span class="badge bg-danger-subtle text-danger">Your Choice</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="essay-box">
                                            <div class="small text-muted mb-2">STUDENT'S ANSWER:</div>
                                            <div style="white-space: pre-wrap;">${q.essayText}</div>
                                        </div>
                                        <div class="mt-3 p-3 bg-light rounded shadow-sm">
                                            <div class="d-flex justify-content-between">
                                                <span class="fw-bold small text-primary">TEACHER GRADING</span>
                                                <span class="badge bg-dark">Score: ${q.essayScore} / ${q.points}</span>
                                            </div>
                                            <c:if test="${not empty q.teacherComment}">
                                                <div class="teacher-comment mt-2">
                                                    <i class="bi bi-chat-left-dots-fill me-2 text-primary"></i>
                                                    <span class="fst-italic">${q.teacherComment}</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

    </body>
</html>