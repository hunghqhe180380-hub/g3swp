<%-- 
    Document   : manage-classroom
    Created on : Jan 27, 2026, 10:37:35 PM
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
        <h1>Manage Classroom </h1>
        <table>
            <tr>
                <th>Class</th>
                <th>Code</th>
                <th>Teacher</th>
                <th>Students</th>
                <th>Created</th>
                <th></th>
            </tr>           
            <c:forEach items="${classes}" var="cl" begin="${page.start}" end="${page.end}">
                <tr>
                    <td>
                        <strong>${cl.name}</strong>
                        <small>${cl.subject}</small>
                    </td>
                    <td>${cl.classCode}</td>
                    <td>${cl.teacherName}</td>
                    <td>${cl.sumOfStudent}</td>
                    <td>${cl.createdAt}</td>
                    <td>
                        
                        <form action="${pageContext.request.contextPath}/admin/change-role" method="post">
                            <input type="hidden" name="classId" value="${cl.id}">
                            <input type="hidden" name="pageIndex" value="${page.index}">
                            <button type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>            
        </table>
        <c:if test="${page.index!=0}">
            <a href="${pageContext.request.contextPath}/admin/class-list?index=0">Home</a>
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${page.index-1}">Pre</a>
        </c:if>
        <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${index}">${index+1}</a>
        </c:forEach>
        <c:if test="${page.index!=page.totalPage-1}">
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${page.index+1}">Next</a>
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${page.totalPage-1}">End</a>
        </c:if>
</body>
</html>