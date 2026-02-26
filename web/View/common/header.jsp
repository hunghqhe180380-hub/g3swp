<%-- 
    Document   : header
    Created on : Feb 18, 2026
    Common Header (shared)
    Usage:
      <jsp:include page="/View/common/header.jsp" />
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%-- ===== Resolve avatar path safely ===== --%>
<c:set var="rawAvatar" value="" />

<%-- Prefer session user avatar --%>
<c:catch var="ignore1">
    <c:if test="${not empty sessionScope.user and not empty sessionScope.user.urlImgProfile}">
        <c:set var="rawAvatar" value="${sessionScope.user.urlImgProfile}" />
    </c:if>
</c:catch>

<%-- Fallback --%>
<c:if test="${empty rawAvatar}">
    <c:catch var="ignore2">
        <c:if test="${not empty requestScope.user and not empty requestScope.user.urlImgProfile}">
            <c:set var="rawAvatar" value="${requestScope.user.urlImgProfile}" />
        </c:if>
    </c:catch>
</c:if>

<%-- Build final avatar src --%>
<c:set var="avatarSrc" value="${ctx}/uploads/avatars/avatarDefault.png" />
<c:if test="${not empty rawAvatar}">
    <c:choose>
        <c:when test="${fn:startsWith(rawAvatar,'http://') or fn:startsWith(rawAvatar,'https://')}">
            <c:set var="avatarSrc" value="${rawAvatar}" />
        </c:when>
        <c:when test="${fn:startsWith(rawAvatar,'/')}">
            <c:set var="avatarSrc" value="${ctx}${rawAvatar}" />
        </c:when>
        <c:otherwise>
            <c:set var="avatarSrc" value="${ctx}/${rawAvatar}" />
        </c:otherwise>
    </c:choose>
</c:if>

<style>
/* ===== Header scope ===== */
.nav.dash-nav{
  background: rgba(255,255,255,0.92);
  border-bottom: 1px solid #eef2f7;
}
.dash-nav .container{
  width: 100%;
  max-width: 1160px;
  margin: 0 auto;
  padding: 0 22px;
}
.dash-nav-inner{
  display:flex;
  align-items:center;
  justify-content: space-between;
  min-height: 72px;
}
.brand{ display:flex; align-items:center; gap:10px; }
.logo-img{ height:34px; width:auto; display:block; }

.dash-actions{
  display:flex;
  align-items:center;
  gap: 14px;
}

.teacher-btn{
  border-radius: 10px;
  padding: 10px 14px;
}

/* ===== User dropdown hover ===== */
.user-menu{
  position: relative;
  outline: none;
}
.user-trigger{
  display:flex;
  align-items:center;
  gap: 10px;
  padding: 8px 12px;
  border-radius: 999px;
  border: 1px solid #dbeafe;
  background: #fff;
  cursor: default;
  user-select: none;
}
.avatar{
  width: 34px;
  height: 34px;
  border-radius: 999px;
  display:block;
  background: #eef2ff;
  border: 1px solid #e2e8f0;
  object-fit: cover;
}
.user-name{
  font-weight: 800;
  color: #0f172a;
}
.caret{
  font-size: 14px;
  color: #64748b;
  transform: translateY(-1px);
}

.user-dropdown{
  position: absolute;
  right: 0;
  top: calc(100% + 10px);
  width: 220px;
  background: #fff;
  border: 1px solid #e2e8f0;
  border-radius: 14px;
  box-shadow: 0 10px 30px rgba(2, 6, 23, 0.10);
  overflow: hidden;

  opacity: 0;
  transform: translateY(-6px);
  visibility: hidden;
  pointer-events: none;
  transition: 0.15s ease;
  z-index: 1000;
}

.user-hover-bridge{
  position:absolute;
  right: 0;
  top: 100%;
  width: 220px;
  height: 16px;
  background: transparent;
  pointer-events: none;
}

.user-menu:hover .user-dropdown,
.user-menu:focus-within .user-dropdown{
  opacity: 1;
  transform: translateY(0);
  visibility: visible;
  pointer-events: auto;
}
.user-menu:hover .user-hover-bridge,
.user-menu:focus-within .user-hover-bridge{
  pointer-events: auto;
}

.user-dropdown-title{
  padding: 14px 16px;
  font-weight: 900;
  border-bottom: 1px solid #eef2f7;
}
.user-dropdown-item{
  display:block;
  padding: 12px 16px;
  font-weight: 800;
  color: #0f172a;
  text-decoration: none;
}
.user-dropdown-item:hover{
  background: #f8fafc;
}

/* ===== Modal ===== */
.dash-modal{
  position: fixed;
  inset: 0;
  display: none;
  z-index: 1200;
}
.dash-modal.is-open{ display:block; }
.dash-modal__backdrop{
  position:absolute;
  inset:0;
  background: rgba(15, 23, 42, 0.55);
}
.dash-modal__dialog{
  position: relative;
  width: min(760px, calc(100% - 36px));
  margin: 10vh auto;
  background: #fff;
  border-radius: 14px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 10px 30px rgba(2, 6, 23, 0.10);
  overflow: hidden;
}
.dash-modal__header{
  padding: 14px 16px;
  display:flex;
  align-items:center;
  justify-content: space-between;
  background: linear-gradient(90deg, #2563eb, #22c1dc);
  color: #fff;
}
.dash-modal__title{ font-weight: 900; font-size: 18px; }
.dash-modal__close{
  border: none;
  background: transparent;
  color: #fff;
  font-size: 26px;
  line-height: 1;
  cursor: pointer;
}
.dash-modal__body{ padding: 16px; color: #0f172a; }
.dash-modal__body p{ margin: 0 0 10px; color: #334155; }
.dash-modal__body ul{ margin: 0 0 12px 18px; color: #334155; line-height: 1.6; }
.dash-modal__sendto{
  margin: 10px 0 0;
  padding: 14px;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  background: #f8fafc;
}
.dash-modal__sendto-label{
  color: #64748b;
  font-size: 12px;
  font-weight: 900;
  margin-bottom: 6px;
}
.dash-modal__email{ font-weight: 900; color: #2563eb; text-decoration:none; }
.dash-modal__hint{ margin-top: 12px; color: #64748b; }
.dash-modal__footer{
  padding: 14px 16px;
  display:flex;
  justify-content: flex-end;
  border-top: 1px solid #eef2f7;
}
</style>

<header class="nav dash-nav">
  <div class="container">
    <div class="nav-inner dash-nav-inner">

      <!-- Brand / Logo -->
      <a class="brand" href="${ctx}/account/dashboard" aria-label="POET Dashboard">
        <img src="${ctx}/uploads/Images/LOGO/POETLOGO.png" alt="POET Logo" class="logo-img">
      </a>

      <div class="nav-actions dash-actions">
        <!-- Teacher upgrade -->
        <c:if test="${requestScope.hideTeacherCTA ne true}">
          <button class="btn btn-outline teacher-btn" type="button" id="openTeacherModal">
            Are you a teacher?
          </button>
        </c:if>

        <!-- User dropdown -->
        <div class="user-menu" tabindex="0">
          <div class="user-trigger" aria-haspopup="true" aria-expanded="false">

            <img class="avatar" src="${avatarSrc}" alt="Avatar" />

            <span class="user-name">
              <c:out value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : sessionScope.user.userName}" />
            </span>
            <span class="caret" aria-hidden="true">▾</span>
          </div>

          <div class="user-hover-bridge" aria-hidden="true"></div>

          <div class="user-dropdown" role="menu" aria-label="User menu">
            <div class="user-dropdown-title">
              <c:out value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : sessionScope.user.userName}" />
            </div>
            <a class="user-dropdown-item" href="${ctx}/account/profile">Profile</a>
            <a class="user-dropdown-item" href="${ctx}/logout">Log out</a>
          </div>
        </div>

      </div>
    </div>
  </div>
</header>

<!-- Teacher modal -->
<c:if test="${requestScope.hideTeacherCTA ne true}">
  <div class="dash-modal" id="teacherModal" aria-hidden="true">
    <div class="dash-modal__backdrop" data-close="1"></div>
    <div class="dash-modal__dialog" role="dialog" aria-modal="true" aria-labelledby="teacherModalTitle">
      <div class="dash-modal__header">
        <div class="dash-modal__title" id="teacherModalTitle">Upgrade to Teacher</div>
        <button class="dash-modal__close" type="button" aria-label="Close" data-close="1">×</button>
      </div>
      <div class="dash-modal__body">
        <p>If you are a teacher or wish to become one on POET, please send proof of eligibility to our verification email.</p>
        <ul>
          <li>Acceptable documents: teaching certificate, employment confirmation, faculty/lecturer ID, or other credible evidence.</li>
          <li>Make sure your full name and a contact method are visible.</li>
          <li>Optionally include your POET username for faster processing.</li>
        </ul>

        <div class="dash-modal__sendto">
          <div class="dash-modal__sendto-label">Send to</div>
          <a class="dash-modal__email" href="mailto:poet176749@gmail.com">poet176749@gmail.com</a>
        </div>

        <p class="dash-modal__hint">We usually review requests within a reasonable timeframe. You will receive an email once your role has been updated.</p>
      </div>
      <div class="dash-modal__footer">
        <button class="btn btn-outline" type="button" data-close="1">Close</button>
      </div>
    </div>
  </div>

  <script>
    (function () {
      const openBtn = document.getElementById('openTeacherModal');
      const modal = document.getElementById('teacherModal');
      if (!openBtn || !modal) return;

      function open() {
        modal.classList.add('is-open');
        modal.setAttribute('aria-hidden', 'false');
      }
      function close() {
        modal.classList.remove('is-open');
        modal.setAttribute('aria-hidden', 'true');
      }

      openBtn.addEventListener('click', open);
      modal.addEventListener('click', function (e) {
        const t = e.target;
        if (t && t.getAttribute && t.getAttribute('data-close') === '1') close();
      });
      document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && modal.classList.contains('is-open')) close();
      });
    })();
  </script>
</c:if>