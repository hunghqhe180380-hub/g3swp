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
import java.time.LocalDateTime;
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
public class ForgotPasswordController extends HttpServlet {

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
            out.println("<title>Servlet ForgotPasswordController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPasswordController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("request-password.jsp").forward(request, response);
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
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        String userID = userDAO.getUserIdByEmail(email);
        String userName = userDAO.getUserNameByEmail(email);
        //list message errors
        Map<String, String> listMSG = validator(email);
        if (listMSG.isEmpty() && userDAO.isExistEmail(email) == true) {
            //send email allow to reset password
            EmailService serviceEmail = new EmailService();
            String newToken = serviceEmail.generateToken();
            String linkReset = "http://localhost:8080/POET/reset-password?token=" + newToken;
            Token newTokenForgetPassword = new Token(
                    email,
                    userID,
                    false,
                    newToken,
                    serviceEmail.setExpriryDateTime());
            //send link to this email 
            TokenDAO tokenForgetDAO = new TokenDAO();
            boolean isInsert = tokenForgetDAO.insertTokenForget(newTokenForgetPassword, "ResetPassword");
            boolean isSend = serviceEmail.sendEmail(email, linkReset, userName, "resetPassword");
            listMSG.put("msgEmail", Message.MSG102);
        } else {
            //wrong format email or email is not exist(have not register)
            if (!userDAO.isExistEmail(email) && listMSG.isEmpty()) {
                listMSG.put("msgEmail", Message.MSG19);
            }
        }
        //back to request-password.jsp
        request.setAttribute("email", email);
        request.setAttribute("listMSG", listMSG);
        request.getRequestDispatcher("request-password.jsp").forward(request, response);
    }

    private Map<String, String> validator(String email) {
        Map<String, String> errors = new HashMap<>();
        InputValidator inputValidator = new InputValidator();

        // email
        if (inputValidator.isEmail(email) != null) {
            errors.put("msgEmail", inputValidator.isEmail(email.trim()));
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
