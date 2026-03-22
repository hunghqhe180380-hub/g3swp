<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
    <head>
        <title>Question Groups</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            body {
                background: #f6f8fc;
            }

            .header {
                background: linear-gradient(90deg, #5f5fff, #4cc9f0);
                padding: 30px 0; /* QUAN TRỌNG: bỏ padding ngang */
                color: white;
            }

            .header-title {
                font-size: 14px;
                opacity: 0.9;
            }

            .header-sub {
                font-size: 22px;
                font-weight: 600;
            }

            .header .btn {
                border-radius: 6px;
                font-size: 14px;
                padding: 6px 12px;
            }
            .group-card {
                border-radius: 14px;
                background: white;
                margin-bottom: 15px;
                transition: 0.3s;
            }

            .group-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            }

            .collapse-box {
                max-height: 0;
                overflow: hidden;
                transition: 0.4s;
            }

            .collapse-box.open {
                max-height: 2000px;
            }

            .arrow {
                transition: 0.3s;
            }
            .rotate {
                transform: rotate(180deg);
            }

            .question {
                background: #fff;
                padding: 12px;
                border-left: 4px solid #6366f1;
                border-radius: 8px;
                margin-bottom: 10px;
            }

            .choice {
                padding: 6px;
                border-radius: 6px;
                cursor: pointer;
            }

            .choice:hover {
                background: #eef2ff;
            }

            .correct {
                background: #dcfce7;
                color: #16a34a;
                font-weight: bold;
            }

            .point-badge {
                background: #6366f1;
            }
        </style>
    </head>

    <body>

        <!-- HEADER -->
        <div class="header">
            <div class="container d-flex justify-content-between align-items-center">

                <!-- LEFT -->
                <div>
                    <div class="header-title">Create Assignment</div>
                    <div class="header-sub">ClassName • Subject</div>
                </div>

                <!-- RIGHT -->
                <div>

                    <a href="${ctx}/assignment/manage/create?classId=${requestScope.classId}" class="btn btn-light btn-sm">
                        ← Back
                    </a>
                </div>

            </div>
        </div>

        <div class="container mt-4">

            <form action="${ctx}/assignment/manage/create" method="post">
                <div class="card mb-4 border-0" style="border-radius:14px; box-shadow: 0 4px 16px rgba(0,0,0,0.06);">

                    <div class="d-flex align-items-center justify-content-between px-4 py-3">

                        <!-- LEFT -->
                        <div class="d-flex align-items-center gap-3">

                            <!-- ICON -->
                            <div style="
                                 width:42px;
                                 height:42px;
                                 border-radius:10px;
                                 background:#eef2ff;
                                 display:flex;
                                 align-items:center;
                                 justify-content:center;
                                 ">
                                <i class="bi bi-file-earmark-text" style="font-size:20px; color:#4f46e5;"></i>
                            </div>

                            <!-- TEXT -->
                            <div>
                                <div style="font-size:13px; color:#6b7280;">Assignment</div>
                                <div style="font-size:20px; font-weight:600; color:#111827;">
                                    ${requestScope.title}
                                </div>
                            </div>

                        </div>

                        <!-- RIGHT -->
                        <div style="
                             background:#f9fafb;
                             padding:10px 18px;
                             border-radius:10px;
                             text-align:center;
                             min-width:110px;
                             ">
                            <div style="font-size:12px; color:#6b7280;">Total Points</div>
                            <div style="font-size:24px; font-weight:700; color:#4f46e5;">
                                ${requestScope.totalPoint}
                            </div>
                        </div>

                        <!-- XXXXXXXXXXXXX -->
                        
                    </div>
                </div>

                <!-- hidden -->
                <input type="hidden" name="title" value="${requestScope.title}">
                <input type="hidden" name="totalPoint" value="${requestScope.totalPoint}">
                <c:forEach var="entry" items="${listquestion}" varStatus="gLoop">

                    <!-- tách key + value -->
                    <c:set var="g" value="${entry.key}" />
                    <c:set var="questions" value="${entry.value}" />

                    <!-- split key -->
                    <c:set var="parts" value="${fn:split(g, '-')}" />

                    <div class="card group-card">

                        <!-- GROUP HEADER -->
                        <div class="card-body d-flex justify-content-between align-items-center"
                             onclick="toggleGroup(${gLoop.index})"
                             style="cursor:pointer">

                            <div>
                                <span class="badge bg-primary">Type: ${parts[0] == 1 ? 'MCQ' : 'Essay'}</span>
                                <span class="badge bg-danger">Level: ${parts[1]}</span>

                                <span class="ms-2 text-muted">
                                    | Total: ${parts[2]}
                                    | Point/Q: ${parts[3]}
                                </span>
                            </div>

                            <i id="arrow${gLoop.index}" class="bi bi-chevron-down arrow"></i>
                        </div>

                        <!-- QUESTIONS -->
                        <div id="group${gLoop.index}" class="collapse-box px-3 pb-3">

                            <c:forEach var="q" items="${questions}" varStatus="qLoop">

                                <div class="question">
                                    <div class="d-flex justify-content-between">
                                        <!-- Question ID -->
                                        <input type="text" name="questionId" value="${q.id}" hidden>
                                        <!-- Question's Point -->
                                        <input type="text" name="questionPoint" value="${q.settingPoint}" hidden>
                                        <b>QIDxxx --- ${q.id}</b>
                                        <b>Q${qLoop.index + 1}: ${q.prompt}</b>
                                        <span class="badge point-badge text-white">
                                            ${q.settingPoint} pts
                                        </span>
                                    </div>

                                    <ul class="list-unstyled mt-2">

                                        <c:forEach var="c" items="${q.listQuestionBankChoice}" varStatus="cLoop">

                                            <li class="choice ${c.isCorrect ? 'correct' : ''}">
                                                <label style="width:100%">

                                                    <input type="radio"
                                                           name="q${gLoop.index}_${qLoop.index}"
                                                           value="${cLoop.index}"
                                                           ${c.isCorrect ? 'checked' : ''}
                                                           onchange="updateUI(this)">

                                                    ${c.text}

                                                </label>
                                            </li>

                                        </c:forEach>

                                    </ul>
                                </div>

                            </c:forEach>

                        </div>
                    </div>

                </c:forEach>

                <!-- SAVE BUTTON -->
                <div class="text-end mt-3">
                    <input type="text" name="action" value="createNewAssignment" hidden>
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-save"></i> Save List Question
                    </button>
                </div>

            </form>

        </div>

        <script>
            function toggleGroup(i) {
                let g = document.getElementById("group" + i);
                let arrow = document.getElementById("arrow" + i);

                g.classList.toggle("open");
                arrow.classList.toggle("rotate");
            }

            function updateUI(radio) {
                let list = radio.closest("ul").querySelectorAll("li");

                list.forEach(li => li.classList.remove("correct"));
                radio.closest("li").classList.add("correct");
            }
        </script>

    </body>
</html>