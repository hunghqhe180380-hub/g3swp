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
        <title>Create Exam</title>

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

        </style>

    </head>

    <body>


        <!-- HEADER -->

        <div class="page-header d-flex justify-content-between align-items-center">

            <div>
                <h2 class="fw-bold">Create Exam</h2>
                <div>Class 22</div>
            </div>

            <a href="${ctx}/classroom/assignment/view/list-assingment" class="btn btn-light">
                <i class="bi bi-arrow-left"></i> Back
            </a>

        </div>


        <div class="container mt-4">

            <!-- MODE SWITCH -->

            <div class="mb-4">

                <button id="autoBtn" class="btn mode-btn mode-active" onclick="switchMode('auto')">
                    Auto Mode
                </button>

                <button id="manualBtn" class="btn mode-btn btn-outline-secondary" onclick="switchMode('manual')">
                    Manual Mode
                </button>

            </div>


            <!-- ================= AUTO MODE ================= -->

            <div id="autoMode">

                <div class="card card-custom shadow-sm p-4 mb-4">

                    <h5 class="fw-bold mb-3">Exam Details</h5>

                    <div class="row mb-3">

                        <div class="col-md-8">
                            <label class="form-label">Exam Title</label>
                            <input class="form-control" placeholder="Enter exam title">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Total Points (Max)</label>
                            <input class="form-control" value="100">
                        </div>

                    </div>

                    <div class="alert alert-secondary d-flex justify-content-between">

                        <div>
                            Current Total<br>
                            <strong>100 pts</strong>
                        </div>

                        <div>
                            Max Points<br>
                            <strong>100 pts</strong>
                        </div>

                    </div>

                </div>


                <!-- QUESTION GROUP -->

                <div id="groupContainer">

                    <div class="card card-custom shadow-sm p-4 mb-3 question-group">

                        <h5 class="fw-bold mb-3">Question Groups</h5>

                        <label class="form-label">Question Type</label>

                        <div class="mb-3">

                            <button class="btn btn-primary btn-sm">MCQ</button>
                            <button class="btn btn-outline-secondary btn-sm">Essay</button>

                        </div>

                        <label class="form-label">Difficulty Level</label>

                        <div class="mb-3">

                            <button class="btn btn-primary level-btn">1</button>
                            <button class="btn btn-outline-secondary level-btn">2</button>
                            <button class="btn btn-outline-secondary level-btn">3</button>
                            <button class="btn btn-outline-secondary level-btn">4</button>
                            <button class="btn btn-outline-secondary level-btn">5</button>

                        </div>


                        <div class="row mb-3">

                            <div class="col-md-6">
                                <label>Number of Questions</label>
                                <input type="number" class="form-control num-question" value="5">
                            </div>

                            <div class="col-md-6">
                                <label>Points per Question</label>
                                <input type="number" class="form-control point-question" value="20">
                            </div>

                        </div>

                        <div class="alert alert-light border group-total">
                            5 questions × 20 = 100 pts
                        </div>

                    </div>

                </div>


                <div class="add-group mb-4" onclick="addGroup()">
                    <i class="bi bi-plus-lg"></i> Add Another Question Group
                </div>


                <div class="d-flex gap-3 mb-5">

                    <button class="btn btn-light flex-fill">Cancel</button>

                    <button class="btn btn-secondary flex-fill">Create Exam</button>

                </div>

            </div>


            <!-- ================= MANUAL MODE ================= -->

            <div id="manualMode" style="display:none">

                <div class="row">

                    <!-- LEFT -->

                    <div class="col-md-8">

                        <div class="card card-custom shadow-sm p-4">

                            <h5 class="fw-bold mb-3">Select Questions</h5>

                            <label>Question Type</label>

                            <div class="mb-3">

                                <button class="btn btn-primary w-50">MCQ</button>
                                <button class="btn btn-outline-secondary w-50">Essay</button>

                            </div>

                            <label>Difficulty Level</label>

                            <div class="mb-4">

                                <button class="btn btn-primary level-btn">1</button>
                                <button class="btn btn-outline-secondary level-btn">2</button>
                                <button class="btn btn-outline-secondary level-btn">3</button>
                                <button class="btn btn-outline-secondary level-btn">4</button>
                                <button class="btn btn-outline-secondary level-btn">5</button>

                            </div>


                            <div class="question-item d-flex justify-content-between align-items-center">

                                <div>
                                    <input type="radio">
                                    What is the capital of France?
                                    <br>
                                    <span class="badge bg-primary">Level 1</span>
                                </div>

                                <div style="width:80px">
                                    <input class="form-control form-control-sm" value="5">
                                </div>

                            </div>


                            <div class="question-item d-flex justify-content-between align-items-center">

                                <div>
                                    <input type="radio">
                                    What is 2 + 2?
                                    <br>
                                    <span class="badge bg-primary">Level 1</span>
                                </div>

                                <div style="width:80px">
                                    <input class="form-control form-control-sm" value="5">
                                </div>

                            </div>


                            <div class="question-item d-flex justify-content-between align-items-center">

                                <div>
                                    <input type="radio">
                                    Which planet is closest to the sun?
                                    <br>
                                    <span class="badge bg-primary">Level 1</span>
                                </div>

                                <div style="width:80px">
                                    <input class="form-control form-control-sm" value="5">
                                </div>

                            </div>


                            <div class="mt-4 d-flex gap-3">

                                <button class="btn btn-light flex-fill">Cancel</button>

                                <button class="btn btn-secondary flex-fill">Create Exam</button>

                            </div>

                        </div>

                    </div>


                    <!-- RIGHT PANEL -->

                    <div class="col-md-4">

                        <div class="card summary-box p-4 mb-3">

                            <h5 class="fw-bold">Points Summary</h5>

                            <div class="d-flex justify-content-between mt-3">

                                <div>Current Total:</div>
                                <div><b>15</b></div>

                            </div>

                            <div class="d-flex justify-content-between">

                                <div>Max Points:</div>
                                <div><b>100</b></div>

                            </div>

                            <div class="alert alert-warning mt-3">
                                Mismatch <br>
                                Points must equal 100
                            </div>

                        </div>


                        <div class="card selected-box p-4">

                            <h5 class="fw-bold">Selected Questions (3)</h5>

                            <div class="border rounded p-2 mb-2">

                                What is the capital of France?

                                <div class="small text-muted">MCQ Level 1</div>

                                <div class="d-flex justify-content-between mt-2">

                                    <span>Points:</span>

                                    <input class="form-control form-control-sm" style="width:70px" value="5">

                                </div>

                            </div>


                            <div class="border rounded p-2 mb-2">

                                What is 2 + 2?

                                <div class="small text-muted">MCQ Level 1</div>

                                <div class="d-flex justify-content-between mt-2">

                                    <span>Points:</span>

                                    <input class="form-control form-control-sm" style="width:70px" value="5">

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </div>



        <script>

            function switchMode(mode) {

                let autoBtn = document.getElementById("autoBtn");
                let manualBtn = document.getElementById("manualBtn");

                if (mode === "auto") {

                    document.getElementById("autoMode").style.display = "block";
                    document.getElementById("manualMode").style.display = "none";

                    autoBtn.classList.add("mode-active");
                    manualBtn.classList.remove("mode-active");

                } else {

                    document.getElementById("autoMode").style.display = "none";
                    document.getElementById("manualMode").style.display = "block";

                    manualBtn.classList.add("mode-active");
                    autoBtn.classList.remove("mode-active");

                }

            }


            function addGroup() {

                let container = document.getElementById("groupContainer")

                let group = document.querySelector(".question-group").cloneNode(true)

                container.appendChild(group)

            }

        </script>

        <script>

            // ===== BUTTON TOGGLE (MCQ / ESSAY / LEVEL) =====

            document.querySelectorAll(".btn").forEach(btn => {

                btn.addEventListener("click", function () {

                    // group button
                    let parent = this.parentElement;

                    // nếu trong cùng group
                    if (parent.querySelectorAll(".btn").length > 1) {

                        parent.querySelectorAll(".btn").forEach(b => {
                            b.classList.remove("btn-primary")
                            b.classList.add("btn-outline-secondary")
                        })

                        this.classList.remove("btn-outline-secondary")
                        this.classList.add("btn-primary")

                    }

                })

            })

        </script>
        <script>

            function calculateTotal() {

                let groups = document.querySelectorAll(".question-group");
                let total = 0;

                groups.forEach(group => {

                    let num = parseInt(group.querySelector(".num-question").value) || 0;
                    let point = parseInt(group.querySelector(".point-question").value) || 0;

                    let groupTotal = num * point;

                    group.querySelector(".group-total").innerHTML =
                            num + " questions × " + point + " points = <b class='text-primary'>" + groupTotal + " pts</b>";

                    total += groupTotal;

                })

                document.getElementById("currentTotal").innerText = total + " pts";

            }


// chạy khi nhập
            document.addEventListener("input", function (e) {

                if (e.target.classList.contains("num-question") ||
                        e.target.classList.contains("point-question")) {

                    calculateTotal();

                }

            });


// chạy khi load trang
            window.onload = calculateTotal;

            }


// event input
            document.addEventListener("input", function (e) {

                if (e.target.classList.contains("num-question") ||
                        e.target.classList.contains("point-question")) {

                    updatePoints();

                }

            });


// run first time
            updatePoints();

        </script>
    </body>
</html>