/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.assignment;

import dal.AssignmentAttemptDAO;
import dal.AssignmentDAO;
import dal.AssignmentQuestionDAO;
import dal.ClassroomDAO;
import dal.EnrollmentDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.io.PrintWriter;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import model.Assignment;
import model.AssignmentQuestion;
import model.Classroom;
import model.SubmissionListItem;
import model.User;

/**
 *
 * @author hung2
 */
public class ListAssignmentController extends HttpServlet {

    private EnrollmentDAO enrollDAO;

    @Override
    public void init() {
        enrollDAO = new EnrollmentDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ListAssignmentController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListAssignmentController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String classId = request.getParameter("classId");

        request.setAttribute("classId", classId);

        System.out.println("abccc: " + classId);
        //get list assignment by class'id
        AssignmentDAO assignmentDAO = new AssignmentDAO();
        ClassroomDAO clsDAO = new ClassroomDAO();
        AssignmentAttemptDAO attemptDAO = new AssignmentAttemptDAO();

        List<Assignment> rawAssignments = assignmentDAO.getListAssignmentByClassId(classId);
        List<Map<String, Object>> assignmentCards = new ArrayList<>();

        String userId = user.getUserID();
        DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        LocalDateTime now = LocalDateTime.now();

        for (Assignment a : rawAssignments) {
            Map<String, Object> item = new HashMap<>();

            String typeLabel = "Mixed";
            if (a.getType() == 1) {
                typeLabel = "MCQ";
            } else if (a.getType() == 2) {
                typeLabel = "Essay";
            }

            LocalDateTime closeAt = null;
            if (a.getCloseAt() != null && !a.getCloseAt().trim().isEmpty()) {
                closeAt = LocalDateTime.parse(a.getCloseAt(), dateFmt);
            }

            String statusLabel = "Open";
            if (closeAt != null && now.isAfter(closeAt)) {
                statusLabel = "Closed";
            }

            int usedAttempts = attemptDAO.getAttemptCount(a.getId(), userId);

            List<SubmissionListItem> allHistory = attemptDAO.getSubmissionList(String.valueOf(a.getId()));
            List<SubmissionListItem> studentHistory = new ArrayList<>();

            for (SubmissionListItem h : allHistory) {
                if (h.getStudentId() != null && h.getStudentId().equals(userId)) {
                    studentHistory.add(h);
                }
            }

            item.put("id", a.getId());
            item.put("title", a.getTitle());
            item.put("description", a.getDescription());
            item.put("type", typeLabel);
            item.put("status", statusLabel);
            item.put("duration", a.getDurationMinutes());
            item.put("maxAttempts", a.getMaxAttempts());
            item.put("usedAttempts", usedAttempts);
            item.put("openAt", a.getOpenAt());
            item.put("closeAt", a.getCloseAt());
            item.put("history", studentHistory);

            assignmentCards.add(item);
        }

        Classroom cls = clsDAO.getClassInfoByClassId(classId);
        request.setAttribute("listAssignment", assignmentCards);
        request.setAttribute("classroom", cls);
        if (user.getRole().equalsIgnoreCase("teacher")) {
            
            request.getRequestDispatcher("/view/assignment/teacher-assignment-list.jsp").forward(request, response);
            return;
        }
        if (user.getRole().equalsIgnoreCase("student")) {
            request.getRequestDispatcher("/view/assignment/student-assignment-list.jsp").forward(request, response);
            return;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
