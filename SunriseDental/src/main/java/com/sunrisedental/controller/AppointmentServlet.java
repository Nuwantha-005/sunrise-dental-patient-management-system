package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.dao.DentistDAO;
import com.sunrisedental.dao.PatientDAO;
import com.sunrisedental.dao.TreatmentDAO;
import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Dentist;
import com.sunrisedental.model.Patient;
import com.sunrisedental.model.Treatment;
import com.sunrisedental.model.User;
import com.sunrisedental.util.EmailUtil;
import com.sunrisedental.util.EmailUtil.EmailRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AppointmentServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final DentistDAO dentistDAO = new DentistDAO();
    private final TreatmentDAO treatmentDAO = new TreatmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = getRequestPath(req);
        try {
            if (path.equals("/appointments/register")) {
                showRegisterForm(req, resp);
            } else if (path.equals("/appointments/search")) {
                showSearchPage(req, resp);
            } else if (path.equals("/appointments/history")) {
                showHistoryPage(req, resp);
            } else if (path.startsWith("/appointments/complete/")) {
                int id = Integer.parseInt(path.substring("/appointments/complete/".length()));
                completeAppointment(req, resp, id);
            } else if (path.startsWith("/appointments/edit/")) {
                int id = Integer.parseInt(path.substring("/appointments/edit/".length()));
                showEditForm(req, resp, id);
            } else if (path.startsWith("/appointments/resend-email/")) {
                int id = Integer.parseInt(path.substring("/appointments/resend-email/".length()));
                resendEmail(req, resp, id);
            } else if (path.startsWith("/appointments/delete/")) {
                int id = Integer.parseInt(path.substring("/appointments/delete/".length()));
                deleteAppointment(req, resp, id);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = getRequestPath(req);
        try {
            if (path.equals("/appointments/register")) {
                saveAppointment(req, resp);
            } else if (path.equals("/appointments/search")) {
                searchAppointment(req, resp);
            } else if (path.equals("/appointments/history")) {
                showHistoryPage(req, resp);
            } else if (path.startsWith("/appointments/edit/")) {
                int id = Integer.parseInt(path.substring("/appointments/edit/".length()));
                updateAppointment(req, resp, id);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private String getRequestPath(HttpServletRequest req) {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();
        return pathInfo != null ? servletPath + pathInfo : servletPath;
    }

    private void showRegisterForm(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        List<Dentist> dentists = dentistDAO.findAll();
        List<Patient> patients = patientDAO.findAll();
        List<Treatment> treatments = treatmentDAO.findAll();
        req.setAttribute("dentists", dentists);
        req.setAttribute("patients", patients);
        req.setAttribute("treatments", treatments);
        req.setAttribute("nextAppointmentNo", appointmentDAO.generateNextAppointmentNo());
        req.setAttribute("pageTitle", "Register New Appointment");
        req.setAttribute("activeMenu", "appointments");
        req.getRequestDispatcher("/appointments/register.jsp").forward(req, resp);
    }

    private void saveAppointment(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String patientIdParam = req.getParameter("patientId");
        String patientName = req.getParameter("patientName");
        String contact = req.getParameter("contact");
        String email = req.getParameter("email");
        String address = req.getParameter("address");
        int dentistId = Integer.parseInt(req.getParameter("dentistId"));
        
        String[] treatmentTypeArr = req.getParameterValues("treatmentType");
        StringBuilder treatmentBuilder = new StringBuilder();
        if (treatmentTypeArr != null) {
            for (String t : treatmentTypeArr) {
                if (t != null && !t.isBlank()) {
                    if (treatmentBuilder.length() > 0) treatmentBuilder.append(", ");
                    treatmentBuilder.append(t.trim());
                }
            }
        }
        String treatmentType = treatmentBuilder.length() > 0 ? treatmentBuilder.toString() : "Dental Checkup";
        
        Date appointmentDate = Date.valueOf(req.getParameter("appointmentDate"));
        Time appointmentTime = Time.valueOf(req.getParameter("appointmentTime") + ":00");

        // Availability check: ensure dentist is available on the selected day of the week for the selected procedures
        String selectedDayName = appointmentDate.toLocalDate().getDayOfWeek().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH);
        List<Treatment> dentistTreatments = treatmentDAO.findByDentistId(dentistId);
        if (treatmentTypeArr != null && dentistTreatments != null && !dentistTreatments.isEmpty()) {
            for (String selectedTName : treatmentTypeArr) {
                if (selectedTName != null && !selectedTName.isBlank()) {
                    for (Treatment dt : dentistTreatments) {
                        if (dt.getTreatmentName().equalsIgnoreCase(selectedTName.trim())) {
                            if (dt.getAvailableDays() != null && !dt.getAvailableDays().toLowerCase().contains(selectedDayName.toLowerCase())) {
                                Dentist dentist = dentistDAO.findById(dentistId);
                                String dName = (dentist != null) ? dentist.getName() : "The selected dentist";
                                req.setAttribute("errorMessage", "⚠️ Schedule Availability Alert: Dr. " + dName + " is NOT available on " + selectedDayName + "s for procedure '" + dt.getTreatmentName() + "'. Doctor's available schedule days: " + dt.getAvailableDays() + ".");

                                // Preserve form inputs
                                req.setAttribute("inputPatientId", patientIdParam);
                                req.setAttribute("inputPatientName", patientName);
                                req.setAttribute("inputContact", contact);
                                req.setAttribute("inputEmail", email);
                                req.setAttribute("inputAddress", address);
                                req.setAttribute("inputDentistId", dentistId);
                                req.setAttribute("inputTreatments", treatmentTypeArr);
                                req.setAttribute("inputAppointmentDate", req.getParameter("appointmentDate"));
                                req.setAttribute("inputAppointmentTime", req.getParameter("appointmentTime"));

                                showRegisterForm(req, resp);
                                return;
                            }
                        }
                    }
                }
            }
        }

        // Conflict check: ensure no other active appointment exists for this dentist on this date & time
        Appointment conflict = appointmentDAO.findConflictingAppointment(dentistId, appointmentDate, appointmentTime, -1);
        if (conflict != null) {
            Dentist dentist = dentistDAO.findById(dentistId);
            String dentistName = (dentist != null) ? dentist.getName() : "The selected dentist";
            String timeFormatted = req.getParameter("appointmentTime");

            req.setAttribute("errorMessage", "⚠️ Booking Conflict: " + dentistName + " is already booked on " 
                    + appointmentDate + " at " + timeFormatted + " (" + conflict.getAppointmentNo() + " - " + conflict.getPatientName() + "). Please choose a different time slot or dentist.");

            // Preserve form inputs
            req.setAttribute("inputPatientId", patientIdParam);
            req.setAttribute("inputPatientName", patientName);
            req.setAttribute("inputContact", contact);
            req.setAttribute("inputEmail", email);
            req.setAttribute("inputAddress", address);
            req.setAttribute("inputDentistId", dentistId);
            req.setAttribute("inputTreatments", treatmentTypeArr);
            req.setAttribute("inputTreatmentType", treatmentType);
            req.setAttribute("inputAppointmentDate", req.getParameter("appointmentDate"));
            req.setAttribute("inputAppointmentTime", req.getParameter("appointmentTime"));

            showRegisterForm(req, resp);
            return;
        }

        int patientId = -1;
        if (patientIdParam != null && !patientIdParam.isBlank()) {
            try {
                patientId = Integer.parseInt(patientIdParam);
            } catch (NumberFormatException ignored) {}
        }

        Patient patient;
        if (patientId > 0) {
            patient = patientDAO.findById(patientId);
            if (patient != null) {
                patient.setName(patientName);
                patient.setContact(contact);
                patient.setEmail(email);
                patient.setAddress(address);
                patientDAO.update(patient);
            } else {
                patient = new Patient();
                patient.setName(patientName);
                patient.setContact(contact);
                patient.setEmail(email);
                patient.setAddress(address);
                patientId = patientDAO.insert(patient);
                patient.setId(patientId);
            }
        } else {
            patient = new Patient();
            patient.setName(patientName);
            patient.setContact(contact);
            patient.setEmail(email);
            patient.setAddress(address);
            patientId = patientDAO.insert(patient);
            patient.setId(patientId);
        }

        String appNo = appointmentDAO.generateNextAppointmentNo();
        Appointment appointment = new Appointment();
        appointment.setAppointmentNo(appNo);
        appointment.setPatientId(patientId);
        appointment.setDentistId(dentistId);
        appointment.setTreatmentType(treatmentType);
        appointment.setAppointmentDate(appointmentDate);
        appointment.setAppointmentTime(appointmentTime);
        appointment.setStatus("Pending");
        int appointmentId = appointmentDAO.insert(appointment);
        appointment.setId(appointmentId);

        // Fetch dentist details for email
        Dentist dentist = dentistDAO.findById(dentistId);
        String dentistName = (dentist != null) ? dentist.getName() : "Specialist Dentist";
        appointment.setDentistName(dentistName);
        appointment.setPatientName(patientName);
        appointment.setPatientContact(contact);
        appointment.setPatientEmail(email);

        // Generate Patient Portal Credentials
        // Username = appointment number (e.g. APT-004), Password = random 8-char alphanumeric
        String rawPortalPassword = generateRandomPassword(8);
        appointment.setPatientUsername(appNo);
        appointmentDAO.savePatientCredentials(appointmentId, appNo, com.sunrisedental.util.PasswordUtil.hash(rawPortalPassword));

        // Dispatch Confirmation Email (includes patient portal login credentials)
        EmailUtil.sendAppointmentConfirmation(appointment, patient, rawPortalPassword);

        resp.sendRedirect(req.getContextPath() + "/appointments/history?success=registered&appointmentNo=" + appNo + "&emailSent=1");
    }

    /** Generates a secure random alphanumeric password of the given length. */
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
        java.util.Random random = new java.security.SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }


    private void showSearchPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        String appointmentNo = req.getParameter("appointmentNo");
        if (appointmentNo != null && !appointmentNo.isBlank()) {
            Appointment appointment = appointmentDAO.findByAppointmentNo(appointmentNo.trim());
            if (appointment != null) {
                populateAppointmentEmail(req, appointment);
            } else {
                req.setAttribute("error", "Appointment not found");
            }
            req.setAttribute("appointmentNo", appointmentNo.trim());
        }
        if ("1".equals(req.getParameter("emailSent"))) {
            req.setAttribute("emailSentNotice", true);
        }
        if ("resent".equals(req.getParameter("success"))) {
            req.setAttribute("resendNotice", true);
        }
        req.setAttribute("pageTitle", "Search Appointment");
        req.setAttribute("activeMenu", "appointments");
        req.getRequestDispatcher("/appointments/search.jsp").forward(req, resp);
    }

    private void searchAppointment(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String appointmentNo = req.getParameter("appointmentNo");
        Appointment appointment = appointmentDAO.findByAppointmentNo(appointmentNo);
        if (appointment == null) {
            req.setAttribute("error", "Appointment not found");
        } else {
            populateAppointmentEmail(req, appointment);
        }
        req.setAttribute("appointmentNo", appointmentNo);
        req.setAttribute("pageTitle", "Search Appointment");
        req.setAttribute("activeMenu", "appointments");
        req.getRequestDispatcher("/appointments/search.jsp").forward(req, resp);
    }

    private void populateAppointmentEmail(HttpServletRequest req, Appointment appointment) {
        req.setAttribute("appointment", appointment);
        EmailRecord emailRecord = EmailUtil.getEmailByAppointmentNo(appointment.getAppointmentNo());
        if (emailRecord == null) {
            emailRecord = EmailUtil.sendAppointmentConfirmation(appointment, null);
        }
        req.setAttribute("emailRecord", emailRecord);
        req.setAttribute("emailHtml", emailRecord != null ? emailRecord.getHtmlBody() : "");
    }

    private void showHistoryPage(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String keyword = req.getParameter("search");
        String status = req.getParameter("status");
        String dentistId = req.getParameter("dentistId");

        List<Appointment> historyList = appointmentDAO.findHistory(keyword, status, dentistId);
        List<Dentist> dentists = dentistDAO.findAll();

        req.setAttribute("historyList", historyList);
        req.setAttribute("dentists", dentists);
        req.setAttribute("search", keyword);
        req.setAttribute("selectedStatus", status != null ? status : "ALL");
        req.setAttribute("selectedDentist", dentistId);
        req.setAttribute("pageTitle", "Booking History");
        req.setAttribute("activeMenu", "history");
        req.getRequestDispatcher("/appointments/history.jsp").forward(req, resp);
    }

    private void completeAppointment(HttpServletRequest req, HttpServletResponse resp, int id)
            throws SQLException, IOException {
        resp.sendRedirect(req.getContextPath() + "/billing/generate/" + id);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, int id)
            throws SQLException, ServletException, IOException {
        Appointment appointment = appointmentDAO.findById(id);
        List<Dentist> dentists = dentistDAO.findAll();
        List<Treatment> treatments = treatmentDAO.findAll();
        Patient patient = patientDAO.findById(appointment.getPatientId());
        req.setAttribute("appointment", appointment);
        req.setAttribute("patient", patient);
        req.setAttribute("dentists", dentists);
        req.setAttribute("treatments", treatments);
        req.setAttribute("pageTitle", "Edit Appointment");
        req.setAttribute("activeMenu", "appointments");
        req.getRequestDispatcher("/appointments/edit.jsp").forward(req, resp);
    }

    private void updateAppointment(HttpServletRequest req, HttpServletResponse resp, int id)
            throws SQLException, ServletException, IOException {
        Appointment appointment = appointmentDAO.findById(id);
        Patient patient = patientDAO.findById(appointment.getPatientId());

        String patientName = req.getParameter("patientName");
        String contact = req.getParameter("contact");
        String email = req.getParameter("email");
        String address = req.getParameter("address");
        int dentistId = Integer.parseInt(req.getParameter("dentistId"));
        
        String[] treatmentTypeArr = req.getParameterValues("treatmentType");
        StringBuilder treatmentBuilder = new StringBuilder();
        if (treatmentTypeArr != null) {
            for (String t : treatmentTypeArr) {
                if (t != null && !t.isBlank()) {
                    if (treatmentBuilder.length() > 0) treatmentBuilder.append(", ");
                    treatmentBuilder.append(t.trim());
                }
            }
        }
        String treatmentType = treatmentBuilder.length() > 0 ? treatmentBuilder.toString() : "Dental Checkup";
        
        Date appointmentDate = Date.valueOf(req.getParameter("appointmentDate"));
        Time appointmentTime = Time.valueOf(req.getParameter("appointmentTime") + ":00");
        String status = req.getParameter("status");

        // Availability check: ensure dentist is available on the selected day of the week for the selected procedures
        String selectedDayName = appointmentDate.toLocalDate().getDayOfWeek().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH);
        List<Treatment> dentistTreatments = treatmentDAO.findByDentistId(dentistId);
        if (treatmentTypeArr != null && dentistTreatments != null && !dentistTreatments.isEmpty()) {
            for (String selectedTName : treatmentTypeArr) {
                if (selectedTName != null && !selectedTName.isBlank()) {
                    for (Treatment dt : dentistTreatments) {
                        if (dt.getTreatmentName().equalsIgnoreCase(selectedTName.trim())) {
                            if (dt.getAvailableDays() != null && !dt.getAvailableDays().toLowerCase().contains(selectedDayName.toLowerCase())) {
                                Dentist dentist = dentistDAO.findById(dentistId);
                                String dName = (dentist != null) ? dentist.getName() : "The selected dentist";
                                req.setAttribute("errorMessage", "⚠️ Schedule Availability Alert: Dr. " + dName + " is NOT available on " + selectedDayName + "s for procedure '" + dt.getTreatmentName() + "'. Doctor's available schedule days: " + dt.getAvailableDays() + ".");

                                showEditForm(req, resp, id);
                                return;
                            }
                        }
                    }
                }
            }
        }

        if (!"Cancelled".equalsIgnoreCase(status)) {
            Appointment conflict = appointmentDAO.findConflictingAppointment(dentistId, appointmentDate, appointmentTime, id);
            if (conflict != null) {
                Dentist dentist = dentistDAO.findById(dentistId);
                String dentistName = (dentist != null) ? dentist.getName() : "The selected dentist";
                String timeFormatted = req.getParameter("appointmentTime");

                req.setAttribute("errorMessage", "⚠️ Rescheduling Conflict: " + dentistName + " is already booked on " 
                        + appointmentDate + " at " + timeFormatted + " (" + conflict.getAppointmentNo() + " - " + conflict.getPatientName() + "). Please choose a different time or dentist.");
                showEditForm(req, resp, id);
                return;
            }
        }

        patient.setName(patientName);
        patient.setContact(contact);
        patient.setEmail(email);
        patient.setAddress(address);
        patientDAO.update(patient);

        appointment.setDentistId(dentistId);
        appointment.setTreatmentType(treatmentType);
        appointment.setAppointmentDate(appointmentDate);
        appointment.setAppointmentTime(appointmentTime);
        appointment.setStatus(status);
        appointmentDAO.update(appointment);

        resp.sendRedirect(req.getContextPath() + "/appointments/search?appointmentNo="
                + appointment.getAppointmentNo() + "&success=updated");
    }

    private void resendEmail(HttpServletRequest req, HttpServletResponse resp, int id)
            throws SQLException, IOException {
        Appointment appointment = appointmentDAO.findById(id);
        if (appointment != null) {
            Patient patient = patientDAO.findById(appointment.getPatientId());
            EmailUtil.sendAppointmentConfirmation(appointment, patient);
            resp.sendRedirect(req.getContextPath() + "/appointments/search?appointmentNo="
                    + appointment.getAppointmentNo() + "&success=resent");
        } else {
            resp.sendRedirect(req.getContextPath() + "/appointments/search");
        }
    }

    private void deleteAppointment(HttpServletRequest req, HttpServletResponse resp, int id)
            throws SQLException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/appointments/history?error=unauthorized");
            return;
        }
        appointmentDAO.delete(id);
        resp.sendRedirect(req.getContextPath() + "/appointments/history?success=deleted");
    }
}
