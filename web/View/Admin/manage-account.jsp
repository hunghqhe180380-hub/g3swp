<%-- 
    Document   : manage-account
    Created on : Jan 26, 2026, 11:35:26 AM
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div>
            <h1>Manage Account </h1>
            <a href="${pageContext.request.contextPath}/account/dashboard">Back</a>
        </div>
        <div>
            <h2>Account (${fn:length(users)})</h2>
            <form action="${pageContext.request.contextPath}/admin/user-list" method="get">
                <input type="search" name="search" value="${search}" placeholder="Search name/username/email">
                <button type="submit">Search</button>
            </form>
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
                                <strong>${user.fullName}</strong><br>
                                <small>${user.userName}</small>
                            </td>
                            <td>${user.email}</td>
                            <td>${user.role}</td>
                            <td>${user.accountCode}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role == 'Admin'}">
                                        <span>Admin</span>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/admin/change-role" method="post">
                                            <input type="hidden" name="userId" value="${user.userID}">
                                            <input type="hidden" name="pageIndex" value="${page.index}">
                                            <c:choose>
                                                <c:when test="${user.role == 'Student'}">
                                                    <button type="submit">Promote -> Teacher</button>
                                                </c:when>
                                                <c:when test="${user.role == 'Teacher'}">
                                                    <button type="submit">Demote -> Student</button>
                                                </c:when>                                   
                                            </c:choose>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/delete-user" method="post">
                                            <input type="hidden" name="userId" value="${user.userID}">
                                            <input type="hidden" name="pageIndex" value="${page.index}">
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
        <c:if test="${page.index!=0}">
            <a href="${pageContext.request.contextPath}/admin/user-list?index=0<c:if test="${not empty search}">&search=${search}</c:if>">Home</a>
            <a href="${pageContext.request.contextPath}/admin/user-list?index=${page.index-1}<c:if test="${not empty search}">&search=${search}</c:if>">Pre</a>
        </c:if>
        <c:forEach var="index" begin="${page.pageStart}" end="${page.pageEnd}">
            <a href="${pageContext.request.contextPath}/admin/user-list?index=${index}<c:if test="${not empty search}">&search=${search}</c:if>">${index+1}</a>
        </c:forEach>
        <c:if test="${page.index!=page.totalPage-1}">
            <a href="${pageContext.request.contextPath}/admin/user-list?index=${page.index+1}<c:if test="${not empty search}">&search=${search}</c:if>">Next</a>
            <a href="${pageContext.request.contextPath}/admin/user-list?index=${page.totalPage-1}<c:if test="${not empty search}">&search=${search}</c:if>">End</a>
        </c:if>
    </body>
</html>