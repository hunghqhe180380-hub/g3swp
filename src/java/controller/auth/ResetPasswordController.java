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
import java.util.HashMap;
import java.util.Map;
import message.Message;
import util.PasswordService;
import validation.InputValidator;

/**
 *
 * @author hung2
 */
public class ResetPasswordController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
        //validation token exist and no expirytime
        String token = request.getParameter("token");
        TokenDAO tokenForgetDAO = new TokenDAO();
        //get email of this user
        UserDAO userDAO = new UserDAO();
        String userId = userDAO.getUserIdByTokenRequest(token, "ResetPassword");
        String email = userDAO.getEmailByUserId(userId);
        //if exist token and not expiry time => allow to reset password
        if (tokenForgetDAO.isExistToken(token)) {
            request.setAttribute("email", email);
            request.setAttribute("token", token);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        } else {
            //token is not exits or expiry time => not allow to reset password
            Map<String, String> listMSG = new HashMap<>();
            listMSG.put("msgToken", Message.MSG101);
            request.setAttribute("listMSG", listMSG);
            request.getRequestDispatcher("request-password.jsp").forward(request, response);
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
        String token = request.getParameter("token");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        //token is not used and not expirytime
        TokenDAO tokenForgetDAO = new TokenDAO();
        if (tokenForgetDAO.getEmailByToken(token) == null) {
            listMSG.put("msgToken", Message.MSG103);
        }
        //validator new password and confirm password
        PasswordService passwordService = new PasswordService();
        if (newPassword == null) {
            listMSG.put("msgPassword", Message.MSG04);
        } else {
            InputValidator inputValidator = new InputValidator();
            if (inputValidator.isPassword(newPassword) != null) {
                listMSG.put("msgPassword", inputValidator.isPassword(newPassword));
            };
        }
        if (newPassword != null && confirmPassword != null && !passwordService.isPasswordMatch(newPassword, confirmPassword)) {
            listMSG.put("msgConfirmPassword", Message.MSG07);
        }

        //if not have erros => reset password
        if (listMSG.isEmpty()) {
            //reset password
            PasswordDAO passwordDAO = new PasswordDAO();
            passwordDAO.resetPassword(email, newPassword);
            //after reset password => token is not reused
            tokenForgetDAO.setTokenIsUsed(token, "ResetPassword");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("email", email);
            request.setAttribute("listMSG", listMSG);
            request.setAttribute("newPassword", newPassword);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
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
