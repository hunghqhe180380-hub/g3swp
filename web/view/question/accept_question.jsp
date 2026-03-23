<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.net.URLDecoder"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="snState" value="${param.txtSubjectName != null ? param.txtSubjectName : '0'}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Question Bank - POET</title>

        <link rel="stylesheet" href="${ctx}/assets/css/admin-users.css">
    </head>

    <body>

        <header class="admin-topbar">
            <div class="admin-topbar__inner">
                <div class="admin-title">
                    <div class="admin-title__small">Administration</div>
                    <div class="admin-title__big">Question Bank</div>
                </div>

                <a class="btn-top btn-top--ghost" href="${ctx}/account/dashboard">
                    ← Back
                </a>
            </div>
        </header>

        <main class="page">
            <div class="wrap">

                <div class="section-head">

                    <h2 class="section-title">
                        Total Question
                        <span class="count">(${fn:length(listQuestion)})</span>
                    </h2>

                    <button type="button" class="btn-create-subject" id="openCreateSubjectModal">
                        <span class="btn-create-subject__icon">＋</span>
                        <span>Create New Subject</span>
                    </button>
                </div>

                <div class="card">

                    <table class="table">

                        <thead>
                            <tr>
                                <th>Code</th>
                                <th onclick="sort('SubjectName')" style="cursor:pointer">
                                    Subject Name
                                    <span id="iconSubjectName">
                                        <c:choose>
                                            <c:when test="${snState == '1'}">▲</c:when>
                                            <c:when test="${snState == '2'}">▼</c:when>
                                            <c:otherwise>⇅</c:otherwise>
                                        </c:choose>
                                    </span>
                                </th>
                                <th>Classes</th>
                                <th>Teachers</th>
                                <th>Active</th>
                                <th>Create At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach items="${listSubject}" var="subject" begin="${page.start}" end="${page.end}">

                                <tr>

                                    <td>
                                        <c:out value="${subject.id}"/>
                                    </td>

                                    <td>
                                        <c:out value="${subject.name}"/>
                                    </td>

                                    <td>
                                        <c:out value="${subject.totalClass}"/>
                                    </td>

                                    <td>
                                        <c:out value="${subject.totalTeacher}"/>
                                    </td>

                                    <td>
                                        <c:out value="${subject.isActive}"/>
                                    </td>

                                    <td>
                                        <c:out value="${subject.createAt}"/>
                                    </td>
                                    <td class="actions">

                                        <div class="btncol">

                                            <form action="${ctx}/subject/manage/toggle-status" method="post">
                                                <input type="hidden" name="id" value="${subject.id}">
                                                <input type="hidden" name="currentStatus" value="${subject.isActive}">

                                                <c:choose>
                                                    <c:when test="${subject.isActive == 1}">
                                                        <button class="btn-act btn-act--amber" type="submit">Deactivate</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn-act btn-act--green" type="submit">Activate</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>

                                            <form action="${ctx}/admin/delete-subject" method="post">
                                                <input type="hidden" name="id" value="${subject.id}">
                                                <button class="btn-act btn-act--red" type="submit">Delete</button>
                                            </form>

                                        </div>

                                    </td>

                                </tr>

                            </c:forEach>

                            <c:if test="${empty listSubject}">
                                <tr>
                                    <td colspan="7" class="empty">
                                        No subjects yet.
                                    </td>
                                </tr>
                            </c:if>

                        </tbody>

                    </table>

                </div>

                <div class="pager">                    
                    <c:url var="basePath" value="/subject/view/subject-list">
                        <c:if test="${not empty search}">
                            <c:param name="search" value="${search}"/>
                        </c:if>                        
                        <c:param name="txtSubjectName" value="${snState}"/>
                        <c:forEach items="${statusList}" var="s">
                            <c:param name="txtStatus" value="${s}"/>
                        </c:forEach>
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
            </div>
        </main>

        <!-- CREATE SUBJECT MODAL -->
        <div class="subject-modal ${param.modal eq 'create-subject' ? 'is-open' : ''}" id="createSubjectModal">
            <div class="subject-modal__dialog">
                <div class="subject-modal__header">
                    <div>
                        <div class="subject-modal__eyebrow">Administration</div>
                        <h3 class="subject-modal__title">Create New Subject</h3>
                    </div>

                    <button type="button" class="subject-modal__close" id="closeCreateSubjectModal">&times;</button>
                </div>

                <form action="${ctx}/subject/manage/create" method="post" class="subject-modal__body">
                    <div class="subject-modal__field">
                        <label for="subjectName">Subject name</label>
                        <input
                            id="subjectName"
                            name="subjectName"
                            type="text"
                            class="subject-modal__input"
                            placeholder="e.g. Tin học"
                            value="${fn:escapeXml(param.subjectName)}">
                    </div>

                    <c:if test="${not empty param.createError}">
                        <div class="subject-modal__alert subject-modal__alert--error">
                            ${param.createError}
                        </div>
                    </c:if>

                    <c:if test="${not empty param.createSuccess}">
                        <div class="subject-modal__alert subject-modal__alert--success">
                            ${param.createSuccess}
                        </div>
                    </c:if>

                    <div class="subject-modal__actions">
                        <button type="button" class="btn-modal btn-modal--ghost" id="cancelCreateSubjectModal">
                            Cancel
                        </button>
                        <button type="submit" class="btn-modal btn-modal--primary" name="action" value="create">
                            Create Subject
                        </button>
                    </div>
                </form>
            </div>
        </div>

    </body>
</html>
<script>
    function sort(x) {
        reset(x);

        let el = document.getElementById("txt" + x);
        let state = parseInt(el.value);
        if (isNaN(state))
            state = 0;

        let newState = (state + 1) % 3;
        el.value = newState;

        updateIcon(x, newState);
        document.getElementById("frmSort").submit();
    }

    function reset(x) {
        ["SubjectName"].forEach(f => {
            if (f !== x) {
                const item = document.getElementById("txt" + f);
                if (item) {
                    item.value = 0;
                }
                updateIcon(f, 0);
            }
        });
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
        const modal = document.getElementById('createSubjectModal');
        const openBtn = document.getElementById('openCreateSubjectModal');
        const closeBtn = document.getElementById('closeCreateSubjectModal');
        const cancelBtn = document.getElementById('cancelCreateSubjectModal');

        function openModal() {
            modal.classList.add('is-open');
            document.body.classList.add('modal-open');
        }

        function closeModal() {
            modal.classList.remove('is-open');
            document.body.classList.remove('modal-open');

            const url = new URL(window.location.href);
            url.searchParams.delete('modal');
            url.searchParams.delete('createError');
            url.searchParams.delete('createSuccess');
            url.searchParams.delete('subjectName');
            window.history.replaceState({}, '', url.toString());
        }

        if (openBtn) {
            openBtn.addEventListener('click', openModal);
        }

        if (closeBtn) {
            closeBtn.addEventListener('click', closeModal);
        }

        if (cancelBtn) {
            cancelBtn.addEventListener('click', closeModal);
        }

        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                closeModal();
            }
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modal.classList.contains('is-open')) {
                closeModal();
            }
        });

        if (modal.classList.contains('is-open')) {
            document.body.classList.add('modal-open');
        }
    })();
</script>
<style>
    body.modal-open{
        overflow: hidden;
    }

    .btn-create-subject{
        display:inline-flex;
        align-items:center;
        gap:10px;
        padding: 12px 18px;
        border:none;
        border-radius: 14px;
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        color:#fff;
        font-weight: 800;
        font-size: 14px;
        box-shadow: 0 14px 30px rgba(37,99,235,0.24);
        cursor:pointer;
        transition: .18s ease;
    }

    .btn-create-subject:hover{
        transform: translateY(-1px);
        box-shadow: 0 18px 34px rgba(37,99,235,0.28);
    }

    .btn-create-subject__icon{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        width: 22px;
        height: 22px;
        border-radius: 999px;
        background: rgba(255,255,255,0.18);
        font-size: 15px;
        line-height: 1;
    }

    .subject-modal{
        position: fixed;
        inset: 0;
        display: none;
        align-items: center;
        justify-content: center;
        padding: 24px;
        background: rgba(15,23,42,0.52);
        z-index: 1000;
    }

    .subject-modal.is-open{
        display: flex;
    }

    .subject-modal__dialog{
        width: 100%;
        max-width: 500px;
        background: #fff;
        border-radius: 22px;
        overflow: hidden;
        box-shadow: 0 30px 80px rgba(2,6,23,0.22);
        border: 1px solid #e5e7eb;
        animation: modalFadeIn .18s ease;
    }

    @keyframes modalFadeIn{
        from{
            opacity: 0;
            transform: translateY(8px) scale(.98);
        }
        to{
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .subject-modal__header{
        background: linear-gradient(90deg, #0ea5e9, #4f46e5);
        color: #fff;
        padding: 18px 20px 16px;
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap: 16px;
    }

    .subject-modal__eyebrow{
        font-size: 13px;
        color: rgba(255,255,255,0.86);
        margin-bottom: 4px;
    }

    .subject-modal__title{
        margin: 0;
        font-size: 24px;
        font-weight: 900;
        line-height: 1.1;
    }

    .subject-modal__close{
        border:none;
        background: transparent;
        color:#fff;
        font-size: 32px;
        line-height: 1;
        cursor:pointer;
        padding:0;
    }

    .subject-modal__body{
        padding: 20px;
    }

    .subject-modal__field{
        display:flex;
        flex-direction:column;
        gap: 8px;
    }

    .subject-modal__field label{
        font-size: 14px;
        font-weight: 800;
        color: var(--text);
    }

    .subject-modal__input{
        width:100%;
        padding: 12px 14px;
        border-radius: 12px;
        border: 1px solid #cbd5e1;
        outline:none;
        background:#fff;
        font-size: 14px;
        transition:.15s ease;
    }

    .subject-modal__input:focus{
        border-color: rgba(37,99,235,0.65);
        box-shadow: 0 0 0 4px rgba(37,99,235,0.12);
    }

    .subject-modal__alert{
        margin-top: 14px;
        padding: 12px 14px;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 700;
        line-height: 1.55;
    }

    .subject-modal__alert--error{
        background: rgba(239,68,68,0.10);
        color:#b91c1c;
        border:1px solid rgba(239,68,68,0.24);
    }

    .subject-modal__alert--success{
        background: rgba(34,197,94,0.10);
        color:#15803d;
        border:1px solid rgba(34,197,94,0.22);
    }

    .subject-modal__actions{
        display:flex;
        justify-content:flex-end;
        gap: 10px;
        margin-top: 18px;
        flex-wrap: wrap;
    }

    .btn-modal{
        min-width: 120px;
        height: 44px;
        border-radius: 12px;
        border: 1px solid transparent;
        font-weight: 800;
        cursor:pointer;
        transition: .15s ease;
    }

    .btn-modal--ghost{
        background:#fff;
        color:#334155;
        border-color:#cbd5e1;
    }

    .btn-modal--ghost:hover{
        border-color:#94a3b8;
    }

    .btn-modal--primary{
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        color:#fff;
        box-shadow: 0 10px 24px rgba(37,99,235,0.22);
    }

    .btn-modal--primary:hover{
        filter: brightness(1.03);
    }

    @media (max-width: 900px){
        .btn-create-subject{
            width: 100%;
            justify-content: center;
        }
    }

    @media (max-width: 640px){
        .subject-modal{
            padding: 14px;
        }

        .subject-modal__body{
            padding: 16px;
        }

        .subject-modal__actions{
            flex-direction: column-reverse;
        }

        .btn-modal{
            width: 100%;
        }
    }
</style>