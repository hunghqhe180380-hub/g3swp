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
import java.util.Map;
import model.Assignment;
import model.SubmissionListItem;
import model.User;
import util.PagingUtil;

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
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        AssignmentAttemptDAO attemptDao = new AssignmentAttemptDAO();
        AssignmentDAO assignmentDao = new AssignmentDAO();
        List<SubmissionListItem> list = attemptDao.getSubmissionList(search, status, assignmentId);

        // Get assignment title
        Assignment assignment = assignmentDao.getAssignmentById(Integer.parseInt(assignmentId));
        String assignmentTitle = assignment != null ? assignment.getTitle() : "Assignment #" + assignmentId;

        paging(request, list);
        
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

    private void paging(HttpServletRequest request, List<SubmissionListItem> submissionList)
            throws ServletException, IOException {
        int nrpp = Integer.parseInt(request.getServletContext().getInitParameter("paging.submission"));
        int size = submissionList.size();
        int index = 0;
        try {
            index = Integer.parseInt(request.getParameter("index"));
            index = index < 0 ? 0 : index;
        } catch (Exception e) {
            index = 0;
        }
        PagingUtil page = new PagingUtil(size, nrpp, index);
        page.calc();
        request.setAttribute("page", page);
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
