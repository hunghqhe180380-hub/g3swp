package validation;

import jakarta.servlet.http.Part;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Server-side validation for Material upload/edit.
 * Mirrors C# MaterialsController validation logic.
 */
public class MaterialValidator {

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(
        ".pdf", ".doc", ".docx", ".ppt", ".pptx",
        ".xls", ".xlsx", ".jpg", ".jpeg", ".png",
        ".mp4", ".zip", ".rar"
    );

    private final Map<String, List<String>> errors = new LinkedHashMap<>();

    // ── public API ──────────────────────────────────────────────────────────

    /** Validate for CREATE (no existing file). */
    public boolean validateCreate(String title, Part file, String externalUrl, String indexContent) {
        checkTitle(title);
        checkFile(file);
        checkAtLeastOneContent(file, externalUrl, indexContent, false, false);
        return errors.isEmpty();
    }

    /** Validate for EDIT (may have existing file). */
    public boolean validateEdit(String title, Part file, String externalUrl,
                                String indexContent, boolean hasExistingFile, boolean removeFile) {
        checkTitle(title);
        checkFile(file);
        checkAtLeastOneContent(file, externalUrl, indexContent, hasExistingFile, removeFile);
        return errors.isEmpty();
    }

    public Map<String, List<String>> getErrors() {
        return errors;
    }

    /** Flat list of all error messages. */
    public List<String> getAllErrors() {
        List<String> all = new ArrayList<>();
        for (List<String> msgs : errors.values()) {
            all.addAll(msgs);
        }
        return all;
    }

    // ── private helpers ─────────────────────────────────────────────────────

    private void checkTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            addError("title", "Title is required.");
        } else if (title.trim().length() > 200) {
            addError("title", "Title must not exceed 200 characters.");
        }
    }

    private void checkFile(Part file) {
        if (file == null || file.getSize() == 0) return;
        String name = getFileName(file);
        if (name == null || name.isEmpty()) return;
        int dot = name.lastIndexOf('.');
        String ext = (dot >= 0) ? name.substring(dot).toLowerCase() : "";
        if (!ALLOWED_EXTENSIONS.contains(ext)) {
            addError("file", "File type " + ext + " not supported.");
        }
    }

    private void checkAtLeastOneContent(Part file, String externalUrl,
                                        String indexContent, boolean hasExistingFile,
                                        boolean removeFile) {
        boolean hasFile      = file != null && file.getSize() > 0;
        boolean hasUrl       = externalUrl != null && !externalUrl.trim().isEmpty();
        boolean hasIndex     = indexContent != null && !indexContent.trim().isEmpty();
        boolean keepOldFile  = hasExistingFile && !removeFile;

        if (!hasFile && !hasUrl && !hasIndex && !keepOldFile) {
            addError("content", "Provide at least one: File, URL or Index content.");
        }
    }

    private void addError(String field, String message) {
        errors.computeIfAbsent(field, k -> new ArrayList<>()).add(message);
    }

    // ── util ────────────────────────────────────────────────────────────────

    public static String getFileName(Part part) {
        if (part == null) return null;
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String token : header.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // IE sends full path
                int slash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return (slash >= 0) ? name.substring(slash + 1) : name;
            }
        }
        return null;
    }

    public static boolean isAllowedExtension(String filename) {
        if (filename == null) return false;
        int dot = filename.lastIndexOf('.');
        String ext = (dot >= 0) ? filename.substring(dot).toLowerCase() : "";
        return ALLOWED_EXTENSIONS.contains(ext);
    }
}
