/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.account;

import controller.auth.RouteByRoleController;
import controller.material.MaterialListController;
import dal.MaterialDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Classroom;
import model.User;

/**
 *
 * @author hung2
 */
public class DashboardController extends HttpServlet {

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
        HttpSession session = request.getSession();

        User userLogin = (User) session.getAttribute("user");
        if (userLogin == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        RouteByRoleController route = new RouteByRoleController();
        List<Classroom> classList = route.showClassList(userLogin.getUserID(), userLogin.getRole());
         //get totalMaterial
        MaterialDAO mtrCtrl = new MaterialDAO();
        session.setAttribute("totalMaterial", mtrCtrl.getTotalMaterial(classList));
        session.setAttribute("classList", classList);
        //check user login ? continue : back to login
        if (userLogin == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userRole = userLogin.getRole();
        switch (userRole) {
            case "Student":
                request.getRequestDispatcher("/view/student/dashboard.jsp").forward(request, response);
                break;
            case "Teacher":
                request.getRequestDispatcher("/view/teacher/dashboard.jsp").forward(request, response);
                break;
            case "Admin":
                request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
                break;
            default:
                throw new AssertionError();
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
        processRequest(request, response);
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
