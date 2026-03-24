<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.UserDAO"%>
<%@page import="util.PasswordService"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html>
<head><title>Debug Login</title></head>
<body>
<h2>Debug Login Test</h2>
<%
    String testUser = "binhnguyen";
    String testPass = "Binh061105@";

    UserDAO userDAO = new UserDAO();
    PasswordService ps = new PasswordService();

    // Step 1: get hash from DB
    String hash = userDAO.getPasswordHash(testUser);
    out.println("<p><b>1. PasswordHash from DB:</b> " + (hash == null ? "NULL - user not found!" : hash) + "</p>");

    if (hash != null) {
        // Step 2: check BCrypt format
        out.println("<p><b>2. Is BCrypt ($2x$):</b> " + hash.startsWith("$2") + "</p>");
        out.println("<p><b>3. Hash length:</b> " + hash.length() + "</p>");

        // Step 3: verify password
        boolean match = ps.checkPassword(testPass, hash);
        out.println("<p><b>4. checkPassword result:</b> " + match + "</p>");

        // Step 4: try full login
        User user = userDAO.isLogin(testUser, testPass);
        out.println("<p><b>5. isLogin result:</b> " + (user == null ? "NULL (failed)" : "OK - role: " + user.getRole()) + "</p>");
        if (user != null) {
            out.println("<p><b>EmailConfirmed:</b> " + user.getEmailConfirm() + "</p>");
            out.println("<p><b>IsDeleted:</b> " + user.getIsDeleted() + "</p>");
        }
    }
%>
</body>
</html>
