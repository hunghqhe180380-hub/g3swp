<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

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
                                <th>Subject Name</th>
                                <th>Classes</th>
                                <th>Teachers</th>
                                <th>Active</th>
                                <th>Create At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach items="${listSubject}" var="subject">

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

            </div>
        </main>

    </body>
</html>