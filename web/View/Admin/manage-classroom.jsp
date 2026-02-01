<%-- 
    Document   : manage-classroom
    Created on : Jan 27, 2026, 10:37:35 PM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Classes - POET</title>
    </head>
    <body>  
        <div>
            <div>
                <small>Administration</small><br>
                <p><h1>Manage Classes</h1>        
                <a href="${path}/account/dashboard">Back</a></p>
            </div>
            <div>
                <div>
                    <h2>Classes (${fn:length(classes)})</h2>
                    <form action="${path}/admin/class-list" method="get">
                        <input type="search" name="search" value="<c:out value="${search}"/>" placeholder="Search class/teacher/code">
                        <button type="submit">Search</button>
                    </form>
                </div>
                <div>
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
                                    <strong><c:out value="${cl.name}"/></strong><br>
                                    <small><c:out value="${cl.subject}"/></small>
                                </td>
                                <td><c:out value="${cl.classCode}"/></td>
                                <td><c:out value="${cl.teacherName}"/></td>
                                <td><c:out value="${cl.sum}"/></td>
                                <td><c:out value="${cl.createdAt}"/></td>
                                <td>
                                    <a href="${path}/admin/material-list?classId=${fn:escapeXml(cl.id)}">Materials</a><br>
                                    <a href="${path}/admin/assginment-list">Assignments</a><br>
                                    <a href="${path}/admin/student-list?classId=${fn:escapeXml(cl.id)}">Students</a><br>
                                    <form action="${path}/admin/delete-class" method="post">
                                        <input type="hidden" name="classId" value="<c:out value="${cl.id}"/>">
                                        <input type="hidden" name="pageIndex" value="<c:out value="${page.index}"/>">
                                        <button type="submit">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>            
                    </table>
                </div>
                <div>        
                    <c:set var="mark" value="${empty search ? '?': '&'}" />
                    <c:url var="basePath" value="/admin/class-list">                        
                        <c:if test="${not empty search}">
                            <c:param name="search" value="${search}"/>
                        </c:if>                                                
                    </c:url>
                    <c:if test="${page.index!=0}">
                        <a href="${basePath}${mark}index=0">Home</a>
                        <a href="${basePath}${mark}index=${page.index-1}">Pre</a>
                    </c:if>
                    <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
                        <a href="${basePath}${mark}index=${index}">${index+1}</a>
                    </c:forEach>
                    <c:if test="${page.index!=page.totalPage-1}">
                        <a href="${basePath}${mark}index=${page.index+1}">Next</a>
                        <a href="${basePath}${mark}index=${page.totalPage-1}">End</a>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>