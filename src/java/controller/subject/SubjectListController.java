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
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import model.Subject;
import util.PagingUtil;

/**
 *
 * @author hung2
 */
public class SubjectListController extends HttpServlet {

    private SubjectDAO dao;

    public void init() {
        dao = new SubjectDAO();
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
            out.println("<title>Servlet SubjectListController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubjectListController at " + request.getContextPath() + "</h1>");
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
        //String search = request.getParameter("search");
        //String[] statuses = request.getParameterValues("txtStatus");
        List<Subject> listSubject = dao.getListSubject();
        paging(request, listSubject);
        request.setAttribute("listSubject", listSubject);
        request.getRequestDispatcher("/view/admin/list-subject.jsp").forward(request, response);
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

    private void sort(HttpServletRequest request, List<Subject> listSubject)
            throws ServletException, IOException {
        int snState = 0;
        try {
            snState = Integer.parseInt(request.getParameter("txtSubjectName"));
        } catch (Exception e) {
        }
        if (snState != 0) {
            Comparator<Subject> cmp
                    = Comparator.comparing(Subject::getName, String.CASE_INSENSITIVE_ORDER);

            if (snState == 2) {
                cmp = cmp.reversed();
            }
            Collections.sort(listSubject, cmp);
        }
    }

    private void paging(HttpServletRequest request, List<Subject> listSubject)
            throws ServletException, IOException {
        int nrpp = Integer.parseInt(request.getServletContext().getInitParameter("nrpp"));
        int size = listSubject.size();
        int index = 0;
        try {
            index = Integer.parseInt(request.getParameter("index"));
            index = index < 0 ? 0 : index;
        } catch (Exception e) {
            index = 0;
        }
        PagingUtil page = new PagingUtil(size, nrpp, index);
        page.calc();
        request.setAttribute("page", page);
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
