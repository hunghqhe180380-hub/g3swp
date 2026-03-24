package controller.subject;

import dal.SubjectDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Handles Delete for a Subject.
 * Receives: id (subject ID)
 * Deletes the subject then redirects back to subject list.
 */
public class DeleteSubjectController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/subject/view/subject-list");
            return;
        }

        SubjectDAO dao = new SubjectDAO();
        dao.deleteSubject(id.trim());

        response.sendRedirect(request.getContextPath() + "/subject/view/subject-list");
    }
}
