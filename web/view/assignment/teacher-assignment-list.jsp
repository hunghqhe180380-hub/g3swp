<%-- 
    Document   : list-assignment
    Created on : Mar 16, 2026, 5:49:00 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
java.util.List<java.util.Map<String,Object>> listAssignment = new java.util.ArrayList<>();

java.util.Map<String,Object> a1 = new java.util.HashMap<>();
a1.put("id",1);
a1.put("title","Math test");
a1.put("description","Try your best");
a1.put("dueDate","15/03/2026 11:18");
a1.put("attempts",2);
a1.put("type","Mixed");

java.util.Map<String,Object> a2 = new java.util.HashMap<>();
a2.put("id",2);
a2.put("title","English Final Exam");
a2.put("description","Final English language test");
a2.put("dueDate","25/11/2025 23:59");
a2.put("attempts",1);
a2.put("type","Mixed");

java.util.Map<String,Object> a3 = new java.util.HashMap<>();
a3.put("id",3);
a3.put("title","English Final Exam");
a3.put("description","Final English language test");
a3.put("dueDate","16/11/2025 17:20");
a3.put("attempts",10);
a3.put("type","Mixed");

java.util.Map<String,Object> a4 = new java.util.HashMap<>();
a4.put("id",4);
a4.put("title","MON TOAN");
a4.put("description","123");
a4.put("dueDate","16/11/2025 15:13");
a4.put("attempts",1);
a4.put("type","Mixed");

java.util.Map<String,Object> a5 = new java.util.HashMap<>();
a5.put("id",5);
a5.put("title","Ngu Van Final Test");
a5.put("description","Essay exam");
a5.put("dueDate","20/11/2025 21:00");
a5.put("attempts",3);
a5.put("type","Mixed");

listAssignment.add(a1);
listAssignment.add(a2);
listAssignment.add(a3);
listAssignment.add(a4);
listAssignment.add(a5);

request.setAttribute("listAssignment",listAssignment);
request.setAttribute("classId",22);
request.setAttribute("className","D1");
%>

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
                padding:20px 40px;
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

        </style>

    </head>

    <body>

        <div class="header d-flex justify-content-between align-items-center">

            <div>
                <div style="font-size:14px">Assignment</div>
                <h3>Assignments • Lớp ${className}</h3>
            </div>

            <div>

                <a href="${ctx}/classroom/assignment/manage/create" class="btn btn-light me-2">
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

            <c:forEach items="${listAssignment}" var="a">

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

                                <i class="bi bi-calendar"></i> Due: ${a.dueDate}
                                &nbsp;&nbsp;

                                <i class="bi bi-arrow-repeat"></i> Attempts: ${a.attempts}

                                <span class="badge badge-type ms-2">
                                    ${a.type}
                                </span>

                            </div>

                        </div>

                        <div class="d-flex align-items-center">

                            <button class="btn btn-outline-primary btn-sm me-2">
                                <i class="bi bi-pencil"></i> Edit
                            </button>

                            <button class="btn btn-outline-secondary btn-sm me-2">
                                <i class="bi bi-people"></i> Submissions
                            </button>

                            <button class="btn btn-outline-danger btn-sm">
                                <i class="bi bi-trash"></i> Delete
                            </button>

                        </div>

                    </div>

                </div>

            </c:forEach>

        </div>

    </body>
</html>