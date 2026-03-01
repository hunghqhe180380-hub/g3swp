/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.classroom;

import dal.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.*;

/**
 *
 * @author BINH
 */
public class StudentListController extends HttpServlet {

    private EnrollmentDAO enrollDAO;
    private ClassroomDAO classDAO;

    public void init() {
        enrollDAO = new EnrollmentDAO();
        classDAO = new ClassroomDAO();
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
            out.println("<title>Servlet StudentListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StudentListController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        String classId = request.getParameter("classId");
        String search = request.getParameter("search");
        HttpSession ses = request.getSession();
        User user = (User) ses.getAttribute("user");
        Classroom cl = classDAO.getClassInfoByClassId(classId);
        String[] status = request.getParameterValues("txtStatus");
        List<Enrollment> enrolls = enrollDAO.getEnrollmentByClassId(search, classId, status);
        sort(request, enrolls);
        request.setAttribute("classes", cl);
        request.setAttribute("classId", classId);
        request.setAttribute("search", search);
        request.setAttribute("enrolls", enrolls);
        if (status != null) {
            request.setAttribute("statusList", java.util.Arrays.asList(status));
        }
        request.getRequestDispatcher("/view/classroom/student-admin.jsp").forward(request, response);
    }

    private void sort(HttpServletRequest request, List<Enrollment> enrolls)
            throws ServletException, IOException {
        int fnState = 0;
        int tiState = 0;
        try {
            fnState = Integer.parseInt(request.getParameter("txtFullName"));
            tiState = Integer.parseInt(request.getParameter("txtJoined"));
        } catch (Exception e) {
        }
        if (fnState != 0) {
            Comparator<Enrollment> cmp
                    = Comparator.comparing(e -> e.getUser().getFullName(), String.CASE_INSENSITIVE_ORDER);

            if (fnState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(enrolls, cmp);
        } else if (tiState != 0) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            Comparator<Enrollment> cmp = (c1, c2) -> {
                LocalDateTime time1 = LocalDateTime.parse(c1.getJoinedAt(), formatter);
                LocalDateTime time2 = LocalDateTime.parse(c2.getJoinedAt(), formatter);
                return time1.compareTo(time2);
            };

            if (tiState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(enrolls, cmp);
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
        processRequest(request, response);
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
