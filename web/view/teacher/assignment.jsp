<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">
        <title>Submissions - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/admin-materials.css">

    </head>

    <body>

        <!-- TOPBAR -->
        <header class="topbar">

            <div class="topbar__inner">

                <div class="topbar__title">
                    <div class="topbar__small">Teacher • Assignment</div>
                    <h1 class="topbar__big">${assignmentTitle}</h1>
                    <div class="topbar__meta">
                        ${submissions.size()} submissions
                    </div>
                </div>

                <a class="btn-back"
                   href="${ctx}/assignment/teacher?classId=${classId}">
                    ← Back
                </a>

            </div>

        </header>


        <!-- PAGE -->

        <main class="page">

            <div class="wrap">


                <!-- TOOLBAR -->

                <div class="toolbar">

                    <div class="search">

                        <span class="search__icon">

                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                            <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="2"/>
                            <path d="M20 20l-3.5-3.5" stroke="currentColor" stroke-width="2"/>
                            </svg>

                        </span>

                        <input id="q"
                               class="search__input"
                               type="search"
                               placeholder="Search student name or email">

                    </div>

                    <div class="showing">
                        Showing <strong>${submissions.size()}</strong> submissions
                    </div>

                </div>


                <!-- CONTENT -->

                <div class="card">

                    <table class="table" id="submissionsTable">

                        <thead>

                            <tr>
                                <th>Student</th>
                                <th>Attempt</th>
                                <th>Started</th>
                                <th>Submitted</th>
                                <th>MCQ</th>
                                <th>Essay</th>
                                <th>Final</th>
                                <th class="th-actions"></th>
                            </tr>

                        </thead>


                        <tbody>

                            <c:forEach items="${submissions}" var="it">

                                <tr
                                    data-name="${it.studentName}"
                                    data-email="${it.studentEmail}"
                                    >

                                    <td class="cell-title">

                                        <div>${it.studentName}</div>

                                        <div class="muted">
                                            ${it.studentEmail}
                                        </div>

                                    </td>


                                    <td>

                                        <span class="badge-kind">
                                            #${it.attemptNumber}
                                        </span>

                                        <span class="badge-kind">
                                            ${it.status}
                                        </span>

                                    </td>


                                    <td class="muted">
                                        ${it.startedAt}
                                    </td>

                                    <td class="muted">
                                        ${it.submittedAt}
                                    </td>


                                    <td>
                                        ${it.mcqScore} / ${it.mcqMax}
                                    </td>

                                    <td>

                                        <c:choose>

                                            <c:when test="${it.essayScore != null}">
                                                ${it.essayScore} / ${it.essayMax}
                                            </c:when>

                                            <c:otherwise>
                                                —
                                            </c:otherwise>

                                        </c:choose>

                                    </td>


                                    <td>

                                        <c:choose>

                                            <c:when test="${it.finalScore != null}">
                                                ${it.finalScore} / ${it.finalMax}
                                            </c:when>

                                            <c:otherwise>
                                                —
                                            </c:otherwise>

                                        </c:choose>

                                    </td>


                                    <td class="actions">

                                        <c:if test="${it.requiresManual}">

                                            <a class="btn-danger"
                                               href="${ctx}/assignment/grade?attemptId=${it.attemptId}">
                                                Grade
                                            </a>

                                        </c:if>

                                        <a class="btn-back"
                                           href="${ctx}/assignment/review?attemptId=${it.attemptId}">
                                            View
                                        </a>

                                    </td>

                                </tr>

                            </c:forEach>

                        </tbody>

                    </table>

                </div>

            </div>

        </main>


        <script>

            const q = document.getElementById("q");
            const rows = document.querySelectorAll("#submissionsTable tbody tr");

            q.addEventListener("keyup", function () {

                let v = q.value.toLowerCase();

                rows.forEach(r => {

                    let name = r.dataset.name.toLowerCase();
                    let email = r.dataset.email.toLowerCase();

                    if (name.includes(v) || email.includes(v)) {
                        r.style.display = "";
                    } else {
                        r.style.display = "none";
                    }

                });

            });

        </script>

    </body>
</html>