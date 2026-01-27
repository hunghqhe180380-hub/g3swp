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
import java.util.Date;
import java.util.Properties;

/**
 *
 * @author hung2
 */
public class Email {
    //email : hunghoang042310s10@gmail.com
    //password : zlqg woso wovy qlkh

    public static void main(String[] args) {
        final String from = "hunghoang042310s10@gmail.com";
        final String password = "zlqgwosowovyqlkh";

        //Properties : decleare attribute to send email
        Properties props = new Properties();
        //SMTP host
        props.put("mail.smtp.host", "smtp.gmail.com");
        //TLS 587 or SSL 465
        props.put("mail.smtp.port", "587");
        //login email to send mail to another email
        props.put("mail.smtp.auth", "true");
        //TLS
        props.put("mail.smtp.starttls.enable", "true");

        //create Authenticator
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        //session of email
        Session session = Session.getInstance(props, auth);

        //send email
        final String to = "hung231004@gmail.com";

        //create a new message
        MimeMessage msg = new MimeMessage(session);

        try {
            //content type
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            //user send email
            msg.setFrom(from);
            //user receive email
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            //subject email
            msg.setSubject("POET Beta");
            
            //set day send
            msg.setSentDate(new Date());
            
            //content
            msg.setText("This is content", "UTF-8");
            
            //send email
            Transport.send(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
