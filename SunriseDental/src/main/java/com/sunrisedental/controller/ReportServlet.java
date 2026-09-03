package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

import com.sunrisedental.dao.AppointmentDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ReportServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String reportType = req.getParameter("type");
        if (reportType == null) {
            reportType = "daily";
        }

        String dateParam = req.getParameter("date");
        Date reportDate = (dateParam != null && !dateParam.isBlank())
                ? Date.valueOf(dateParam)
                : new Date(System.currentTimeMillis());

        try {
            int total = appointmentDAO.countByDate(reportDate);
            int completed = appointmentDAO.countByDateAndStatus(reportDate, "Completed");
            int pending = appointmentDAO.countByDateAndStatus(reportDate, "Pending");
            int cancelled = appointmentDAO.countByDateAndStatus(reportDate, "Cancelled");
            int confirmed = appointmentDAO.countByDateAndStatus(reportDate, "Confirmed");

            req.setAttribute("reportType", reportType);
            req.setAttribute("reportDate", reportDate.toString());
            req.setAttribute("total", total);
            req.setAttribute("completed", completed);
            req.setAttribute("pending", pending + confirmed);
            req.setAttribute("cancelled", cancelled);
            req.setAttribute("pageTitle", "Reports");
            req.setAttribute("activeMenu", "reports");
            req.getRequestDispatcher("/reports/index.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
