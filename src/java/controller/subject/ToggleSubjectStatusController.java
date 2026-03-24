package controller.subject;

import dal.SubjectDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Handles Activate / Deactivate for a Subject.
 * Receives: id (subject ID), currentStatus (0 or 1)
 * Toggles is_active then redirects back to subject list.
 */
public class ToggleSubjectStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String currentStatusStr = request.getParameter("currentStatus");

        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/subject/view/subject-list");
            return;
        }

        int currentStatus = 1;
        try { currentStatus = Integer.parseInt(currentStatusStr); } catch (Exception ignored) {}

        int newStatus = (currentStatus == 1) ? 0 : 1; // toggle

        SubjectDAO dao = new SubjectDAO();
        dao.updateSubjectStatus(id.trim(), newStatus);

        response.sendRedirect(request.getContextPath() + "/subject/view/subject-list");
    }
}
