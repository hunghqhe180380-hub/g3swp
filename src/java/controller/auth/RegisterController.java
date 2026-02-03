/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dal.TokenDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import message.Message;
import model.Token;
import model.User;
import util.EmailService;
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
        HttpSession session = request.getSession();
        if (session != null) {
            request.setAttribute("msgVeriyEmail", session.getAttribute("msgVeriyEmail"));
            request.setAttribute("listMSG", session.getAttribute("listMSG"));
            request.setAttribute("userName", session.getAttribute("userName"));
            request.setAttribute("fullName", session.getAttribute("fullName"));
            request.setAttribute("email", session.getAttribute("email"));
            request.setAttribute("phoneNumber", session.getAttribute("phoneNumber"));
            request.setAttribute("password", session.getAttribute("password"));
            session.removeAttribute("msgVeriyEmail");
            session.removeAttribute("listMSG");
            session.removeAttribute("userName");
            session.removeAttribute("fullName");
            session.removeAttribute("email");
            session.removeAttribute("phoneNumber");
            session.removeAttribute("password");
        }
        request.getRequestDispatcher("register.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        //list message errors
        Map<String, String> listMSG = validator(userName, fullName, email, phoneNumber, password, confirmPassword);
        //if validator is true => allow to register account        
        String userID = userDAO.generateID();
        String accCode = userDAO.generateAccCode();
        //encrypte password
        if (listMSG.isEmpty()) {
            User user = new User(userID,
                    userName,
                    fullName,
                    email,
                    phoneNumber,
                    password,
                    accCode);
            //inser new user into database
            User newUser = userDAO.isRegister(user);
            System.out.println(newUser);
            //verify email to done register
            EmailService emailService = new EmailService();
            //genarate token
            String newToken = emailService.generateToken();
            String linkVerifyEmail = "http://localhost:8080/POET/verify-email?token=" + newToken;
            Token token = new Token(email,
                    user.getUserID(),
                    false,
                    newToken,
                    emailService.setExpriryDateTime());
            //send link to this email
            TokenDAO tokenDAO = new TokenDAO();
            boolean isInsert = tokenDAO.insertToTokenDB(token, "VerifyEmail");
            boolean isSend = emailService.sendEmail(email, linkVerifyEmail, userName, "VerifyEmail");
            //send link to this email 
            session.setAttribute("msgVeriyEmail", Message.MSG98);
            response.sendRedirect("login");
        } else {
            //if input wrong format => back to register (require user have to reinput)
            getInformation(request, response,
                    userName, fullName,
                    email, phoneNumber,
                    password);
            session.setAttribute("listMSG", listMSG);
            response.sendRedirect("register");
        }
    }

    protected void getInformation(HttpServletRequest request, HttpServletResponse response,
            String userName, String fullName,
            String email, String phoneNumber,
            String password)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setAttribute("userName", userName);
        session.setAttribute("fullName", fullName);
        session.setAttribute("email", email);
        session.setAttribute("phoneNumber", phoneNumber);
        session.setAttribute("password", password);
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

        //check exist
        UserDAO userDAO = new UserDAO();
        if (userDAO.isExistEmail(email)) {
            errors.put("msgEmail", Message.MSG12);
        }
        if (userDAO.isExistUserName(userName)) {
            errors.put("msgUserName", Message.MSG00);
        }
        return errors;
    }

    //check confirm password match password ? 
    private String isConfirmPassword(String password, String confirmPassword) {

        if (password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return Message.MSG04; // Password is required
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
