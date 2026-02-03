/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import dal.DBContext;
import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.Multipart;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.util.ByteArrayDataSource;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.time.Year;
import java.util.Properties;
import java.util.UUID;

/**
 *
 * @author hung2
 */
public class EmailService extends DBContext {

    //root email
    private final String from = "hunghoang042310s10@gmail.com";
    private final String password = "xlbj ijse gbzr fqab";
    // time expiry token (minutes)
    private final int LIMIT_MINUS = 10;

    // ===== Brand config =====
    private static final String BRAND_NAME = "POET-Service";
    private static final String WEBSITE_URL = "http://localhost:9999/POET/";
    private static final String SUPPORT_EMAIL = "poet176749@gmail.com";
    private static final String LOGO_CLASSPATH = "/upload/Images/LOGO/POETLOGO.png";
    private static final String LOGO_CONTENT_ID = "poet-logo";
    // ========================

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

    public boolean sendEmail(String to, String link, String userName, String action) {
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
        try{
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-Type", "text/html; charset=UTF-8");

            // From hiển thị tên
            msg.setFrom(new InternetAddress(from, BRAND_NAME, "UTF-8"));

            // To
            if (to == null || to.trim().isEmpty()) {
                throw new IllegalArgumentException("Recipient email is empty");
            }
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));

            boolean isReset = action != null && action.equalsIgnoreCase("resetPassword");

            String subject = isReset
                    ? BRAND_NAME + " | Password Reset Request"
                    : BRAND_NAME + " | Verify Your Email Address";
            msg.setSubject(subject, "UTF-8");

            // HTML content (tham chiếu logo bằng cid)
            String html = buildEmailHtml(isReset, link, userName, true);

            // Tạo multipart/related: html + inline image
            Multipart multipart = new MimeMultipart("related");

            // Part 1: HTML
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(html, "text/html; charset=UTF-8");
            multipart.addBodyPart(htmlPart);

            // Part 2: Inline logo
            byte[] logoBytes = loadResourceBytes(LOGO_CLASSPATH);
            if (logoBytes != null && logoBytes.length > 0) {
                MimeBodyPart imagePart = new MimeBodyPart();
                String mimeType = guessImageMimeType(LOGO_CLASSPATH);
                DataSource fds = new ByteArrayDataSource(logoBytes, mimeType);
                imagePart.setDataHandler(new DataHandler(fds));
                imagePart.setHeader("Content-ID", "<" + LOGO_CONTENT_ID + ">");
                imagePart.setDisposition(MimeBodyPart.INLINE);
                imagePart.setFileName("logo" + getImageExt(LOGO_CLASSPATH));

                multipart.addBodyPart(imagePart);
            } else {
                String htmlNoLogo = buildEmailHtml(isReset, link, userName, false);
                MimeBodyPart htmlPartNoLogo = new MimeBodyPart();
                htmlPartNoLogo.setContent(htmlNoLogo, "text/html; charset=UTF-8");

                Multipart mp2 = new MimeMultipart("related");
                mp2.addBodyPart(htmlPartNoLogo);
                msg.setContent(mp2);
                Transport.send(msg);
                return true;
            }

            msg.setContent(multipart);

            Transport.send(msg);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private String buildEmailHtml(boolean isReset, String link, String userName, boolean includeLogo) {
        String safeName = escapeHtml(userName);
        String safeLink = link == null ? "" : link;

        String title = isReset ? "Reset your password" : "Verify your email";
        String intro = isReset
                ? "We received a request to reset your password. Click the button below to continue."
                : "Thanks for signing up. Please confirm your email address to complete your registration.";
        String buttonText = isReset ? "Reset Password" : "Verify Email";
        String note = isReset
                ? "If you didn’t request a password reset, you can safely ignore this email."
                : "If you didn’t create an account, you can safely ignore this email.";

        int year = Year.now().getValue();

        String logoHtml = includeLogo
                ? "<img src=\"cid:" + LOGO_CONTENT_ID + "\" alt=\"" + escapeHtml(BRAND_NAME) + "\" style=\"display:block; height:40px; width:auto;\"/>"
                : "<div style=\"font-weight:700; font-size:18px; color:#111827;\">" + escapeHtml(BRAND_NAME) + "</div>";

        return ""
                + "<!DOCTYPE html>"
                + "<html><head>"
                + "  <meta charset=\"UTF-8\"/>"
                + "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>"
                + "</head>"
                + "<body style=\"margin:0; padding:0; background:#f5f7fb;\">"
                + "  <table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" style=\"background:#f5f7fb; padding:24px 0;\">"
                + "    <tr><td align=\"center\">"
                + "      <table role=\"presentation\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" style=\"width:600px; max-width:600px; background:#ffffff; border-radius:12px; overflow:hidden; box-shadow:0 4px 18px rgba(0,0,0,0.06);\">"
                + "        <tr>"
                + "          <td style=\"padding:20px 24px; background:#ffffff; border-bottom:1px solid #eef1f6;\">"
                + "            <table role=\"presentation\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">"
                + "              <tr>"
                + "                <td align=\"left\" style=\"vertical-align:middle;\">" + logoHtml + "</td>"
                + "                <td align=\"right\" style=\"vertical-align:middle; font-family:Arial, Helvetica, sans-serif; color:#6b7280; font-size:12px;\">"
                +                  escapeHtml(BRAND_NAME)
                + "                </td>"
                + "              </tr>"
                + "            </table>"
                + "          </td>"
                + "        </tr>"

                + "        <tr>"
                + "          <td style=\"padding:28px 24px; font-family:Arial, Helvetica, sans-serif; color:#111827;\">"
                + "            <h2 style=\"margin:0 0 10px; font-size:20px;\">" + escapeHtml(title) + "</h2>"
                + "            <p style=\"margin:0 0 10px;\">Hello <b>" + safeName + "</b>,</p>"
                + "            <p style=\"margin:0 0 18px; color:#374151;\">" + escapeHtml(intro) + "</p>"

                + "            <table role=\"presentation\" cellspacing=\"0\" cellpadding=\"0\" style=\"margin:0 0 18px;\">"
                + "              <tr>"
                + "                <td bgcolor=\"#1a73e8\" style=\"border-radius:8px;\">"
                + "                  <a href=\"" + escapeHtml(safeLink) + "\""
                + "                     style=\"display:inline-block; padding:12px 18px; color:#ffffff; text-decoration:none; font-weight:600; font-size:14px; font-family:Arial, Helvetica, sans-serif;\">"
                +                      escapeHtml(buttonText)
                + "                  </a>"
                + "                </td>"
                + "              </tr>"
                + "            </table>"

                + "            <p style=\"margin:0 0 8px; color:#6b7280; font-size:13px;\">This link will expire in <b>" + LIMIT_MINUS + " minutes</b>.</p>"
                + "            <p style=\"margin:0; color:#6b7280; font-size:13px;\">" + escapeHtml(note) + "</p>"

                + "            <hr style=\"border:none; border-top:1px solid #eef1f6; margin:18px 0;\"/>"
                + "            <p style=\"margin:0; color:#6b7280; font-size:12px;\">If the button doesn’t work, copy and paste this link into your browser:</p>"
                + "            <p style=\"margin:6px 0 0; font-size:12px; word-break:break-all;\">"
                + "              <a href=\"" + escapeHtml(safeLink) + "\" style=\"color:#1a73e8; text-decoration:none;\">" + escapeHtml(safeLink) + "</a>"
                + "            </p>"
                + "          </td>"
                + "        </tr>"

                + "        <tr>"
                + "          <td style=\"padding:18px 24px; background:#fbfcfe; border-top:1px solid #eef1f6; font-family:Arial, Helvetica, sans-serif;\">"
                + "            <p style=\"margin:0; color:#6b7280; font-size:12px;\">"
                + "              Need help? Contact us at "
                + "              <a href=\"mailto:" + escapeHtml(SUPPORT_EMAIL) + "\" style=\"color:#1a73e8; text-decoration:none;\">" + escapeHtml(SUPPORT_EMAIL) + "</a>"
                + "              or visit "
                + "              <a href=\"" + escapeHtml(WEBSITE_URL) + "\" style=\"color:#1a73e8; text-decoration:none;\">" + escapeHtml(WEBSITE_URL) + "</a>"
                + "            </p>"
                + "            <p style=\"margin:8px 0 0; color:#9ca3af; font-size:12px;\">© " + year + " " + escapeHtml(BRAND_NAME) + ". All rights reserved.</p>"
                + "          </td>"
                + "        </tr>"

                + "      </table>"
                + "    </td></tr>"
                + "  </table>"
                + "</body></html>";
    }

    private byte[] loadResourceBytes(String classpath) {
        // classpath ví dụ: "/assets/logo.png"
        try (InputStream is = EmailService.class.getResourceAsStream(classpath)) {
            if (is == null) return null;
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int read;
            while ((read = is.read(buf)) != -1) {
                baos.write(buf, 0, read);
            }
            return baos.toByteArray();
        } catch (Exception e) {
            return null;
        }
    }

    private String guessImageMimeType(String path) {
        String p = path == null ? "" : path.toLowerCase();
        if (p.endsWith(".jpg") || p.endsWith(".jpeg")) return "image/jpeg";
        if (p.endsWith(".gif")) return "image/gif";
        if (p.endsWith(".webp")) return "image/webp";
        return "image/png"; // default
    }

    private String getImageExt(String path) {
        String p = path == null ? "" : path.toLowerCase();
        if (p.endsWith(".jpg")) return ".jpg";
        if (p.endsWith(".jpeg")) return ".jpeg";
        if (p.endsWith(".gif")) return ".gif";
        if (p.endsWith(".webp")) return ".webp";
        return ".png";
    }

    private String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
