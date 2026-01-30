<%-- 
    Document   : student-list
    Created on : Jan 29, 2026, 10:49:35 PM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div>
            <div>
                <small>Admin • Students</small>
                <h1>${classes.name}</h1>
                <small>${classes.sumOfStudent} student</small>
            </div>${name}
            <a href="${pageContext.request.contextPath}/admin/class-list">Back</a>
        </div>
        <div>
            <div>
                <form action="${pageContext.request.contextPath}/admin/student-list" method="get">
                    <input type="search" name="search" value="${search}" placeholder="Search name/username/email">
                    <input type="hidden" name="classId" value="${classId}">
                    <button type="submit">Search</button>
                </form>
                <span>Showing <strong>${classes.sumOfStudent}</strong> of ${classes.sumOfStudent}</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>User</th>
                        <th>Email</th>
                        <th>Joined</th>
                        <th></th>
                    </tr> 
                </thead>
                <tbody>
                    <c:forEach items="${enrolls}" var="enroll">
                        <tr>
                            <td>${enroll.user.fullName}</td>
                            <td>${enroll.user.userName}</td>
                            <td>${enroll.user.email}</td>
                            <td>${enroll.joinedAt}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/admin/kick-student" method="post">
                                    <input type="hidden" name="userId" value="${enroll.userId}">
                                    <input type="hidden" name="classId" value="${classId}">
                                    <button type="submit">Kick</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach> 
                </tbody>
            </table>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/class-list">Back</a>
        </div>
    </body>
</html>
