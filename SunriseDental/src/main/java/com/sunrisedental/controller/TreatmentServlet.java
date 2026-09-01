package com.sunrisedental.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

import com.sunrisedental.dao.DentistDAO;
import com.sunrisedental.dao.TreatmentDAO;
import com.sunrisedental.model.Dentist;
import com.sunrisedental.model.Treatment;
import com.sunrisedental.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class TreatmentServlet extends HttpServlet {

    private final TreatmentDAO treatmentDAO = new TreatmentDAO();
    private final DentistDAO dentistDAO = new DentistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = getRequestPath(req);
        try {
            if (path.equals("/treatments") || path.equals("/treatments/list")) {
                listTreatments(req, resp);
            } else if (path.equals("/treatments/add")) {
                if (!requireAdmin(req, resp)) return;
                showAddForm(req, resp);
            } else if (path.startsWith("/treatments/edit/")) {
                if (!requireAdmin(req, resp)) return;
                int id = Integer.parseInt(path.substring("/treatments/edit/".length()));
                showEditForm(req, resp, id);
            } else if (path.startsWith("/treatments/delete/")) {
                if (!requireAdmin(req, resp)) return;
                int id = Integer.parseInt(path.substring("/treatments/delete/".length()));
                treatmentDAO.delete(id);
                resp.sendRedirect(req.getContextPath() + "/treatments/list?success=deleted");
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in TreatmentServlet", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        String path = getRequestPath(req);
        try {
            int dentistId = Integer.parseInt(req.getParameter("dentistId"));
            String treatmentName = req.getParameter("treatmentName");
            BigDecimal price = new BigDecimal(req.getParameter("price"));
            String[] availableDaysArr = req.getParameterValues("availableDays");
            String availableDaysStr = (availableDaysArr != null && availableDaysArr.length > 0)
                    ? String.join(", ", availableDaysArr)
                    : "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday";
            String description = req.getParameter("description");

            if (path.startsWith("/treatments/edit/")) {
                int id = Integer.parseInt(path.substring("/treatments/edit/".length()));
                Treatment t = new Treatment(id, dentistId, treatmentName, price, availableDaysStr, description);
                treatmentDAO.update(t);
                resp.sendRedirect(req.getContextPath() + "/treatments/list?success=updated");
            } else {
                Treatment t = new Treatment(0, dentistId, treatmentName, price, availableDaysStr, description);
                treatmentDAO.insert(t);
                resp.sendRedirect(req.getContextPath() + "/treatments/list?success=added");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in TreatmentServlet", e);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/treatments/list?error=invalid_input");
        }
    }

    private void listTreatments(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String dentistIdParam = req.getParameter("dentistId");
        List<Treatment> list;
        if (dentistIdParam != null && !dentistIdParam.isBlank() && !"0".equals(dentistIdParam)) {
            int dId = Integer.parseInt(dentistIdParam);
            list = treatmentDAO.findByDentistId(dId);
        } else {
            list = treatmentDAO.findAll();
        }

        List<Dentist> dentists = dentistDAO.findAll();
        req.setAttribute("treatments", list);
        req.setAttribute("dentists", dentists);
        req.setAttribute("selectedDentist", dentistIdParam);
        req.setAttribute("pageTitle", "Manage Treatments & Pricing");
        req.setAttribute("activeMenu", "treatments");
        req.getRequestDispatcher("/treatments/list.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        List<Dentist> dentists = dentistDAO.findAll();
        req.setAttribute("dentists", dentists);
        req.setAttribute("pageTitle", "Add New Treatment");
        req.setAttribute("activeMenu", "treatments");
        req.getRequestDispatcher("/treatments/form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp, int id)
            throws SQLException, ServletException, IOException {
        Treatment treatment = treatmentDAO.findById(id);
        if (treatment != null) {
            List<Dentist> dentists = dentistDAO.findAll();
            req.setAttribute("treatment", treatment);
            req.setAttribute("dentists", dentists);
            req.setAttribute("pageTitle", "Edit Treatment");
            req.setAttribute("activeMenu", "treatments");
            req.getRequestDispatcher("/treatments/form.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/treatments/list");
        }
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/treatments/list?error=unauthorized");
            return false;
        }
        return true;
    }

    private String getRequestPath(HttpServletRequest req) {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();
        return pathInfo != null ? servletPath + pathInfo : servletPath;
    }
}
