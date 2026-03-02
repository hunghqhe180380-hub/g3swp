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
import model.Classroom;

/**
 *
 * @author BINH
 */
public class EditClassController extends HttpServlet {

    private ClassroomDAO dao;

    public void init() {
        dao = new ClassroomDAO();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditClassController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditClassController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("classId");
        Classroom classes = dao.getClassInfoByClassId(classId);
        request.setAttribute("classroom", classes);
        request.getRequestDispatcher("/view/classroom/edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String classId = request.getParameter("classId");
        String className = request.getParameter("name");
        String subject = request.getParameter("subject");
        String maxStudent = request.getParameter("maxStudents");
        Classroom classes = dao.getClassInfoByClassId(classId);

        if (className != null && !className.isEmpty()) {
            classes.setName(className);
        }
        if (subject != null && !subject.isEmpty()) {
            classes.setSubject(subject);
        }
        if (maxStudent != null && !maxStudent.isEmpty()) {
            int max = Integer.parseInt(maxStudent);            
            classes.setMaxStudent(max);
        }        
        dao.updateClassroom(classes);
        request.setAttribute("classroom", classes);
        request.getRequestDispatcher("/view/classroom/edit.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
