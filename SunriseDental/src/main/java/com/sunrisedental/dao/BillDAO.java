package com.sunrisedental.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Bill;
import com.sunrisedental.util.DBConnection;

public class BillDAO {

    public List<Bill> findAll(String keyword) throws SQLException {
        String base = "SELECT b.id, b.bill_no, b.appointment_id, b.treatment_amount, b.consultation_fee, "
                + "b.other_charges, b.total_amount, b.created_at, "
                + "a.appointment_no, p.name AS patient_name, d.name AS dentist_name, a.treatment_type "
                + "FROM bills b "
                + "JOIN appointments a ON b.appointment_id = a.id "
                + "JOIN patients p ON a.patient_id = p.id "
                + "JOIN dentists d ON a.dentist_id = d.id ";
        String where = "";
        if (keyword != null && !keyword.isBlank()) {
            where = "WHERE b.bill_no LIKE ? OR p.name LIKE ? OR a.appointment_no LIKE ? OR d.name LIKE ? ";
        }
        String sql = base + where + "ORDER BY b.id DESC";

        List<Bill> bills = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.isBlank()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
                ps.setString(3, kw);
                ps.setString(4, kw);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bills.add(mapBill(rs));
                }
            }
        }
        return bills;
    }


    public Bill findByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT b.id, b.bill_no, b.appointment_id, b.treatment_amount, b.consultation_fee, "
                + "b.other_charges, b.total_amount, b.created_at, "
                + "a.appointment_no, p.name AS patient_name, d.name AS dentist_name, a.treatment_type "
                + "FROM bills b "
                + "JOIN appointments a ON b.appointment_id = a.id "
                + "JOIN patients p ON a.patient_id = p.id "
                + "JOIN dentists d ON a.dentist_id = d.id "
                + "WHERE b.appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBill(rs);
                }
            }
        }
        return null;
    }

    public Bill findByBillNo(String billNo) throws SQLException {
        String sql = "SELECT b.id, b.bill_no, b.appointment_id, b.treatment_amount, b.consultation_fee, "
                + "b.other_charges, b.total_amount, b.created_at, "
                + "a.appointment_no, p.name AS patient_name, d.name AS dentist_name, a.treatment_type "
                + "FROM bills b "
                + "JOIN appointments a ON b.appointment_id = a.id "
                + "JOIN patients p ON a.patient_id = p.id "
                + "JOIN dentists d ON a.dentist_id = d.id "
                + "WHERE b.bill_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, billNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBill(rs);
                }
            }
        }
        return null;
    }

    public int insert(Bill bill) throws SQLException {
        String sql = "INSERT INTO bills (bill_no, appointment_id, treatment_amount, consultation_fee, "
                + "other_charges, total_amount) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, bill.getBillNo());
            ps.setInt(2, bill.getAppointmentId());
            ps.setBigDecimal(3, bill.getTreatmentAmount());
            ps.setBigDecimal(4, bill.getConsultationFee());
            ps.setBigDecimal(5, bill.getOtherCharges());
            ps.setBigDecimal(6, bill.getTotalAmount());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    public BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM bills";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    public String generateNextBillNo() throws SQLException {
        String sql = "SELECT bill_no FROM bills ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                String last = rs.getString("bill_no");
                int num = Integer.parseInt(last.replace("BILL-", ""));
                return String.format("BILL-%03d", num + 1);
            }
        }
        return "BILL-001";
    }

    private Bill mapBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setId(rs.getInt("id"));
        bill.setBillNo(rs.getString("bill_no"));
        bill.setAppointmentId(rs.getInt("appointment_id"));
        bill.setTreatmentAmount(rs.getBigDecimal("treatment_amount"));
        bill.setConsultationFee(rs.getBigDecimal("consultation_fee"));
        bill.setOtherCharges(rs.getBigDecimal("other_charges"));
        bill.setTotalAmount(rs.getBigDecimal("total_amount"));
        bill.setCreatedAt(rs.getTimestamp("created_at"));
        bill.setAppointmentNo(rs.getString("appointment_no"));
        bill.setPatientName(rs.getString("patient_name"));
        bill.setDentistName(rs.getString("dentist_name"));
        bill.setTreatmentType(rs.getString("treatment_type"));
        return bill;
    }
}
