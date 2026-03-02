/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.classroom;

import dal.ClassroomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.Classroom;
import util.PagingUtil;

/**
 *
 * @author BINH
 */
public class ClassListController extends HttpServlet {

    private ClassroomDAO dao;

    public void init() {
        dao = new ClassroomDAO();
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
            out.println("<title>Servlet ClassListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ClassListController at " + request.getContextPath() + "</h1>");
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
        String search = request.getParameter("search");
        List<Classroom> classes = dao.getAllClassBySearch(search);
        sort(request, classes);
        paging(request, classes);
        request.setAttribute("search", search);
        request.setAttribute("classes", classes);
        request.getRequestDispatcher("/view/classroom/list-admin.jsp").forward(request, response);
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

    private void sort(HttpServletRequest request, List<Classroom> classes)
            throws ServletException, IOException {
        int clState = 0;
        int teState = 0;
        int tiState = 0;
        try {
            clState = Integer.parseInt(request.getParameter("txtClassName"));
            teState = Integer.parseInt(request.getParameter("txtTeacherName"));
            tiState = Integer.parseInt(request.getParameter("txtCreateAt"));
        } catch (Exception e) {
        }
        if (clState != 0) {
            Comparator<Classroom> cmp
                    = Comparator.comparing(Classroom::getName, String.CASE_INSENSITIVE_ORDER);

            if (clState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(classes, cmp);
        } else if (teState != 0) {
            Comparator<Classroom> cmp
                    = Comparator.comparing(Classroom::getTeacherName, String.CASE_INSENSITIVE_ORDER);

            if (teState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(classes, cmp);
        } else if (tiState != 0) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            Comparator<Classroom> cmp = (c1, c2) -> {
                LocalDateTime time1 = LocalDateTime.parse(c1.getCreatedAt(), formatter);
                LocalDateTime time2 = LocalDateTime.parse(c2.getCreatedAt(), formatter);
                return time1.compareTo(time2);
            };

            if (tiState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(classes, cmp);
        }
    }

    private void paging(HttpServletRequest request, List<Classroom> classes)
            throws ServletException, IOException {
        int nrpp = Integer.parseInt(request.getServletContext().getInitParameter("nrpp"));
        int size = classes.size();
        request.setAttribute("nrpp", nrpp);
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
