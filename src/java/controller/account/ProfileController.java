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

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB
        maxFileSize = 5 * 1024 * 1024,        // 5MB
        maxRequestSize = 6 * 1024 * 1024      // 6MB
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

        // Profile page: tắt CTA teacher
        request.setAttribute("hideTeacherCTA", true);

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
                request.setCharacterEncoding("UTF-8");

                String fullName = request.getParameter("fullName");
                String phoneNumber = request.getParameter("phoneNumber");

                
                User current = userDAO.getUserInforByID(userLogin.getUserID());
                String savedAvatarUrl = (current != null) ? current.getUrlImgProfile() : null;

                // ==== avatar upload ====
                Part avatarPart = request.getPart("avatar"); // name="avatar" trong JSP
                if (avatarPart != null && avatarPart.getSize() > 0) {
                    String submitted = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();

                    String ext = "";
                    int dot = submitted.lastIndexOf('.');
                    if (dot >= 0) ext = submitted.substring(dot).toLowerCase();

                    boolean ok = ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".webp");
                    if (!ok) {
                        response.sendRedirect(request.getContextPath() + "/account/profile?tab=profile");
                        return;
                    }

                    // Lưu vào /uploads/avatars
                    String uploadDir = getServletContext().getRealPath("") + File.separator
                            + "uploads" + File.separator + "avatars";
                    File dir = new File(uploadDir);
                    if (!dir.exists()) dir.mkdirs();

                    String newName = "avt_" + userLogin.getUserID() + "_" + System.currentTimeMillis() + ext;
                    String fullPath = uploadDir + File.separator + newName;

                    avatarPart.write(fullPath);

                    savedAvatarUrl = "uploads/avatars/" + newName;
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
