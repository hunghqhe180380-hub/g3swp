/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package validation;

/**
 *
 * @author hung2
 */
import message.Message;

public class InputValidator {

    private Message msg = new Message();

    public static String isEmail(String email) {

        if (email == null || email.trim().isEmpty()) {
            return Message.MSG11; // Email is required
        }

        email = email.trim();

        // not allow spaces
        if (email.contains(" ")) {
            return Message.MSG13;
        }

        int atIndex = email.indexOf('@');

        // must contain exactly one '@'
        if (atIndex == -1 || atIndex != email.lastIndexOf('@')) {
            return Message.MSG14;
        }

        // not allow start or end with '@'
        if (atIndex == 0 || atIndex == email.length() - 1) {
            return Message.MSG15;
        }

        // domain must contain dot
        String domain = email.substring(atIndex + 1);
        if (!domain.contains(".")) {
            return Message.MSG16;
        }

        // not allow start or end with dot
        if (email.startsWith(".") || email.endsWith(".")) {
            return Message.MSG17;
        }

        // not allow "@." or ".@"
        if (email.contains("@.") || email.contains(".@")) {
            return Message.MSG18;
        }

        return null; // valid
    }

    public static String isPassword(String password) {

        // null or empty
        if (password == null || password.trim().isEmpty()) {
            return Message.MSG04; // Password is required
        }

        // length 8 - 20
//        if (password.length() < 8 || password.length() > 20) {
//            return Message.MSG06;
//        }

        boolean hasUpper = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (!Character.isLetterOrDigit(c)) {
                hasSpecial = true;
            }
        }

        if (!hasUpper || !hasDigit || !hasSpecial) {
            return Message.MSG06;
        }

        return null; // valid password
    }

    //check legit user name 
    public String isUserName(String username) {
        if (username.isEmpty()) {
            return msg.MSG11;
        }

        //have aleast 4 character
        if (username.length() < 4) {
            return msg.MSG08;
        }

        //containing only letters, digits, dots, hyphens, or underscores.
        for (int i = 0; i < username.length(); i++) {
            char c = username.charAt(i);

            boolean isLetter = Character.isLetter(c);
            boolean isDigit = Character.isDigit(c);
            boolean isAllowedSpecial
                    = c == '.' || c == '-' || c == '_';

            if (!isLetter && !isDigit && !isAllowedSpecial) {
                return msg.MSG08;
            }
        }

        return null; // pass
    }

    //check fullname allow Unicode letters + 1 space between words
    public String isFullName(String fullName) {
        if (fullName.isEmpty()) {
            return msg.MSG10;
        }

        fullName = fullName.trim();
        //from 4 to 50 characters
        if (fullName.length() < 4 || fullName.length() > 50) {
            return msg.MSG21;
        }

        // allow Unicode letters + 1 space between words
        if (!fullName.matches("^[\\p{L}]+(\\s[\\p{L}]+)+$")) {
            return msg.MSG22;
        };

        return null;
    }

    // Check phone number: start with 0 or +84, followed by 9 digits
    public String isPhoneNumber(String phone) {

        if (phone == null || phone.trim().isEmpty()) {
            return msg.MSG23;
        }

        phone = phone.trim();

        if (!phone.matches("^(0|\\+84)[0-9]{9}$")) {
            return msg.MSG24;
        }

        return null; // valid
    }

    //encryp password by Bcrypt
}
