<%-- 
    Document   : list-assignment
    Created on : Mar 16, 2026, 5:49:00 AM
    Author     : hung2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%
List<Map<String,Object>> list = new ArrayList<>();

String[][] data = {
{"Math test","Mixed","Closed","2","2","15/03/2026 11:18"},
{"English Final Exam","Mixed","Closed","0","1","25/11/2025 23:59"},
{"English Final Exam","Mixed","Closed","0","10","16/11/2025 17:20"},
{"MON TOAN","Mixed","Closed","0","1","16/11/2025 15:13"},
{"Ngu Van Final Test","Mixed","Closed","0","1","20/11/2025 23:59"},
{"English Quick Quiz","MCQ","Closed","0","3","15/11/2025 23:59"},
{"Ngữ Văn Practice 1","MCQ","Open","1","20","30/11/2030 12:00"},
{"Tiếng Anh Practice 1","MCQ","Open","0","20","30/11/2030 10:00"},
{"Tiếng Anh Mid Test","Mixed","Closed","0","1","05/11/2025 10:00"},
{"Ngữ Văn Mid Test","Essay","Closed","0","1","03/11/2025 10:00"},
{"Ngữ Văn Test 2","MCQ","Open","1","1","13/10/2026 10:00"},
{"Tiếng Anh Test 1","MCQ","Closed","0","1","06/10/2025 10:00"}
};

for(String[] d:data){
Map<String,Object> m=new HashMap<>();
m.put("title",d[0]);
m.put("type",d[1]);
m.put("status",d[2]);
m.put("used",Integer.parseInt(d[3]));
m.put("max",Integer.parseInt(d[4]));
m.put("due",d[5]);
list.add(m);
}

request.setAttribute("listAssignment",list);
%>

<!DOCTYPE html>
<html>
    <head>

        <title>Assignments</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <style>

            body{
                background:#f5f7fb;
                font-family:Segoe UI;
            }

            /* HEADER */

            .header{
                background:linear-gradient(90deg,#5c6cff,#27c6da);
                padding:28px 40px;
                color:white;
            }

            /* SEARCH */

            .search-box{
                background:white;
                border-radius:10px;
                border:1px solid #e6e6e6;
                padding:10px 15px;
                width:360px;
                display:flex;
                align-items:center;
            }

            .search-box input{
                border:none;
                outline:none;
                width:100%;
                margin-left:8px;
            }

            /* FILTER */

            .filter button{
                border-radius:20px;
                font-size:13px;
                padding:4px 12px;
            }

            /* CARD */

            .assignment-card{

                background:white;
                border-radius:12px;
                border:1px solid #eee;
                padding:18px;
                position:relative;
                transition:.25s;

            }

            .assignment-card:hover{
                transform:translateY(-4px);
                box-shadow:0 6px 20px rgba(0,0,0,.08);
            }

            /* TOP BORDER */

            .card-top{

                position:absolute;
                top:0;
                left:0;
                width:100%;
                height:4px;
                background:linear-gradient(90deg,#5c6cff,#27c6da);
                border-radius:12px 12px 0 0;

            }

            /* BADGES */

            .badge-mixed{
                background:#ff6b35;
            }
            .badge-mcq{
                background:#5b8cff;
            }
            .badge-essay{
                background:#9c6bff;
            }

            .status-open{
                background:#e8f2ff;
                color:#2a7fff;
            }

            .status-closed{
                background:#f1f1f1;
                color:#777;
            }

            /* PROGRESS */

            .progress{
                height:5px;
                background:#f1f1f1;
            }

            .progress-bar{
                background:linear-gradient(90deg,#5c6cff,#27c6da);
            }

            .small-icon{
                font-size:13px;
                color:#777;
            }

        </style>

    </head>

    <body>

        <!-- HEADER -->

        <div class="header d-flex justify-content-between align-items-center">

            <div>

                <div style="opacity:.9">Assignments</div>
                <h3 class="fw-bold">Lớp D1</h3>

            </div>

            <a href="${ctx}/account/dashboard" class="btn btn-outline-light btn-sm">
                <i class="bi bi-arrow-left"></i> Back
            </a>

        </div>

        <div class="container mt-4">

            <!-- SEARCH + FILTER -->

            <div class="d-flex justify-content-between align-items-center mb-4">

                <div class="search-box">

                    <i class="bi bi-search"></i>

                    <input placeholder="Search by title or class...">

                </div>

                <div class="filter">

                    <button class="btn btn-light btn-sm">All</button>
                    <button class="btn btn-outline-primary btn-sm">Open</button>
                    <button class="btn btn-outline-warning btn-sm">Closed</button>

                    <div class="text-muted small text-center">Total: 13</div>

                </div>

            </div>

            <!-- LIST -->

            <div class="row g-3">

                <c:forEach items="${listAssignment}" var="a">

                    <div class="col-md-4">

                        <div class="assignment-card">

                            <div class="card-top"></div>

                            <div class="d-flex justify-content-between">

                                <div>

                                    <h6 class="fw-bold">

                                        <i class="bi bi-journal-text"></i>
                                        ${a.title}

                                        <c:choose>

                                            <c:when test="${a.type=='Mixed'}">
                                                <span class="badge badge-mixed">${a.type}</span>
                                            </c:when>

                                            <c:when test="${a.type=='MCQ'}">
                                                <span class="badge badge-mcq">${a.type}</span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-essay">${a.type}</span>
                                            </c:otherwise>

                                        </c:choose>

                                    </h6>

                                </div>

                                <span class="badge ${a.status=='Open'?'status-open':'status-closed'}">
                                    ${a.status}
                                </span>

                            </div>

                            <div class="small-icon mt-2">

                                <i class="bi bi-folder"></i> Lớp D1
                                &nbsp;&nbsp;

                                <i class="bi bi-clock"></i> Due: ${a.due}

                            </div>

                            <div class="text-muted small mt-2">

                                Attempts ${a.used} / ${a.max}

                            </div>

                            <div class="progress mt-1">

                                <div class="progress-bar" style="width:${a.used*100/a.max}%"></div>

                            </div>

                        </div>

                    </div>

                </c:forEach>

            </div>

        </div>

    </body>
</html>