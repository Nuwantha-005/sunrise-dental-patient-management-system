package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.dao.BillDAO;
import com.sunrisedental.dao.PatientDAO;
import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Bill;
import com.sunrisedental.model.Patient;
import com.sunrisedental.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PatientPortalServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final BillDAO billDAO = new BillDAO();
    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        try {
            if ("/patient-login".equals(path)) {
                HttpSession session = req.getSession(false);
                if (session != null && session.getAttribute("patientSession") != null) {
                    resp.sendRedirect(req.getContextPath() + "/patient-dashboard");
                    return;
                }

                // Read Remember Me Cookie for Patient Login
                Cookie[] cookies = req.getCookies();
                if (cookies != null) {
                    for (Cookie c : cookies) {
                        if ("remember_patient_username".equals(c.getName())) {
                            req.setAttribute("rememberedPatientUsername", c.getValue());
                        }
                    }
                }

                req.getRequestDispatcher("/patient-login.jsp").forward(req, resp);

            } else if ("/patient-dashboard".equals(path)) {
                HttpSession session = req.getSession(false);
                if (session == null || session.getAttribute("patientSession") == null) {
                    resp.sendRedirect(req.getContextPath() + "/patient-login");
                    return;
                }
                showDashboard(req, resp, session);

            } else if ("/patient-logout".equals(path)) {
                HttpSession session = req.getSession(false);
                if (session != null) {
                    session.removeAttribute("patientSession");
                }
                resp.sendRedirect(req.getContextPath() + "/home");

            } else if (path.startsWith("/patient-receipt")) {
                // Patient-accessible receipt — requires patient session
                HttpSession session = req.getSession(false);
                if (session == null || session.getAttribute("patientSession") == null) {
                    resp.sendRedirect(req.getContextPath() + "/patient-login");
                    return;
                }
                showPatientReceipt(req, resp, session);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in patient portal", e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/patient-login".equals(path)) {
            try {
                handleLogin(req, resp);
            } catch (SQLException e) {
                throw new ServletException("Database error during patient login", e);
            }
        } else {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Please enter your Appointment ID and password.");
            req.getRequestDispatcher("/patient-login.jsp").forward(req, resp);
            return;
        }

        String hashedPassword = PasswordUtil.hash(password.trim());
        Appointment matchedAppointment = appointmentDAO.findByPatientLogin(username.trim().toUpperCase(), hashedPassword);

        if (matchedAppointment == null) {
            req.setAttribute("error", "Invalid Appointment ID or password. Please check your confirmation email for your login credentials.");
            req.getRequestDispatcher("/patient-login.jsp").forward(req, resp);
            return;
        }

        // Manage Remember Me Cookie for Patient Login
        String remember = req.getParameter("remember");
        String contextPath = req.getContextPath().isEmpty() ? "/" : req.getContextPath();
        if ("true".equals(remember) || "on".equals(remember)) {
            Cookie cookie = new Cookie("remember_patient_username", username.trim().toUpperCase());
            cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            cookie.setPath(contextPath);
            resp.addCookie(cookie);
        } else {
            Cookie cookie = new Cookie("remember_patient_username", "");
            cookie.setMaxAge(0);
            cookie.setPath(contextPath);
            resp.addCookie(cookie);
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("patientSession", matchedAppointment);
        resp.sendRedirect(req.getContextPath() + "/patient-dashboard");
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws SQLException, ServletException, IOException {
        Appointment sessionAppointment = (Appointment) session.getAttribute("patientSession");
        Patient patient = patientDAO.findById(sessionAppointment.getPatientId());
        
        String patientEmail = (patient != null && patient.getEmail() != null) 
                ? patient.getEmail() 
                : sessionAppointment.getPatientEmail();

        List<Appointment> appointments = null;
        if (patientEmail != null && !patientEmail.isBlank()) {
            appointments = appointmentDAO.findAllByPatientEmail(patientEmail);
        } else {
            appointments = java.util.Collections.singletonList(sessionAppointment);
        }

        java.util.Map<Integer, Bill> billsMap = new java.util.LinkedHashMap<>();
        if (appointments != null) {
            for (Appointment apt : appointments) {
                try {
                    Bill bill = billDAO.findByAppointmentId(apt.getId());
                    if (bill != null) {
                        billsMap.put(apt.getId(), bill);
                    }
                } catch (Exception ignored) {}
            }
        }

        long totalCount = appointments != null ? appointments.size() : 0;
        long pendingCount = appointments != null ? appointments.stream().filter(a -> "Pending".equalsIgnoreCase(a.getStatus()) || "Confirmed".equalsIgnoreCase(a.getStatus())).count() : 0;
        long completedCount = appointments != null ? appointments.stream().filter(a -> "Completed".equalsIgnoreCase(a.getStatus())).count() : 0;

        req.setAttribute("patient", patient);
        req.setAttribute("patientName", (patient != null) ? patient.getName() : sessionAppointment.getPatientName());
        req.setAttribute("patientCode", (patient != null) ? patient.getPatientCode() : String.format("PAT-%03d", sessionAppointment.getPatientId()));
        req.setAttribute("patientEmail", patientEmail);
        req.setAttribute("appointments", appointments);
        req.setAttribute("billsMap", billsMap);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("completedCount", completedCount);

        req.getRequestDispatcher("/patient/dashboard.jsp").forward(req, resp);
    }

    private void showPatientReceipt(HttpServletRequest req, HttpServletResponse resp, HttpSession session)
            throws SQLException, ServletException, IOException {
        // Extract appointment ID from path: /patient-receipt/123
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            resp.sendRedirect(req.getContextPath() + "/patient-dashboard");
            return;
        }
        int appointmentId;
        try {
            appointmentId = Integer.parseInt(pathInfo.substring(1));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/patient-dashboard");
            return;
        }

        // Validate this appointment belongs to the logged-in patient
        Appointment sessionAppointment = (Appointment) session.getAttribute("patientSession");
        Patient patient = patientDAO.findById(sessionAppointment.getPatientId());
        String patientEmail = (patient != null && patient.getEmail() != null)
                ? patient.getEmail()
                : sessionAppointment.getPatientEmail();

        Appointment appointment = appointmentDAO.findById(appointmentId);
        if (appointment == null) {
            resp.sendRedirect(req.getContextPath() + "/patient-dashboard");
            return;
        }
        // Security check: appointment must belong to this patient
        boolean isOwner = appointment.getPatientId() == sessionAppointment.getPatientId()
                || (patientEmail != null && patientEmail.equalsIgnoreCase(appointment.getPatientEmail()));
        if (!isOwner) {
            resp.sendRedirect(req.getContextPath() + "/patient-dashboard");
            return;
        }

        Bill bill = billDAO.findByAppointmentId(appointmentId);
        req.setAttribute("bill", bill);
        req.setAttribute("appointment", appointment);
        req.setAttribute("patientName", (patient != null) ? patient.getName() : sessionAppointment.getPatientName());
        req.setAttribute("patientCode", (patient != null) ? patient.getPatientCode() : String.format("PAT-%03d", sessionAppointment.getPatientId()));
        req.getRequestDispatcher("/patient/receipt.jsp").forward(req, resp);
    }
}

