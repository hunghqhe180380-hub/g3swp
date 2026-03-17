/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.assignment;

import dal.AssignmentAttemptDAO;
import dal.AssignmentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Assignment;
import model.SubmissionListItem;
import model.User;

/**
 *
 * @author FPT
 */
public class SubmissionListController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SubmissionListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubmissionListController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String assignmentId = request.getParameter("assignmentId");
        String classId = request.getParameter("classId");

        AssignmentAttemptDAO attemptDao = new AssignmentAttemptDAO();
        AssignmentDAO assignmentDao = new AssignmentDAO();
        List<SubmissionListItem> list = attemptDao.getSubmissionList(assignmentId);

        // Get assignment title
        Assignment assignment = assignmentDao.getAssignmentById(Integer.parseInt(assignmentId));
        String assignmentTitle = assignment != null ? assignment.getTitle() : "Assignment #" + assignmentId;

        // Get user from session to check role
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String userRole = (user != null) ? user.getRole() : "";

        // Set attributes for JSP
        request.setAttribute("items", list);
        request.setAttribute("assignmentId", assignmentId);
        request.setAttribute("assignmentTitle", assignmentTitle);
        request.setAttribute("userRole", userRole);   
        request.setAttribute("classId", classId);

        request.getRequestDispatcher("/view/assignment/submission-list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
