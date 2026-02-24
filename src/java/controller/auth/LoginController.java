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
import java.util.HashMap;
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
public class LoginController extends HttpServlet {

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
        HttpSession session = request.getSession();
        if (session != null) {
            request.setAttribute("userName", session.getAttribute("userName"));
            request.setAttribute("listMSG", session.getAttribute("listMSG"));
            request.setAttribute("user", session.getAttribute("user"));
            request.setAttribute("msgVeriyEmail", session.getAttribute("msgVeriyEmail"));
            session.removeAttribute("userName");
            session.removeAttribute("listMSG");
            session.removeAttribute("user");
            session.removeAttribute("msgVeriyEmail");
        }
        request.getRequestDispatcher("login.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");

        //list message input errors
        Map<String, String> listMSG = validator(userName, password);
        if (listMSG.isEmpty()) {
            //if UserName/Email and Password input right format => continue
            //session have : useID, role, userName, isConfimedEmail 
            User userLogin = userDAO.isLogin(userName, password);
            //check user exist in database
            if (userLogin == null) {
                listMSG.put("msgInvalidUser", Message.MSG05);
                session.setAttribute("userName", userName);
                session.setAttribute("listMSG", listMSG);
                response.sendRedirect("login");
                return;
            }
            //email is confirmed to login
            if (userLogin.getEmailConfirm() == 1) {
                //login success => save user's session
                userLogin.setUrlImgProfile(userDAO.getAvatarUrlByUserID(userLogin.getUserID()));
                System.out.println("getavt: " + userDAO.getAvatarUrlByUserID(userLogin.getUserID()));
                System.out.println("userLogin.setUrlImgProfile: " + userLogin.getUrlImgProfile());
                session.setAttribute("user", userLogin);
                //route user by this role
                request.getRequestDispatcher("View/" + userLogin.getRole() + "/dashboard.jsp").forward(request, response);
                return;
            } else {
                String email = "";
                if (userName.contains("@")) {
                    // login bằng email
                    email = userName;
                } else {
                    // login bằng username
                    email = userDAO.getEmailByUserName(userName);
                }
                //auto send email to account not verify yet 
                EmailService emailService = new EmailService();
                String newToken = emailService.generateToken();
                String linkVerifyEmail = "http://localhost:8080/POET/verify-email?token=" + newToken;
                System.out.println("EmailL:" + email);
                Token newTokenForgetPassword = new Token(
                        email,
                        userLogin.getUserID(),
                        false,
                        newToken,
                        emailService.setExpriryDateTime());
                //send link to this email 
                TokenDAO tokenForgetDAO = new TokenDAO();
                boolean isInsert = tokenForgetDAO.insertToTokenDB(newTokenForgetPassword, "VerifyEmail");
                boolean isSend = emailService.sendEmail(email, linkVerifyEmail, userName, "VerifyEmail");
                //send link to this email 
                session.setAttribute("msgVeriyEmail", Message.MSG99);
            }
        }
        session.setAttribute("userName", userName);
        session.setAttribute("listMSG", listMSG);
        response.sendRedirect("login");
        return;
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
