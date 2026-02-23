/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.account;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.User;

/**
 *
 * @author hung2
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class ProfileController extends HttpServlet {

    private String normalizeTab(String tab) {
        if (tab == null || tab.isBlank()) return "profile";
        tab = tab.toLowerCase().trim();
        if (!tab.equals("profile") && !tab.equals("email") && !tab.equals("password")) return "profile";
        return tab;
    }

    private String viewByRole(String role) {
        if (role == null) return "/View/Student/profile.jsp";
        switch (role.toLowerCase()) {
            case "student":
                return "/View/Student/profile.jsp";
            case "teacher":
                return "/View/Teacher/profile.jsp";
            case "admin":
                return "/View/Admin/profile.jsp";
            default:
                return "/View/Student/profile.jsp";
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("user");
    }

    private void loadUserAndForward(HttpServletRequest request, HttpServletResponse response, String tab)
            throws ServletException, IOException {

        User userLogin = getSessionUser(request);
        if (userLogin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserInforByID(userLogin.getUserID()); // UUID String

        request.setAttribute("user", user);
        request.setAttribute("tab", tab);
        request.setAttribute("showHome", true);

        request.getRequestDispatcher(viewByRole(userLogin.getRole())).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tab = normalizeTab(request.getParameter("tab"));
        loadUserAndForward(request, response, tab);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User userLogin = getSessionUser(request);
        if (userLogin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String tab = normalizeTab(request.getParameter("tab"));
        UserDAO userDAO = new UserDAO();

        try {
            if ("profile".equals(tab)) {
                String fullName = request.getParameter("fullName");
                String phoneNumber = request.getParameter("phoneNumber");

                // avatar
                String savedAvatarUrl = null;
                Part avatarPart = request.getPart("avatar"); // name="avatar" trong JSP

                if (avatarPart != null && avatarPart.getSize() > 0) {
                    String submitted = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int dot = submitted.lastIndexOf('.');
                    if (dot >= 0) ext = submitted.substring(dot).toLowerCase();

                    boolean ok = ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".webp");
                    if (ok) {
                        String uploadDir = request.getServletContext().getRealPath("/uploads/avatars/");
                        File dir = new File(uploadDir);
                        if (!dir.exists()) dir.mkdirs();

                        String newName = "avt_" + userLogin.getUserID() + "_" + System.currentTimeMillis() + ext;
                        avatarPart.write(uploadDir + File.separator + newName);

                        // AvatarUrl trong DB nên lưu đường dẫn web-relative
                        savedAvatarUrl = "/uploads/avatars/" + newName;
                    }
                }

                // Update DB
                userDAO.updateProfile(userLogin.getUserID(), fullName, phoneNumber, savedAvatarUrl);

                // refresh session user
                User refreshed = userDAO.getUserInforByID(userLogin.getUserID());
                HttpSession session = request.getSession(false);
                if (session != null) session.setAttribute("user", refreshed);

                response.sendRedirect(request.getContextPath() + "/account/profile?tab=profile");
                return;
            }

            // TODO, UI chạy trước
            if ("email".equals(tab)) {
                // String newEmail = request.getParameter("newEmail");
                response.sendRedirect(request.getContextPath() + "/account/profile?tab=email");
                return;
            }

            if ("password".equals(tab)) {
                // String currentPassword = request.getParameter("currentPassword");
                // String newPassword = request.getParameter("newPassword");
                // String confirmPassword = request.getParameter("confirmPassword");
                response.sendRedirect(request.getContextPath() + "/account/profile?tab=password");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/account/profile?tab=profile");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            loadUserAndForward(request, response, tab);
        }
    }
}
