/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.assignment;

import dal.AssignmentDAO;
import dal.ClassroomDAO;
import dal.QuestionBankDAO;
import dal.SubjectDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.security.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import model.QuestionGroup;
import model.User;
import java.util.List;
import java.util.Map;
import model.Assignment;
import model.AssignmentQuestion;
import model.Classroom;
import model.QuestionBank;
import model.Subject;

/**
 *
 * @author hung2
 */
public class CreateAssignmentController extends HttpServlet {

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
            out.println("<title>Servlet CreateAssignmentController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateAssignmentController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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

        ClassroomDAO clsDAO = new ClassroomDAO();
        Classroom cls = clsDAO.getClassInfoByClassId(classId);

        //get subject's name and id
        SubjectDAO subjectDAO = new SubjectDAO();
        Subject subject = new Subject();
        subject.setName(subjectDAO.getSubjectNameById(cls.getSubjectId()));
        subject.setId(cls.getSubjectId());

        //get list question from question bank of this subject by subject'id
        QuestionBankDAO qBankDAO = new QuestionBankDAO();
        List<QuestionBank> listQuestion = qBankDAO.getListQuestionBankByTeacherAndSubject(subject.getId(), user.getUserID(), 1); // -1 = all statuses

        /////
        request.setAttribute("listQuestion", listQuestion);
        request.setAttribute("subject", subject);

        if (user.getRole().equalsIgnoreCase("teacher")) {
            request.getRequestDispatcher("/view/assignment/create-assignment.jsp").forward(request, response);
            return;
        }
        if (user.getRole().equalsIgnoreCase("student")) {
            request.getRequestDispatcher("/account/dashboard").forward(request, response);
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
        //get mode create asssignment
        String modeCreate = request.getParameter("modeCreate");

        String classId = request.getParameter("classId");
        String title = request.getParameter("title");
        String maxPoint = request.getParameter("maxPoint");

        String description = request.getParameter("description");
        String duration = request.getParameter("durationMinutes");
        String maxAttempts = request.getParameter("maxAttempts");

        String openAtStr = request.getParameter("openAt");
        String closeAtStr = request.getParameter("closeAt");

        Assignment asg = new Assignment();
        asg.setTitle(title);
        asg.setDescription(description);
        asg.setType(4);
        asg.setDurationMinutes(Integer.parseInt(duration));
        asg.setMaxAttempts(Integer.parseInt(maxAttempts));
        asg.setOpenAt(openAtStr);
        asg.setCloseAt(closeAtStr);
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        asg.setCreatedById(user.getUserID());
        asg.setClassId(Integer.parseInt(classId));

        AssignmentDAO asgDAO = new AssignmentDAO();

        int newAssignmentId = asgDAO.createAssignment(asg);

        //add question to assignment with each mode
        request.setAttribute("modeCreate", modeCreate);
        request.setAttribute("newAssignmentId", newAssignmentId);
        request.getRequestDispatcher("/assignment/manage/add-question").forward(request, response);
        /*
            create with auto mode => show preview first
         */
    }

    public Map<String, String> validateAssignmentInput(
            String classId,
            String title,
            String maxPoint,
            String description,
            String duration,
            String maxAttempts,
            String openAt,
            String closeAt
    ) {
        Map<String, String> errors = new HashMap<>();

        // ===== CLASS ID =====
        if (isEmpty(classId)) {
            errors.put("classId", "Class không được để trống");
        }

        // ===== TITLE =====
        if (isEmpty(title)) {
            errors.put("title", "Title không được để trống");
        } else if (title.length() > 255) {
            errors.put("title", "Title không được vượt quá 255 ký tự");
        }

        // ===== MAX POINT =====
        if (!isInteger(maxPoint)) {
            errors.put("maxPoint", "Max Point phải là số nguyên");
        } else {
            int mp = Integer.parseInt(maxPoint);
            if (mp <= 0) {
                errors.put("maxPoint", "Max Point phải > 0");
            } else if (mp > 100) {
                errors.put("maxPoint", "Max Point không được quá 100");
            }
        }

        // ===== DESCRIPTION =====
        if (isEmpty(description)) {
            errors.put("description", "Description không được để trống");
        }

        // ===== DURATION =====
        if (!isInteger(duration)) {
            errors.put("durationMinutes", "Duration phải là số nguyên");
        } else {
            int d = Integer.parseInt(duration);
            if (d <= 0) {
                errors.put("durationMinutes", "Duration phải > 0 phút");
            }
        }

        // ===== MAX ATTEMPTS =====
        if (!isInteger(maxAttempts)) {
            errors.put("maxAttempts", "Max Attempts phải là số nguyên");
        } else {
            int ma = Integer.parseInt(maxAttempts);
            if (ma <= 0) {
                errors.put("maxAttempts", "Max Attempts phải > 0");
            }
        }

        // ===== DATETIME =====
        LocalDateTime open = null;
        LocalDateTime close = null;

        if (isEmpty(openAt)) {
            errors.put("openAt", "OpenAt không được để trống");
        } else {
            try {
                open = LocalDateTime.parse(openAt);
            } catch (Exception e) {
                errors.put("openAt", "Sai format (yyyy-MM-ddTHH:mm)");
            }
        }

        if (isEmpty(closeAt)) {
            errors.put("closeAt", "CloseAt không được để trống");
        } else {
            try {
                close = LocalDateTime.parse(closeAt);
            } catch (Exception e) {
                errors.put("closeAt", "Sai format (yyyy-MM-ddTHH:mm)");
            }
        }

        // ===== LOGIC TIME =====
        if (open != null && close != null) {
            if (open.isAfter(close)) {
                errors.put("openAt", "Open phải trước Close");
            }

            if (open.isBefore(LocalDateTime.now())) {
                errors.put("openAt", "Open không được ở quá khứ");
            }
        }

        return errors;
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private boolean isInteger(String s) {
        if (isEmpty(s)) {
            return false;
        }
        return s.matches("\\d+"); // chỉ cho số nguyên dương
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
