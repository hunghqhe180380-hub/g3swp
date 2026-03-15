/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.classroom;

import dal.ClassroomDAO;
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
public class DeleteClassController extends HttpServlet {

    private ClassroomDAO dao;

    public void init() {
        dao = new ClassroomDAO();
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
            out.println("<title>Servlet DeleteClassController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteClassController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
        String classId = request.getParameter("classId");
        String pageIndex = request.getParameter("pageIndex");
        HttpSession ses = request.getSession();
        User user = (User) ses.getAttribute("user");

        //if role = Admin => delete class without condition
        if (user.getRole().equals("Admin")) {
            //delete class 
            dao.deleteClassroom(classId);
            response.sendRedirect(request.getContextPath() + "/classroom/view/class-list?index=" + pageIndex);
        } else if (user.getRole().equals("Teacher")) {
            //if role = Teacher => class have student joined ? not allow to delete class : allow to delete class
            String msgDeleteThisClass = null;
            if (dao.hasStudentInClass(classId)) {
                msgDeleteThisClass = "This class have student, not allow to DELETE.";
            } else {
                msgDeleteThisClass = "Delete class success!";
                dao.deleteClassroom(classId);
            }
            request.getSession().setAttribute("msgDeleteThisClass", msgDeleteThisClass);
            response.sendRedirect(request.getContextPath() + "/account/dashboard");
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
