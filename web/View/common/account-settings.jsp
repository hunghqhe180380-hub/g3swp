<%-- 
    Document   : account-settings
    Created on : Feb 19, 2026, 4:21:04 AM
    Author     : tuana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Account Settings - POET</title>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

  <link rel="stylesheet" href="${ctx}/assets/css/main.css">
  <link rel="stylesheet" href="${ctx}/assets/css/account-settings.css">
</head>

<body class="acc-page">
  <c:set var="hideTeacherCTA" value="true" scope="request"/>
  <jsp:include page="/View/common/header.jsp" />

  <main class="acc-main">
    <div class="acc-container">

      <h1 class="acc-title">Change your account settings</h1>
      <div class="acc-divider"></div>

      <div class="acc-grid">
        <!-- Sidebar -->
        <aside class="acc-side">
          <nav class="acc-menu" id="accMenu">
            <button class="acc-tab active" type="button" data-tab="profile">Profile</button>
            <button class="acc-tab" type="button" data-tab="email">Email</button>
            <button class="acc-tab" type="button" data-tab="password">Password</button>
          </nav>
        </aside>

        <!-- Content -->
        <section class="acc-card pad">
          <!-- PROFILE PANEL -->
          <div class="tab-panel is-active" data-panel="profile">
            <form method="post" enctype="multipart/form-data">
              <div class="acc-form">
                <div>
                  <div class="acc-label">User Name</div>
                  <input class="acc-input readonly" type="text"
                         value="${requestScope.user.userName}" readonly>
                </div>

                <div>
                  <div class="acc-label">Account Code</div>
                  <input class="acc-input readonly" type="text"
                         value="${requestScope.user.accountCode}" readonly>
                </div>

                <div class="full">
                  <div class="acc-label">Full Name</div>
                  <input class="acc-input" type="text" name="fullName"
                         value="${requestScope.user.fullName}">
                </div>

                <div class="full">
                  <div class="acc-label">Phone Number</div>
                  <input class="acc-input" type="text" name="phoneNumber"
                         value="${requestScope.user.phoneNumber}">
                </div>

                <div class="full">
                  <div class="acc-label">Avatar</div>
                  <div class="acc-help">Upload file</div>
                  <input class="acc-input" type="file" name="avatar" accept=".jpg,.jpeg,.png,.webp">
                  <div class="acc-help">JPG/JPEG/PNG/WebP, tối đa 5MB.</div>
                </div>

                <div class="full acc-actions">
                  <button class="acc-btn primary" type="submit">Save</button>
                  <button class="acc-btn ghost" type="reset">Reset</button>
                </div>
              </div>
            </form>
          </div>

          <!-- EMAIL PANEL -->
          <div class="tab-panel" data-panel="email">
            <h2 class="acc-subtitle">Email</h2>

            <div class="two-col">
              <div class="acc-card pad">
                <div class="acc-label">Current email</div>
                <input class="acc-input readonly" type="text"
                       value="${requestScope.user.email}" readonly>
                <div class="chip ok">Verified</div>

                <div style="margin-top:16px;">
                  <div class="acc-label">New email</div>
                  <input class="acc-input" type="email" name="newEmail" placeholder="Enter new email">
                  <div class="acc-help">We’ll send a confirmation link to the new address.</div>
                </div>

                <div class="acc-actions" style="margin-top:14px;">
                  <button class="acc-btn primary" type="button">Change email</button>
                  <button class="acc-btn ghost" type="button" data-go="profile">Back</button>
                </div>
              </div>

              <div class="acc-card pad tip-card">
                <div class="tip-title">ⓘ Heads up</div>
                <ul class="tip-list">
                  <li>Verification is required to receive class notifications.</li>
                  <li>If you don’t see the email, check Spam/Promotions.</li>
                  <li>Links expire for security. You can request a fresh one anytime.</li>
                </ul>
              </div>
            </div>
          </div>

          <!-- PASSWORD PANEL -->
          <div class="tab-panel" data-panel="password">
            <h2 class="acc-subtitle">Change password</h2>

            <div class="two-col">
              <div class="acc-card pad">
                <div class="acc-label">Current password</div>
                <div class="pw-wrap">
                  <input class="acc-input" type="password" name="currentPassword"
                         placeholder="Enter your current password">
                  <button class="pw-eye" type="button" aria-label="Toggle password">👁</button>
                </div>

                <div style="margin-top:14px;">
                  <div class="acc-label">New password</div>
                  <div class="pw-wrap">
                    <input class="acc-input" type="password" name="newPassword"
                           placeholder="Choose a new password">
                    <button class="pw-eye" type="button" aria-label="Toggle password">👁</button>
                  </div>
                  <div class="strength-bar"></div>
                  <div class="acc-help">Weak: add length and mix upper/lower/digits/symbols.</div>
                </div>

                <div style="margin-top:14px;">
                  <div class="acc-label">Confirm new password</div>
                  <div class="pw-wrap">
                    <input class="acc-input" type="password" name="confirmPassword"
                           placeholder="Re-enter new password">
                    <button class="pw-eye" type="button" aria-label="Toggle password">👁</button>
                  </div>
                </div>

                <div class="acc-actions" style="margin-top:18px;">
                  <button class="acc-btn primary" type="button">Update password</button>
                  <button class="acc-btn ghost" type="button" data-go="profile">Back</button>
                </div>
              </div>

              <div class="acc-card pad tip-card">
                <div class="tip-title">🛡 Password tips</div>
                <ul class="tip-list">
                  <li>Longer is stronger. Aim for 12+ characters.</li>
                  <li>Use a unique password you don’t reuse elsewhere.</li>
                  <li>Consider a passphrase you can remember but others can’t guess.</li>
                </ul>
              </div>
            </div>
          </div>
        </section>

        <!-- Preview -->
        <aside class="acc-card pad preview-col" id="previewCol">
          <div class="preview-title">Preview</div>

          <img id="previewAvatar" class="preview-avatar"
               src="${ctx}/${empty requestScope.user.urlImgProfile ? 'uploads/avatars/avatarDefault.png' : requestScope.user.urlImgProfile}"
               alt="avatar"/>
          
          <div class="preview-line"></div>

          <div class="preview-row">
            <div class="preview-k">User:</div>
            <div class="preview-v">${requestScope.user.userName}</div>
          </div>
          <div class="preview-row">
            <div class="preview-k">Account:</div>
            <div class="preview-v pink">${requestScope.user.accountCode}</div>
          </div>
          <div class="preview-row">
            <div class="preview-k">Name:</div>
            <div class="preview-v">${requestScope.user.fullName}</div>
          </div>
          <div class="preview-row">
            <div class="preview-k">Phone:</div>
            <div class="preview-v">${requestScope.user.phoneNumber}</div>
          </div>
        </aside>

      </div>
    </div>
  </main>

  <script>
    const tabs = document.querySelectorAll('.acc-tab');
    const panels = document.querySelectorAll('.tab-panel');
    const preview = document.getElementById('previewCol');

    function showTab(name) {
      tabs.forEach(t => t.classList.toggle('active', t.dataset.tab === name));
      panels.forEach(p => p.classList.toggle('is-active', p.dataset.panel === name));
      if (preview) preview.style.display = (name === 'profile') ? '' : 'none';
    }

    tabs.forEach(t => t.addEventListener('click', () => showTab(t.dataset.tab)));

    document.addEventListener('click', (e) => {
      const btn = e.target.closest('[data-go]');
      if (!btn) return;
      showTab(btn.dataset.go);
    });

    document.addEventListener('click', (e) => {
      const eye = e.target.closest('.pw-eye');
      if (!eye) return;
      const input = eye.parentElement.querySelector('input');
      if (!input) return;
      input.type = (input.type === 'password') ? 'text' : 'password';
    });

    showTab('profile');
    
    // ===== Live avatar preview =====
   (function () {
    const fileInput = document.querySelector('input[name="avatar"]');
    const img = document.getElementById('previewAvatar');
    if (!fileInput || !img) return;

    // lưu src cũ để bấm Reset trả về ảnh ban đầu
    const originalSrc = img.getAttribute('src');

    function isValidImage(file) {
      if (!file) return false;
      const okTypes = ['image/jpeg', 'image/png', 'image/webp'];
      const maxBytes = 5 * 1024 * 1024; // 5MB
      return okTypes.includes(file.type) && file.size <= maxBytes;
    }

    fileInput.addEventListener('change', function () {
      const file = this.files && this.files[0];
      if (!file) {
        img.src = originalSrc;
        return;
      }

      if (!isValidImage(file)) {
        alert('Ảnh không hợp lệ. Chỉ nhận JPG/JPEG/PNG/WebP và tối đa 5MB.');
        this.value = '';
        img.src = originalSrc;
        return;
      }

      const reader = new FileReader();
      reader.onload = function (e) {
        img.src = e.target.result; // dataURL -> show
      };
      reader.readAsDataURL(file);
    });

    const form = fileInput.closest('form');
    if (form) {
      form.addEventListener('reset', function () {
        setTimeout(() => {
          img.src = originalSrc;
        }, 0);
      });
    }
  })();
  </script>
</body>
</html>