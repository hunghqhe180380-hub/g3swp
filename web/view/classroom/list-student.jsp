<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="isStaff" value="${fn:toUpperCase(sessionScope.user.role) == 'TEACHER'|| fn:toUpperCase(sessionScope.user.role) == 'ADMIN'}" />
<c:set var="isAdmin" value="${fn:toUpperCase(sessionScope.user.role) == 'ADMIN'}" />
<c:set var="isTeacher" value="${fn:toUpperCase(sessionScope.user.role) == 'TEACHER'}" />
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="fnState" value="${param.txtFullName != null ? param.txtFullName : '0'}"/>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Class Students - POET</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link rel="stylesheet" href="${ctx}/assets/css/list-student.css">
        <style>
            /* Pager */
            .pager{
                margin-top: 14px;
                display:flex;
                gap:6px;
                flex-wrap:wrap;
                align-items:center;
            }
            .pg{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                min-width:36px;
                height:36px;
                padding:0 10px;
                border-radius:8px;
                border:1px solid #dee2e6;
                background:#fff;
                font-size:14px;
                font-weight:700;
                color:#334155;
                text-decoration:none;
                transition:border-color .12s,background .12s,color .12s;
                user-select:none;
            }
            .pg:hover{
                border-color:#94a3b8;
                color:#0f172a;
            }
            .pg.is-active{
                background:#2563eb;
                border-color:#2563eb;
                color:#fff;
            }
            /* Restore button */
            .rs-btn-restore-outline{
                background: transparent;
                border-color: #198754;
                color: #198754;
            }
            .rs-btn-restore-outline:hover{
                background: #198754;
                color: #fff;
            }
            .rs-btn-restore{
                background: #198754;
                border-color: #198754;
                color: #fff;
            }
            .rs-btn-restore:hover{
                background: #157347;
                border-color: #146c43;
            }
            .rs-modal-header.is-restore{
                background: #198754;
            }
        </style>
    </head>
    <body>
        <!-- ===== HEADER ===== -->
        <div class="rs-header">
            <div class="rs-header-inner">
                <div class="rs-header-meta">
                    <div class="rs-header-label">
                        <c:choose>
                            <c:when test="${isAdmin}">Admin</c:when>
                            <c:when test="${isTeacher}">Teacher</c:when>
                            <c:otherwise>Student</c:otherwise>
                        </c:choose>
                        &bull; Student List
                    </div>
                    <h4 class="rs-header-title">
                        ${classes.name} <span class="rs-code">&bull; ${classes.subjectName}</span>
                    </h4>
                </div>

                <div class="rs-header-actions">
                    <c:if test='${not isAdmin}'>
                        <a class="rs-btn rs-btn-slate"
                           href="${ctx}/material/view/material-list?classId=${classId}">
                            <i class="bi bi-files"></i> Materials
                        </a>
                        <a class="rs-btn rs-btn-slate"
                           href="${ctx}">
                            <i class="bi bi-clipboard2-check"></i> Assignments
                        </a>
                    </c:if>
                    <c:choose>
                        <c:when test="${isAdmin}">
                            <a class="rs-btn rs-btn-outline-light"
                               href="${ctx}/classroom/view/class-list">
                                <i class="bi bi-arrow-left"></i> Back
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="rs-btn rs-btn-outline-light"
                               href="${ctx}/account/dashboard">
                                <i class="bi bi-arrow-left"></i> Back
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <!-- /HEADER -->

        <!-- ===== MAIN CONTENT ===== -->
        <div class="section-shell">            

            <!-- Toolbar -->
            <div class="rs-toolbar">
                <div class="rs-search">
                    <form action="${ctx}/classroom/view/student-list" method="get" id="frmSearch" style="display:contents">
                        <span class="rs-search-icon"><i class="bi bi-search"></i></span>
                        <input id="q" type="text" name="txtSearch"
                               placeholder="Search name<c:if test='${isStaff}'>, username</c:if> or email…"
                               value="${fn:escapeXml(param.txtSearch)}">
                        <select name="txtStatus" onchange="this.form.submit()" style="border:none;border-left:1px solid #dee2e6;padding:0 8px;outline:none;cursor:pointer;background:transparent;font-size:14px;color:#495057;">
                            <option value="">All</option>
                            <option value="0" ${param.txtStatus == '0' ? 'selected' : ''}>Active</option>
                            <option value="1" ${param.txtStatus == '1' ? 'selected' : ''}>Deactive</option>
                        </select>
                        <input type="hidden" name="classId" value="${classId}">
                    </form>
                </div>

                <form action="${ctx}/classroom/view/student-list" method="get" id="frmSort">
                    <input type="hidden" name="txtSearch" value="${fn:escapeXml(param.txtSearch)}">
                    <input type="hidden" name="txtStatus" value="${fn:escapeXml(param.txtStatus)}">
                    <input type="hidden" id="txtFullName" name="txtFullName" value="<c:out value="${param.txtFullName != null ? param.txtFullName : 0}"/>">
                    <input type="hidden" id="txtJoined"   name="txtJoined"   value="<c:out value="${param.txtJoined   != null ? param.txtJoined   : 0}"/>">
                    <input type="hidden" name="classId" value="${classId}">
                </form>

                <div class="rs-toolbar-right">
                    <c:if test="${isStaff}">
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
                                    <c:if test="${isStaff}"><th style="width:44px"></th></c:if>
                                        <th onclick="sort('FullName')" style="cursor:pointer">
                                            Name
                                            <span id="iconFullName">
                                            <c:choose>
                                                <c:when test="${fnState == '1'}">▲</c:when>
                                                <c:when test="${fnState == '2'}">▼</c:when>
                                                <c:otherwise>⇅</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </th>
                                    <c:if test="${isStaff}"><th>Username</th></c:if>
                                        <th>Email</th>
                                        <th>Phone</th>
                                    <c:if test="${isAdmin}"><th>Account</th></c:if>                                        
                                    <c:if test="${isStaff}"><th>Role</th></c:if>
                                        <th>Joined</th>
                                    <c:if test="${isStaff}">
                                        <th style="width:45px"><c:if test="${isAdmin}">Status</c:if></th>
                                    </c:if>
                                    <c:if test="${isAdmin}"><th style="width:45px"></th></c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="s" items="${enrolls}" varStatus="loop" begin="${page.start}" end="${page.end}">
                                    <c:set var="fullName"    value="${not empty s.user.fullName    ? s.user.fullName    : '(unknown)'}" />
                                    <c:set var="userName"    value="${not empty s.user.userName    ? s.user.userName    : ''}" />
                                    <c:set var="email"       value="${not empty s.user.email       ? s.user.email       : ''}" />
                                    <c:set var="phone"       value="${not empty s.user.phoneNumber ? s.user.phoneNumber : ''}" />
                                    <c:set var="account"     value="${not empty s.user.accountCode ? s.user.accountCode : ''}" />
                                    <c:set var="roleInClass" value="${not empty s.roleInClass      ? s.roleInClass      : 'Student'}" />
                                    <c:set var="avatarUrl"   value="${not empty s.user.urlImgProfile
                                                                      ? ctx.concat(s.user.urlImgProfile)
                                                                      : ctx.concat('/uploads/avatars/avatarDefault.png')}" />

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
                                        <c:if test="${isStaff}">
                                            <td class="rs-td-num">
                                                ${loop.index + 1}
                                            </td>
                                        </c:if>

                                        <%-- Col 2: avatar + tên --%>
                                        <td>
                                            <div class="rs-name-cell">
                                                <img src="${avatarUrl}" alt="avatar"
                                                     class="rs-avatar-img" loading="lazy"
                                                     onerror="this.onerror=null;this.src='${ctx}/uploads/avatars/avatarDefault.png'">
                                                <div>
                                                    <div class="rs-name rs-truncate" title="${fullName}">${fullName}</div>
                                                    <c:if test="${isStaff}">
                                                        <div class="rs-name-sub rs-truncate" title="${email}">${email}</div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>

                                        <%-- Username: Teacher only --%>
                                        <c:if test="${isStaff}">
                                            <td class="rs-truncate" title="${userName}">${userName}</td>
                                        </c:if>

                                        <%-- Email --%>
                                        <td class="rs-truncate">
                                            <a class="rs-mail" href="mailto:${email}" title="${email}">${email}</a>
                                        </td>

                                        <%-- Phone --%>
                                        <td class="rs-td-muted rs-truncate" title="${phone}">${phone}</td>

                                        <%-- Account code --%>
                                        <c:if test="${isAdmin}">
                                            <td><code class="rs-code-badge">${account}</code></td>
                                            </c:if>

                                        <%-- Role pill: Teacher only --%>
                                        <c:if test="${isStaff}">
                                            <td><span class="${roleCls}">${roleInClass}</span></td>
                                            </c:if>

                                        <%-- Joined --%>
                                        <td class="rs-td-muted">
                                            ${s.joinedAt}
                                        </td>

                                        <%-- Kick/Restore: Teacher only --%>
                                        <c:if test="${isStaff}">
                                            <td style="text-align:right">                                            
                                                <c:choose>
                                                    <c:when test="${s.status == 1}">
                                                        <button type="button"
                                                                class="rs-btn rs-btn-restore-outline rs-action-btn"
                                                                data-action="restore"
                                                                data-userid="${s.userId}"
                                                                data-fullname="${fullName}">
                                                            <i class="bi bi-person-check"></i> Restore
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button"
                                                                class="rs-btn rs-btn-danger-outline rs-action-btn"
                                                                data-action="kick"
                                                                data-userid="${s.userId}"
                                                                data-fullname="${fullName}">
                                                            <i class="bi bi-person-dash"></i> Kick
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </c:if>
                                            
                                        <c:if test="${isAdmin}">
                                            <td style="text-align: center; vertical-align: middle;">
                                                <form action="${ctx}/classroom/manage/delete-student" method="post"
                                                      style="margin: 0; display: inline-block;"
                                                      onsubmit="return confirm('WARNING: Are you sure you want to PERMANENTLY delete this student? This action cannot be undone.');">
                                                    <input type="hidden" name="userId" value="<c:out value='${s.userId}'/>">
                                                    <input type="hidden" name="classId" value="<c:out value='${classId}'/>">

                                                    <button class="rs-btn rs-btn-danger-outline" type="submit" title="Delete Permanently">
                                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                             stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                        <polyline points="3 6 5 6 21 6"></polyline>
                                                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                        <line x1="10" y1="11" x2="10" y2="17"></line>
                                                        <line x1="14" y1="11" x2="14" y2="17"></line>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </td>                                            
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- PAGING -->
            <c:if test="${not empty enrolls}">
                <div class="pager">
                    <c:url var="basePath" value="/classroom/view/student-list">
                        <c:param name="classId" value="${classId}"/>
                        <c:if test="${not empty param.txtSearch}">
                            <c:param name="txtSearch" value="${param.txtSearch}"/>
                        </c:if>
                        <c:if test="${not empty param.txtStatus}">
                            <c:param name="txtStatus" value="${param.txtStatus}"/>
                        </c:if>
                    </c:url>

                    <c:if test="${page.index!=0}">
                        <a class="pg" href="${basePath}&index=0">&laquo;</a>
                        <a class="pg" href="${basePath}&index=${page.index-1}">&lsaquo;</a>
                    </c:if>

                    <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
                        <a class="pg ${index==page.index ? 'is-active' : ''}"
                           href="${basePath}&index=${index}">
                            ${index+1}
                        </a>
                    </c:forEach>

                    <c:if test="${page.index!=page.totalPage-1}">
                        <a class="pg" href="${basePath}&index=${page.index+1}">&rsaquo;</a>
                        <a class="pg" href="${basePath}&index=${page.totalPage-1}">&raquo;</a>
                    </c:if>
                </div>
            </c:if>
        </div>
        <!-- /MAIN CONTENT -->

        <!-- ===== KICK MODAL — vanilla JS ===== -->
        <c:if test="${isStaff}">
            <div class="rs-modal-backdrop" id="kickBackdrop">
                <div class="rs-modal">
                    <div class="rs-modal-header" id="kickModalHeader">
                        <h5 id="kickModalTitle"><i class="bi bi-person-dash"></i> Remove student?</h5>
                        <button class="rs-modal-close" id="kickModalClose" title="Close">&times;</button>
                    </div>
                    <div class="rs-modal-body">
                        <p id="kickModalDesc">
                            You are removing <strong id="kickName">this student</strong>
                            from <strong>${classes.name}</strong>.
                        </p>
                        <p class="rs-modal-hint" id="kickModalHint">This only unenrolls the student from this class.</p>
                    </div>
                    <div class="rs-modal-footer">
                        <button class="rs-btn rs-btn-gray" id="kickCancel">Cancel</button>  
                        <form action="#" method="POST" id="kickActionForm">                        
                            <button class="rs-btn rs-btn-danger" id="kickConfirmBtn" type="button">
                                <i class="bi bi-check2-circle"></i> Confirm
                            </button>   
                        </form>
                    </div>
                </div>
            </div>
        </c:if>
    </body>
</html>
<script>
    function sort(x) {
        ["FullName", "Joined"].forEach(f => {
            if (f !== x) {
                document.getElementById("txt" + f).value = 0;
                updateIcon(f, 0);
            }
        });

        let el = document.getElementById("txt" + x);
        let state = parseInt(el.value);
        if (isNaN(state))
            state = 0;
        let newState = (state + 1) % 3;
        el.value = newState;
        updateIcon(x, newState);

        // Keep current search term in the sort form
        var searchInput = document.getElementById("q");
        var sortForm = document.getElementById("frmSort");
        if (sortForm) {
            var searchHidden = sortForm.querySelector('input[name="txtSearch"]');
            if (searchHidden)
                searchHidden.value = searchInput ? searchInput.value.trim() : '';
            var statusSelect = document.querySelector('#frmSearch select[name="txtStatus"]');
            var statusHidden = sortForm.querySelector('input[name="txtStatus"]');
            if (statusHidden && statusSelect)
                statusHidden.value = statusSelect.value;
            sortForm.submit();
        }
    }

    function updateIcon(field, state) {
        if (!field || !state)
            return;
        const icon = document.getElementById("icon" + field);
        if (!icon)
            return;
        switch (state) {
            case 1:
                icon.textContent = "▲";
                break;
            case 2:
                icon.textContent = "▼";
                break;
            default:
                icon.textContent = "⇅";
        }
    }
    function updateIcon(field, state) {
        const icon = document.getElementById("icon" + field);
        if (!icon)
            return;
        switch (state) {
            case 1:
                icon.textContent = "▲";
                break;
            case 2:
                icon.textContent = "▼";
                break;
            default:
                icon.textContent = "⇅";
        }
    }
    (function () {
        var isStaff = ${not empty isStaff ? isStaff : false};
        var classId = '${classId}';
        var ctx = '${pageContext.request.contextPath}';

        var tbody = document.querySelector('#rosterTable tbody');

        function getRows() {
            return tbody ? Array.from(tbody.querySelectorAll('tr')) : [];
        }

        if (isStaff) {
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
            var currentAction = 'kick';
            var backdrop = document.getElementById('kickBackdrop');
            var nameEl = document.getElementById('kickName');
            var btnOk = document.getElementById('kickConfirmBtn');
            var btnCancel = document.getElementById('kickCancel');
            var btnClose = document.getElementById('kickModalClose');
            var headerEl = document.getElementById('kickModalHeader');
            var titleEl = document.getElementById('kickModalTitle');
            var descEl = document.getElementById('kickModalDesc');
            var hintEl = document.getElementById('kickModalHint');
            var actionForm = document.getElementById('kickActionForm');

            function setMode(mode) {
                currentAction = mode === 'restore' ? 'restore' : 'kick';
                var isRestore = currentAction === 'restore';
                if (headerEl)
                    headerEl.classList.toggle('is-restore', isRestore);
                if (titleEl)
                    titleEl.innerHTML = isRestore
                            ? '<i class="bi bi-person-check"></i> Restore student?'
                            : '<i class="bi bi-person-dash"></i> Remove student?';
                if (descEl)
                    descEl.innerHTML = isRestore
                            ? 'You are restoring <strong id="kickName">this student</strong> to <strong>${classes.name}</strong>.'
                            : 'You are removing <strong id="kickName">this student</strong> from <strong>${classes.name}</strong>.';
                if (hintEl)
                    hintEl.textContent = isRestore
                            ? 'This will re-enroll the student to this class.'
                            : 'This only unenrolls the student from this class.';
                if (btnOk) {
                    btnOk.classList.toggle('rs-btn-danger', !isRestore);
                    btnOk.classList.toggle('rs-btn-restore', isRestore);
                    btnOk.innerHTML = isRestore
                            ? '<i class="bi bi-check2-circle"></i> Restore'
                            : '<i class="bi bi-check2-circle"></i> Remove';
                }
                if (actionForm) {
                    actionForm.action = isRestore
                            ? (ctx + '/classroom/manage/restore-student')
                            : (ctx + '/classroom/manage/expel');
                }
            }

            function openModal(userId, fullName, mode) {
                setMode(mode);
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
                currentAction = 'kick';
            }

            document.addEventListener('click', function (e) {
                var btn = e.target.closest('.rs-action-btn');
                if (btn)
                    openModal(btn.dataset.userid, btn.dataset.fullname, btn.dataset.action);
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
                    if (!currentUserId || !actionForm)
                        return;
                    try {
                        // Assign classId
                        var inputClass = actionForm.querySelector('input[name="classId"]');
                        if (!inputClass) {
                            inputClass = document.createElement('input');
                            inputClass.type = 'hidden';
                            inputClass.name = 'classId';
                            actionForm.appendChild(inputClass);
                        }
                        inputClass.value = String(classId);

                        // Assign userId
                        var inputUser = actionForm.querySelector('input[name="userId"]');
                        if (!inputUser) {
                            inputUser = document.createElement('input');
                            inputUser.type = 'hidden';
                            inputUser.name = 'userId';
                            actionForm.appendChild(inputUser);
                        }
                        inputUser.value = currentUserId;
                        actionForm.submit();
                        closeModal();
                    } catch (err) {
                        console.error(err);
                        alert(currentAction === 'restore' ? 'Cannot restore student.' : 'Cannot remove student.');
                    }
                });
            }
        }

    })();
</script>
