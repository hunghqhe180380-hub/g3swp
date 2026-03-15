<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="snState" value="${param.txtSubjectName != null ? param.txtSubjectName : '0'}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Subject - POET</title>

        <link rel="stylesheet" href="${ctx}/assets/css/admin-users.css">
    </head>

    <body>

        <header class="admin-topbar">
            <div class="admin-topbar__inner">
                <div class="admin-title">
                    <div class="admin-title__small">Administration</div>
                    <div class="admin-title__big">Manage Subject</div>
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
                        Subjects
                        <span class="count">(${fn:length(listSubject)})</span>
                    </h2>
                    <!-- Css cái này thành hình như nút button he =)) -->
                    <a href="${ctx}/subject/manage/create">Create New Subject</a>
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

                                            <form action="${ctx}/admin/edit-subject" method="get">
                                                <input type="hidden" name="id" value="${subject.id}">
                                                <button class="btn-act btn-act--blue">Edit</button>
                                            </form>

                                            <form action="${ctx}/admin/delete-subject" method="post">
                                                <input type="hidden" name="id" value="${subject.id}">
                                                <button class="btn-act btn-act--red">Delete</button>
                                            </form>

                                        </div>

                                    </td>

                                </tr>

                            </c:forEach>

                            <c:if test="${empty listSubject}">
                                <tr>
                                    <td colspan="6" class="empty">
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
                document.getElementById("txt" + f).value = 0;
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
</script>