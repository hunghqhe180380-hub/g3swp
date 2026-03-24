package controller.material;

import dal.MaterialDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import model.Classroom;
import model.Material;
import model.User;
import validation.MaterialValidator;

/**
 * Handles Edit material.
 * GET  /material/manage/edit?id=X  → show edit.jsp pre-filled
 * POST /material/manage/edit       → save changes, redirect to list
 *
 * C# equivalent: MaterialsController.Edit (GET + POST)
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 50 * 1024 * 1024,
    maxRequestSize    = 55 * 1024 * 1024
)
public class MaterialEditController extends HttpServlet {

    private MaterialDAO dao;

    @Override
    public void init() {
        dao = new MaterialDAO();
    }

    // ── GET: show pre-filled form ─────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendError(400, "Bad Request"); return; }

        User user = getUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        Material m = dao.findById(id);
        if (m == null) { response.sendError(404, "Material not found"); return; }

        Classroom cls = dao.getClassById(m.getClassId());
        if (cls == null || !isOwner(cls, user)) { response.sendError(403, "Forbidden"); return; }

        request.setAttribute("material",  m);
        request.setAttribute("classId",   m.getClassId());
        request.setAttribute("className", cls.getName());
        request.getRequestDispatcher("/view/material/edit.jsp").forward(request, response);
    }

    // ── POST: process edit ────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = parseId(request.getParameter("id"));
        if (id <= 0) { response.sendError(400, "Bad Request"); return; }

        User user = getUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        // load existing record
        Material m = dao.findById(id);
        if (m == null) { response.sendError(404, "Material not found"); return; }

        Classroom cls = dao.getClassById(m.getClassId());
        if (cls == null || !isOwner(cls, user)) { response.sendError(403, "Forbidden"); return; }

        // -- read form params --
        String title        = trim(request.getParameter("title"));
        String description  = trim(request.getParameter("description"));
        String category     = trim(request.getParameter("category"));
        String externalUrl  = trim(request.getParameter("externalUrl"));
        String indexContent = trim(request.getParameter("indexContent"));
        boolean removeFile  = "true".equalsIgnoreCase(request.getParameter("removeFile"));
        Part filePart       = getFilePart(request, "file");

        boolean hasExistingFile = m.getFileUrl() != null && !m.getFileUrl().isBlank();

        // -- validate --
        MaterialValidator v = new MaterialValidator();
        boolean valid = v.validateEdit(title, filePart, externalUrl, indexContent,
                                       hasExistingFile, removeFile);

        if (!valid) {
            // keep existing data so JSP can show current file info etc.
            m.setTitle(title);
            m.setDescription(description);
            m.setCategory(category);
            m.setExternalUrl(externalUrl);
            m.setIndexContent(indexContent);
            request.setAttribute("material",  m);
            request.setAttribute("classId",   m.getClassId());
            request.setAttribute("className", cls.getName());
            request.setAttribute("errors",    v.getAllErrors());
            request.getRequestDispatcher("/view/material/edit.jsp").forward(request, response);
            return;
        }

        // -- apply scalar updates --
        m.setTitle(title);
        m.setDescription(description);
        m.setCategory(category);
        m.setIndexContent(indexContent);

        // -- handle file upload / removal --
        boolean hasNewFile = filePart != null && filePart.getSize() > 0;
        String oldFileUrl  = m.getFileUrl(); // remember for physical deletion

        if (hasNewFile) {
            // delete old physical file first
            deletePhysicalFile(oldFileUrl);
            String savedPath = saveFile(request, filePart);
            m.setFileUrl(savedPath);
            m.setOriginalFileName(MaterialValidator.getFileName(filePart));
            m.setFileSize(filePart.getSize());
            if (m.getProvider() == null || m.getProvider().isBlank()) m.setProvider("Local");
            if (m.getMediaKind() == null || m.getMediaKind().isBlank()) m.setMediaKind("file");
        } else if (removeFile) {
            deletePhysicalFile(oldFileUrl);
            m.setFileUrl(null);
            m.setOriginalFileName(null);
            m.setFileSize(0);
        }

        // -- handle external URL --
        if (externalUrl != null && !externalUrl.isBlank()) {
            m.setExternalUrl(externalUrl);
            String youId = MaterialUploadController.extractYouTubeId(externalUrl);
            if (youId != null) {
                m.setProvider("YouTube");
                m.setMediaKind("video");
                m.setThumbnailUrl("https://img.youtube.com/vi/" + youId + "/hqdefault.jpg");
            } else {
                if (m.getProvider() == null || "Local".equals(m.getProvider())) m.setProvider("Link");
                if (m.getMediaKind() == null || "file".equals(m.getMediaKind())) m.setMediaKind("link");
                m.setThumbnailUrl(null);
            }
        } else {
            // clear URL (mirrors C# FIX comment)
            m.setExternalUrl(null);
            m.setThumbnailUrl(null);
        }

        // -- if only index content remains --
        boolean nowHasFile  = m.getFileUrl() != null && !m.getFileUrl().isBlank();
        boolean nowHasUrl   = m.getExternalUrl() != null && !m.getExternalUrl().isBlank();
        if (!nowHasFile && !nowHasUrl && indexContent != null && !indexContent.isBlank()) {
            m.setProvider("Index");
            m.setMediaKind("note");
        }

        dao.updateMaterial(m);
        response.sendRedirect(request.getContextPath()
                + "/material/view/material-list?classId=" + m.getClassId());
    }

    // ── helpers ───────────────────────────────────────────────────────────────

    private String saveFile(HttpServletRequest request, Part part) throws IOException {
        String uploadDir = getServletContext().getRealPath("") + File.separator
                + "uploads" + File.separator + "materials";
        Files.createDirectories(Paths.get(uploadDir));

        String origName = MaterialValidator.getFileName(part);
        String ext = "";
        if (origName != null) {
            int dot = origName.lastIndexOf('.');
            if (dot >= 0) ext = origName.substring(dot).toLowerCase();
        }
        String savedName = UUID.randomUUID().toString().replace("-", "") + ext;
        String fullPath  = uploadDir + File.separator + savedName;
        try (InputStream in = part.getInputStream()) {
            Files.copy(in, Paths.get(fullPath), StandardCopyOption.REPLACE_EXISTING);
        }
        return "/uploads/materials/" + savedName;
    }

    private void deletePhysicalFile(String relUrl) {
        if (relUrl == null || relUrl.isBlank()) return;
        try {
            String physPath = getServletContext().getRealPath("")
                    + relUrl.replace('/', File.separatorChar);
            File f = new File(physPath);
            if (f.exists()) f.delete();
        } catch (Exception ignored) {}
    }

    private Part getFilePart(HttpServletRequest request, String fieldName) {
        try {
            Part p = request.getPart(fieldName);
            return (p != null && p.getSize() > 0) ? p : null;
        } catch (Exception e) {
            return null;
        }
    }

    private User getUser(HttpServletRequest request) {
        return (User) request.getSession().getAttribute("user");
    }

    private boolean isOwner(Classroom cls, User user) {
        return user != null && user.getUserID() != null
                && user.getUserID().equals(cls.getTeacherId());
    }

    private int parseId(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return -1; }
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}
