/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.assignment;

import dal.AssignmentDAO;
import dal.AssignmentQuestionDAO;
import dal.ClassroomDAO;
import dal.QuestionBankDAO;
import dal.SubjectDAO;
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
import model.Assignment;
import model.AssignmentQuestion;
import model.Classroom;
import model.QuestionBank;
import model.QuestionGroup;
import model.User;

/**
 *
 * @author hung2
 */
public class AddQuestionToAssignmentController extends HttpServlet {

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
            out.println("<title>Servlet AddQuestionToAssignmentController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddQuestionToAssignmentController at " + request.getContextPath() + "</h1>");
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
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String modeCreate = request.getParameter("modeCreate");
        System.out.println("modeCreate: " + modeCreate);
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String classId = request.getParameter("classId");

        AssignmentDAO asgDAO = new AssignmentDAO();
        //insert listQuestionBankRandomResult into Assignment 
        int newAssignmentId = (int) request.getAttribute("newAssignmentId");
        AssignmentQuestionDAO asgQuestionDAO = new AssignmentQuestionDAO();
        QuestionBankDAO qBankDAO = new QuestionBankDAO();
        //create with auto mode
        if (modeCreate.equalsIgnoreCase("auto")) {

            String[] typeQuestionGroup   = request.getParameterValues("typeQuestionGroup");
            String[] chapterQuestionGroup = request.getParameterValues("chapterQuestionGroup");
            String[] numberQuestionGroup  = request.getParameterValues("numberQuestionGroup");
            String[] pointPerQuestion     = request.getParameterValues("pointPerQuestion");

            //get subjectId of this class
            ClassroomDAO clsDAO = new ClassroomDAO();
            Classroom cls = clsDAO.getClassInfoByClassId(classId);
            String subjectId = cls.getSubjectId();

            boolean hasSCQ   = false;
            boolean hasMCQ   = false;
            boolean hasEssay = false;

            // Global dedup: no question can appear twice in the same assignment
            java.util.Set<Integer> insertedQuestionIds = new java.util.HashSet<>();

            for (int i = 0; i < typeQuestionGroup.length; i++) {
                int type    = Integer.parseInt(typeQuestionGroup[i]);
                int numberQ = Integer.parseInt(numberQuestionGroup[i]);
                int pointQ  = Integer.parseInt(pointPerQuestion[i]);

                if (type == 1) hasSCQ   = true;
                if (type == 2) hasMCQ   = true;
                if (type == 3) hasEssay = true;

                // chapterQuestionGroup[i] may be "1" or "1,2,3" – handle both
                String chaptersRaw = chapterQuestionGroup[i];
                String[] chapTokens = (chaptersRaw == null || chaptersRaw.trim().isEmpty())
                        ? new String[0]
                        : chaptersRaw.trim().split(",");

                // Collect a pool from every selected chapter, then pick N random
                List<QuestionBank> pool = new ArrayList<>();
                for (String tok : chapTokens) {
                    tok = tok.trim();
                    if (tok.isEmpty()) continue;
                    int chapter = Integer.parseInt(tok);
                    List<QuestionBank> batch = qBankDAO.getRandomQuestions(
                            subjectId, user.getUserID(), chapter, type, numberQ, pointQ);
                    for (QuestionBank b : batch) {
                        // Only add to pool if not already inserted in a previous group
                        if (!insertedQuestionIds.contains(b.getId())) {
                            pool.add(b);
                        }
                    }
                }

                // Shuffle the combined pool and pick the required number of questions
                java.util.Collections.shuffle(pool);
                int take = Math.min(numberQ, pool.size());
                for (int j = 0; j < take; j++) {
                    QuestionBank q = pool.get(j);
                    if (insertedQuestionIds.add(q.getId())) { // add() returns false if already present
                        q.setSettingPoint(pointQ);
                        asgQuestionDAO.insertQuestion(newAssignmentId, q);
                    }
                }
            }

            // Count distinct types
            int countType = (hasSCQ ? 1 : 0) + (hasMCQ ? 1 : 0) + (hasEssay ? 1 : 0);
            int assignmentType;
            if      (countType >= 2) assignmentType = 4;
            else if (hasSCQ)         assignmentType = 1;
            else if (hasMCQ)         assignmentType = 2;
            else if (hasEssay)       assignmentType = 3;
            else                     assignmentType = 0;

            asgDAO.updateTypeFollowQuestionInAssignment(newAssignmentId, assignmentType);
        }

        /*
        *create with manual mode 
         */
        if (modeCreate.equalsIgnoreCase("manual")) {
            String[] questionId = request.getParameterValues("questionId");
            String[] pointOfQuestion = request.getParameterValues("pointOfQuestion");

            List<QuestionBank> listQuestion = new ArrayList<>();
            for (int i = 0; i < questionId.length; i++) {
                listQuestion.add(qBankDAO.getQuestionById(questionId[i],
                        user.getUserID(),
                        Double.parseDouble(pointOfQuestion[i])));
            }

            //add question from question bank into asssignment question
            for (int i = 0; i < listQuestion.size(); i++) {
                asgQuestionDAO.insertQuestion(newAssignmentId, listQuestion.get(i));
            }

            boolean hasSGC = false;
            boolean hasMCQ = false;
            boolean hasEssay = false;

            for (QuestionBank q : listQuestion) {
                if (q.getType() == 1) {
                    hasSGC = true;
                }
                if (q.getType() == 2) {
                    hasMCQ = true;
                }
                if (q.getType() == 3) {
                    hasEssay = true;
                }
            }

// đếm số loại có trong assignment
            int countType = 0;
            if (hasSGC) {
                countType++;
            }
            if (hasMCQ) {
                countType++;
            }
            if (hasEssay) {
                countType++;
            }

            int assignmentType;

            if (countType >= 2) {
                assignmentType = 4; // mixed
            } else if (hasSGC) {
                assignmentType = 1;
            } else if (hasMCQ) {
                assignmentType = 2;
            } else if (hasEssay) {
                assignmentType = 3;
            } else {
                assignmentType = 0; // fallback (không có câu nào)
            }

// update DB
            asgDAO.updateTypeFollowQuestionInAssignment(newAssignmentId, assignmentType);
        }

        response.sendRedirect(request.getContextPath()
                + "/assignment/view/list-assignment?classId=" + classId);
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
