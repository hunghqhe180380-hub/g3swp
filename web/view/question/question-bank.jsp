<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Question Bank</title>

        <style>
            body {
                font-family: Arial;
                background: #f5f7fa;
                margin: 0;
            }

            .header {
                background: #2c3e50;
                color: white;
                padding: 15px 30px;
                font-size: 20px;
                font-weight: bold;
            }

            .container {
                padding: 30px;
            }

            .card {
                background: white;
                border-radius: 10px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .card-header {
                padding: 15px 20px;
                cursor: pointer;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-header:hover {
                background: #f0f0f0;
            }

            .question {
                font-weight: bold;
            }

            .badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                color: white;
            }

            .level-1 {
                background: #27ae60;
            }
            .level-2 {
                background: #2980b9;
            }
            .level-3 {
                background: #f39c12;
            }
            .level-4 {
                background: #e67e22;
            }
            .level-5 {
                background: #c0392b;
            }

            .card-body {
                display: none;
                padding: 15px 25px;
                border-top: 1px solid #eee;
            }

            .choice {
                padding: 8px;
                border-radius: 6px;
                margin-bottom: 6px;
            }

            .correct {
                background: #d4edda;
                color: #155724;
                font-weight: bold;
            }

            .meta {
                font-size: 12px;
                color: gray;
                margin-top: 5px;
            }
        </style>

        <script>
            function toggle(id) {
                let el = document.getElementById(id);
                el.style.display = (el.style.display === "block") ? "none" : "block";
            }
        </script>

    </head>

    <body>

        <div class="header">
            📚 Question Bank
        </div>

        <div class="container">

            <c:forEach var="q" items="${listQuestionBank}" varStatus="loop">

                <div class="card">

                    <!-- HEADER -->
                    <div class="card-header" onclick="toggle('q${q.id}')">
                        <div class="question">
                            ${loop.index + 1}. ${q.prompt}
                        </div>

                        <div>
                            <span class="badge level-${q.level}">
                                Level ${q.level}
                            </span>
                        </div>
                    </div>

                    <!-- BODY -->
                    <div id="q${q.id}" class="card-body">

                        <c:forEach var="c" items="${q.listQuestionBankChoice}">
                            <div class="choice ${c.isCorrect ? 'correct' : ''}">
                                ○ ${c.text}
                                <c:if test="${c.isCorrect}">
                                    ✔
                                </c:if>
                            </div>
                        </c:forEach>

                        <div class="meta">
                            Created by: ${q.createdById} |
                            Date: ${q.createdAt} |
                            ${q.isPublic == 1 ? 'Public' : 'Private'}
                        </div>

                    </div>

                </div>

            </c:forEach>

        </div>

    </body>
</html>