<%--
    Document   : student-user
    Handles Teacher view and Student view via sessionScope.user.role
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="isTeacher" value="${fn:toUpperCase(sessionScope.user.role) == 'TEACHER'}" />

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Class Students - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-student.css">
    </head>

    <!-- ===== HEADER ===== -->
    <div class="rs-header">
        <div class="rs-header-inner">
            <div class="rs-header-meta">
                <div class="rs-header-label">
                    <c:choose>
                        <c:when test="${isTeacher}">Teacher</c:when>
                        <c:otherwise>Student</c:otherwise>
                    </c:choose>
                    &bull; Student List
                </div>
                <h4 class="rs-header-title">
                    ${classes.name} <span class="rs-code">&bull; ${classes.classCode}</span>
                </h4>
            </div>

            <div class="rs-header-actions">
                <a class="rs-btn rs-btn-slate"
                   href="${pageContext.request.contextPath}/material/view/material-list?classId=${classId}">
                    <i class="bi bi-files"></i> Materials
                </a>
                <a class="rs-btn rs-btn-slate"
                   href="${pageContext.request.contextPath}">
                    <i class="bi bi-clipboard2-check"></i> Assignments
                </a>
                <a class="rs-btn rs-btn-outline-light"
                   href="${pageContext.request.contextPath}/account/dashboard">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
            </div>
        </div>
    </div>
    <!-- /HEADER -->

    <!-- ===== MAIN CONTENT ===== -->
    <div class="section-shell">

        <!-- Toolbar -->
        <div class="rs-toolbar">
            <div class="rs-search">
                <span class="rs-search-icon"><i class="bi bi-search"></i></span>
                <input id="q" type="text"
                       placeholder="Search name<c:if test='${isTeacher}'>, username</c:if> or email…">
                </div>

                <div class="rs-toolbar-right">
                <c:if test="${isTeacher}">
                    <button id="btnCopyEmails" class="rs-btn rs-btn-gray">
                        <i class="bi bi-clipboard-check"></i> Copy emails
                    </button>
                </c:if>
                <span class="rs-total">Total: <strong id="totalCount">${fn:length(enrolls)}</strong></span>
            </div>
        </div>

        <!-- Table / Empty state -->
        <c:choose>
            <c:when test="${empty enrolls}">
                <div class="rs-empty">
                    <div class="rs-empty__icon"><i class="bi bi-people"></i></div>
                    <p class="rs-empty__title">No students yet.</p>
                    <p class="rs-empty__sub">
                        <c:choose>
                            <c:when test="${isTeacher}">Invite your students with the class code.</c:when>
                            <c:otherwise>When classmates join, they will appear here.</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </c:when>

            <c:otherwise>
                <div class="rs-table-wrap">
                    <table class="rs-table" id="rosterTable">
                        <thead>
                            <tr>
                                <th style="width:44px"></th>
                                <th>Name</th>
                                <c:if test="${isTeacher}"><th>Username</th></c:if>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Account</th>
                                <c:if test="${isTeacher}"><th>Role</th></c:if>
                                    <th>Joined</th>
                                <c:if test="${isTeacher}"><th style="width:90px"></th></c:if>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="s" items="${enrolls}" varStatus="loop">
                                <c:set var="fullName"    value="${not empty s.user.fullName    ? s.user.fullName    : '(unknown)'}" />
                                <c:set var="userName"    value="${not empty s.user.userName    ? s.user.userName    : ''}" />
                                <c:set var="email"       value="${not empty s.user.email       ? s.user.email       : ''}" />
                                <c:set var="phone"       value="${not empty s.user.phoneNumber ? s.user.phoneNumber : ''}" />
                                <c:set var="account"     value="${not empty s.user.accountCode ? s.user.accountCode : ''}" />
                                <c:set var="roleInClass" value="${not empty s.roleInClass      ? s.roleInClass      : 'Student'}" />
                                <c:set var="avatarUrl"   value="${not empty s.user.urlImgProfile
                                                                  ? s.user.urlImgProfile
                                                                  : pageContext.request.contextPath.concat('/uploads/avatars/avatarDefault.png')}" />

                                <%-- Role pill class --%>
                                <c:set var="roleCls" value="pill pill-emerald" />
                                <c:if test="${fn:toLowerCase(roleInClass) == 'teacher'}">
                                    <c:set var="roleCls" value="pill pill-indigo" />
                                </c:if>
                                <c:if test="${fn:toLowerCase(roleInClass) == 'assistant'}">
                                    <c:set var="roleCls" value="pill pill-amber" />
                                </c:if>

                                <tr data-name="${fn:toLowerCase(fullName)}"
                                    data-email="${fn:toLowerCase(email)}"
                                    data-username="${fn:toLowerCase(userName)}">

                                    <%-- Col 1: số thứ tự (Teacher) | trống (Student) --%>
                                    <td class="rs-td-num">
                                        <c:if test="${isTeacher}">${loop.index + 1}</c:if>
                                        </td>

                                    <%-- Col 2: avatar + tên --%>
                                    <td>
                                        <div class="rs-name-cell">
                                            <img src="${avatarUrl}" alt="avatar"
                                                 class="rs-avatar-img" loading="lazy"
                                                 onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/uploads/avatars/avatarDefault.png'">
                                            <div>
                                                <div class="rs-name rs-truncate" title="${fullName}">${fullName}</div>
                                                <c:if test="${isTeacher}">
                                                    <div class="rs-name-sub rs-truncate" title="${email}">${email}</div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>

                                    <%-- Username: Teacher only --%>
                                    <c:if test="${isTeacher}">
                                        <td class="rs-truncate" title="${userName}">${userName}</td>
                                    </c:if>

                                    <%-- Email --%>
                                    <td class="rs-truncate">
                                        <a class="rs-mail" href="mailto:${email}" title="${email}">${email}</a>
                                    </td>

                                    <%-- Phone --%>
                                    <td class="rs-td-muted rs-truncate" title="${phone}">${phone}</td>

                                    <%-- Account code --%>
                                    <td><code class="rs-code-badge">${account}</code></td>

                                    <%-- Role pill: Teacher only --%>
                                    <c:if test="${isTeacher}">
                                        <td><span class="${roleCls}">${roleInClass}</span></td>
                                        </c:if>

                                    <%-- Joined --%>
                                    <td class="rs-td-muted">
                                        ${s.joinedAt}
                                    </td>

                                    <%-- Kick: Teacher only --%>
                                    <c:if test="${isTeacher}">
                                        <td style="text-align:right">
                                            <button type="button"
                                                    class="rs-btn rs-btn-danger-outline rs-kick-btn"
                                                    data-userid="${s.id}"
                                                    data-fullname="${fullName}">
                                                <i class="bi bi-person-dash"></i> Kick
                                            </button>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
    <!-- /MAIN CONTENT -->

    <!-- ===== KICK MODAL — vanilla JS ===== -->
    <c:if test="${isTeacher}">
        <div class="rs-modal-backdrop" id="kickBackdrop">
            <div class="rs-modal">
                <div class="rs-modal-header">
                    <h5><i class="bi bi-person-dash"></i> Remove student?</h5>
                    <button class="rs-modal-close" id="kickModalClose" title="Close">&times;</button>
                </div>
                <div class="rs-modal-body">
                    <p>You are removing <strong id="kickName">this student</strong>
                        from <strong>${classes.name}</strong>.</p>
                    <p class="rs-modal-hint">This only unenrolls the student from this class.</p>
                </div>
                <div class="rs-modal-footer">
                    <button class="rs-btn rs-btn-gray" id="kickCancel">Cancel</button>
                    <button class="rs-btn rs-btn-danger" id="kickConfirmBtn">
                        <i class="bi bi-check2-circle"></i> Remove
                    </button>
                </div>
            </div>
        </div>
    </c:if>

    <script>
        (function () {
            var isTeacher = ${isTeacher};
            var classId = ${classId};
            var ctx = '${pageContext.request.contextPath}';

            var q = document.getElementById('q');
            var total = document.getElementById('totalCount');
            var tbody = document.querySelector('#rosterTable tbody');

            function getRows() {
                return tbody ? Array.from(tbody.querySelectorAll('tr')) : [];
            }

            function filter() {
                var term = (q ? q.value : '').trim().toLowerCase();
                var visible = 0;
                getRows().forEach(function (r) {
                    var match = !term
                            || (r.dataset.name || '').includes(term)
                            || (r.dataset.email || '').includes(term)
                            || (r.dataset.username || '').includes(term);
                    r.style.display = match ? '' : 'none';
                    if (match)
                        visible++;
                });
                if (total)
                    total.textContent = String(visible);
            }

            if (q)
                q.addEventListener('input', filter, {passive: true});

            if (isTeacher) {
                var btnCopy = document.getElementById('btnCopyEmails');
                if (btnCopy) {
                    btnCopy.addEventListener('click', async function () {
                        var emails = getRows()
                                .filter(function (r) {
                                    return r.style.display !== 'none';
                                })
                                .map(function (r) {
                                    return r.dataset.email || '';
                                })
                                .filter(Boolean);
                        try {
                            await navigator.clipboard.writeText(emails.join(', '));
                            var orig = btnCopy.innerHTML;
                            btnCopy.innerHTML = '<i class="bi bi-clipboard-check-fill"></i> Copied!';
                            setTimeout(function () {
                                btnCopy.innerHTML = orig;
                            }, 1400);
                        } catch (_) {
                            alert('Cannot copy to clipboard.');
                        }
                    });
                }

                var currentUserId = null;
                var backdrop = document.getElementById('kickBackdrop');
                var nameEl = document.getElementById('kickName');
                var btnOk = document.getElementById('kickConfirmBtn');
                var btnCancel = document.getElementById('kickCancel');
                var btnClose = document.getElementById('kickModalClose');

                function openModal(userId, fullName) {
                    currentUserId = userId;
                    if (nameEl)
                        nameEl.textContent = fullName || 'this student';
                    if (backdrop)
                        backdrop.classList.add('is-open');
                }
                function closeModal() {
                    if (backdrop)
                        backdrop.classList.remove('is-open');
                    currentUserId = null;
                }

                document.addEventListener('click', function (e) {
                    var btn = e.target.closest('.rs-kick-btn');
                    if (btn)
                        openModal(btn.dataset.userid, btn.dataset.fullname);
                });
                if (btnClose)
                    btnClose.addEventListener('click', closeModal);
                if (btnCancel)
                    btnCancel.addEventListener('click', closeModal);
                if (backdrop)
                    backdrop.addEventListener('click', function (e) {
                        if (e.target === backdrop)
                            closeModal();
                    });
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape')
                        closeModal();
                });

                if (btnOk) {
                    btnOk.addEventListener('click', async function () {
                        if (!currentUserId)
                            return;
                        var fd = new FormData();
                        fd.append('classId', String(classId));
                        fd.append('userId', currentUserId);
                        try {
                            var resp = await fetch(ctx + '/classroom/student/expel', {
                                method: 'POST', body: fd,
                                credentials: 'same-origin',
                                headers: {'X-Requested-With': 'XMLHttpRequest'}
                            });
                            if (!resp.ok)
                                throw new Error('HTTP ' + resp.status);
                            var json = await resp.json();
                            if (!json || !json.ok)
                                throw new Error((json && json.error) || 'Kick failed');
                            var kicked = getRows().find(function (tr) {
                                var b = tr.querySelector('.rs-kick-btn');
                                return b && b.dataset.userid === currentUserId;
                            });
                            if (kicked)
                                kicked.remove();
                            closeModal();
                            filter();
                        } catch (err) {
                            console.error(err);
                            alert('Cannot remove student.');
                        }
                    });
                }
            }

            filter();
        })();
    </script>
