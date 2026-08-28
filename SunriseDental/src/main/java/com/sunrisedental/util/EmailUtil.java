package com.sunrisedental.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Patient;

public class EmailUtil {

    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());
    private static final ExecutorService EXECUTOR = Executors.newFixedThreadPool(3);
    private static final Properties CONFIG = new Properties();
    private static final Map<String, EmailRecord> RECENT_EMAILS = new ConcurrentHashMap<>();

    static {
        loadConfiguration();
    }

    public static class EmailRecord {
        private final String appointmentNo;
        private final String recipientEmail;
        private final String recipientName;
        private final String subject;
        private final String htmlBody;
        private final String timestamp;
        private final boolean realSmtpSent;
        private final String statusMessage;

        public EmailRecord(String appointmentNo, String recipientEmail, String recipientName,
                           String subject, String htmlBody, boolean realSmtpSent, String statusMessage) {
            this.appointmentNo = appointmentNo;
            this.recipientEmail = recipientEmail;
            this.recipientName = recipientName;
            this.subject = subject;
            this.htmlBody = htmlBody;
            this.timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            this.realSmtpSent = realSmtpSent;
            this.statusMessage = statusMessage;
        }

        public String getAppointmentNo() { return appointmentNo; }
        public String getRecipientEmail() { return recipientEmail; }
        public String getRecipientName() { return recipientName; }
        public String getSubject() { return subject; }
        public String getHtmlBody() { return htmlBody; }
        public String getTimestamp() { return timestamp; }
        public boolean isRealSmtpSent() { return realSmtpSent; }
        public String getStatusMessage() { return statusMessage; }
    }

    private static void loadConfiguration() {
        try (InputStream in = EmailUtil.class.getClassLoader().getResourceAsStream("email.properties")) {
            if (in != null) {
                CONFIG.load(in);
                LOGGER.info("email.properties loaded successfully.");
            } else {
                LOGGER.warning("email.properties not found on classpath, using default simulation settings.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Could not load email.properties, using defaults", e);
        }
    }

    /**
     * Sends appointment confirmation email asynchronously in the background.
     */
    public static void sendAppointmentConfirmationAsync(Appointment appointment, Patient patient) {
        EXECUTOR.submit(() -> {
            try {
                sendAppointmentConfirmation(appointment, patient);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to send confirmation email for appointment: " + appointment.getAppointmentNo(), e);
            }
        });
    }

    /**
     * Builds and dispatches appointment confirmation email (SMTP if enabled, otherwise simulated).
     */
    public static EmailRecord sendAppointmentConfirmation(Appointment appointment, Patient patient) {
        loadConfiguration(); // Refresh configuration so edits to email.properties take effect immediately
        String toEmail = (patient != null && patient.getEmail() != null && !patient.getEmail().isBlank())
                ? patient.getEmail().trim()
                : (appointment.getPatientEmail() != null ? appointment.getPatientEmail().trim() : "");

        String patientName = (patient != null && patient.getName() != null)
                ? patient.getName()
                : (appointment.getPatientName() != null ? appointment.getPatientName() : "Valued Patient");

        String appointmentNo = appointment.getAppointmentNo() != null ? appointment.getAppointmentNo() : "APT-N/A";
        String dentistName = appointment.getDentistName() != null ? appointment.getDentistName() : "Assigned Specialist";
        String treatment = appointment.getTreatmentType() != null ? appointment.getTreatmentType() : "Dental Consultation";
        String dateStr = appointment.getAppointmentDate() != null ? appointment.getAppointmentDate().toString() : "To be confirmed";
        String timeStr = appointment.getAppointmentTime() != null ? appointment.getAppointmentTime().toString() : "To be confirmed";

        String subject = "Appointment Confirmation [" + appointmentNo + "] - Sunrise Dental Clinic";
        String htmlBody = buildHtmlTemplate(appointmentNo, patientName, dentistName, treatment, dateStr, timeStr);

        boolean enabled = Boolean.parseBoolean(CONFIG.getProperty("mail.smtp.enabled", "false"));
        boolean smtpSuccess = false;
        String statusMsg;

        if (toEmail.isBlank()) {
            statusMsg = "No email address provided for patient";
            System.out.println("[SunriseDental Email] No email provided for appointment " + appointmentNo);
        } else if (!enabled) {
            statusMsg = "Demo Mode: Email generated & queued for preview (SMTP disabled in email.properties)";
            System.out.println("[SunriseDental Email] Demo Mode active (mail.smtp.enabled=false). Generated confirmation email for " + toEmail + " (APT #" + appointmentNo + ").");
            System.out.println("[SunriseDental Email] (To send to real Gmail inboxes, set mail.smtp.enabled=true and add your Gmail App Password in src/main/resources/email.properties)");
        } else {
            try {
                System.out.println("[SunriseDental Email] Connecting to SMTP server to send email to " + toEmail + "...");
                sendRawSmtpEmail(toEmail, subject, htmlBody);
                smtpSuccess = true;
                statusMsg = "Email successfully dispatched to " + toEmail + " via SMTP";
                System.out.println("[SunriseDental Email] SUCCESS! Real email delivered to " + toEmail);
            } catch (Exception e) {
                statusMsg = "SMTP dispatch failed: " + e.getMessage() + ". Email stored in preview cache.";
                System.err.println("[SunriseDental Email] SMTP ERROR: " + e.getMessage());
                LOGGER.log(Level.WARNING, "SMTP delivery failed, falling back to cached preview", e);
            }
        }

        EmailRecord record = new EmailRecord(appointmentNo, toEmail, patientName, subject, htmlBody, smtpSuccess, statusMsg);
        RECENT_EMAILS.put(appointmentNo, record);
        return record;
    }

    /**
     * Native Pure-Java SMTP implementation supporting STARTTLS and TLS encryption without external jars.
     */
    private static void sendRawSmtpEmail(String toEmail, String subject, String htmlContent) throws Exception {
        String host = CONFIG.getProperty("mail.smtp.host", "smtp.gmail.com");
        int port = Integer.parseInt(CONFIG.getProperty("mail.smtp.port", "587"));
        String username = CONFIG.getProperty("mail.smtp.username", "");
        String password = CONFIG.getProperty("mail.smtp.password", "");
        String fromName = CONFIG.getProperty("mail.from.name", "Sunrise Dental Clinic");
        String fromAddress = CONFIG.getProperty("mail.from.address", username);

        if (username.isBlank() || password.isBlank() || password.contains("your_")) {
            throw new IllegalStateException("SMTP username or password not configured in email.properties");
        }

        try (Socket socket = new Socket(host, port)) {
            socket.setSoTimeout(10000);
            BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), StandardCharsets.UTF_8));

            readResponse(reader, 220);

            sendCommand(writer, "EHLO " + host);
            readEhloResponse(reader);

            // STARTTLS handshake
            sendCommand(writer, "STARTTLS");
            readResponse(reader, 220);

            SSLSocketFactory sslFactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
            try (SSLSocket sslSocket = (SSLSocket) sslFactory.createSocket(socket, host, port, true)) {
                sslSocket.setSoTimeout(10000);
                sslSocket.startHandshake();

                BufferedReader sslReader = new BufferedReader(new InputStreamReader(sslSocket.getInputStream(), StandardCharsets.UTF_8));
                BufferedWriter sslWriter = new BufferedWriter(new OutputStreamWriter(sslSocket.getOutputStream(), StandardCharsets.UTF_8));

                sendCommand(sslWriter, "EHLO " + host);
                readEhloResponse(sslReader);

                // AUTH LOGIN
                sendCommand(sslWriter, "AUTH LOGIN");
                readResponse(sslReader, 334);

                sendCommand(sslWriter, Base64.getEncoder().encodeToString(username.getBytes(StandardCharsets.UTF_8)));
                readResponse(sslReader, 334);

                sendCommand(sslWriter, Base64.getEncoder().encodeToString(password.getBytes(StandardCharsets.UTF_8)));
                readResponse(sslReader, 235);

                // MAIL FROM & RCPT TO
                sendCommand(sslWriter, "MAIL FROM:<" + fromAddress + ">");
                readResponse(sslReader, 250);

                sendCommand(sslWriter, "RCPT TO:<" + toEmail + ">");
                readResponse(sslReader, 250);

                // DATA
                sendCommand(sslWriter, "DATA");
                readResponse(sslReader, 354);

                // Headers & MIME Body
                String encodedSubject = "=?UTF-8?B?" + Base64.getEncoder().encodeToString(subject.getBytes(StandardCharsets.UTF_8)) + "?=";
                sslWriter.write("From: \"" + fromName + "\" <" + fromAddress + ">\r\n");
                sslWriter.write("To: <" + toEmail + ">\r\n");
                sslWriter.write("Subject: " + encodedSubject + "\r\n");
                sslWriter.write("MIME-Version: 1.0\r\n");
                sslWriter.write("Content-Type: text/html; charset=UTF-8\r\n");
                sslWriter.write("Content-Transfer-Encoding: 8bit\r\n");
                sslWriter.write("\r\n");
                sslWriter.write(htmlContent);
                sslWriter.write("\r\n.\r\n");
                sslWriter.flush();
                readResponse(sslReader, 250);

                sendCommand(sslWriter, "QUIT");
                try { readResponse(sslReader, 221); } catch (Exception ignored) {}
            }
        }
    }

    private static void sendCommand(BufferedWriter writer, String command) throws Exception {
        writer.write(command + "\r\n");
        writer.flush();
    }

    private static String readResponse(BufferedReader reader, int expectedCode) throws Exception {
        String line = reader.readLine();
        if (line == null) {
            throw new Exception("SMTP server closed connection unexpectedly");
        }
        if (!line.startsWith(String.valueOf(expectedCode))) {
            throw new Exception("SMTP error (expected " + expectedCode + "): " + line);
        }
        return line;
    }

    private static void readEhloResponse(BufferedReader reader) throws Exception {
        String line;
        while ((line = reader.readLine()) != null) {
            if (line.length() >= 4 && line.charAt(3) == ' ') {
                break; // End of multiline response
            }
        }
    }

    public static EmailRecord getEmailByAppointmentNo(String appointmentNo) {
        return RECENT_EMAILS.get(appointmentNo);
    }

    public static Map<String, EmailRecord> getAllRecentEmails() {
        return RECENT_EMAILS;
    }

    /**
     * Generates a modern, clean HTML email template for dental appointment confirmation.
     */
    private static String buildHtmlTemplate(String appointmentNo, String patientName,
                                            String dentistName, String treatment,
                                            String dateStr, String timeStr) {
        String clinicName = CONFIG.getProperty("clinic.name", "Sunrise Dental Clinic");
        String clinicPhone = CONFIG.getProperty("clinic.phone", "+94 11 234 5678");
        String clinicAddress = CONFIG.getProperty("clinic.address", "No. 123, Galle Road, Colombo 03");

        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                + "<title>Appointment Confirmation</title>"
                + "<style>"
                + "body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; color: #2c3e50; }"
                + ".container { max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.08); border: 1px solid #e1e8ed; }"
                + ".header { background: linear-gradient(135deg, #1a5276 0%, #2e86c1 100%); color: #ffffff; padding: 30px 25px; text-align: center; }"
                + ".header h1 { margin: 0 0 6px 0; font-size: 24px; font-weight: 700; letter-spacing: 0.5px; }"
                + ".header p { margin: 0; font-size: 13px; opacity: 0.9; }"
                + ".content { padding: 30px 25px; }"
                + ".badge-box { text-align: center; margin-bottom: 25px; }"
                + ".badge-no { display: inline-block; background: #eaf2f8; color: #1a5276; font-weight: bold; font-size: 16px; padding: 8px 18px; border-radius: 20px; border: 1px solid #aed6f1; }"
                + ".details-table { width: 100%; border-collapse: collapse; margin-bottom: 25px; }"
                + ".details-table td { padding: 12px 14px; border-bottom: 1px solid #f0f4f8; font-size: 14px; }"
                + ".details-table td.label { font-weight: 600; color: #7f8c8d; width: 38%; background: #fafbfc; }"
                + ".details-table td.value { color: #2c3e50; font-weight: 500; }"
                + ".info-box { background: #fef9e7; border-left: 4px solid #f39c12; padding: 14px 16px; border-radius: 4px; margin-bottom: 25px; font-size: 13px; color: #7d6608; line-height: 1.5; }"
                + ".clinic-box { background: #f0f4f8; padding: 16px; border-radius: 8px; font-size: 13px; color: #34495e; }"
                + ".footer { text-align: center; padding: 20px; font-size: 12px; color: #95a5a6; background: #fafbfc; border-top: 1px solid #edf2f7; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "  <div class='header'>"
                + "    <h1>&#129463; " + clinicName + "</h1>"
                + "    <p>Healthy Smiles, Brighter Lives &bull; Appointment Confirmation</p>"
                + "  </div>"
                + "  <div class='content'>"
                + "    <p style='font-size: 16px; margin-top:0;'>Dear <strong>" + patientName + "</strong>,</p>"
                + "    <p style='color: #555; line-height: 1.5; font-size: 14px;'>Thank you for choosing " + clinicName + ". Your dental appointment has been scheduled successfully. Please find the details below:</p>"
                + "    <div class='badge-box'>"
                + "      <span class='badge-no'>Appointment #" + appointmentNo + "</span>"
                + "    </div>"
                + "    <table class='details-table'>"
                + "      <tr><td class='label'>Patient Name</td><td class='value'>" + patientName + "</td></tr>"
                + "      <tr><td class='label'>Assigned Dentist</td><td class='value'><strong>" + dentistName + "</strong></td></tr>"
                + "      <tr><td class='label'>Treatment / Service</td><td class='value'>" + treatment + "</td></tr>"
                + "      <tr><td class='label'>Scheduled Date</td><td class='value'><strong>" + dateStr + "</strong></td></tr>"
                + "      <tr><td class='label'>Scheduled Time</td><td class='value'><strong>" + timeStr + "</strong></td></tr>"
                + "      <tr><td class='label'>Current Status</td><td class='value'><span style='color:#e67e22; font-weight:bold;'>Pending / Scheduled</span></td></tr>"
                + "    </table>"
                + "    <div class='info-box'>"
                + "      <strong>&#128204; Important Patient Instructions:</strong><br>"
                + "      &bull; Please arrive at the clinic <strong>10 minutes prior</strong> to your scheduled time.<br>"
                + "      &bull; If you have any previous dental X-rays or ongoing prescriptions, please bring them with you.<br>"
                + "      &bull; If you need to reschedule or cancel, please notify us at least 24 hours in advance."
                + "    </div>"
                + "    <div class='clinic-box'>"
                + "      <strong>&#128205; Clinic Location & Contact:</strong><br>"
                + "      " + clinicAddress + "<br>"
                + "      &#128222; Hotline: " + clinicPhone + "<br>"
                + "    </div>"
                + "  </div>"
                + "  <div class='footer'>"
                + "    This is an automated appointment confirmation from " + clinicName + " Management System.<br>"
                + "    Please do not reply directly to this automated email."
                + "  </div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }
}
