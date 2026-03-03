<%-- 
    Document   : user
    Created on : Jan 21, 2026, 11:53:10 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Teacher Dashboard - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${ctx}/assets/css/main.css">
        <link rel="stylesheet" href="${ctx}/assets/css/dashboard.css">
    </head>
    <body class="dash-page">

        <jsp:include page="/view/common/header.jsp" />

        <main class="dash-main">
            <div class="dash-container">

                <section class="welcome">
                    <h1>
                        Hello Teacher,
                        <c:out value="${empty sessionScope.user.fullName ? sessionScope.user.userName : sessionScope.user.fullName}" />!
                    </h1>
                    <p>Have a good day!</p>
                </section>

                <section class="stats" aria-label="Quick stats">
                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M4 7h16v12H4V7Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M7 7V5h10v2" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">My Classes</div>
                            <div class="stat-value">${sessionScope.classList.size()}</div>
                        </div>
                    </div>

                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M7 4h10v16H7V4Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M9 8h6M9 12h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            <path d="M9 16h3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">Assignments Due</div>
                            <div class="stat-value">${empty requestScope.assignmentsDue ? "Error" : requestScope.assignmentsDue}</div>
                        </div>
                    </div>

                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M4 6h16v12H4V6Z" stroke="currentColor" stroke-width="2"/>
                            <path d="M9 10h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            <path d="M9 14h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">Materials</div>
                            <div class="stat-value">${empty requestScope.materials ? "Error" : requestScope.materials}</div>
                        </div>
                    </div>

                    <div class="stat">
                        <div class="stat-icon" aria-hidden="true">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
                            <path d="M4 12h7l2-4 3 8 2-4h2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </div>
                        <div>
                            <div class="stat-label">Classes Active This Week</div>
                            <div class="stat-value">${empty requestScope.activeThisWeek ? "Error" : requestScope.activeThisWeek}</div>
                        </div>
                    </div>
                </section>

                <section>
                    <div class="classes-head">
                        <h2 class="section-title">My Classes</h2>

                        <div class="classes-actions">
                            <div class="searchbox">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                <path d="M10 18a8 8 0 1 1 0-16 8 8 0 0 1 0 16Z" stroke="currentColor" stroke-width="2"/>
                                <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                </svg>
                                <input id="classSearchInput" type="text" placeholder="Search classes..." />
                            </div>

                            <button class="btn btn-primary search-btn" type="button" id="btnSearchClass">Search</button>
                            <a class="btn btn-primary join-btn" href="${ctx}/classroom/manage/create">+ New Class</a>
                        </div>
                    </div>

                    <!-- Class List -->
                    <c:if test="${not empty sessionScope.classList}">
                        <div class="classes classes-scroll">
                            <c:forEach items="${sessionScope.classList}" var="cls">
                                <a class="class-card"
                                   href="#"
                                   data-class-id="<c:out value='${cls.id}'/>"
                                   data-class-name="<c:out value='${cls.name}'/>"
                                   data-class-code="<c:out value='${cls.classCode}'/>"
                                   data-subject="<c:out value='${cls.subject}'/>"
                                   data-teacher="<c:out value='${cls.teacherName}'/>"
                                   data-created="<c:out value='${cls.createdAt}'/>"
                                   data-sum="<c:out value='${cls.sum}'/>"
                                   data-max="<c:out value='${cls.maxStudent}'/>">
                                    <div class="class-banner"></div>
                                    <div class="class-body">
                                        <h3 class="class-title"><c:out value="${cls.name}"/></h3>
                                        <div class="class-meta">
                                            Subject : <c:out value="${cls.subject}"/><br>
                                            Student : <c:out value="${cls.sum}"/>/<c:out value="${cls.maxStudent}"/>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${empty sessionScope.classList}">
                        <h1>Have not created any class yet!</h1>
                    </c:if>
                </section>
            </div>
        </main>
        <!-- Class Detail Modal (Teacher)-->
        <div id="classDetailModal" class="dash-modal class-detail-modal" aria-hidden="true">
            <div class="dash-modal__backdrop" data-close="1"></div>

            <div class="dash-modal__dialog class-detail__dialog" role="dialog" aria-modal="true" aria-labelledby="cd-title">
                <div class="class-detail__header">
                    <div class="class-detail__heading" id="cd-title">Class Details</div>
                    <button class="class-detail__close" type="button" aria-label="Close" data-close="1">×</button>
                </div>

                <div class="class-detail__body">
                    <div class="class-detail__top">
                        <div>
                            <div class="class-detail__name" id="cd-name">—</div>
                            <div class="class-detail__code-line">
                                <span class="class-detail__code" id="cd-class-code">—</span>
                                <button type="button" class="class-detail__copy" id="cd-copy-btn">Copy code</button>
                            </div>
                        </div>
                    </div>

                    <div class="class-detail__row">
                        <div class="class-detail__label">Subject:</div>
                        <div class="class-detail__value" id="cd-subject">—</div>
                    </div>

                    <div class="class-detail__row">
                        <div class="class-detail__label">Created:</div>
                        <div class="class-detail__value" id="cd-created">—</div>
                    </div>

                    <div class="class-detail__row">
                        <div class="class-detail__label">Capacity:</div>
                        <div class="class-detail__value" id="cd-capacity">—</div>
                    </div>

                    <div class="class-detail__actions">
                        <a class="class-detail__btn is-blue" id="cd-students" href="#">Student List</a>
                        <a class="class-detail__btn is-green" id="cd-materials" href="#">Materials</a>
                        <a class="class-detail__btn is-orange" id="cd-assignments" href="#">Assignments</a>

                        <a class="class-detail__btn is-purple" id="cd-edit" href="#">Edit Class</a>

                        <form id="cd-delete-form" method="post" action="${ctx}/classroom/manage/delete-class" class="class-detail__delete">
                            <input type="hidden" name="classId" id="cd-classId" value="" />
                            <button type="submit" class="class-detail__btn is-red"
                                    onclick="return confirm('Delete this class?');">
                                Delete
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
 <script>
        (() => {
            const modal = document.getElementById('classDetailModal');
            if (!modal) {
                console.log('Missing #classDetailModal');
                return;
            }

            const ctx = '${ctx}';

            const setText = (id, val) => {
                const el = document.getElementById(id);
                if (el)
                    el.textContent = (val ?? '').toString().trim() || '—';
            };

            const openModal = () => {
                modal.classList.add('is-open');
                modal.setAttribute('aria-hidden', 'false');
                document.body.classList.add('modal-open');
            };

            const closeModal = () => {
                modal.classList.remove('is-open');
                modal.setAttribute('aria-hidden', 'true');
                document.body.classList.remove('modal-open');
            };

            // Close by backdrop / X
            modal.addEventListener('click', (e) => {
                if (e.target && e.target.dataset && e.target.dataset.close === '1')
                    closeModal();
            });

            // Close by ESC
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && modal.classList.contains('is-open'))
                    closeModal();
            });

            // dashboard.jsp - Đoạn Script xử lý click
            document.addEventListener('click', (e) => {
                const card = e.target.closest('.class-card');
                if (!card)
                    return;

                e.preventDefault();
                const d = card.dataset;
                setText('cd-class-code', d.classCode);
                setText('cd-name', d.className);
                setText('cd-subject', d.subject);
                setText('cd-created', d.created);
                setText('cd-teacher', d.teacher);

                // FIX 1: Nối chuỗi kiểu cũ (dùng dấu +) để JSP không nhận nhầm 
                const sum = d.sum || '';
                const max = d.max || '';
                const capacityText = (sum !== '' && max !== '') ? sum + ' students • ' + max + ' max' : '—';
                setText('cd-capacity', capacityText);

                const hidden = document.getElementById('cd-classId');
                if (hidden)
                    hidden.value = d.classId || '';

                // FIX 2: Tách ctx (biến JSP) ra khỏi classId (biến JS)
                const classId = encodeURIComponent(d.classId || '');
                const a1 = document.getElementById('cd-students');
                const a2 = document.getElementById('cd-materials');

                if (a1)
                    a1.href = ctx + '/classroom/view/student-list?classId=' + classId;
                if (a2)
                    a2.href = ctx + '/material/view/material-list?classId=' + classId;

                openModal();
            });
        })();
    </script>

    <script>
        (() => {
            const modal = document.getElementById('joinClassModal');
            const openBtn = document.getElementById('openJoinModalBtn');
            const input = document.getElementById('join-classCode');

            if (!modal || !openBtn)
                return;

            const open = () => {
                modal.classList.add('is-open');
                modal.setAttribute('aria-hidden', 'false');
                document.body.classList.add('modal-open');
                setTimeout(() => input && input.focus(), 0);
            };

            const close = () => {
                modal.classList.remove('is-open');
                modal.setAttribute('aria-hidden', 'true');
                document.body.classList.remove('modal-open');
            };

            const shouldOpen = ${openJoinModal ? "true" : "false"};
            if (shouldOpen)
                open();

            openBtn.addEventListener('click', open);

            modal.addEventListener('click', (e) => {
                if (e.target?.dataset?.close === 'join')
                    close();
            });

            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape' && modal.classList.contains('is-open'))
                    close();
            });
        })();
    </script>
</script>
