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
import java.util.HashMap;
import java.util.Map;
import message.Message;
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        InputValidator inputValidator = new InputValidator();
        UserDAO userDAO = new UserDAO();
        request.setAttribute("email", email);
        //list message errors
        Map<String, String> listMSG = validator(email);

        if (listMSG.isEmpty()) {
            if (!userDAO.isExistEmail(email)) {
                listMSG.put("msgEmail", Message.MSG19);
            } else {
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
        }
        System.out.println(listMSG.size());

        request.setAttribute("listMSG", listMSG);
        request.getRequestDispatcher("request-password.jsp").forward(request, response);
    }

    private Map<String, String> validator(String email) {
        Map<String, String> errors = new HashMap<>();
        InputValidator inputValidator = new InputValidator();
        // email is blank ? return : continue
        if (email.isEmpty()) {
            errors.put("msgEmail", Message.MSG11);
            return errors;
        }

        // email
        if (inputValidator.isEmail(email) != null) {
            errors.put("msgEmail", inputValidator.isEmail(email.trim()));
        }

        return errors;
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
