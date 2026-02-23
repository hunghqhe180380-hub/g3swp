<%-- 
    Document   : user-list
    Created on : Feb 23, 2026
    Author     : BINH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Materials - POET</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link rel="stylesheet" href="${ctx}/assets/css/user-materials.css">
    </head>
    <body>

        <!-- ===== HEADER ===== -->
        <div class="header">
            <div class="header__inner">
                <div>
                    <div class="header__label">Materials</div>
                    <h4 class="header__title">
                        <c:out value="${classes.name}"/>
                        <span class="header__code">• <c:out value="${classes.classCode}"/></span>
                    </h4>
                </div>
                <div style="display:flex; gap:8px;">
                    <c:if test="${fn:toLowerCase(user.role) eq 'teacher'}">
                        <a class="btn btn-white" href="${ctx}/material/manage/upload?classId=${classes.id}">
                            <i class="bi bi-plus-lg"></i> Add material
                        </a>
                    </c:if>
                    <a class="btn btn-outline-white" href="${ctx}/account/dashboard">
                        <i class="bi bi-arrow-left"></i> Back
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== PAGE ===== -->
    <div class="page">
        <div class="wrap">

            <!-- Toolbar: search + total -->
            <div class="toolbar">
                <form class="search" action="${ctx}/material/view/material-list" method="get">
                    <span class="search__icon">
                        <i class="bi bi-search"></i>
                    </span>
                    <input class="search__input" type="search" name="search" id="searchInput"
                           value="<c:out value='${search}'/>"
                           placeholder="Search materials by title or description...">
                    <input type="hidden" name="classId" value="${classes.id}">
                </form>
                <div class="total">Total: <strong><c:out value="${classes.sum}"/></strong></div>
            </div>

            <!-- Material list -->
            <div class="material-list">

                <c:choose>
                    <c:when test="${empty materials}">
                        <!-- Empty state -->
                        <div class="empty">
                            <div class="empty__icon"><i class="bi bi-journal-text"></i></div>
                            <div class="empty__title">No materials yet</div>
                            <div class="empty__sub">Drop a link, upload a file, or paste an index to get started.</div>
                            <c:if test="${fn:toLowerCase(user.role) eq 'teacher'}">
                                <a class="btn btn-outline-primary" style="margin-top:14px;"
                                   href="${ctx}/material/manage/upload?classId=${classes.id}">
                                    <i class="bi bi-plus-lg"></i> Add material
                                </a>
                            </c:if>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach items="${materials}" var="material">
                            <div class="material-card" data-title="${fn:toLowerCase(material.title)}">

                                <!-- Card header row -->
                                <div class="card-row">

                                    <!-- Toggle button -->
                                    <button class="toggle-btn" type="button"
                                            aria-expanded="false"
                                            aria-controls="body-${material.id}"
                                            onclick="toggleCard(this)">
                                        <i class="bi bi-chevron-down chev"></i>
                                    </button>

                                    <!-- Title + date -->
                                    <div class="card-info">
                                        <div class="card-title"><c:out value="${material.title}"/></div>
                                        <div class="card-meta">
                                            <i class="bi bi-clock"></i>
                                            <c:out value="${material.createdAt}"/>
                                        </div>
                                    </div>

                                    <!-- Badges + actions -->
                                    <div class="card-right">
                                        <c:if test="${not empty material.externalUrl}">
                                            <span class="pill pill-video">
                                                <i class="bi bi-play-btn"></i> Video/Link
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty material.indexContent}">
                                            <span class="pill pill-index">
                                                <i class="bi bi-list-task"></i> Index
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty material.fileUrl}">
                                            <span class="pill pill-file">
                                                <i class="bi bi-paperclip"></i> File
                                            </span>
                                        </c:if>

                                        <c:if test="${fn:toLowerCase(user.role) eq 'teacher'}">
                                            <a class="btn btn-outline-primary"
                                               href="${ctx}/material/manage/edit?id=${material.id}">
                                                <i class="bi bi-pencil-square"></i> Edit
                                            </a>
                                            <form action="${ctx}/material/manage/delete-material" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="${material.id}">
                                                <input type="hidden" name="classId" value="${classes.id}">
                                                <button class="btn btn-outline-danger" type="submit"
                                                        onclick="return confirm('Delete this material?');">
                                                    <i class="bi bi-trash"></i> Delete
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Collapsible body -->
                                <div class="card-body" id="body-${material.id}">

                                    <%-- Video / URL --%>
                                    <c:if test="${not empty material.externalUrl}">
                                        <c:choose>
                                            <c:when test="${fn:contains(material.externalUrl, 'youtube.com/watch') or fn:contains(material.externalUrl, 'youtu.be/')}">
                                                <c:choose>
                                                    <c:when test="${fn:contains(material.externalUrl, 'youtube.com/watch')}">
                                                        <c:set var="youId" value="${fn:substringAfter(material.externalUrl, 'v=')}"/>
                                                        <c:if test="${fn:contains(youId, '&')}">
                                                            <c:set var="youId" value="${fn:substringBefore(youId, '&')}"/>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="youId" value="${fn:substringAfter(material.externalUrl, 'youtu.be/')}"/>
                                                        <c:if test="${fn:contains(youId, '?')}">
                                                            <c:set var="youId" value="${fn:substringBefore(youId, '?')}"/>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="video-wrap">
                                                    <iframe src="https://www.youtube.com/embed/${youId}"
                                                            title="${material.title}" allowfullscreen loading="lazy"></iframe>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="btn btn-download" href="${material.externalUrl}" target="_blank" rel="noopener">
                                                    <i class="bi bi-box-arrow-up-right"></i> Open link
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>

                                    <%-- Description --%>
                                    <c:if test="${not empty material.description}">
                                        <c:if test="${not empty material.externalUrl}">
                                            <hr class="card-divider">
                                        </c:if>
                                        <p style="margin:0; font-size:14px; color:#374151;">
                                            <c:out value="${material.description}"/>
                                        </p>
                                    </c:if>

                                    <%-- Index content --%>
                                    <c:if test="${not empty material.indexContent}">
                                        <c:if test="${not empty material.externalUrl or not empty material.description}">
                                            <hr class="card-divider">
                                        </c:if>
                                        <div class="index-box">${material.indexContent}</div>
                                    </c:if>

                                    <%-- File download --%>
                                    <c:if test="${not empty material.fileUrl}">
                                        <c:if test="${not empty material.externalUrl or not empty material.description or not empty material.indexContent}">
                                            <hr class="card-divider">
                                        </c:if>
                                        <div class="file-row">
                                            <a class="btn btn-download" href="${ctx}${material.fileUrl}" target="_blank" rel="noopener">
                                                <i class="bi bi-download"></i>
                                                <c:choose>
                                                    <c:when test="${not empty material.originalFileName}">
                                                        <c:out value="${material.originalFileName}"/>
                                                    </c:when>
                                                    <c:otherwise>Download file</c:otherwise>
                                                </c:choose>
                                            </a>
                                            <c:if test="${not empty material.fileSize}">
                                                <span class="file-size">(<fmt:formatNumber value="${material.fileSize / (1024 * 1024)}" pattern="#.##" /> MB)</span>
                                            </c:if>
                                        </div>
                                    </c:if>

                                    <%-- Nothing --%>
                                    <c:if test="${empty material.externalUrl and empty material.description and empty material.indexContent and empty material.fileUrl}">
                                        <span style="color:#9ca3af; font-size:14px;">No content.</span>
                                    </c:if>

                                </div>

                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>

    <script>
        function toggleCard(btn) {
            var card = btn.closest('.material-card');
            var body = document.getElementById(btn.getAttribute('aria-controls'));
            var isOpen = btn.getAttribute('aria-expanded') === 'true';

            if (isOpen) {
                body.classList.remove('show');
                btn.setAttribute('aria-expanded', 'false');
                card.classList.remove('is-open');
            } else {
                body.classList.add('show');
                btn.setAttribute('aria-expanded', 'true');
                card.classList.add('is-open');
            }
        }

        // Live search filter
        document.getElementById('searchInput').addEventListener('input', function () {
            var term = this.value.trim().toLowerCase();
            document.querySelectorAll('.material-card').forEach(function (card) {
                var title = card.getAttribute('data-title') || '';
                card.style.display = (!term || title.includes(term)) ? '' : 'none';
            });
        });
    </script>

</body>
</html>
