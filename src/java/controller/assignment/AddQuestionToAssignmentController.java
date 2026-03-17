/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.assignment;

import dal.AssignmentDAO;
import dal.ClassroomDAO;
import dal.QuestionBankDAO;
import dal.SubjectDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Assignment;
import model.Classroom;
import model.QuestionBank;
import model.QuestionGroup;

/**
 *
 * @author hung2
 */
public class AddQuestionToAssignmentController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet AddQuestionToAssignmentController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddQuestionToAssignmentController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String classId = request.getParameter("classId");
        String assignmentId = request.getParameter("assignmentId");
        request.setAttribute("classId", classId);
        ClassroomDAO clsDAO = new ClassroomDAO();
        Classroom cls = clsDAO.getClassInfoByClassId(classId);
        
        SubjectDAO subjDAO = new SubjectDAO();
        String subjectName = subjDAO.getSubjectNameById(cls.getSubjectId());
        String className = cls.getName();
        
        //assignment
        AssignmentDAO asgDAO = new AssignmentDAO();
        Assignment asg = asgDAO.getAssignmentById(Integer.parseInt(assignmentId));
        
        request.setAttribute("assignment", asg);
        request.setAttribute("className", className);
        request.setAttribute("subjectName", subjectName);
        request.getRequestDispatcher("/view/assignment/assignment-add-question.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        String classId = request.getParameter("classId");
        String[] typeQuestionGroup = request.getParameterValues("typeQuestionGroup");
        String[] levelQuestionGroup = request.getParameterValues("levelQuestionGroup");
        String[] numberQuestionGroup = request.getParameterValues("numberQuestionGroup");
        String[] pointPerQuestion = request.getParameterValues("pointPerQuestion");

        //get subjectId of this class
        ClassroomDAO clsDAO = new ClassroomDAO();
        Classroom cls = clsDAO.getClassInfoByClassId(classId);
        String subjectId = cls.getSubjectId();

        //create question group then put into list question group
        List<QuestionGroup> listQuestionGroup = new ArrayList<>();

        //every group question also have type - level - number of question - point per questio
        // => length of each properties must be equal
        for (int i = 0; i < typeQuestionGroup.length; i++) {

            QuestionGroup qGroup = new QuestionGroup();

            qGroup.setType(Integer.parseInt(typeQuestionGroup[i]));
            qGroup.setLevel(Integer.parseInt(levelQuestionGroup[i]));
            qGroup.setNumberQuestion(Integer.parseInt(numberQuestionGroup[i]));
            qGroup.setPointPerQuestion(Integer.parseInt(pointPerQuestion[i]));

            listQuestionGroup.add(qGroup);
        }

        //get random question from QuestionBank by (subjectId and properties of question groups)
        QuestionBankDAO qBankDAO = new QuestionBankDAO();

        //random question group
        Map<String, List<QuestionBank>> listRandomGroup = new HashMap<>();
        for (int i = 0; i < listQuestionGroup.size(); i++) {
            listRandomGroup.put(listQuestionGroup.get(i).getType() + "-" + listQuestionGroup.get(i).getLevel(),
                    qBankDAO.getRandomQuestions(subjectId,
                            listQuestionGroup.get(i).getLevel(),
                            listQuestionGroup.get(i).getType(),
                            listQuestionGroup.get(i).getNumberQuestion(),
                            listQuestionGroup.get(i).getPointPerQuestion()));
        }
       

        

        
        request.setAttribute("listQuestionGroup", listQuestionGroup);
        request.setAttribute("classId", classId);
        request.setAttribute("listquestion", listRandomGroup);
        request.getRequestDispatcher("/view/question/auto-preview-question-list.jsp").forward(request, response);
        return;
    }

    /*
            create with manual mode => show preview first
     */
//    if (action.equalsIgnoreCase ( 
//        "manualMode")) {
//
//            return;
//    }
//
//    /*
//            CREATE ASSIGNMENT
//        clone db from questionbank to db.assignmentquestion
//     */
//    if (action.equalsIgnoreCase ( 
//        "createNewAssignment")) {
//            //get list question's id
//            String[] questionId = request.getParameterValues("questionId");
//        //get question's point
//        String[] questionPoint = request.getParameterValues("questionPoint");
//
//        //get lis question
//        List<QuestionBank> listQuestion = new ArrayList<>();
//        QuestionBankDAO qBankDAO = new QuestionBankDAO();
//        for (int i = 0; i < questionId.length; i++) {
//            QuestionBank qBank = qBankDAO.getQuestionById(questionId[i]);
//            qBank.setSettingPoint(Double.parseDouble(questionPoint[i]));
//            listQuestion.add(qBank);
//        }
//
//        //inset list question from question bank to assignmentquestion
//        return;
//    }
    

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
