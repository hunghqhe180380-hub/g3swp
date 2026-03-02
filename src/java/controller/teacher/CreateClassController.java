/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.teacher;

import dal.TeacherDAO;
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
import model.User;
import validation.InputValidator;

/**
 *
 * @author hung2
 */
public class CreateClassController extends HttpServlet {

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
            out.println("<title>Servlet CreateClassController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateClassController at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("view/classroom/create_class.jsp").forward(request, response);
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
        String className = request.getParameter("className");
        String subject = request.getParameter("subject");
        String studentLimit = request.getParameter("studentLimit");
        System.out.println("student limit: " + studentLimit.length());
        HttpSession session = request.getSession();
        User teacher = (User) session.getAttribute("user");
        Map<String, String> listMSG = validator(teacher.getUserID(), className, subject, studentLimit);
        if (listMSG.size() > 0) {
            request.setAttribute("className", className);
            request.setAttribute("subject", subject);
            request.setAttribute("studentLimit", studentLimit);
            request.setAttribute("listMSG", listMSG);
            request.getRequestDispatcher("view/classroom/create_class.jsp").forward(request, response);
            return;
        } else {
            TeacherDAO techerDAO = new TeacherDAO();
            User user = (User) session.getAttribute("user");
            techerDAO.createNewClass(className, subject, user.getUserID(), studentLimit);
            request.getRequestDispatcher("route").forward(request, response);
        }
    }
    

    //validation 
    private Map<String, String> validator(
            String teacherID,
            String className,
            String subject,
            String studentLimitRaw) {
        TeacherDAO teacherDAO = new TeacherDAO();
        Map<String, String> errors = new HashMap<>();

        // className is blank ? return : continue
        if (className.isEmpty()) {
            errors.put("msgClassName", Message.MSG301);
        }
        // className of teachers unique
        if(teacherDAO.isExistClassName(teacherID, className)){
            errors.put("msgClassName", Message.MSG305);
        }
        // subject is blank ? return : continue
        if (subject.isEmpty()) {
            errors.put("msgSubject", Message.MSG302);
        }

        // studentLimitRaw is blank ? return : continue
        if (studentLimitRaw.isEmpty()) {
            errors.put("msgStudentLimit", Message.MSG303);
            return errors;
        }

        // studentLimitRaw must be > 0 and < 100
        if (!studentLimitRaw.isEmpty()) {
            if (Integer.parseInt(studentLimitRaw) <= 0 || Integer.parseInt(studentLimitRaw) > 100) {
                errors.put("msgStudentLimit", Message.MSG304);
            }
            return errors;
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
