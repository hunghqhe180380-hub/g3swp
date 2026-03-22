/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.account;

import dal.TokenDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

public class ConfirmEmailChangeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        if (token == null || token.isBlank()) {
            request.setAttribute("status", "invalid");
            request.getRequestDispatcher("/view/user/email-change.jsp").forward(request, response);
            return;
        }

        TokenDAO tokenDAO = new TokenDAO();
        UserDAO userDAO = new UserDAO();

        if (!tokenDAO.isExistToken(token, "ChangeEmail")) {
            request.setAttribute("status", "invalid");
            request.getRequestDispatcher("/view/user/email-change.jsp").forward(request, response);
            return;
        }

        String newEmail = tokenDAO.getEmailByToken(token, "ChangeEmail");
        if (newEmail == null || newEmail.isBlank()) {
            request.setAttribute("status", "invalid");
            request.getRequestDispatcher("/view/user/email-change.jsp").forward(request, response);
            return;
        }

        String userId = userDAO.getUserIdByTokenRequest(token, "ChangeEmail");
        if (userId == null) {
            request.setAttribute("status", "invalid");
            request.getRequestDispatcher("/view/user/email-change.jsp").forward(request, response);
            return;
        }

        // tránh trùng email
        if (userDAO.isExistEmail(newEmail)) {
            request.setAttribute("status", "exists");
            request.getRequestDispatcher("/view/user/email-change.jsp").forward(request, response);
            return;
        }

        boolean ok = userDAO.updateEmailByUserId(userId, newEmail);
        tokenDAO.setTokenIsUsed(token, "ChangeEmail");

        // refresh session nếu user đang đăng nhập
        HttpSession session = request.getSession(false);
        if (session != null) {
            User u = (User) session.getAttribute("user");
            if (u != null && userId.equals(u.getUserID())) {
                User refreshed = userDAO.getUserInforByID(userId);
                session.setAttribute("user", refreshed);
            }
        }

        request.setAttribute("status", ok ? "success" : "failed");
        request.setAttribute("newEmail", newEmail);
        request.getRequestDispatcher("/view/user/email-change.jsp").forward(request, response);
    }
}
