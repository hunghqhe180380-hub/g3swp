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
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import model.User;
import dal.TokenDAO;
import model.Token;
import util.EmailService;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 6 * 1024 * 1024 // 6MB
)
public class ProfileController extends HttpServlet {

    private String normalizeTab(String tab) {
        if (tab == null || tab.isBlank()) {
            return "profile";
        }
        tab = tab.toLowerCase().trim();
        if (!tab.equals("profile") && !tab.equals("email") && !tab.equals("password")) {
            return "profile";
        }
        return tab;
    }

    private String viewByRole(String role) {
        if (role == null) {
            return "/view/student/profile.jsp";
        }
        switch (role.toLowerCase()) {
            case "student":
                return "/view/student/profile.jsp";
            case "teacher":
                return "/view/teacher/profile.jsp";
            default:
                return "/view/student/profile.jsp";
        }
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
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
        User user = userDAO.getUserInforByID(userLogin.getUserID());

        request.setAttribute("user", user);
        request.setAttribute("tab", tab);
        request.setAttribute("hideTeacherCTA", true);

        request.getRequestDispatcher(viewByRole(userLogin.getRole())).forward(request, response);
    }

    private Path resolvePersistentAvatarDir() {
        String realRoot = getServletContext().getRealPath("/");
        if (realRoot == null) {
            return null;
        }

        File webAppRoot = new File(realRoot); // thường là .../build/web/ hoặc .../wtpwebapps/...
        File buildDir = webAppRoot.getParentFile();       // .../build
        File projectRoot = (buildDir != null) ? buildDir.getParentFile() : null; // .../<project>

        if (projectRoot != null) {
            File antWeb = new File(projectRoot, "web" + File.separator + "uploads" + File.separator + "avatars");
            if (antWeb.exists() || antWeb.mkdirs()) {
                return antWeb.toPath();
            }

            File mavenWeb = new File(projectRoot, "src" + File.separator + "main" + File.separator + "webapp"
                    + File.separator + "uploads" + File.separator + "avatars");
            if (mavenWeb.exists() || mavenWeb.mkdirs()) {
                return mavenWeb.toPath();
            }
        }
        return null;
    }

    private Path resolveDeployedAvatarDir() {
        String deployed = getServletContext().getRealPath("/uploads/avatars");
        if (deployed == null) {
            return null;
        }
        File dir = new File(deployed);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return dir.toPath();
    }

    private boolean isAllowedImageExt(String ext) {
        if (ext == null) {
            return false;
        }
        ext = ext.toLowerCase();
        return ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".webp");
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
                    if (dot >= 0) {
                        ext = submitted.substring(dot).toLowerCase();
                    }

                    if (!isAllowedImageExt(ext)) {
                        response.sendRedirect(request.getContextPath() + "/account/profile?tab=profile");
                        return;
                    }

                    String newName = "avt_" + userLogin.getUserID() + "_" + System.currentTimeMillis() + ext;

                    Path persistentDir = resolvePersistentAvatarDir();
                    Path deployedDir = resolveDeployedAvatarDir();

                    if (persistentDir == null && deployedDir == null) {
                        throw new IllegalStateException("Không xác định được thư mục lưu avatars.");
                    }

                    Path persistentFile = (persistentDir != null) ? persistentDir.resolve(newName) : null;
                    Path deployedFile = (deployedDir != null) ? deployedDir.resolve(newName) : null;

                    if (persistentFile != null) {
                        Files.createDirectories(persistentDir);
                        try (InputStream in = avatarPart.getInputStream()) {
                            Files.copy(in, persistentFile, StandardCopyOption.REPLACE_EXISTING);
                        }
                        if (deployedFile != null && !deployedFile.equals(persistentFile)) {
                            Files.createDirectories(deployedDir);
                            Files.copy(persistentFile, deployedFile, StandardCopyOption.REPLACE_EXISTING);
                        }
                    } else {
                        Files.createDirectories(deployedDir);
                        try (InputStream in = avatarPart.getInputStream()) {
                            Files.copy(in, deployedFile, StandardCopyOption.REPLACE_EXISTING);
                        }
                    }

                    // Lưu URL dạng tuyệt đối theo context: /uploads/avatars/xxx.png
                    savedAvatarUrl = "/uploads/avatars/" + newName;
                }

                userDAO.updateProfile(userLogin.getUserID(), fullName, phoneNumber, savedAvatarUrl);

                // refresh session user
                User refreshed = userDAO.getUserInforByID(userLogin.getUserID());
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.setAttribute("user", refreshed);
                }

                response.sendRedirect(request.getContextPath() + "/account/profile?tab=profile");
                return;
            }

            // TODO, UI chạy trước
            if ("email".equals(tab)) {
                request.setCharacterEncoding("UTF-8");

                String newEmail = request.getParameter("newEmail");
                if (newEmail == null) {
                    newEmail = "";
                }
                newEmail = newEmail.trim();

                if (newEmail.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/account/profile?tab=email&err=empty");
                    return;
                }

                User current = userDAO.getUserInforByID(userLogin.getUserID());
                String currentEmail = current != null ? current.getEmail() : null;
                if (currentEmail != null && newEmail.equalsIgnoreCase(currentEmail)) {
                    response.sendRedirect(request.getContextPath() + "/account/profile?tab=email&err=same");
                    return;
                }

                if (userDAO.isExistEmail(newEmail)) {
                    response.sendRedirect(request.getContextPath() + "/account/profile?tab=email&err=exists");
                    return;
                }

                EmailService emailService = new EmailService();
                String tokenStr = emailService.generateToken();

                Token token = new Token(
                        newEmail,
                        userLogin.getUserID(),
                        false,
                        tokenStr,
                        emailService.setExpriryDateTime()
                );

                TokenDAO tokenDAO = new TokenDAO();
                tokenDAO.insertToTokenDB(token, "ChangeEmail");

                String link = "http://localhost:9999/POET/account/confirm-email-change?token=" + tokenStr;

                emailService.sendEmail(
                        newEmail,
                        link,
                        current != null ? current.getFullName() : "User",
                        "ChangeEmail"
                );

                response.sendRedirect(request.getContextPath() + "/account/profile?tab=email&msg=sent");
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
