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
        <title>Assignment Review</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <style>

            body{
                background:#f5f6f8;
            }

            /* HEADER */
            .header{
                width:100%;
                background:linear-gradient(90deg,#6a6ff2,#2bc0c6);
                color:white;
                padding:22px 40px;
            }

            /* MAIN CONTENT */
            .main-container{
                max-width:1200px;
                margin:auto;
                margin-top:25px;
            }

            /* SUMMARY */
            .summary-card{
                background:white;
                border-radius:10px;
                padding:20px;
                box-shadow:0 2px 6px rgba(0,0,0,0.05);
            }

            .score{
                font-size:32px;
                font-weight:bold;
            }

            .progress{
                height:8px;
            }

            /* QUESTION CARD */
            .question-card{
                background:white;
                border-radius:10px;
                padding:20px;
                margin-bottom:20px;
                box-shadow:0 2px 6px rgba(0,0,0,0.05);
            }

            /* CHOICE */
            .choice{
                border:1px solid #e6e6e6;
                border-radius:8px;
                padding:10px;
                margin-bottom:10px;
            }

            .choice.correct{
                border-color:#31c48d;
                background:#eafaf3;
            }

            .correct-label{
                float:right;
                color:#31c48d;
                font-weight:600;
            }

            .tag{
                font-size:12px;
                background:#eef2ff;
                padding:4px 8px;
                border-radius:5px;
            }

            /* ESSAY */
            .essay-box{
                border:1px dashed #d7dbe2;
                border-radius:8px;
                padding:15px;
                background:#fafafa;
            }
            .summary-card{
                background:white;
                border-radius:14px;
                padding:24px;
                box-shadow:0 8px 20px rgba(0,0,0,0.05);
            }

            .summary-title{
                font-weight:700;
                font-size:18px;
                margin-bottom:20px;
            }

            .stat-box{
                background:#f8f9ff;
                border-radius:10px;
                padding:12px;
                text-align:center;
            }

            .stat-icon{
                font-size:18px;
            }

            .timeline-item{
                border-left:2px solid #e9ecef;
                padding-left:12px;
                margin-bottom:12px;
            }
            .timeline-compact{
                display:flex;
                align-items:center;
                font-size:14px;
                margin-bottom:10px;
            }

            .timeline-icon{
                width:26px;
                height:26px;
                display:flex;
                align-items:center;
                justify-content:center;
                border-radius:50%;
                background:#f1f3f5;
                margin-right:8px;
                font-size:13px;
            }

            .timeline-time{
                margin-left:auto;
                font-weight:500;
            }

            .type-badge{
                font-size:12px;
                padding:5px 10px;
                border-radius:20px;
                font-weight:500;
            }

            .type-mcq{
                background:#e8f1ff;
                color:#2f6fed;
            }

            .type-essay{
                background:#fff3e6;
                color:#d97706;
            }
        </style>

    </head>


    <body>


        <!-- HEADER -->
        <div class="header">

            <div class="d-flex justify-content-between align-items-center">

                <div>
                    <div style="font-size:14px">Assignment review</div>
                    <h4 class="mb-0">Math test</h4>
                </div>

                <a href="${ctx}/assignment/view/list-assignment?classId=${requestScope.classId}" class="btn btn-light">
                    <i class="bi bi-arrow-left"></i> Back
                </a>

            </div>

        </div>



        <div class="main-container">

            <div class="row">

                <!-- SUMMARY -->
                <div class="col-md-3">

                    <div class="summary-card">

                        <!-- TITLE -->
                        <div class="summary-title">
                            <i class="bi bi-card-heading text-primary me-2"></i>
                            Assignment Details
                        </div>



                        <!-- STATUS + TIME -->
                        <div class="d-flex justify-content-between align-items-center mb-4">

                            <span class="badge bg-success fs-6">
                                <i class="bi bi-check-circle-fill me-1"></i>
                                Closed
                            </span>

                            <span class="text-muted small">
                                <i class="bi bi-hourglass-split me-1"></i>
                                30 minutes
                            </span>

                        </div>



                        <!-- SCORE -->
                        <div class="mb-4">

                            <div class="text-muted small mb-1">
                                <i class="bi bi-trophy me-1 text-warning"></i>
                                Total Score
                            </div>

                            <div class="fw-bold fs-4 text-primary">
                                <i class="bi bi-star-fill text-warning"></i>
                                100 / 100
                            </div>

                            <div class="progress mt-2">
                                <div class="progress-bar bg-success" style="width:100%"></div>
                            </div>

                        </div>



                        <!-- STATISTICS -->
                        <div class="mb-4">

                            <div class="text-muted small mb-2">
                                <i class="bi bi-bar-chart-line me-1"></i>
                                Statistics
                            </div>

                            <div class="row g-2">

                                <div class="col-6">
                                    <div class="stat-box">

                                        <i class="bi bi-list-check text-primary fs-5"></i>

                                        <div class="fw-bold">10</div>

                                        <small class="text-muted">
                                            Questions
                                        </small>

                                    </div>
                                </div>


                                <div class="col-6">
                                    <div class="stat-box">

                                        <i class="bi bi-arrow-repeat text-info fs-5"></i>

                                        <div class="fw-bold">Unlimited</div>

                                        <small class="text-muted">
                                            Attempts
                                        </small>

                                    </div>
                                </div>


                                <div class="col-6">
                                    <div class="stat-box">

                                        <i class="bi bi-people-fill text-success fs-5"></i>

                                        <div class="fw-bold">18</div>

                                        <small class="text-muted">
                                            Submissions
                                        </small>

                                    </div>
                                </div>


                                <div class="col-6">
                                    <div class="stat-box">

                                        <i class="bi bi-graph-up-arrow text-warning fs-5"></i>

                                        <div class="fw-bold">82</div>

                                        <small class="text-muted">
                                            Avg Score
                                        </small>

                                    </div>
                                </div>

                            </div>

                        </div>



                        <!-- SCHEDULE -->
                        <div>

                            <div class="text-muted small mb-2">
                                <i class="bi bi-calendar-week me-1"></i>
                                Schedule
                            </div>


                            <div class="timeline-compact">

                                <div class="timeline-icon">
                                    <i class="bi bi-unlock-fill text-secondary"></i>
                                </div>

                                Open

                                <span class="timeline-time">
                                    14/03/2026 11:18
                                </span>

                            </div>


                            <div class="timeline-compact">

                                <div class="timeline-icon">
                                    <i class="bi bi-flag-fill text-primary"></i>
                                </div>

                                Due

                                <span class="timeline-time">
                                    15/03/2026 11:18
                                </span>

                            </div>


                            <div class="timeline-compact">

                                <div class="timeline-icon">
                                    <i class="bi bi-play-circle-fill text-warning"></i>
                                </div>

                                Created at  

                                <span class="timeline-time">
                                    14/03/2026 11:26
                                </span>

                            </div>


                            <div class="timeline-compact">

                                <div class="timeline-icon">
                                    <i class="bi bi-send-check-fill text-success"></i>
                                </div>

                                Submitted

                                <span class="timeline-time">
                                    14/03/2026 11:27
                                </span>

                            </div>


                            <div class="timeline-compact">

                                <div class="timeline-icon">
                                    <i class="bi bi-stopwatch-fill text-dark"></i>
                                </div>

                                Duration

                                <span class="timeline-time">
                                    1 minute
                                </span>

                            </div>

                        </div>

                    </div>

                </div>



                <!-- QUESTIONS -->
                <div class="col-md-9">
                    <c:forEach items="${requestScope.listQuestion}" var="q" varStatus="loop">
                        <!-- QUESTION 1 -->
                        <div class="question-card">

                            <div class="d-flex justify-content-between align-items-center">

                                <div>
                                    <c:if test="${q.type == 1}">
                                        <span class="type-badge type-mcq">
                                            <i class="bi bi-ui-radios me-1"></i>
                                            MCQ
                                        </span>
                                    </c:if>
                                    <c:if test="${q.type == 2}">
                                        <span class="type-badge type-essay">
                                            <i class="bi bi-pencil-square me-1"></i>
                                            Essay
                                        </span>
                                    </c:if>
                                    <strong class="ms-2">
                                        <i class="bi bi-question-circle text-primary"></i>
                                        Question ${loop.index + 1}
                                    </strong>

                                </div>

                                <div>

                                    <span class="text-muted me-3">
                                        <i class="bi bi-star-fill text-warning"></i>
                                        ${q.points} pts
                                    </span>

                                    <button class="btn btn-sm btn-light"
                                            data-bs-toggle="collapse"
                                            data-bs-target="#q${q.id}">

                                        <i class="bi bi-chevron-down"></i>

                                    </button>

                                </div>

                            </div>


                            <p class="mt-3">
                                ${q.prompt}
                            </p>

                            <div id="q${q.id}" class="collapse mt-3">
                                <c:forEach items="${q.listAssignmentChoice}" var="choice">
                                    <div class="choice ${choice.isCorrect ? 'correct' : ''}">
                                        ○ ${choice.text}
                                        <c:if test="${choice.isCorrect}">
                                            <span class="correct-label">
                                                <i class="bi bi-check-circle"></i>
                                                Correct
                                            </span>
                                        </c:if>

                                    </div>
                                </c:forEach>
                            </div>

                        </div>

                    </c:forEach>

                    <!-- QUESTION 2 -->
                    <div class="question-card">

                        <div class="d-flex justify-content-between align-items-center">

                            <div>

                                <span class="type-badge type-essay">
                                    <i class="bi bi-pencil-square me-1"></i>
                                    Essay
                                </span>

                                <strong class="ms-2">
                                    <i class="bi bi-question-circle text-warning"></i>
                                    Question 2
                                </strong>

                            </div>

                            <div>

                                <span class="text-muted me-3">
                                    <i class="bi bi-star-fill text-warning"></i>
                                    50 pts
                                </span>

                                <button class="btn btn-sm btn-light"
                                        data-bs-toggle="collapse"
                                        data-bs-target="#essay1">

                                    <i class="bi bi-chevron-down"></i>

                                </button>

                            </div>

                        </div>


                        <p class="mt-3">
                            How many times do you play game on weeks
                        </p>


                        <div id="essay1" class="collapse mt-3">

                            <div class="essay-box">

                                <div class="text-muted mb-1">
                                    <i class="bi bi-person"></i>
                                    Student Answer
                                </div>

                                <p class="mb-0">
                                    I usually play games about 3 times per week.
                                </p>

                            </div>


                            <div class="mt-3">

                                <i class="bi bi-person-check text-success"></i>
                                <strong>Teacher Grading</strong>

                                <br>

                                <span class="text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    40 / 50
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
