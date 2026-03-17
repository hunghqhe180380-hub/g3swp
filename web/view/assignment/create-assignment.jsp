<%-- 
    Document   : list-assignment
    Created on : Mar 16, 2026, 5:49:00 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<html>
    <head>
        <title>Create Assignment</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icon -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

        <style>

            body{
                background:#f6f7fb;
            }

            /* HEADER */

            .page-header{
                background: linear-gradient(90deg,#1e5ed8,#1aa7c9);
                padding:40px;
                color:white;
            }

            .mode-btn{
                padding:10px 25px;
                border-radius:10px;
            }

            .mode-active{
                background:#2b67f6;
                color:white;
            }

            .card-custom{
                border-radius:14px;
            }

            .level-btn{
                width:45px;
            }

            .question-item{
                border-bottom:1px solid #eee;
                padding:15px;
            }

            .question-item:last-child{
                border-bottom:none;
            }

            .summary-box{
                background:#eef3fb;
            }

            .selected-box{
                background:white;
            }

            .add-group{
                border:2px dashed #cbd5e1;
                padding:18px;
                border-radius:12px;
                text-align:center;
                color:#4a6cf7;
                cursor:pointer;
            }
            .question-group{
                position: relative;
            }

            .remove-group{
                position: absolute;
                top: 12px;
                right: 12px;

                padding: 8px 14px;
                font-size: 14px;

                border-radius: 8px; /* bo góc nhẹ, không tròn */

                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
        </style>

    </head>

    <body>


        <!-- HEADER -->

        <div class="page-header d-flex justify-content-between align-items-center">

            <div>
                <h2 class="fw-bold">Create Assignment</h2>
                <div>ClassName * SubjectName</div>
            </div>

            <a href="${ctx}/assignment/view/list-assignment?classId=${requestScope.classId}" class="btn btn-light">
                <i class="bi bi-arrow-left"></i> Back
            </a>

        </div>


        <div class="container mt-4">
            <div id="autoMode">
                <!-- Form create auto mode -->
                <form action="${ctx}/assignment/manage/create" method="POST">

                    <div class="card card-custom shadow-sm p-4 mb-4">

                        <h5 class="fw-bold mb-3">Assignment Details</h5>

                        <div class="row mb-3">

                            <div class="col-md-8">
                                <label class="form-label">Exam Title</label>
                                <input name="title" class="form-control" placeholder="Enter assignment's title">
                            </div>

                        </div>
                        <div class="row mb-3">

                            <div class="col-md-6">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="2"
                                          placeholder="Enter description..."></textarea>
                            </div>

                            <div class="col-md-2">
                                <label class="form-label">Duration (minutes)</label>
                                <input name="durationMinutes" type="number" class="form-control" min="1">
                            </div>

                            <div class="col-md-2">
                                <label class="form-label">Max Attempts</label>
                                <input name="maxAttempts" type="number" class="form-control" min="1" value="1">
                            </div>

                        </div>

                        <div class="row mb-3">

                            <div class="col-md-3">
                                <label class="form-label">Open At</label>
                                <input name="openAt" type="datetime-local" class="form-control">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Close At</label>
                                <input name="closeAt" type="datetime-local" class="form-control">
                            </div>
                            <div class="col-md-3">
                                 <label class="form-label"></label>
                                 <input type="text" name="classId" value="${requestScope.classId}" hidden>
                                <input type="submit" class="btn btn-primary align-items-bottom" value="Create Assignment">
                            </div>
                        </div>
                    </div>
            </div>


    </body>
</html>