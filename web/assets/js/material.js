/**
 * material.js
 * Shared JS for upload.jsp and edit.jsp.
 * Mirrors the inline scripts from Create.cshtml and Edit.cshtml.
 */

// ── YouTube preview ─────────────────────────────────────────────────────────
(function () {
    const url  = document.getElementById('urlInput');
    const wrap = document.getElementById('urlPreview');
    const frame = document.getElementById('ytFrame');

    function getYouTubeId(u) {
        try {
            const x = new URL(u);
            if (x.hostname.includes('youtube.com')) {
                return new URLSearchParams(x.search).get('v') || '';
            }
            if (x.hostname.includes('youtu.be')) {
                return x.pathname.replace('/', '');
            }
        } catch (_) {}
        return '';
    }

    function updatePreview() {
        const id = getYouTubeId(url?.value?.trim() || '');
        if (id) {
            frame.src = 'https://www.youtube.com/embed/' + id;
            wrap?.classList.remove('d-none');
        } else {
            frame?.removeAttribute('src');
            wrap?.classList.add('d-none');
        }
        window.refreshPills && window.refreshPills();
    }

    url?.addEventListener('input', updatePreview, { passive: true });
    updatePreview();
})();

// ── File drag-and-drop / browse ──────────────────────────────────────────────
(function () {
    const allowed = ['.pdf', '.doc', '.docx', '.ppt', '.pptx',
        '.xls', '.xlsx', '.jpg', '.jpeg', '.png', '.mp4', '.zip', '.rar'];

    const dz        = document.getElementById('dropZone');
    const fi        = document.getElementById('fileInput');
    const browseBtn = document.getElementById('browseBtn');
    const info      = document.getElementById('fileInfo');
    const nameEl    = document.getElementById('fileName');
    const sizeEl    = document.getElementById('fileSize');
    const clearBtn  = document.getElementById('clearFile');
    const errEl     = document.getElementById('fileError');

    function bytesToKB(b) { return Math.round((b || 0) / 1024).toLocaleString() + ' KB'; }

    window.validateFile = function (f) {
        if (!f) { errEl.textContent = ''; errEl.classList.add('d-none'); return true; }
        const ext = ('.' + f.name.split('.').pop()).toLowerCase();
        if (!allowed.includes(ext)) {
            errEl.textContent = 'File type ' + ext + ' not supported.';
            errEl.classList.remove('d-none');
            return false;
        }
        errEl.textContent = ''; errEl.classList.add('d-none'); return true;
    };

    function showFile(f) {
        if (!f) { info?.classList.add('d-none'); if (nameEl) nameEl.textContent = '—'; return; }
        info?.classList.remove('d-none');
        if (nameEl) nameEl.textContent = f.name;
        if (sizeEl) sizeEl.textContent = '(' + bytesToKB(f.size) + ')';
    }

    browseBtn?.addEventListener('click', () => fi?.click());

    fi?.addEventListener('change', () => {
        const f = fi.files?.[0] || null;
        if (validateFile(f)) { showFile(f); } else { fi.value = ''; showFile(null); }
        window.refreshPills && window.refreshPills();
    });

    clearBtn?.addEventListener('click', () => {
        fi.value = ''; showFile(null); validateFile(null);
        window.refreshPills && window.refreshPills();
    });

    ['dragenter', 'dragover'].forEach(ev =>
        dz?.addEventListener(ev, e => { e.preventDefault(); e.stopPropagation(); dz.classList.add('dragover'); }, false)
    );
    ['dragleave', 'drop'].forEach(ev =>
        dz?.addEventListener(ev, e => { e.preventDefault(); e.stopPropagation(); dz.classList.remove('dragover'); }, false)
    );
    dz?.addEventListener('drop', e => {
        const files = e.dataTransfer?.files;
        if (files?.length) {
            try { fi.files = files; } catch (_) {}
            const f = fi.files?.[0] || null;
            if (validateFile(f)) { showFile(f); } else { fi.value = ''; showFile(null); }
            window.refreshPills && window.refreshPills();
        }
    });
})();

// ── Status pills + submit button state ──────────────────────────────────────
(function () {
    const titleEl        = document.getElementById('titleInput');
    const urlEl          = document.getElementById('urlInput');
    const fileEl         = document.getElementById('fileInput');
    const indexEl        = document.getElementById('indexInput');
    const countEl        = document.getElementById('indexCount');
    const btnCreate      = document.getElementById('btnCreate'); // upload page
    const btnSave        = document.getElementById('btnSave');   // edit page
    const pillTitle      = document.getElementById('pillTitle');
    const pillUrl        = document.getElementById('pillUrl');
    const pillFile       = document.getElementById('pillFile');
    const pillIndex      = document.getElementById('pillIndex');

    // edit-page specific
    const hasExistingEl  = document.getElementById('hasExistingFile');
    const removeFileCheck = document.getElementById('removeFile');
    const hasExisting    = hasExistingEl?.value === 'true';

    function niceLen(s) { return ((s || '').length).toLocaleString(); }

    window.refreshPills = function () {
        const t  = titleEl?.value?.trim() || '';
        const u  = urlEl?.value?.trim() || '';
        const fNew = fileEl?.files?.[0];
        const ix = indexEl?.value?.trim() || '';
        const removed = removeFileCheck?.checked;
        const fEffective = fNew || (hasExisting && !removed);

        if (pillTitle) pillTitle.textContent = 'Title \u2022 ' + niceLen(t);
        if (pillUrl)   pillUrl.className   = u        ? 'pill pill-indigo'  : 'pill pill-gray';
        if (pillFile)  pillFile.className  = fEffective ? 'pill pill-emerald' : 'pill pill-gray';
        if (pillIndex) {
            pillIndex.textContent = 'Index \u2022 ' + niceLen(ix);
            pillIndex.className   = ix ? 'pill pill-sky' : 'pill pill-gray';
        }

        const hasContent = !!(u || fEffective || ix);
        const hasTitle   = !!t;
        const fileValid  = window.validateFile ? window.validateFile(fNew) : true;

        // upload page: btnCreate is disabled by default, enable when valid
        if (btnCreate) btnCreate.disabled = !(hasTitle && hasContent && fileValid);
        // edit page: btnSave is always enabled (existing content ensures validity)
        // but we still reflect state visually
    };

    function updateCount() {
        if (countEl) countEl.textContent = ((indexEl?.value?.length) || 0).toLocaleString() + ' chars';
    }

    ['input', 'change'].forEach(ev => {
        titleEl?.addEventListener(ev, refreshPills);
        urlEl?.addEventListener(ev, refreshPills);
        indexEl?.addEventListener(ev, () => { updateCount(); refreshPills(); });
        fileEl?.addEventListener(ev, refreshPills);
        removeFileCheck?.addEventListener('change', refreshPills);
    });

    updateCount();
    refreshPills();
})();
