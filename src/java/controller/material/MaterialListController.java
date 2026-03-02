/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.material;

import dal.MaterialDAO;
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
public class MaterialListController extends HttpServlet {

    private MaterialDAO dao;

    public void init() {
        dao = new MaterialDAO();
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
            out.println("<title>Servlet MaterialListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MaterialListController at " + request.getContextPath() + "</h1>");
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
        //int index = Integer.parseInt(request.getParameter("index"));
        String classId = request.getParameter("classId");
        String search = request.getParameter("search");
        Classroom cl = dao.getClassInfoByClassId(classId);
        HttpSession ses = request.getSession();
        User user = (User) ses.getAttribute("user");
        List<Material> materials = dao.getMaterialByClassId(search, classId);
        sort(request, materials);
        request.setAttribute("classes", cl);
        request.setAttribute("search", search);
        request.setAttribute("materials", materials);
//        if (user.getRole().equalsIgnoreCase("admin")) {
//            request.getRequestDispatcher("/view/material/list-admin.jsp").forward(request, response);
//        } else {
            request.getRequestDispatcher("/view/material/list-user.jsp").forward(request, response);
        //}
    }

    private void sort(HttpServletRequest request, List<Material> materials)
            throws ServletException, IOException {
        int tlState = 0;
        int tiState = 0;
        try {
            tlState = Integer.parseInt(request.getParameter("txtTitle"));
            tiState = Integer.parseInt(request.getParameter("txtCreated"));
        } catch (Exception e) {
        }
        if (tlState != 0) {
            Comparator<Material> cmp
                    = Comparator.comparing(Material::getTitle, String.CASE_INSENSITIVE_ORDER);

            if (tlState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(materials, cmp);
        } else if (tiState != 0) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            Comparator<Material> cmp = (c1, c2) -> {
                LocalDateTime time1 = LocalDateTime.parse(c1.getCreatedAt(), formatter);
                LocalDateTime time2 = LocalDateTime.parse(c2.getCreatedAt(), formatter);
                return time1.compareTo(time2);
            };

            if (tiState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(materials, cmp);
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
