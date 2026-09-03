package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.sunrisedental.dao.PatientDAO;
import com.sunrisedental.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PatientServlet extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = getRequestPath(req);
        try {
            if (path.equals("/patients/list")) {
                listPatients(req, resp);
            } else if (path.equals("/patients/add")) {
                req.setAttribute("pageTitle", "Add Patient");
                req.setAttribute("activeMenu", "patients");
                req.getRequestDispatcher("/patients/form.jsp").forward(req, resp);
            } else if (path.startsWith("/patients/edit/")) {
                int id = Integer.parseInt(path.substring("/patients/edit/".length()));
                Patient patient = patientDAO.findById(id);
                req.setAttribute("patient", patient);
                req.setAttribute("pageTitle", "Edit Patient");
                req.setAttribute("activeMenu", "patients");
                req.getRequestDispatcher("/patients/form.jsp").forward(req, resp);
            } else if (path.startsWith("/patients/delete/")) {
                HttpSession session = req.getSession(false);
                com.sunrisedental.model.User user = (session != null) ? (com.sunrisedental.model.User) session.getAttribute("user") : null;
                if (user == null || !user.isAdmin()) {
                    resp.sendRedirect(req.getContextPath() + "/patients/list?error=unauthorized");
                    return;
                }
                int id = Integer.parseInt(path.substring("/patients/delete/".length()));
                patientDAO.delete(id);
                resp.sendRedirect(req.getContextPath() + "/patients/list");
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
            String name = req.getParameter("name");
            String contact = req.getParameter("contact");
            String email = req.getParameter("email");
            String address = req.getParameter("address");

            // Required-field and format validation
            if (name == null || name.trim().isBlank()) {
                forwardValidationError(req, resp, path, "Patient Name is required.");
                return;
            }

            if (contact == null || !contact.trim().matches("^\\d{10}$")) {
                forwardValidationError(req, resp, path, "Contact number must contain exactly 10 digits (e.g. 0771234567).");
                return;
            }

            if (email == null || !email.trim().matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
                forwardValidationError(req, resp, path, "Please provide a valid email format (e.g. patient@example.com).");
                return;
            }

            Patient patient = new Patient();
            patient.setName(name.trim());
            patient.setContact(contact.trim());
            patient.setEmail(email.trim());
            patient.setAddress(address != null ? address.trim() : "");

            if (path.startsWith("/patients/edit/")) {
                patient.setId(Integer.parseInt(path.substring("/patients/edit/".length())));
                patientDAO.update(patient);
            } else {
                patientDAO.insert(patient);
            }
            resp.sendRedirect(req.getContextPath() + "/patients/list");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private void forwardValidationError(HttpServletRequest req, HttpServletResponse resp, String path, String errorMsg)
            throws ServletException, IOException, SQLException {
        req.setAttribute("errorMessage", errorMsg);
        req.setAttribute("inputName", req.getParameter("name"));
        req.setAttribute("inputContact", req.getParameter("contact"));
        req.setAttribute("inputEmail", req.getParameter("email"));
        req.setAttribute("inputAddress", req.getParameter("address"));

        boolean isEdit = path.startsWith("/patients/edit/");
        if (isEdit) {
            int id = Integer.parseInt(path.substring("/patients/edit/".length()));
            Patient existing = patientDAO.findById(id);
            req.setAttribute("patient", existing);
            req.setAttribute("pageTitle", "Edit Patient");
        } else {
            req.setAttribute("pageTitle", "Add Patient");
        }
        req.setAttribute("activeMenu", "patients");
        req.getRequestDispatcher("/patients/form.jsp").forward(req, resp);
    }

    private String getRequestPath(HttpServletRequest req) {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();
        return pathInfo != null ? servletPath + pathInfo : servletPath;
    }

    private void listPatients(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String keyword = req.getParameter("search");
        List<Patient> patients = (keyword != null && !keyword.isBlank())
                ? patientDAO.search(keyword.trim())
                : patientDAO.findAll();
        req.setAttribute("patients", patients);
        req.setAttribute("search", keyword);
        req.setAttribute("pageTitle", "Patients List");
        req.setAttribute("activeMenu", "patients");
        req.getRequestDispatcher("/patients/list.jsp").forward(req, resp);
    }
}
