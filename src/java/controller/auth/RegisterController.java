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
public class RegisterController extends HttpServlet {

    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
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
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    //confirm email when register
    public boolean isConfirmEmail() {
        return false;
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
        String userName = request.getParameter("userName").trim();
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phoneNumber = request.getParameter("phoneNumber").trim();
        String password = request.getParameter("password").trim();
        String confirmPassword = request.getParameter("confirmPassword").trim();

        //list message errors
        Map<String, String> listMSG = validator(userName, fullName, email, phoneNumber, password, confirmPassword);
        //if validator is true => allow to register account        
        String userID = userDAO.generateID();
        String accCode = userDAO.generateAccCode();
//        System.out.println("User ID: " + userID);
//        System.out.println("Account code: " + accCode);
//        System.out.println("Email: " + email);
//        System.out.println("Phone: " + phoneNumber);
//        System.out.println("Pass: " + password);
//        System.out.println("Confirm: " + confirmPassword);

        if (listMSG.isEmpty()) {
            User newUser = new User(userID,
                    userName,
                    fullName,
                    email,
                    phoneNumber,
                    password,
                    accCode);
            userDAO.isRegister(newUser);

            //tạm thời chưa làm register, đợi mofify lại database đã 
            //còn confirm email chưa làm 
            request.getRequestDispatcher("home.jsp").forward(request, response);
        } else {
            //if input wrong format => back to register (require user have to reinput)
            getInformation(request, response,
                    userName, fullName,
                    email, phoneNumber,
                    password);
            request.setAttribute("listMSG", listMSG);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    protected void getInformation(HttpServletRequest request, HttpServletResponse response,
            String userName, String fullName,
            String email, String phoneNumber,
            String password)
            throws ServletException, IOException {

        request.setAttribute("userName", userName);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phoneNumber", phoneNumber);
        request.setAttribute("password", password);
    }

    private Map<String, String> validator(
            String userName,
            String fullName,
            String email,
            String phoneNumber,
            String password,
            String confirmPassword) {

        Map<String, String> errors = new HashMap<>();
        InputValidator inputValidator = new InputValidator();

        // valid input username
        if (inputValidator.isUserName(userName) != null) {
            errors.put("msgUserName", inputValidator.isUserName(userName.trim()));
        }
        // full name
        if (inputValidator.isFullName(fullName) != null) {
            errors.put("msgFullName", inputValidator.isFullName(fullName.trim()));
        }
        // email
        if (inputValidator.isEmail(email) != null) {
            errors.put("msgEmail", inputValidator.isEmail(email.trim()));
        }
        // phone number
        if (inputValidator.isPhoneNumber(phoneNumber) != null) {
            errors.put("msgPhoneNumber", inputValidator.isPhoneNumber(phoneNumber.trim()));
        }
        // password
        if (inputValidator.isPassword(password) != null) {
            errors.put("msgPassword", inputValidator.isPassword(password.trim()));
        }
        // confirm password
        if (isConfirmPassword(password, confirmPassword) != null) {
            errors.put("msgConfirmPassword", isConfirmPassword(password.trim(), confirmPassword.trim()));
        }
        return errors;
    }

    //check confirm password match password ? 
    private String isConfirmPassword(String password, String confirmPassword) {

        if (password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return Message.MSG07; // Password is required
        }

        if (!password.equals(confirmPassword)) {
            return Message.MSG07; // Passwords do not match
        }

        return null; // valid
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
