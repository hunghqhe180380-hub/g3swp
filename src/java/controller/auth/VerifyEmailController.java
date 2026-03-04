/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dal.PasswordDAO;
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
import java.util.HashMap;
import java.util.Map;
import message.Message;
import model.Token;
import util.EmailService;
import validation.InputValidator;

/**
 *
 * @author hung2
 */
public class VerifyEmailController extends HttpServlet {

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
        //list message errors
        Map<String, String> listMSG = new HashMap<>();
        String token = request.getParameter("token");
        //token is not used and not expirytime
        TokenDAO tokenDAO = new TokenDAO();
        String email = tokenDAO.getEmailByToken(token, "VerifyEmail");
        boolean confirmedEmail = false;
        if (email == null) {
            //if email is null
            //thay mean token(action=verify email) is expiried time
            //in this time, need to take email by token expired time
            email = tokenDAO.getEmailByTokenExpiryTime(token, "VerifyEmail");
            //check email conifmed?
            //if confirmed => login
            UserDAO userDAO = new UserDAO();
            System.out.println("Emailll: " + email);
            if (userDAO.isConfirmEmail(email)) {
                HttpSession session = request.getSession();
                session.setAttribute("msgVeriyEmail", Message.MSG104);
                response.sendRedirect("login");
                return;
            }
            listMSG.put("msgToken", Message.MSG103);
            request.setAttribute("listMSG", listMSG);
            request.setAttribute("email", email);
            request.getRequestDispatcher("verify-email.jsp").forward(request, response);
            return;
        }
        //if have not erros => reset password
        if (listMSG.isEmpty()) {
            UserDAO userDAO = new UserDAO();
            userDAO.setConfimedEmail(email);
            System.out.println(Message.MSG104);
            HttpSession session = request.getSession();
            session.setAttribute("msgVeriyEmail", Message.MSG104);
            response.sendRedirect("login");
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
        //list message errors
        Map<String, String> listMSG = new HashMap<>();
        //get email from request
        String email = request.getParameter("email");
        //There's no need to check if the email has been confirmed,
        //because if the token has expired or already been used, 
        //user can't be able to access this page.
        UserDAO userDAO = new UserDAO();
        String userID = userDAO.getUserIdByEmail(email);
        //send email
        EmailService emailService = new EmailService();
        //generate new token
        String newToken = emailService.generateToken();
        Token token = new Token(email,
                userID,
                false,
                newToken,
                emailService.setExpriryDateTime());

        String linkVerifyEmail = "http://localhost:8080/POET/verify-email?token=" + newToken;
        //insert newToken with action=VerifyEmail into Database
        TokenDAO tokenDAO = new TokenDAO();
        tokenDAO.insertToTokenDB(token, "VerifyEmail");
        emailService.sendEmail(email, linkVerifyEmail, userDAO.getUserNameByEmail(email), "VerifyEmail");
        //send link to this email 
        listMSG.put("msgToken", Message.MSG104);
        request.setAttribute("listMSG", listMSG);
        request.getRequestDispatcher("login.jsp").forward(request, response);
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
