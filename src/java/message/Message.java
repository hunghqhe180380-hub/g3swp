/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package message;

/**
 *
 * @author hung2
 */
public class Message {

    public static final String MSG00 = "The username already exists.";
    public static final String MSG01 = "Email or username is required.";
    public static final String MSG02 = "Invalid email format.";
    public static final String MSG03 = "Full name may contain only letters and spaces.";
    public static final String MSG04 = "Password is required.";
    public static final String MSG05 = "Incorrect username or password. Please try again.";
    public static final String MSG06 = "Password must be at least 8 characters and include an uppercase letter, a number, and a special character.";
    public static final String MSG07 = "Password and confirmation password do not match.";
    public static final String MSG08 = "Username must be between 4 and 20 characters and contain letters, digits, dots, hyphens, or underscores.";
    public static final String MSG09 = "Invalid phone number. Please enter a 10-digit number starting with 0 or +84.";
    public static final String MSG10 = "Full Name is required";

    public static final String MSG20 = "Confirm password is required.";
// Email validation
    public static final String MSG11 = "Email is required.";
    public static final String MSG12 = "The email address already exists.";
    public static final String MSG13 = "Email must not contain spaces.";
    public static final String MSG14 = "Email must contain exactly one '@' symbol.";
    public static final String MSG15 = "Email must not start or end with '@'.";
    public static final String MSG16 = "Email domain must contain a dot ('.').";
    public static final String MSG17 = "Email must not start or end with a dot ('.').";
    public static final String MSG18 = "Email must not contain '@.' or '.@'.";
    public static final String MSG19 = "Email is not exist.";
    public static final String MSG25 = "Email is exist.";

    // Full name validation
    public static final String MSG21 = "Full name must be between 4 and 50 characters.";
    public static final String MSG22 = "Full name may contain only letters and single spaces between words.";

// Phone number validation
    public static final String MSG23 = "Phone number is required.";
    public static final String MSG24 = "Invalid phone number format. Please enter a valid number starting with 0 or +84.";

//Confirm Email
    public static final String MSG98 = "We've sent a verification email to your email address.\n"
            + "Please check your email and follw the instructions to activate your account";
    public static final String MSG99 = "Email not verified.\n"
            + "A verification email has been sent. Please check your email to complete verification.";
    public static final String MSG100 = "Admin role cannot be change.";

    //Reset Password
    public static final String MSG101 = "Your password reset link is invalid or has expired.\n"
            + "Please request a new password reset link to continue.";
    public static final String MSG102 = "We’ve sent a password reset link to your email address.\n"
            + "Please check your inbox and follow the instructions to reset your password.";
    public static final String MSG103 = "This verification link has expired.\n"
            + "Please request a new verification email.";
    public static final String MSG104 = "Email verification successful.\n"
            + "Please log in to access the system.";

    //log in 
    public static final String MSG200 = "Incorrect username/email or password.";
    
    //msg create new class room
    public static final String MSG301 = "Class name is required.";
    public static final String MSG302 = "Subject is required.";
    public static final String MSG303 = "Student limit is required.";
    public static final String MSG304 = "Student limit must be > 0 and <= 100.";
}
