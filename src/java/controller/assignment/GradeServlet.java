/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.assignment;

import dal.AssignmentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.GradeAttemptVM;
import model.GradeEssayItem;

/**
 *
 * @author FPT
 */
public class GradeServlet extends HttpServlet {

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
            out.println("<title>Servlet GradeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GradeServlet at " + request.getContextPath() + "</h1>");
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
        //processRequest(request, response);
        int attemptId = Integer.parseInt(request.getParameter("attemptId"));
        AssignmentDAO dao = new AssignmentDAO();
        GradeAttemptVM vm = dao.getAttemptDetail(attemptId);

        request.setAttribute("vm", vm);

        request.getRequestDispatcher("/view/assignment/grade.jsp").forward(request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int attemptId = Integer.parseInt(request.getParameter("attemptId"));
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        int classId = Integer.parseInt(request.getParameter("classId"));
        String overallComment = request.getParameter("teacherComment");

        String[] qIds = request.getParameterValues("questionId");
        String[] scores = request.getParameterValues("score");
        String[] comments = request.getParameterValues("comment");

        List<GradeEssayItem> essays = new ArrayList<>();
        double totalEssayScore = 0;

        if (qIds != null) {
            for (int i = 0; i < qIds.length; i++) {
                double s = Double.parseDouble(scores[i].replace(",", "."));
                essays.add(new GradeEssayItem(
                        Integer.parseInt(qIds[i]),
                        s,
                        comments[i]
                ));
                totalEssayScore += s;
            }
        }

        AssignmentDAO assignmentDAO = new AssignmentDAO();
        double autoScore = 0;
        double finalScore = 0;

        try {
             autoScore = assignmentDAO.getAutoScoreByAttemptId(attemptId);
             finalScore = autoScore + totalEssayScore;

            assignmentDAO.updateGrade(attemptId, overallComment, finalScore, essays);

            response.sendRedirect("/POET/assignment/view/submission?classId=" + classId+  "&assignmentId=" + assignmentId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi cơ sở dữ liệu khi lưu điểm." + e);
        }
         finalScore = autoScore + totalEssayScore;

        // 4. Gọi DAO thực thi
        try {
            assignmentDAO.updateGrade(attemptId, overallComment, finalScore, essays);
            response.sendRedirect("/POET/assignment/view/submission?classId=" + classId+  "&assignmentId=" + assignmentId);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi lưu điểm.");
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
