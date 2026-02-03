/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author hung2
 */
import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.mindrot.jbcrypt.BCrypt;

public class PasswordService {

    // Hash password
    public String encryptPassword(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(12));
    }

    // Verify password when login
    public boolean checkPassword(String rawPassword, String hashedPassword) {
        if (rawPassword == null || hashedPassword == null) {
            return false;
        }

        // bcrypt hash luôn bắt đầu bằng $2a$, $2b$, $2y$
        if (!hashedPassword.startsWith("$2")) {
            // password cũ → không cho login
            return false;
        }

        return BCrypt.checkpw(rawPassword, hashedPassword);
    }

    //check password and confirm password is match?
    public boolean isPasswordMatch(String newPassword, String confirmPassword) {
        return newPassword.trim().equals(confirmPassword.trim());
    }

}
