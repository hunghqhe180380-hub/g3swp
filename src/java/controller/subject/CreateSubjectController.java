/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.subject;

import dal.SubjectDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author hung2
 */
public class CreateSubjectController extends HttpServlet {

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
            out.println("<title>Servlet CreateSubjectController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateSubjectController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("/view/admin/create-subject.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        if (action.equalsIgnoreCase("reset")) {
            request.removeAttribute("listMSG");
            request.removeAttribute("subjectName");
        } else {
            String subjectName = request.getParameter("subjectName");
            Map<String, String> listMSG = validSubjectName(subjectName);

            if (listMSG.size() == 0) {
                listMSG.put("msgSubjectSucces", message.Message.MSG502);
                SubjectDAO subjectDAO = new SubjectDAO();
                subjectDAO.createSubject(subjectName);
            }
            request.setAttribute("listMSG", listMSG);
            request.setAttribute("subjectName", subjectName.trim());
        }
        request.getRequestDispatcher("/view/admin/create-subject.jsp").forward(request, response);
    }

    public Map<String, String> validSubjectName(String subjectName) {
        Map<String, String> errors = new HashMap<>();
        if (subjectName.trim().isEmpty()) {
            errors.put("msgSubject", message.Message.MSG500);
            return errors;
        }

        if (subjectName.length() > 30) {
            errors.put("msgSubject", message.Message.MSG501);
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
