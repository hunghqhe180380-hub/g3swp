<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Subject - POET</title>

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
                <h1 class="cc-title">Create Subject</h1>

                <div class="cc-grid">
                    <!-- FORM CARD -->
                    <section class="cc-card cc-card--form">
                        <!-- Fix giùm cái link cái -->
                        <form action="${ctx}/subject/manage/create" method="POST" id="createClassForm" novalidate> 
                            <div class="cc-field">
                                <label class="cc-label" for="subject">Subject's Name</label>
                                <input class="cc-input" type="text" id="subject" name="subjectName"
                                       placeholder="e.g. Tin Học"
                                       value="${subjectName}">  
                                    <div class="cc-error">${not empty listMSG.msgSubject ? listMSG.msgSubject : listMSG.msgSubjectSucces}</div>
                            </div>
                            <div class="cc-actions">
                                <button class="cc-btn cc-btn--primary" type="submit" name="action" value="create">Create</button>
                                <button class="cc-btn cc-btn--primary" type="submit" name="action" value="reset">Reset</button>
                                <a class="cc-btn cc-btn--ghost" href="${ctx}/subject/view/subject-list">Back</a>
                            </div>
                        </form>
                    </section>
                </div>
        </main>


    </body>
</html>