/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package validation;

/**
 *
 * @author hung2
 */
public class InputValidator {

    public boolean isEmail(String email) {

        if (email == null) {
            return false;
        }

        email = email.trim();
        if (email.isEmpty()) {
            return false;
        }

        // not allow space
        if (email.contains(" ")) {
            return false;
        }

        int atIndex = email.indexOf('@');

        // have only 1 @
        if (atIndex == -1 || atIndex != email.lastIndexOf('@')) {
            return false;
        }

        // not allow start or end by @
        if (atIndex == 0 || atIndex == email.length() - 1) {
            return false;
        }

        // have to following @ by dot (.)
        String domain = email.substring(atIndex + 1);
        if (!domain.contains(".")) {
            return false;
        }

        // not allow start or end by dot (.)
        if (email.startsWith(".") || email.endsWith(".")) {
            return false;
        }

        // not allow "@." or ".@"
        if (email.contains("@.") || email.contains(".@")) {
            return false;
        }

        return true; //pass
    }

    //check legit password
    public static boolean isPassword(String password) {
        if (password == null) {
            return false;
        }
        // must be have from 8 to 20 character
        if (password.length() < 8 || password.length() > 20) {
            return false;
        }
        //contain at least one uppercase letter, one number, and one special character.
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
        return hasUpper && hasDigit && hasSpecial;
    }

    //check legit user name 
    public static boolean isUserName(String username) {
        if (username == null) {
            return false;
        }

        //have aleast 4 character
        if (username.length() < 4) {
            return false;
        }

        //containing only letters, digits, dots, hyphens, or underscores.
        for (int i = 0; i < username.length(); i++) {
            char c = username.charAt(i);

            boolean isLetter = Character.isLetter(c);
            boolean isDigit = Character.isDigit(c);
            boolean isAllowedSpecial
                    = c == '.' || c == '-' || c == '_';

            if (!isLetter && !isDigit && !isAllowedSpecial) {
                return false;
            }
        }

        return true; // pass
    }
    
    

    //check fullname allow Unicode letters + 1 space between words
    public static boolean isFullName(String fullName) {
    if (fullName == null) return false;

    fullName = fullName.trim();
    //from 4 to 50 characters
    if (fullName.length() < 4 || fullName.length() > 50) {
        return false;
    }

    // allow Unicode letters + 1 space between words
    return fullName.matches("^[\\p{L}]+(\\s[\\p{L}]+)+$");
}

    //check phone number start by 0 or +84 follow by 9 number
    public static boolean isPhoneNumber(String phone) {
    if (phone == null) return false;

    phone = phone.trim();

    return phone.matches("^(0|\\+84)[0-9]{9}$");
}


    //encryp password by Bcrypt
}
