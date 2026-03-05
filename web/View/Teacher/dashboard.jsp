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
                        <form action="${ctx}/classroom/search" method="POST">
                            <div class="classes-actions">
                                <div class="searchbox">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                                    <path d="M10 18a8 8 0 1 1 0-16 8 8 0 0 1 0 16Z" stroke="currentColor" stroke-width="2"/>
                                    <path d="M21 21l-4.3-4.3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                                    </svg>
                                    <input id="classSearchInput" type="text" name="nameClass" value="${requestScope.nameClass}" placeholder="Search classes..." />
                                </div>

                                <button class="btn btn-primary search-btn" type="submit" id="btnSearchClass">Search</button>
                                <a class="btn btn-primary join-btn" href="${ctx}/classroom/manage/create">+ New Class</a>
                            </div>
                        </form>
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
                                <span class="class-detail__code" id="cd-code">
                                    ${empty requestScope.newClassCode ? '—' : requestScope.newClassCode}
                                </span>
                                <form action="${ctx}/classroom/manage/generate-classcode" method="POST">
                                    <input type="text" name="classId"  id="cd-classId-generate" hidden="true">
                                    <button type="submit" class="class-detail__copy" id="cd-copy-btn">Generate code</button>
                                </form>
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
    (function () {
        const input = document.getElementById('classSearchInput');
        const btn = document.getElementById('btnSearchClass');
        const cards = document.querySelectorAll('.classes .class-card');

        if (!input || !btn || !cards.length)
            return;

        function norm(s) {
            return (s || '')
                    .toLowerCase()
                    .normalize('NFD')
                    .replace(/[\u0300-\u036f]/g, '')   // remove accents
                    .trim();
        }

        function applyFilter() {
            const q = norm(input.value);

            cards.forEach(card => {
                const title = card.querySelector('.class-title')?.innerText || '';
                const meta = card.querySelector('.class-meta')?.innerText || '';
                const hay = norm(title + ' ' + meta);

                card.style.display = (q === '' || hay.includes(q)) ? '' : 'none';
            });
        }

        btn.addEventListener('click', applyFilter);
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                applyFilter();
            }
        });
    })();
</script>
<script>
    (() => {
        const modal = document.getElementById('classDetailModal');
        if (!modal)
            return;

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

        modal.addEventListener('click', (e) => {
            if (e.target?.dataset?.close === '1')
                closeModal();
        });

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && modal.classList.contains('is-open'))
                closeModal();
        });

        // Copy code
        const copyBtn = document.getElementById('cd-copy-btn');
        copyBtn?.addEventListener('click', async () => {
            const code = document.getElementById('cd-code')?.textContent?.trim();
            if (!code || code === '—')
                return;

            try {
                await navigator.clipboard.writeText(code);
                copyBtn.textContent = 'Copied!';
                setTimeout(() => (copyBtn.textContent = 'Copy code'), 900);
            } catch (_) {
                const ta = document.createElement('textarea');
                ta.value = code;
                document.body.appendChild(ta);
                ta.select();
                document.execCommand('copy');
                document.body.removeChild(ta);

                copyBtn.textContent = 'Copied!';
                setTimeout(() => (copyBtn.textContent = 'Copy code'), 900);
            }
        });

        document.addEventListener('click', (e) => {
            const card = e.target.closest('.class-card');
            if (!card)
                return;
            e.preventDefault();

            const d = card.dataset;

            setText('cd-name', d.className);
            setText('cd-code', d.classCode);
            setText('cd-subject', d.subject);
            setText('cd-created', d.created);
            setText('cd-teacher', d.teacher);

            const sum = d.sum || '';
            const max = d.max || '';
            const capacityText = (sum !== '' && max !== '') ? sum + ' students • ' + max + ' max' : '—';
            setText('cd-capacity', capacityText);
            const classIdRaw = d.classId || '';
            const classId = encodeURIComponent(classIdRaw);

            const hiddenGenerate = document.getElementById('cd-classId-generate');
            if (hiddenGenerate)
                hiddenGenerate.value = classIdRaw;

            const hiddenDelete = document.getElementById('cd-classId');
            if (hiddenDelete)
                hiddenDelete.value = classIdRaw;

            document.getElementById('cd-students').href = ctx + '/classroom/view/student-list?classId=' + classId;
            document.getElementById('cd-materials').href = ctx + '/material/view/material-list?classId=' + classId;

            document.getElementById('cd-assignments').href = `#`;

            document.getElementById('cd-edit').href = ctx + '/classroom/manage/edit?classId=' + classId;

            openModal();
        });
    })();
</script>