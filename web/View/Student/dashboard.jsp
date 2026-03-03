<%-- 
    Document   : user
    Created on : Jan 21, 2026, 11:53:10 PM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>


<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Dashboard - POET</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

<link rel="stylesheet" href="${ctx}/assets/css/main.css">
<link rel="stylesheet" href="${ctx}/assets/css/dashboard.css">

<body class="dash-page">

    <jsp:include page="/view/common/header.jsp" />

    <main class="dash-main">
        <div class="dash-container">

            <section class="welcome">
                <h1>
                    Welcome back,
                    <c:out value="${empty sessionScope.user.fullName ? sessionScope.user.userName : sessionScope.user.fullName}" />!
                </h1>
                <p>Continue your learning journey</p>
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
                        <div class="stat-label">Joined Classes</div>
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
                        <div class="stat-value">${empty session.materials ? "Error" : requestScope.materials}</div>
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
                        <div class="stat-value">${empty session.activeThisWeek ? "Error" : requestScope.activeThisWeek}</div>
                    </div>
                </div>
            </section>

            <section>
                <div class="section-top">
                    <h2>My Classes</h2>
                    <form action="join" method="POST">
                        <div class="class-tools">
                            <div class="searchbox">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                <path d="M10 18a8 8 0 1 1 0-16 8 8 0 0 1 0 16Z" stroke="currentColor" stroke-width="2"/>
                                <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                </svg>
                                <input type="text" name="q" value="${param.q}" placeholder="Search classes..." />
                            </div>
                            <button class="btn btn-primary join-btn" type="submit" name="action" value="searchClass">+ Search Class</button>
                            <button class="btn btn-primary join-btn" type="button" id="openJoinModalBtn">+ Join Class</button>
                        </div>
                    </form>
                </div>

                <!-- Class List -->
                <c:if test="${not empty classList}">
                    <div class="classes classes-scroll">
                        <c:forEach items="${classList}" var="cls">
                            <a class="class-card"
                               href="#"
                               data-class-id="<c:out value='${cls.id}'/>"
                               data-class-name="<c:out value='${cls.name}'/>"
                               data-subject="<c:out value='${cls.subject}'/>"
                               data-teacher="<c:out value='${cls.teacherName}'/>"
                               data-created="<c:out value='${cls.createdAt}'/>"
                               data-sum="<c:out value='${cls.sum}'/>"
                               data-max="<c:out value='${cls.maxStudent}'/>">
                                <div class="class-banner"></div>
                                <div class="class-body">
                                    <h3 class="class-title">${cls.name}</h3>
                                    <div class="class-meta">
                                        Subject : ${cls.subject}<br>
                                        Student : ${cls.sum}/${cls.maxStudent}
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty sessionScope.classList}">
                    <h1>Have not joined any class yet!</h1>
                </c:if>
            </section>

        </div>
    </main>

    <c:set var="openJoinModal"
           value="${not empty requestScope.listMSG.msgClassCode || not empty requestScope.msgClassCode}" />
    <!-- Join Class Modal -->
    <div id="joinClassModal" class="dash-modal join-modal" aria-hidden="true">
        <div class="dash-modal__backdrop" data-close="join"></div>

        <div class="dash-modal__dialog join-modal__dialog" role="dialog" aria-modal="true" aria-labelledby="join-title">
            <div class="join-modal__header">
                <div class="join-modal__title" id="join-title">Join a class</div>
                <button class="join-modal__close" type="button" aria-label="Close" data-close="join">×</button>
            </div>

            <form method="post" action="${ctx}/join" class="join-modal__body">
                <label class="join-modal__label" for="join-classCode">Class code</label>
                <input
                    id="join-classCode"
                    class="join-modal__input"
                    type="text"
                    name="classCode"
                    placeholder="6-Digit Code"
                    autocomplete="off"
                    value="${requestScope.classCode}"
                    />
                <c:if test="${not empty requestScope.listMSG.msgClassCode}">
                    <div class="form-error">${requestScope.listMSG.msgClassCode}</div>
                </c:if>

                <c:if test="${not empty requestScope.msgClassCode}">
                    <div class="form-success">${requestScope.msgClassCode}</div>
                </c:if> 
                <div class="join-modal__actions">
                    <button type="button" class="btn" data-close="join">Cancel</button>
                    <button type="submit" class="btn btn-primary" name="action" value="joinClass">Join</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Class Detail Modal (Student) -->
    <div id="classDetailModal" class="dash-modal class-detail-modal" aria-hidden="true">
        <div class="dash-modal__backdrop" data-close="1"></div>

        <div class="dash-modal__dialog class-detail__dialog" role="dialog" aria-modal="true" aria-labelledby="cd-title">
            <div class="class-detail__header">
                <div class="class-detail__heading" id="cd-title">Class Details</div>
                <button class="class-detail__close" type="button" aria-label="Close" data-close="1">×</button>
            </div>

            <div class="class-detail__body">
                <div class="class-detail__name" id="cd-name">—</div>

                <div class="class-detail__row">
                    <div class="class-detail__label">Subject:</div>
                    <div class="class-detail__value" id="cd-subject">—</div>
                </div>

                <div class="class-detail__row">
                    <div class="class-detail__label">Created:</div>
                    <div class="class-detail__value" id="cd-created">—</div>
                </div>

                <div class="class-detail__row">
                    <div class="class-detail__label">Teacher:</div>
                    <div class="class-detail__value" id="cd-teacher">—</div>
                </div>

                <div class="class-detail__row">
                    <div class="class-detail__label">Capacity:</div>
                    <div class="class-detail__value" id="cd-capacity">—</div>
                </div>

                <div class="class-detail__actions">
                    <a class="class-detail__btn is-blue" id="cd-students" href="#">Student List</a>
                    <a class="class-detail__btn is-green" id="cd-materials" href="#">Materials</a>
                    <a class="class-detail__btn is-orange" id="cd-assignments" href="#">Assignments</a>

                    <form id="cd-leave-form" method="post" action="${ctx}/join" class="class-detail__leave">
                        <input type="hidden" name="action" value="leaveClass" />
                        <input type="hidden" name="classId" id="cd-classId" value="" />
                        <button type="submit" class="class-detail__btn is-red">Leave</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

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

            // Event delegation
            document.addEventListener('click', (e) => {
                const card = e.target.closest('.class-card');
                if (!card)
                    return;

                e.preventDefault();

                const d = card.dataset;

                setText('cd-name', d.className);
                setText('cd-subject', d.subject);
                setText('cd-created', d.created);
                setText('cd-teacher', d.teacher);

                const sum = d.sum ?? '';
                const max = d.max ?? '';
                setText('cd-capacity', (sum !== '' && max !== '') ? `${sum} students • ${max} max` : '—');

                const hidden = document.getElementById('cd-classId');
                if (hidden)
                    hidden.value = d.classId || '';

                const classId = encodeURIComponent(d.classId || '');
                const a1 = document.getElementById('cd-students');
                const a2 = document.getElementById('cd-materials');
                const a3 = document.getElementById('cd-assignments');
                if (a1)
                    a1.href = `${ctx}/classroom/view/student-list?classId=${classId}`;
                                if (a2)
                                    a2.href = `${ctx}/material/view/material-list?classId=${classId}`;
                                                if (a3)
                                                    a3.href = `#`;
                                                console.log('Open modal for classId=', d.classId); // debug
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
</body>
