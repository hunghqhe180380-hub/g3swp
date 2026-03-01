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

        <jsp:include page="/View/common/header.jsp" />
        <h1>Create Classroom</h1>
        <form action="create" method="POST">
            <table border="1">
                <tbody>
                    <tr>
                        <td>Class name</td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="className"
                                   placeholder="e.g. Lớp 9"
                                   value="${className}">
                            <span>${listMSG.msgClassName}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Subject</td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="subject"
                                   placeholder="e.g. Tin Học"
                                   value="${subject}">
                            <span>${listMSG.msgSubject}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Student limit</td>
                    </tr>
                    <tr>
                        <td>
                            <input type="number" name="studentLimit"
                                   placeholder="e.g. 30"
                                   value="${studentLimit}">
                            <span>${listMSG.msgStudentLimit}</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="submit" value="Create">
                            <button>
                                <a href="${pageContext.request.contextPath}/account/dashboard">Cancel</a>
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </body>
</html>
