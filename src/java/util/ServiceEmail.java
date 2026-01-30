/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.time.LocalDateTime;
import java.util.Properties;
import java.util.UUID;

/**
 *
 * @author hung2
 */
public class ServiceEmail {

    //root email
    private final String from = "hunghoang042310s10@gmail.com";
    private final String password = "xlbj ijse gbzr fqab";
    //time expriry toke
    private final int LIMIT_MINUS = 10;

    //genarate token of this email
    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    //set time expiry token
    public LocalDateTime setExpriryDateTime() {
        return LocalDateTime.now().plusMinutes(LIMIT_MINUS);
    }

    //check time expiry token
    public boolean isExprireTime(LocalDateTime time) {
        return LocalDateTime.now().isAfter(time);
    }

    public boolean sendEmail(String to, String link, String userName) {
        Properties props = new Properties();
        //add host
        props.put("mail.smtp.host", "smtp.gmail.com");
        //add port 
        props.put("mail.smtp.port", "587");
        //add port auth
        props.put("mail.smtp.auth", "true");
        //
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator authenticator = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        //session
        Session session = Session.getInstance(props, authenticator);

        //send doc html
        MimeMessage msg = new MimeMessage(session);

        try {
            msg.addHeader("Content-type", "text/html; character=UTF-8");
            //config email to send
            msg.setFrom(from);
            //config recive email
            msg.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(to, false));
            msg.setSubject("Reset Password", "UTF-8");
            String content
                    = "<h1>Hello " + userName + "</h1>"
                    + "<p>Click the link below to reset your password</p>"
                    + "<a href=\"" + link + "\">Click here</a>";
            msg.setContent(content, "text/html; charaset=UTF-8");

            //send email
            Transport.send(msg);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
