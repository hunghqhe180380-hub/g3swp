<%-- 
    Document   : list-assignment
    Created on : Mar 16, 2026, 5:49:00 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Assignment Management</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

        <style>

            body{
                background:#f5f6fa;
                font-family: Arial;
            }

            .header{
                background: linear-gradient(90deg,#6a5af9,#2ec5ce);
                color:white;
                padding:15px 40px;
            }

            .assignment-card{
                border-radius:10px;
                border:1px solid #e0e0e0;
                margin-bottom:20px;
                position:relative;
                overflow:hidden;
                transition:0.2s;
            }

            .assignment-card:hover{
                transform:translateY(-5px);
                box-shadow:0 10px 25px rgba(0,0,0,0.15);
            }

            .assignment-card::before{
                content:"";
                height:4px;
                width:100%;
                background: linear-gradient(90deg,#6a5af9,#2ec5ce);
                position:absolute;
                top:0;
                left:0;
            }

            .assignment-meta{
                color:#777;
                font-size:14px;
            }

            .badge-type{
                background:#eee;
                color:#555;
            }

            .empty-wrapper{
                min-height:70vh;

                display:flex;
                align-items: center;
                justify-content:center;

                padding:20px;
            }

            .empty-screen{

                width:780px;
                max-width:95%;

                background:white;

                border-radius:18px;

                padding:100px 60px;   /* tăng chiều cao */

                min-height:420px;     /* đảm bảo card cao */

                text-align:center;

                border:1px solid #e9ecef;

                box-shadow:
                    0 25px 50px rgba(0,0,0,0.06);
            }

            .empty-icon{

                width:100px;
                height:100px;

                margin:auto;
                margin-bottom:30px;

                display:flex;
                align-items:center;
                justify-content:center;

                border-radius:20px;

                background:white;

                border:3px solid #2563eb;

                color:#2563eb;

                font-size:44px;

                box-shadow:
                    0 8px 20px rgba(37,99,235,0.15);
            }

            .empty-screen h3{
                font-weight:700;
                margin-bottom:12px;
            }

            .empty-screen p{
                font-size:16px;
                color:#6c757d;
                margin-bottom:30px;
            }

            .empty-screen .btn{
                padding:12px 28px;
                font-weight:500;
                border-radius:10px;
            }

        </style>

    </head>

    <body>

        <div class="header d-flex justify-content-between align-items-center">

            <div>
                <div style="font-size:14px">Assignment</div>
                <h3>Assignments • Class ${classroom.name}</h3>
            </div>

            <div>

                <a href="${ctx}/assignment/manage/create?classId=${requestScope.classId}" class="btn btn-light me-2">
                    <i class="bi bi-plus-lg"></i> Create assignment
                </a>

                <a href="${ctx}/account/dashboard" class="btn btn-outline-light">
                    <i class="bi bi-arrow-left"></i> Back
                </a>

            </div>

        </div>

        <div class="container mt-4">

            <div class="mb-3">
                <strong>Class ID:</strong> ${classId}
            </div>
            <c:choose>

                <c:when test="${empty listAssignment}">

                    <div class="empty-wrapper">

                        <div class="empty-screen">

                            <div class="empty-icon">
                                <i class="bi bi-clipboard-check"></i>
                            </div>

                            <h5>No assignments yet</h5>

                            <p class="text-muted">
                                Create your first assignment for this class
                            </p>

                            <a href="${ctx}/assignment/manage/create?classId=${requestScope.classId}" class="btn btn-primary">
                                <i class="bi bi-plus-lg"></i>
                                Create assignment
                            </a>

                        </div>

                    </div>


                </c:when>

                <c:otherwise>

                    <!-- bảng assignment thật -->
                    <c:forEach items="${requestScope.listAssignment}" var="a">

                        <div class="card assignment-card p-3">

                            <div class="d-flex justify-content-between">

                                <div>

                                    <h5 class="fw-bold">${a.title}</h5>

                                    <div class="text-muted mb-2">
                                        ${a.description}
                                    </div>

                                    <div class="assignment-meta">

                                        <i class="bi bi-folder"></i> Class ${className}
                                        &nbsp;&nbsp;

                                        <i class="bi bi-calendar"></i> Due: ${a.closeAt}
                                        &nbsp;&nbsp;

                                        <i class="bi bi-arrow-repeat"></i> Attempts: ${a.maxAttempts}

                                        <span class="badge badge-type ms-2">
                                            <c:if test="${a.type == 1}">
                                                MCQ
                                            </c:if>
                                            <c:if test="${a.type == 2}">
                                                Essay
                                            </c:if>
                                            <c:if test="${a.type == 3}">
                                                Mixed
                                            </c:if>
                                        </span>

                                    </div>

                                </div>

                                <div class="d-flex align-items-center">

                                    <a href="${ctx}/assignment/view/question?classId=${requestScope.classId}&assignmentId=${a.id}" class="btn btn-outline-primary btn-sm me-2">
                                        <i class="bi bi-pencil"></i> Detail
                                    </a>
                                    
                                    <a href="${ctx}/assignment/view/submission?classId=${requestScope.classId}&assignmentId=${a.id}" class="btn btn-outline-secondary btn-sm me-2">
                                        <i class="bi bi-people"></i> Submissions
                                    </a>

                                    <button class="btn btn-outline-danger btn-sm">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>

                                </div>

                            </div>

                        </div>

                    </c:forEach>

                </c:otherwise>

            </c:choose>


        </div>

    </body>
</html>