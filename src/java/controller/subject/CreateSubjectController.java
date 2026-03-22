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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author hung2
 */
public class CreateSubjectController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/subject/view/subject-list?modal=create-subject");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String baseUrl = request.getContextPath() + "/subject/view/subject-list";

        if (action != null && action.equalsIgnoreCase("reset")) {
            response.sendRedirect(baseUrl + "?modal=create-subject");
            return;
        }

        String subjectName = request.getParameter("subjectName");
        if (subjectName == null) {
            subjectName = "";
        }

        Map<String, String> listMSG = validSubjectName(subjectName);

        if (listMSG.isEmpty()) {
            SubjectDAO subjectDAO = new SubjectDAO();
            subjectDAO.createSubject(subjectName.trim());

            String success = URLEncoder.encode(message.Message.MSG502, StandardCharsets.UTF_8);
            response.sendRedirect(baseUrl + "?createSuccess=" + success);
            return;
        }

        String error = URLEncoder.encode(listMSG.get("msgSubject"), StandardCharsets.UTF_8);
        String subjectNameEncoded = URLEncoder.encode(subjectName.trim(), StandardCharsets.UTF_8);

        response.sendRedirect(
                baseUrl
                + "?modal=create-subject"
                + "&createError=" + error
                + "&subjectName=" + subjectNameEncoded
        );
    }

    public Map<String, String> validSubjectName(String subjectName) {
        Map<String, String> errors = new HashMap<>();

        if (subjectName == null || subjectName.trim().isEmpty()) {
            errors.put("msgSubject", message.Message.MSG500);
            return errors;
        }

        if (subjectName.trim().length() > 30) {
            errors.put("msgSubject", message.Message.MSG501);
        }

        return errors;
    }

    @Override
    public String getServletInfo() {
        return "Create Subject Controller";
    }
}
