/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import message.Message;
import model.User;
import validation.InputValidator;

/**
 *
 * @author hung2
 */
public class LoginController extends HttpServlet {

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("/login.jsp").forward(request, response);
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
        UserDAO userDAO = new UserDAO();
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        //list message errors
        Map<String, String> listMSG = validator(email, password);
        if (listMSG.isEmpty()) {
            //if UserName/Email and Password is correct => allow to login
            User userLogin = userDAO.isLogin(email, password);
            //email is confirmed to login
            if (userLogin.getEmailConfirm() == 1) {
                //login success => save user's session
                HttpSession session = request.getSession();
                session.setAttribute("user", userLogin);
                //route user by this role
                request.getRequestDispatcher("/View/" + userLogin.getRole() + "/dashboard.jsp").forward(request, response);
            } else {
<<<<<<< HEAD
                //email is confirmed to login
                if (userLogin.getEmailConfirm() == 1 && userLogin != null) {
                    //login success => save user's session
                    HttpSession session = request.getSession();
                    session.setAttribute("user", userLogin);
                    //route user by this role
                    request.getRequestDispatcher("/View/" + userLogin.getRole() + "/dashboard.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("MSG99", Message.MSG99);
                    return;
                }
=======
                request.setAttribute("MSG99", Message.MSG99);
>>>>>>> parent of 4591fbc (hunghqhe180380)
            }
        }
        request.setAttribute("email", email);
        request.setAttribute("listMSG", listMSG);
        request.getRequestDispatcher("login.jsp").forward(request, response);

    }

    private Map<String, String> validator(
            String userName,
            String password) {

        Map<String, String> errors = new HashMap<>();
        InputValidator inputValidator = new InputValidator();
        // userName is blank ? return : continue
        if (userName.isEmpty()) {
            errors.put("msgUserName", Message.MSG01);
            return errors;
        }
        // valid input username
        if (!userName.contains("@") && inputValidator.isUserName(userName) != null) {
            errors.put("msgUserName", inputValidator.isUserName(userName.trim()));
        }

        // email
        if (userName.contains("@") && inputValidator.isEmail(userName) != null) {
            errors.put("msgUserName", inputValidator.isEmail(userName.trim()));
        }

        // password
        if (inputValidator.isPassword(password) != null) {
            errors.put("msgPassword", inputValidator.isPassword(password.trim()));
        }

        return errors;
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
