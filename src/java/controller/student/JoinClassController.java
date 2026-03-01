/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student;

import dal.ClassroomDAO;
import dal.StudentDAO;
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
import message.Message;
import model.Classroom;
import model.User;
import validation.InputValidator;

/**
 *
 * @author hung2
 */
public class JoinClassController extends HttpServlet {

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
        HttpSession session = request.getSession();
        List<Classroom> classList = (ArrayList<Classroom>) session.getAttribute("classList");
        String classCode = request.getParameter("classCode");
        ClassroomDAO clsDAO = new ClassroomDAO();
        String clsId = clsDAO.getClassIdByCode(classCode);
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
        if (action.equalsIgnoreCase("searchClass")) {
            doGet(request, response);
        } else {

            String classCode = request.getParameter("classCode");
            HttpSession session = request.getSession();
              User student = (User) session.getAttribute("user");
            Map<String, String> listMSG = validator(classCode, student.getUserID());
            if (listMSG.size() > 0) {
                request.setAttribute("classCode", classCode);
                request.setAttribute("listMSG", listMSG);
            } else {
              
                StudentDAO stDAO = new StudentDAO();
                //get class id by class code
                ClassroomDAO clsDAO = new ClassroomDAO();
                String classId = clsDAO.getClassIdByCode(classCode);
                stDAO.joinClass(classId, student.getUserID());
                request.setAttribute("msgClassCode", "Join new class succesfull.");
            }
            request.getRequestDispatcher("route").forward(request, response);

        }

    }
    
    
    //validator
    private Map<String, String> validator(
            String classCode,
            String studentId) {

        Map<String, String> errors = new HashMap<>();

        // classcode is blank ? return : continue
        if (classCode.isEmpty()) {
            errors.put("msgClassCode", Message.MSG310);
            return errors;
        }
        // class code exist?
        if (classCode != null) {
            ClassroomDAO clsDAO = new ClassroomDAO();
            if (clsDAO.getClassIdByCode(classCode) == null) {
                errors.put("msgClassCode", Message.MSG311);
                return errors;
            } else {
                //check user joined class?
                StudentDAO stDAO = new StudentDAO();
                if(stDAO.isJoinedClass(studentId, classCode)){
                    errors.put("msgClassCode", Message.MSG313);
                }
                //check class is full or not?
            }

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
