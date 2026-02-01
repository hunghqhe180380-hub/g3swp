<%-- 
    Document   : manage-account
    Created on : Jan 26, 2026, 11:35:26 AM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Accounts - POET</title>
    </head>
    <body>
        <div>
            <div>
                <h1>Manage Account </h1>
                <a href="${path}/account/dashboard">Back</a>
            </div>
            <div>
                <div>
                    <h2>Account (${fn:length(users)})</h2>
                    <form action="${path}/admin/user-list" method="get">
                        <input type="search" name="search" value="<c:out value="${search}"/>" placeholder="Search name/username/email">
                        <button type="submit">Search</button>
                    </form>
                </div>
                <div>
                    <table>
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Account</th>
                                <th></th>
                            </tr> 
                        </thead>
                        <tbody>
                            <c:forEach items="${users}" var="user" begin="${page.start}" end="${page.end}">
                                <tr>
                                    <td>
                                        <strong><c:out value="${user.fullName}"/></strong><br>
                                        <small><c:out value="${user.userName}"/></small>
                                    </td>
                                    <td><c:out value="${user.email}"/></td>
                                    <td><c:out value="${user.role}"/></td>
                                    <td><c:out value="${user.accountCode}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.role == 'Admin'}">
                                                <span>Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${path}/admin/change-role" method="post">
                                                    <input type="hidden" name="userId" value="<c:out value="${user.userID}"/>">
                                                    <input type="hidden" name="pageIndex" value="<c:out value="${page.index}"/>">
                                                    <c:choose>
                                                        <c:when test="${user.role == 'Student'}">
                                                            <button type="submit">Promote -> Teacher</button>
                                                        </c:when>
                                                        <c:when test="${user.role == 'Teacher'}">
                                                            <button type="submit">Demote -> Student</button>
                                                        </c:when>                                   
                                                    </c:choose>
                                                </form>
                                                <form action="${path}/admin/delete-user" method="post">
                                                    <input type="hidden" name="userId" value="<c:out value="${user.userID}"/>">
                                                    <input type="hidden" name="pageIndex" value="<c:out value="${page.index}"/>">
                                                    <button type="submit">Delete</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>                            
                                    </td>
                                </tr>
                            </c:forEach> 
                        </tbody>
                    </table>
                </div>
                <div>
                    <c:set var="mark" value="${empty search ? '?': '&'}" />
                    <c:url var="basePath" value="/admin/user-list">                        
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
