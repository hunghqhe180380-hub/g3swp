<%-- 
    Document   : manage-classroom
    Created on : Jan 27, 2026, 10:37:35 PM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>        
        <div>
            <small>Administration</small><br>
            <p><h1>Manage Classes</h1>        
            <a href="${pageContext.request.contextPath}/account/dashboard">Back</a></p>
        </div>
        <div>
            <h2>Classes (${fn:length(classes)})</h2>
            <form action="${pageContext.request.contextPath}/admin/class-list" method="get">
                <input type="search" name="search" value="${search}" placeholder="Search class/teacher/code">
                <button type="submit">Search</button>
            </form>
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
                            <strong>${cl.name}</strong><br>
                            <small>${cl.subject}</small>
                        </td>
                        <td>${cl.classCode}</td>
                        <td>${cl.teacherName}</td>
                        <td>${cl.sumOfStudent}</td>
                        <td>${cl.createdAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/material-list">Materials</a><br>
                            <a href="${pageContext.request.contextPath}/admin/">Assignments</a><br>
                            <a href="${pageContext.request.contextPath}/admin/student-list?classId=${cl.id}">Students</a><br>
                            <form action="${pageContext.request.contextPath}/admin/delete-class" method="post">
                                <input type="hidden" name="classId" value="${cl.id}">
                                <input type="hidden" name="pageIndex" value="${page.index}">
                                <button type="submit">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>            
            </table>
        </div>
        <c:if test="${page.index!=0}">
            <a href="${pageContext.request.contextPath}/admin/class-list?index=0<c:if test="${not empty search}">&search=${search}</c:if>">Home</a>
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${page.index-1}<c:if test="${not empty search}">&search=${search}</c:if>">Pre</a>
        </c:if>
        <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${index}<c:if test="${not empty search}">&search=${search}</c:if>">${index+1}</a>
        </c:forEach>
        <c:if test="${page.index!=page.totalPage-1}">
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${page.index+1}<c:if test="${not empty search}">&search=${search}</c:if>">Next</a>
            <a href="${pageContext.request.contextPath}/admin/class-list?index=${page.totalPage-1}<c:if test="${not empty search}">&search=${search}</c:if>">End</a>
        </c:if>
    </body>
</html>