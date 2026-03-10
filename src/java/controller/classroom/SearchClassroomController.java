/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.classroom;

import dal.ClassroomDAO;
import dal.MaterialDAO;
import dal.StudentDAO;
import dal.TeacherDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.User;
import model.Classroom;

/**
 *
 * @author hung2
 */
public class SearchClassroomController extends HttpServlet {

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
            out.println("<title>Servlet SearchClassroomController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchClassroomController at " + request.getContextPath() + "</h1>");
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
        System.out.println("du pót");
        String nameClass = request.getParameter("nameClass");
        request.setAttribute("nameClass", nameClass);
        if (nameClass.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/account/dashboard");
            return;
        }
        HttpSession session = request.getSession();
        User userLogin = (User) session.getAttribute("user");
        String userRole = userLogin.getRole();
        //role : Teacher can only search their classroom by class name
        //role : Student can only search classroom that they have joined
        //role : Admin can search all of class in database
        ClassroomDAO clsDAO = new ClassroomDAO();
        //get all list class of this user (by user's role)
        List<Classroom> listAllClass = new ArrayList<>();
        if (userLogin.getRole().equalsIgnoreCase("student")) {
            StudentDAO stDAO = new StudentDAO();
            listAllClass = stDAO.getListClassJoined(userLogin.getUserID());
        }
        if (userLogin.getRole().equalsIgnoreCase("teacher")) {
            TeacherDAO teacherDAO = new TeacherDAO();
            listAllClass = teacherDAO.getClassListByTeacherId(userLogin.getUserID());
        }
        //role admin have not done yet
        //searche class
        List<Classroom> listClassSearchByName = searchClassroomByName(nameClass, listAllClass);
        //get total material follow class list by class's id
        MaterialDAO mtrDAO = new MaterialDAO();
        session.setAttribute("totalMaterial", mtrDAO.getTotalMaterial(listClassSearchByName));
        System.out.println("Total nenene: " + mtrDAO.getTotalMaterial(listClassSearchByName));
        System.out.println("list search: " + listClassSearchByName.size());
        session.setAttribute("classList", listClassSearchByName);
        request.getRequestDispatcher("/view" + "/" + userLogin.getRole().toLowerCase() + "/dashboard.jsp").forward(request, response);
    }

    //function search class by name
    private List<Classroom> searchClassroomByName(String className, List<Classroom> listAllClass) {
        List<Classroom> resultSearch = new ArrayList<>();
        for (int i = 0; i < listAllClass.size(); i++) {
            if (listAllClass.get(i).getName().toLowerCase().contains(className.trim().toLowerCase())) {
                resultSearch.add(listAllClass.get(i));
                System.out.println("hahaha");
            }
        }

        return resultSearch;
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
