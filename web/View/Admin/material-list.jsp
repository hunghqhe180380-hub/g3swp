<%-- 
    Document   : manage-material
    Created on : Jan 31, 2026, 10:18:50 PM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Classes Materials - POET</title>
    </head>
    <body>
        <div>
            <div>
                <div>
                    <small>Admin • Materials</small>
                    <h1><c:out value="${classes.name}"/></h1>
                    <small><c:out value="${classes.sum}"/> items</small>
                </div>
                <a href="${path}/admin/class-list">Back</a>
            </div>
            <div>
                <div>
                    <form action="${path}/admin/material-list" method="get">
                        <input type="search" name="search" value="<c:out value="${search}"/>" placeholder="Search by title,kind">
                        <input type="hidden" name="classId" value="<c:out value="${classId}"/>">
                        <button type="submit">Search</button>
                    </form>
                    <span>Showing <strong><c:out value="${classes.sum}"/></strong>
                        of <c:out value="${classes.sum}"/></span>
                </div>
                <div>
                    <table>
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Kind</th>                                
                                <th>Created</th>
                                <th></th>
                            </tr> 
                        </thead>
                        <tbody>
                            <c:forEach items="${materials}" var="material">
                                <tr>
                                    <td><c:out value="${material.title}"/></td>
                                    <td><c:out value="${material.provider}"/></td>                                    
                                    <td><c:out value="${material.createdAt}"/></td>
                                    <td>
                                        <form action="${path}/admin/delete-material" method="post">
                                            <input type="hidden" name="Id" value="<c:out value="${material.id}"/>">
                                            <input type="hidden" name="classId" value="<c:out value="${classId}"/>">
                                            <button type="submit">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach> 
                        </tbody>
                    </table>
                </div>
            </div>
            <div>
                <a href="${path}/admin/class-list">Back</a>
            </div>
        </div>
    </body>
</html>
