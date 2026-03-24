<%-- 
    Document   : assignment-add-question
    Created on : Mar 18, 2026, 4:07:02 AM
    Author     : hung2
--%>

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
        <title>Add Question Assignment</title>

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
                <h2 class="fw-bold">Add Question</h2>
                <div>${className} * ${subjectName}</div>
            </div>

            <a href="${ctx}/assignment/view/list-assignment?classId=${requestScope.classId}" class="btn btn-light">
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
            <h5 class="fw-bold mb-3">Assignment Details</h5>

            <div class="row mb-3">

                <div class="col-md-8">
                    <label class="form-label">Exam Title</label>
                    <input name="title" class="form-control" value="${requestScope.assignment.title}" disabled>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Total Points (Max 100 points)</label>
                    <input name="maxPoint" class="form-control">
                </div>

            </div>

            <!-- ================= AUTO MODE ================= -->

            <div id="autoMode">
                <!-- Form create auto mode -->
                <form action="${ctx}/assignment/manage/add-question" method="POST">
                    <!-- QUESTION GROUP -->

                    <div id="groupContainer">

                        <div class="card card-custom shadow-sm p-4 mb-3 question-group">

                            <h5 class="fw-bold mb-3">Question Groups</h5>
                            <button type="button" class="btn btn-danger remove-group px-3 py-2">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                            <label class="form-label">Question Type</label>

                            <div class="mb-3">

                                <!-- TYPE -->
                                <input type="hidden" name="typeQuestionGroup" value="1" class="type-hidden">

                                <div class="mb-3">
                                    <button type="button" value="1" class="btn btn-primary btn-sm type-btn">MCQ</button>
                                    <button type="button" value="2" class="btn btn-outline-secondary btn-sm type-btn">Essay</button>
                                </div>

                                <!-- LEVEL -->
                                <input type="hidden" name="levelQuestionGroup" value="1" class="level-hidden">

                                <div class="mb-3">
                                    <button type="button" value="1" class="btn btn-primary level-btn">1</button>
                                    <button type="button" value="2" class="btn btn-outline-secondary level-btn">2</button>
                                    <button type="button" value="3" class="btn btn-outline-secondary level-btn">3</button>
                                    <button type="button" value="4" class="btn btn-outline-secondary level-btn">4</button>
                                    <button type="button" value="5" class="btn btn-outline-secondary level-btn">5</button>
                                </div>

                            </div>


                            <div class="row mb-3">

                                <div class="col-md-6">
                                    <label>Number of Questions</label>
                                    <input name="numberQuestionGroup" type="number" class="form-control num-question">
                                </div>

                                <div class="col-md-6">
                                    <label>Points per Question</label>
                                    <input name="pointPerQuestion" type="number" class="form-control point-question" value="20">
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
                        <input type="text" name="classId" value="${requestScope.classId}" hidden>
                        <button type="reset" class="btn btn-secondary flex-fill">Cancel</button>
                        <input name="action" value="createAutoMode" hidden>
                        <button type="submit" class="btn btn-secondary flex-fill">Show Preview</button>

                    </div>
                </form>
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

                                <button class="btn btn-secondary flex-fill">Show Preview</button>

                            </div>

                        </div>

                    </div>


                    <!-- RIGHT PANEL -->

                    <div class="col-md-4">

                        <div class="card summary-box p-4 mb-3">

                            <h5 class="fw-bold">Points Summary</h5>

                            <div class="alert alert-secondary d-flex justify-content-between">

                                <div>
                                    Current Total<br>
                                    <strong id="currentTotal">0 pts</strong>
                                </div>

                                <div>
                                    Max Points<br>
                                    <strong id="maxTotal">0 pts</strong>
                                </div>

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

            // ===== SWITCH MODE =====
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

            // ===== ADD GROUP =====
            function addGroup() {
                let container = document.getElementById("groupContainer");
                let group = document.querySelector(".question-group").cloneNode(true);

                // reset value khi clone
                group.querySelector(".num-question").value = "";
                group.querySelector(".point-question").value = "20";

                container.appendChild(group);
            }

            // ===== CALCULATE TOTAL =====
            function calculateTotal() {

                let groups = document.querySelectorAll(".question-group");
                let total = 0;

                groups.forEach(group => {

                    let num = parseInt(group.querySelector(".num-question").value) || 0;
                    let point = parseInt(group.querySelector(".point-question").value) || 0;

                    let groupTotal = num * point;

                    group.querySelector(".group-total").innerHTML =
                            num + " questions × " + point +
                            " = <b class='text-primary'>" + groupTotal + " pts</b>";

                    total += groupTotal;
                });

                // current total
                document.getElementById("currentTotal").innerText = total + " pts";

                // max total
                let max = parseInt(document.querySelector("input[name='maxPoint']").value) || 0;
                document.getElementById("maxTotal").innerText = max + " pts";
            }

            // ===== INPUT CHANGE =====
            document.addEventListener("input", function (e) {
                if (
                        e.target.classList.contains("num-question") ||
                        e.target.classList.contains("point-question") ||
                        e.target.name === "maxPoint"
                        ) {
                    calculateTotal();
                }
            });

            // ===== BUTTON TOGGLE =====
            document.addEventListener("click", function (e) {

                if (e.target.classList.contains("btn")) {
                    let parent = e.target.parentElement;

                    if (parent.querySelectorAll(".btn").length > 1) {
                        parent.querySelectorAll(".btn").forEach(b => {
                            b.classList.remove("btn-primary");
                            b.classList.add("btn-outline-secondary");
                        });

                        e.target.classList.remove("btn-outline-secondary");
                        e.target.classList.add("btn-primary");
                    }
                }

                // remove group
                if (e.target.closest(".remove-group")) {

                    let groups = document.querySelectorAll(".question-group");

                    if (groups.length === 1) {
                        alert("Phải có ít nhất 1 question group!");
                        return;
                    }

                    e.target.closest(".question-group").remove();
                    calculateTotal();
                }
            });
            document.addEventListener("input", function (e) {
                if (e.target.name === "maxPoint") {

                    let value = e.target.value;

                    // Xóa mọi ký tự không phải số
                    value = value.replace(/[^0-9]/g, "");

                    e.target.value = value;
                }
            });
            // ===== VALIDATE SUBMIT =====
            document.querySelector("form").addEventListener("submit", function (e) {

                let isValid = true;
                let message = "";

                let maxInput = document.querySelector("input[name='maxPoint']");
                let maxVal = parseInt(maxInput.value) || 0;

                // ===== TITLE =====
                let title = document.querySelector("input[name='title']");
                if (!title.value.trim()) {
                    isValid = false;
                    message += "Title không được để trống\n";
                }

                // ===== MAX POINT =====
                if (maxVal <= 0) {
                    isValid = false;
                    message += "Max Point phải > 0\n";
                }

                if (maxVal > 100) {
                    isValid = false;
                    message += "Max Point không được vượt quá 100\n";
                }

                // ===== GROUP =====
                let groups = document.querySelectorAll(".question-group");
                let total = 0;

                groups.forEach((group, index) => {

                    let num = group.querySelector(".num-question").value;
                    let point = group.querySelector(".point-question").value;

                    if (!num.trim() || !Number.isInteger(Number(num)) || Number(num) <= 0) {
                        isValid = false;
                        message += `Group ${index + 1}: Number phải là số nguyên > 0\n`;
                    }

                    if (!point.trim() || Number(point) <= 0) {
                        isValid = false;
                        message += `Group ${index + 1}: Point phải > 0\n`;
                    }

                    total += (parseInt(num) || 0) * (parseInt(point) || 0);
                });

                // ===== TOTAL =====
                if (total > maxVal) {
                    isValid = false;
                    message += `Tổng điểm (${total}) > Max Point (${maxVal})\n`;
                }

                if (total > 100) {
                    isValid = false;
                    message += `Tổng điểm (${total}) không được vượt quá 100\n`;
                }

                // ===== DURATION =====
                let duration = document.querySelector("input[name='durationMinutes']");
                if (!duration.value || parseInt(duration.value) <= 0) {
                    isValid = false;
                    message += "Duration phải > 0\n";
                }

                // ===== ATTEMPTS =====
                let attempts = document.querySelector("input[name='maxAttempts']");
                if (!attempts.value || parseInt(attempts.value) <= 0) {
                    isValid = false;
                    message += "Max Attempts phải > 0\n";
                }

                // ===== TIME =====
                let openAt = document.querySelector("input[name='openAt']");
                let closeAt = document.querySelector("input[name='closeAt']");

                if (!openAt.value || !closeAt.value) {
                    isValid = false;
                    message += "Phải chọn Open At và Close At\n";
                } else {

                    let openTime = new Date(openAt.value);
                    let closeTime = new Date(closeAt.value);
                    let now = new Date();
                    now.setSeconds(0, 0);

                    if (openTime < now) {
                        isValid = false;
                        message += "Open At không được nhỏ hơn hiện tại\n";
                    }

                    if (closeTime < now) {
                        isValid = false;
                        message += "Close At không được nhỏ hơn hiện tại\n";
                    }

                    if (closeTime <= openTime) {
                        isValid = false;
                        message += "Close At phải sau Open At\n";
                    }
                }

                // ===== FINAL =====
                if (!isValid) {
                    e.preventDefault();
                    alert(message);
                }
            });
            // ===== INIT =====
            window.onload = calculateTotal;

        </script>
        <script>
            // ===== TYPE CLICK =====
            document.addEventListener("click", function (e) {
                if (e.target.classList.contains("type-btn")) {

                    let group = e.target.closest(".question-group");

                    // đổi UI
                    group.querySelectorAll(".type-btn").forEach(btn => {
                        btn.classList.remove("btn-primary");
                        btn.classList.add("btn-outline-secondary");
                    });

                    e.target.classList.remove("btn-outline-secondary");
                    e.target.classList.add("btn-primary");

                    // update hidden
                    group.querySelector(".type-hidden").value = e.target.value;
                }
            });

            // ===== LEVEL CLICK =====
            document.addEventListener("click", function (e) {
                if (e.target.classList.contains("level-btn")) {

                    let group = e.target.closest(".question-group");

                    group.querySelectorAll(".level-btn").forEach(btn => {
                        btn.classList.remove("btn-primary");
                        btn.classList.add("btn-outline-secondary");
                    });

                    e.target.classList.remove("btn-outline-secondary");
                    e.target.classList.add("btn-primary");

                    group.querySelector(".level-hidden").value = e.target.value;
                }
            });


        </script>
    </body>
</html>