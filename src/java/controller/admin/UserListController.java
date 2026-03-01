/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.User;
import util.PagingUtil;

/**
 *
 * @author BINH
 */
public class UserListController extends HttpServlet {

    private UserDAO dao;

    public void init() {
        dao = new UserDAO();
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
            out.println("<title>Servlet UserListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserListController at " + request.getContextPath() + "</h1>");
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
        String searchUser = request.getParameter("search");
        String[] roles = request.getParameterValues("txtRole");
        List<User> users = dao.getAllUsers(searchUser, roles);
        sort(request, users);
        paging(request, users);
        request.setAttribute("search", searchUser);
        if (roles != null) {
            request.setAttribute("roleList", java.util.Arrays.asList(roles));
        }
        request.setAttribute("users", users);
        request.getRequestDispatcher("/view/admin/list-account.jsp").forward(request, response);
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

    private void sort(HttpServletRequest request, List<User> users)
            throws ServletException, IOException {
        int fnState = 0;
        try {
            fnState = Integer.parseInt(request.getParameter("txtFullName"));
        } catch (Exception e) {
        }
        if (fnState != 0) {
            Comparator<User> cmp
                    = Comparator.comparing(User::getFullName, String.CASE_INSENSITIVE_ORDER);

            if (fnState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(users, cmp);
        }
    }

    private void paging(HttpServletRequest request, List<User> users)
            throws ServletException, IOException {
        int nrpp = Integer.parseInt(request.getServletContext().getInitParameter("nrpp"));
        int size = users.size();
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
