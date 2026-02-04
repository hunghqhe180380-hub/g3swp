/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.account;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author hung2
 */
public class ProfileController extends HttpServlet {

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

        //check user login ? continue : back to login
        if (session == null || userLogin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String userRole = userLogin.getRole();
        UserDAO userDAO = new UserDAO();
        ////userID, userName, fullName, email, phoneNumber, accountCode
        User user = userDAO.getUserInforByID(userLogin.getUserID());
        //session have : userID, userName, role, email, phone 
        request.setAttribute("user", user);
//        System.out.println("Email: " + user.getEmail());
//        System.out.println("UserNameLg: " + user.getUserName());
//        System.out.println("Accoun Code: " + user.getAccountCode());
//        System.out.println("Full Name: " + user.getFullName());
//        System.out.println("Phone Number: " + user.getPhoneNumber());
        switch (userRole.toLowerCase()) {
            case "student":
                request.getRequestDispatcher("/View/Student/profile.jsp").forward(request, response);
                break;
            case "teacher":
                request.getRequestDispatcher("/View/Teacher/profile.jsp").forward(request, response);
                break;
            case "admin":
                request.getRequestDispatcher("/View/Admin/profile.jsp").forward(request, response);
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
        //this function use to change profile
        String newUserName = request.getParameter("userName");
        String newAccountCode = request.getParameter("accounCode");
        String newFullName = request.getParameter("fullName");
        String newPhoneNumber = request.getParameter("phoneNumber");
        // allow to update avatar

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
