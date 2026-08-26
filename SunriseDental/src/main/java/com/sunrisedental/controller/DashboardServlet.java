package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.dao.BillDAO;
import com.sunrisedental.dao.PatientDAO;
import com.sunrisedental.model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DashboardServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO     patientDAO     = new PatientDAO();
    private final BillDAO        billDAO        = new BillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Appointment> todayAppointments  = appointmentDAO.findTodayAppointments();
            List<Appointment> activeAppointments = appointmentDAO.findActiveAppointments();

            req.setAttribute("todayAppointments",  todayAppointments);
            req.setAttribute("recentAppointments", activeAppointments);
            req.setAttribute("totalAppointments",  appointmentDAO.countAll());
            req.setAttribute("todayCount",         appointmentDAO.countToday());
            req.setAttribute("totalPatients",      patientDAO.countAll());
            req.setAttribute("totalRevenue",       billDAO.getTotalRevenue());
            req.setAttribute("pageTitle",          "Dashboard");
            req.setAttribute("activeMenu",         "dashboard");

            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load dashboard", e);
        }
    }
}

