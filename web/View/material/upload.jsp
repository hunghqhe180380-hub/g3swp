<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add material</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        .matc-header{background:linear-gradient(90deg,#6366f1,#22d3ee);color:#fff;box-shadow:0 2px 8px rgba(99,102,241,.15);}
        .section-shell{max-width:1100px;margin:0 auto;}
        .btn-soft-slate{background:#f3f4f6;border:1px solid #e5e7eb;color:#1f2937;}
        .btn-soft-slate:hover{background:#eef2f7;}
        .btn-grad-amber{background:linear-gradient(90deg,#f59e0b,#ef4444);color:#fff;border:none;}
        .btn-grad-amber:hover{filter:brightness(.95);color:#fff;}
        .btn-grad-amber:disabled{filter:grayscale(1);opacity:.6;cursor:not-allowed;}
        .pill{display:inline-flex;align-items:center;gap:.35rem;border-radius:999px;padding:.15rem .6rem;font-size:.78rem;font-weight:600;border:1px solid transparent;}
        .pill-indigo{background:#eef2ff;color:#4f46e5;border-color:#d9ddff;}
        .pill-sky{background:#e0f2fe;color:#0369a1;border-color:#b4e6fb;}
        .pill-emerald{background:#e9fff3;color:#0f766e;border-color:#bff3d6;}
        .pill-gray{background:#f3f4f6;color:#374151;border-color:#e5e7eb;}
        .matc-box{border:1px solid #ececec;border-radius:14px;overflow:hidden;background:#fff;box-shadow:0 1px 2px rgba(0,0,0,.04);}
        .matc-box__head{padding:12px 14px;border-bottom:1px dashed #eef2f7;background:#fbfcff;}
        .matc-box__title{font-weight:700;margin-bottom:.2rem;}
        .matc-box__body{padding:14px;}
        .matc-drop{text-align:center;padding:20px;border:1px dashed #d9ddff;border-radius:12px;background:#f8fafc;transition:background .15s ease,border-color .15s ease;}
        .matc-drop.dragover{background:#eef2ff;border-color:#6366f1;}
        .matc-drop__icon{font-size:1.6rem;color:#4f46e5;margin-bottom:.35rem;}
        .visually-hidden{position:absolute!important;left:-9999px!important;width:1px;height:1px;overflow:hidden;}
    </style>
</head>
<body>

<!-- Header -->
<div class="matc-header">
    <div class="container d-flex align-items-center justify-content-between">
        <div class="py-3">
            <div class="small opacity-75">Materials</div>
            <h4 class="mb-0">Add material &bull; ${className}</h4>
        </div>
        <div class="d-flex gap-2">
            <a class="btn btn-outline-light btn-sm"
               href="${pageContext.request.contextPath}/material/view/material-list?classId=${classId}">
                <i class="bi bi-arrow-left"></i> Back
            </a>
        </div>
    </div>
</div>

<div class="container py-3 section-shell">
    <div class="card shadow-sm border-0">
        <div class="card-body p-4">

            <!-- Server-side errors -->
            <c:if test="${not empty errors}">
                <div class="alert alert-danger mb-3">
                    <c:forEach var="err" items="${errors}">
                        <div>${err}</div>
                    </c:forEach>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/material/manage/upload"
                  method="post" enctype="multipart/form-data" id="materialForm">
                <input type="hidden" name="classId" value="${classId}">

                <div class="row g-3">
                    <div class="col-12 col-lg-7">
                        <label class="form-label fw-semibold">Title <span class="text-danger">*</span></label>
                        <input name="title" class="form-control form-control-lg" id="titleInput"
                               placeholder="Short, clear title…"
                               value="${fn:escapeXml(material.title)}" maxlength="200">
                    </div>
                    <div class="col-12 col-lg-5">
                        <label class="form-label fw-semibold">Description</label>
                        <input name="description" class="form-control"
                               placeholder="Optional summary…"
                               value="${fn:escapeXml(material.description)}" maxlength="2000">
                    </div>
                </div>

                <hr class="my-4">

                <div class="row g-4">
                    <!-- URL / Video -->
                    <div class="col-12 col-lg-6">
                        <div class="matc-box">
                            <div class="matc-box__head">
                                <div class="matc-box__title">
                                    <span class="pill pill-indigo"><i class="bi bi-play-btn"></i> Video / Link</span>
                                </div>
                            </div>
                            <div class="matc-box__body">
                                <label class="form-label fw-semibold">URL</label>
                                <input name="externalUrl" class="form-control" id="urlInput"
                                       placeholder="https://…"
                                       value="${fn:escapeXml(material.externalUrl)}">
                                <div id="urlPreview" class="mt-3 d-none">
                                    <div class="ratio ratio-16x9">
                                        <iframe id="ytFrame" title="Preview" allowfullscreen loading="lazy"></iframe>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- File upload -->
                    <div class="col-12 col-lg-6">
                        <div class="matc-box">
                            <div class="matc-box__head">
                                <div class="matc-box__title">
                                    <span class="pill pill-emerald"><i class="bi bi-paperclip"></i> File upload</span>
                                </div>
                            </div>
                            <div class="matc-box__body">
                                <div id="dropZone" class="matc-drop">
                                    <input id="fileInput" name="file" type="file" class="visually-hidden"
                                           accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.jpg,.jpeg,.png,.mp4,.zip,.rar">
                                    <div class="matc-drop__icon"><i class="bi bi-cloud-arrow-up"></i></div>
                                    <div class="matc-drop__text">
                                        <strong>Drag &amp; drop</strong> or
                                        <button type="button" class="btn btn-soft-slate btn-sm" id="browseBtn">Browse</button>
                                    </div>
                                </div>
                                <div id="fileInfo" class="alert alert-light border d-none mt-3 mb-0 small">
                                    <i class="bi bi-file-earmark"></i>
                                    <span id="fileName">—</span>
                                    <span id="fileSize" class="text-muted ms-2"></span>
                                    <button type="button" class="btn btn-link btn-sm p-0 ms-2" id="clearFile">Remove</button>
                                </div>
                                <span id="fileError" class="text-danger small mt-2 d-none"></span>
                            </div>
                        </div>
                    </div>

                    <!-- Text / Index -->
                    <div class="col-12">
                        <div class="matc-box">
                            <div class="matc-box__head">
                                <div class="matc-box__title">
                                    <span class="pill pill-sky"><i class="bi bi-list-task"></i> Text / Index</span>
                                </div>
                            </div>
                            <div class="matc-box__body">
                                <label class="form-label fw-semibold">Content</label>
                                <textarea name="indexContent" class="form-control" rows="8"
                                          id="indexInput" placeholder="Write something helpful…">${fn:escapeXml(material.indexContent)}</textarea>
                                <div class="d-flex justify-content-between small mt-1">
                                    <div class="text-muted">Supports HTML.</div>
                                    <div id="indexCount" class="text-muted">0 chars</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex align-items-center justify-content-between mt-4">
                    <div class="d-flex flex-wrap gap-2">
                        <span class="pill pill-gray" id="pillTitle">Title • 0</span>
                        <span class="pill pill-gray" id="pillUrl">URL</span>
                        <span class="pill pill-gray" id="pillFile">File</span>
                        <span class="pill pill-gray" id="pillIndex">Index • 0</span>
                    </div>
                    <div class="d-flex gap-2">
                        <a class="btn btn-soft-slate"
                           href="${pageContext.request.contextPath}/material/view/material-list?classId=${classId}">Cancel</a>
                        <button type="submit" id="btnCreate" class="btn btn-grad-amber px-4" disabled>Create</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/material.js"></script>
<script>
    // init pills from pre-filled values (on validation error redisplay)
    window.addEventListener('DOMContentLoaded', function() {
        if (typeof window.refreshPills === 'function') refreshPills();
    });
</script>
</body>
</html>
