package controller.material;

import dal.MaterialDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
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
import java.util.List;
import java.util.UUID;
import model.Classroom;
import model.Material;
import model.User;
import validation.MaterialValidator;

/**
 * Handles Upload (Create) material.
 * GET  /material/manage/upload  → show upload.jsp
 * POST /material/manage/upload  → save material, redirect to list
 *
 * C# equivalent: MaterialsController.Create (GET + POST)
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB in memory
    maxFileSize       = 50 * 1024 * 1024, // 50 MB per file
    maxRequestSize    = 55 * 1024 * 1024  // 55 MB total
)
public class MaterialUploadController extends HttpServlet {

    private MaterialDAO dao;

    @Override
    public void init() {
        dao = new MaterialDAO();
    }

    // ── GET: show form ────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String classIdStr = request.getParameter("classId");
        int classId = parseId(classIdStr);
        if (classId <= 0) { response.sendError(400, "Bad Request"); return; }

        User user = getUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        Classroom cls = dao.getClassById(classId);
        if (cls == null) { response.sendError(404, "Class not found"); return; }

        if (!isOwner(cls, user)) { response.sendError(403, "Forbidden"); return; }

        request.setAttribute("classId",   classId);
        request.setAttribute("className", cls.getName());
        request.setAttribute("material",  new Material()); // empty model for form
        request.getRequestDispatcher("/view/material/upload.jsp").forward(request, response);
    }

    // ── POST: process upload ──────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // -- read params --
        String classIdStr   = request.getParameter("classId");
        int classId         = parseId(classIdStr);
        String title        = trim(request.getParameter("title"));
        String description  = trim(request.getParameter("description"));
        String category     = trim(request.getParameter("category"));
        String externalUrl  = trim(request.getParameter("externalUrl"));
        String indexContent = trim(request.getParameter("indexContent"));
        Part   filePart     = getFilePart(request, "file");

        if (classId <= 0) { response.sendError(400, "Bad Request"); return; }

        User user = getUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }

        Classroom cls = dao.getClassById(classId);
        if (cls == null) { response.sendError(404, "Class not found"); return; }
        if (!isOwner(cls, user)) { response.sendError(403, "Forbidden"); return; }

        // -- validate --
        MaterialValidator v = new MaterialValidator();
        boolean valid = v.validateCreate(title, filePart, externalUrl, indexContent);

        if (!valid) {
            Material form = new Material();
            form.setClassId(classId);
            form.setTitle(title);
            form.setDescription(description);
            form.setCategory(category);
            form.setExternalUrl(externalUrl);
            form.setIndexContent(indexContent);
            request.setAttribute("material",  form);
            request.setAttribute("classId",   classId);
            request.setAttribute("className", cls.getName());
            request.setAttribute("errors",    v.getAllErrors());
            request.getRequestDispatcher("/view/material/upload.jsp").forward(request, response);
            return;
        }

        // -- build model --
        Material m = new Material();
        m.setClassId(classId);
        m.setTitle(title);
        m.setDescription(description);
        m.setCategory(category);
        m.setIndexContent(indexContent);
        m.setCreatedById(user.getUserID());

        boolean hasFile = filePart != null && filePart.getSize() > 0;
        boolean hasUrl  = externalUrl != null && !externalUrl.trim().isEmpty();

        if (hasFile) {
            String savedPath = saveFile(request, filePart);
            String origName  = MaterialValidator.getFileName(filePart);
            m.setFileUrl(savedPath);
            m.setOriginalFileName(origName);
            m.setFileSize(filePart.getSize());
            m.setProvider("Local");
            m.setMediaKind("file");
        }
        if (hasUrl) {
            m.setExternalUrl(externalUrl);
            String youId = extractYouTubeId(externalUrl);
            if (youId != null) {
                m.setProvider("YouTube");
                m.setMediaKind("video");
                m.setThumbnailUrl("https://img.youtube.com/vi/" + youId + "/hqdefault.jpg");
            } else {
                m.setProvider("Link");
                m.setMediaKind("link");
            }
        }
        if (!hasFile && !hasUrl && indexContent != null && !indexContent.trim().isEmpty()) {
            m.setProvider("Index");
            m.setMediaKind("note");
        }

        dao.insertMaterial(m);
        response.sendRedirect(request.getContextPath()
                + "/material/view/material-list?classId=" + classId);
    }

    // ── helpers ───────────────────────────────────────────────────────────────

    /**
     * Save uploaded file to web/uploads/materials/ folder.
     * @return relative URL like "/uploads/materials/abc123.pdf"
     */
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

    /**
     * Extract YouTube video ID from URL.
     * Supports youtube.com/watch?v=... and youtu.be/...
     */
    static String extractYouTubeId(String url) {
        if (url == null || url.isBlank()) return null;
        try {
            java.net.URL u = new java.net.URL(url.trim());
            String host = u.getHost().toLowerCase();
            if (host.contains("youtube.com")) {
                String query = u.getQuery();
                if (query != null) {
                    for (String pair : query.split("&")) {
                        if (pair.startsWith("v=")) return pair.substring(2);
                    }
                }
            } else if (host.contains("youtu.be")) {
                String path = u.getPath();
                if (path != null && path.length() > 1) return path.substring(1);
            }
        } catch (Exception ignored) {}
        return null;
    }
}
