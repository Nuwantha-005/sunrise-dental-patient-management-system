package com.sunrisedental.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

import com.sunrisedental.dao.AppointmentDAO;
import com.sunrisedental.dao.BillDAO;
import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Bill;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BillServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final BillDAO billDAO = new BillDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = getRequestPath(req);
        try {
            if (path.equals("/billing") || path.equals("/billing/search")) {
                showBillingSearch(req, resp);
            } else if (path.startsWith("/billing/generate/")) {
                int appointmentId = Integer.parseInt(path.substring("/billing/generate/".length()));
                showGenerateForm(req, resp, appointmentId);
            } else if (path.startsWith("/billing/receipt/")) {
                int appointmentId = Integer.parseInt(path.substring("/billing/receipt/".length()));
                showReceipt(req, resp, appointmentId);
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
            if (path.equals("/billing/search")) {
                searchForBilling(req, resp);
            } else if (path.startsWith("/billing/save/")) {
                int appointmentId = Integer.parseInt(path.substring("/billing/save/".length()));
                saveBill(req, resp, appointmentId);
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

    private void showBillingSearch(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        String appointmentNo = req.getParameter("appointmentNo");
        if (appointmentNo != null && !appointmentNo.isBlank()) {
            Appointment appointment = appointmentDAO.findByAppointmentNo(appointmentNo.trim());
            if (appointment != null) {
                req.setAttribute("appointment", appointment);
                req.setAttribute("bill", billDAO.findByAppointmentId(appointment.getId()));
            } else {
                req.setAttribute("error", "Appointment not found");
            }
            req.setAttribute("appointmentNo", appointmentNo.trim());
        }
        req.setAttribute("pageTitle", "Billing");
        req.setAttribute("activeMenu", "billing");
        req.getRequestDispatcher("/billing/search.jsp").forward(req, resp);
    }

    private void searchForBilling(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        String appointmentNo = req.getParameter("appointmentNo");
        Appointment appointment = appointmentDAO.findByAppointmentNo(appointmentNo);
        if (appointment == null) {
            req.setAttribute("error", "Appointment not found");
        } else {
            req.setAttribute("appointment", appointment);
            req.setAttribute("bill", billDAO.findByAppointmentId(appointment.getId()));
        }
        req.setAttribute("appointmentNo", appointmentNo);
        req.setAttribute("pageTitle", "Billing");
        req.setAttribute("activeMenu", "billing");
        req.getRequestDispatcher("/billing/search.jsp").forward(req, resp);
    }

    private void showGenerateForm(HttpServletRequest req, HttpServletResponse resp, int appointmentId)
            throws SQLException, ServletException, IOException {
        Appointment appointment = appointmentDAO.findById(appointmentId);
        Bill existingBill = billDAO.findByAppointmentId(appointmentId);
        req.setAttribute("appointment", appointment);
        req.setAttribute("bill", existingBill);
        req.setAttribute("nextBillNo", billDAO.generateNextBillNo());
        req.setAttribute("pageTitle", "Generate Bill");
        req.setAttribute("activeMenu", "billing");
        req.getRequestDispatcher("/billing/generate.jsp").forward(req, resp);
    }

    private void saveBill(HttpServletRequest req, HttpServletResponse resp, int appointmentId)
            throws SQLException, IOException {
        BigDecimal treatment = new BigDecimal(req.getParameter("treatmentAmount"));
        BigDecimal consultation = new BigDecimal(req.getParameter("consultationFee"));
        BigDecimal other = new BigDecimal(req.getParameter("otherCharges"));
        BigDecimal total = treatment.add(consultation).add(other);

        Bill existing = billDAO.findByAppointmentId(appointmentId);
        if (existing == null) {
            Bill bill = new Bill();
            bill.setBillNo(billDAO.generateNextBillNo());
            bill.setAppointmentId(appointmentId);
            bill.setTreatmentAmount(treatment);
            bill.setConsultationFee(consultation);
            bill.setOtherCharges(other);
            bill.setTotalAmount(total);
            billDAO.insert(bill);
        }

        Appointment appointment = appointmentDAO.findById(appointmentId);
        appointment.setStatus("Completed");
        appointmentDAO.update(appointment);

        resp.sendRedirect(req.getContextPath() + "/billing/receipt/" + appointmentId);
    }

    private void showReceipt(HttpServletRequest req, HttpServletResponse resp, int appointmentId)
            throws SQLException, ServletException, IOException {
        Bill bill = billDAO.findByAppointmentId(appointmentId);
        Appointment appointment = appointmentDAO.findById(appointmentId);
        req.setAttribute("bill", bill);
        req.setAttribute("appointment", appointment);
        req.setAttribute("pageTitle", "Bill Receipt");
        req.setAttribute("activeMenu", "billing");
        req.getRequestDispatcher("/billing/receipt.jsp").forward(req, resp);
    }
}
