<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Assignment Management</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>

            body{
                background:#f5f6fa;
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

        <!-- HEADER -->
        <div class="header d-flex justify-content-between align-items-center">

            <div>
                <div style="font-size:14px">Assignment</div>
                <h3>Assignments • Lớp ${className}</h3>
            </div>

            <div>
                <a href="create-assignment?classId=${classId}" class="btn btn-light">
                    + Create assignment
                </a>

                <a href="teacher-home" class="btn btn-outline-light">
                    ← Back
                </a>
            </div>

        </div>


        <div class="container mt-4">

            <div class="mb-3">
                Class ID: ${classId}
            </div>


            <!-- LIST ASSIGNMENT -->
            <c:forEach items="${listAssignment}" var="a">

                <div class="card assignment-card p-3">

                    <div class="d-flex justify-content-between">

                        <!-- LEFT -->
                        <div>

                            <h5 class="fw-bold">${a.title}</h5>

                            <div class="text-muted mb-2">
                                ${a.description}
                            </div>

                            <div class="assignment-meta">

                                📁 Lớp ${className}
                                &nbsp;&nbsp;

                                📅 Due: ${a.dueDate}
                                &nbsp;&nbsp;

                                🔄 Attempts: ${a.attempts}

                                <span class="badge badge-type ms-2">
                                    ${a.type}
                                </span>

                            </div>

                        </div>


                        <!-- RIGHT BUTTON -->
                        <div class="d-flex align-items-center">

                            <a href="edit-assignment?id=${a.id}"
                               class="btn btn-outline-primary btn-sm me-2">
                                Edit
                            </a>

                            <a href="submissions?assignmentId=${a.id}"
                               class="btn btn-outline-secondary btn-sm me-2">
                                Submissions
                            </a>

                            <a href="delete-assignment?id=${a.id}"
                               class="btn btn-outline-danger btn-sm">
                                Delete
                            </a>

                        </div>

                    </div>

                </div>

            </c:forEach>

        </div>

    </body>
</html>