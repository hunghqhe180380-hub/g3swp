<%-- 
    Document   : edit
    Created on : Mar 1, 2026, 4:27:29 PM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Classroom - POET</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${ctx}/assets/css/edit-classroom.css">
</head>
<body>

    <!-- ===== HEADER ===== -->
    <div class="header">
        <div class="header__inner">
            <div>
                <div class="header__label">Teacher • Class</div>
                <h4 class="header__title">Edit: <c:out value="${classroom.name}"/></h4>
            </div>
            <a class="btn btn-back-header" href="${ctx}/teacher/dashboard">
                <i class="bi bi-arrow-left"></i> Back
            </a>
        </div>
    </div>

    <!-- ===== FORM ===== -->
    <div class="page">
        <div class="form-card">

            <c:if test="${not empty errorMessage}">
                <p class="error-text" style="margin-bottom:16px;">${errorMessage}</p>
            </c:if>

            <form action="${ctx}/classroom/manage/edit" method="post">
                <input type="hidden" name="classId" value="22">

                <div class="form-grid">

                    <div class="form-group">
                        <label for="name">Class name</label>
                        <input type="text" id="name" name="name"
                               value="<c:out value='${classroom.name}'/>" required>                        
                    </div>

                    <div class="form-group">
                        <label>Class code</label>
                        <input type="text" value="<c:out value='${classroom.classCode}'/>" disabled>
                        <span class="form-hint">Auto-generated. Not editable.</span>
                    </div>

                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <input type="text" id="subject" name="subject"
                               value="<c:out value='${classroom.subject}'/>">                        
                    </div>

                    <div class="form-group">
                        <label for="maxStudents">Max students</label>
                        <div class="input-group">
                            <span class="input-group__icon"><i class="bi bi-people"></i></span>
                            <input type="number" id="maxStudents" name="maxStudents"
                                   value="${classroom.maxStudent}" min="${classroom.sum}" max="100">
                        </div>
                        <span class="form-hint">
                            Current enrolled: <strong>${classroom.sum}</strong>. You cannot set a limit below this number.
                        </span>                        
                    </div>

                </div>

                <div class="btn-row">
                    <button type="submit" class="btn btn-save">Save changes</button>
                    <a class="btn btn-back" href="${ctx}/account/dashboard">Back</a>
                </div>
            </form>

        </div>
    </div>

</body>
</html>
