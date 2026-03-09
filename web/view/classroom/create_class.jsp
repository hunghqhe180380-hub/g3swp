<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Classroom - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/main.css">
        <link rel="stylesheet" href="${ctx}/assets/css/create-class.css">
    </head>

    <body class="cc-page">
        <jsp:include page="/view/common/header.jsp" />

        <main class="cc-main">
            <div class="cc-container">
                <h1 class="cc-title">Create Classroom</h1>

                <div class="cc-grid">
                    <!-- FORM CARD -->
                    <section class="cc-card cc-card--form">
                        <!-- Fix giùm cái link cái -->
                        <form action="${ctx}/classroom/manage/create" method="POST" id="createClassForm" novalidate> 
                            <div class="cc-field">
                                <label class="cc-label" for="className">Name</label>
                                <input class="cc-input" type="text" id="className" name="className"
                                       placeholder="e.g. Lớp 9"
                                       value="${className}">
                                <c:if test="${not empty listMSG.msgClassName}">
                                    <div class="cc-error">${listMSG.msgClassName}</div>
                                </c:if>
                            </div>

                            <div class="cc-field">
                                <label class="cc-label" for="subject">Subject</label>
                                <select name="subjectId"  id="id">
                                    <option value="none">---</option>
                                    <c:forEach items="${requestScope.listSubject}" var="subject">
                                        <option value="${subject.id}">${subject.name}</option>
                                    </c:forEach>
                                </select>
                                <c:if test="${not empty listMSG.msgSubject}">
                                    <div class="cc-error">${listMSG.msgSubject}</div>
                                </c:if>
                            </div>

                            <div class="cc-field">
                                <label class="cc-label" for="studentLimit">Student limit</label>

                                <div class="cc-number">
                                    <span class="cc-number__icon" aria-hidden="true">👥</span>
                                    <input class="cc-input cc-input--number" type="number" id="studentLimit" name="studentLimit"
                                           placeholder="e.g. 30"
                                           min="0" max="100"
                                           value="${studentLimit}">
                                </div>

                                <div class="cc-help">
                                    Optional. If set, the class can hold at most this many students (Max 100).
                                </div>

                                <c:if test="${not empty listMSG.msgStudentLimit}">
                                    <div class="cc-error">${listMSG.msgStudentLimit}</div>
                                </c:if>
                                <c:if test="${not empty listMSG.msgNotify}">
                                    <div style="color: #16a34a; font-weight: bolder">${listMSG.msgNotify}</div>
                                </c:if>
                            </div>

                            <div class="cc-actions">
                                <button class="cc-btn cc-btn--primary" type="submit">Create</button>
                                <a class="cc-btn cc-btn--ghost" href="${ctx}/account/dashboard">Cancel</a>
                            </div>
                        </form>
                    </section>

                    <!-- PREVIEW CARD -->
                    <aside class="cc-card cc-card--preview">
                        <div class="cc-preview-head">Live preview</div>

                        <div class="cc-preview-card">
                            <div class="cc-preview-banner"></div>

                            <div class="cc-preview-body">
                                <div class="cc-preview-name" id="pvName">                                    
                                </div>

                                <div class="cc-preview-meta">                                    
                                    <div>
                                        <span class="cc-muted">Subject :</span>
                                        <span id="pvSubject">                                            
                                        </span>
                                    </div>

                                    <div class="cc-preview-students">
                                        <span id="pvStudents">                                                                                    
                                        </span>
                                        <span class="cc-muted">students</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </aside>
                </div>
            </div>
        </main>

        <script>
            (function () {
                const nameInp = document.getElementById('className')
                        || document.querySelector('input[name="className"]');
                const subjectInp = document.getElementById('subject')
                        || document.querySelector('input[name="subject"]');
                const limitInp = document.getElementById('studentLimit')
                        || document.querySelector('input[name="studentLimit"]');

                const pvName = document.getElementById('pvName');
                const pvSubject = document.getElementById('pvSubject');
                const pvStudents = document.getElementById('pvStudents');

                function safeText(v) {
                    return (v || '').trim();
                }

                function update() {
                    const name = safeText(nameInp?.value);
                    const subject = safeText(subjectInp?.value);
                    const limitRaw = safeText(limitInp?.value);

                    pvName.textContent = name ? name : 'Class name';
                    pvSubject.textContent = subject ? subject : '—';

                    const limit = (limitRaw === '' ? '—' : limitRaw);
                    pvStudents.textContent = "0 / " + limit;
                }

                [nameInp, subjectInp, limitInp].forEach(el => {
                    if (!el)
                        return;
                    el.addEventListener('input', update);
                    el.addEventListener('change', update);
                });

                update();
            })();
        </script>
    </body>
</html>