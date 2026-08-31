package com.sunrisedental.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.util.DBConnection;

public class AppointmentDAO {

    private static final String BASE_SELECT =
            "SELECT a.id, a.appointment_no, a.patient_id, a.dentist_id, a.treatment_type, "
            + "a.appointment_date, a.appointment_time, a.status, "
            + "p.name AS patient_name, p.contact AS patient_contact, p.email AS patient_email, p.address AS patient_address, "
            + "d.name AS dentist_name "
            + "FROM appointments a "
            + "JOIN patients p ON a.patient_id = p.id "
            + "JOIN dentists d ON a.dentist_id = d.id ";

    public List<Appointment> findTodayAppointments() throws SQLException {
        Date today = new Date(System.currentTimeMillis());
        String sql = BASE_SELECT + "WHERE a.appointment_date = ? OR a.appointment_date = CURDATE() ORDER BY a.appointment_time ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, today);
            try (ResultSet rs = ps.executeQuery()) {
                List<Appointment> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapAppointment(rs));
                }
                return list;
            }
        }
    }

    public List<Appointment> findActiveAppointments() throws SQLException {
        String sql = BASE_SELECT + "WHERE a.status IN ('Pending', 'Confirmed') ORDER BY a.appointment_date ASC, a.appointment_time ASC";
        return queryList(sql);
    }

    public List<Appointment> findRecentAppointments(int limit) throws SQLException {
        String sql = BASE_SELECT + "ORDER BY a.id DESC LIMIT " + limit;
        return queryList(sql);
    }

    public List<Appointment> findAll() throws SQLException {
        String sql = BASE_SELECT + "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        return queryList(sql);
    }

    public List<Appointment> findHistory(String keyword, String status, String dentistId) throws SQLException {
        StringBuilder sb = new StringBuilder(BASE_SELECT);
        sb.append("WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isBlank() && !"ALL".equalsIgnoreCase(status)) {
            sb.append("AND a.status = ? ");
            params.add(status);
        }

        if (dentistId != null && !dentistId.isBlank() && !"0".equals(dentistId)) {
            try {
                int dId = Integer.parseInt(dentistId);
                sb.append("AND a.dentist_id = ? ");
                params.add(dId);
            } catch (NumberFormatException ignored) {}
        }

        if (keyword != null && !keyword.isBlank()) {
            sb.append("AND (a.appointment_no LIKE ? OR p.name LIKE ? OR p.contact LIKE ? OR p.email LIKE ? OR a.treatment_type LIKE ?) ");
            String pat = "%" + keyword.trim() + "%";
            params.add(pat);
            params.add(pat);
            params.add(pat);
            params.add(pat);
            params.add(pat);
        }

        sb.append("ORDER BY a.appointment_date DESC, a.appointment_time DESC");

        List<Appointment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) {
                    ps.setString(i + 1, (String) p);
                } else if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAppointment(rs));
                }
            }
        }
        return list;
    }

    public Appointment findByAppointmentNo(String appointmentNo) throws SQLException {
        String sql = BASE_SELECT + "WHERE a.appointment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, appointmentNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAppointment(rs);
                }
            }
        }
        return null;
    }

    public Appointment findById(int id) throws SQLException {
        String sql = BASE_SELECT + "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAppointment(rs);
                }
            }
        }
        return null;
    }

    public int insert(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO appointments (appointment_no, patient_id, dentist_id, "
                + "treatment_type, appointment_date, appointment_time, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, appointment.getAppointmentNo());
            ps.setInt(2, appointment.getPatientId());
            ps.setInt(3, appointment.getDentistId());
            ps.setString(4, appointment.getTreatmentType());
            ps.setDate(5, appointment.getAppointmentDate());
            ps.setTime(6, appointment.getAppointmentTime());
            ps.setString(7, appointment.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean update(Appointment appointment) throws SQLException {
        String sql = "UPDATE appointments SET patient_id = ?, dentist_id = ?, treatment_type = ?, "
                + "appointment_date = ?, appointment_time = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDentistId());
            ps.setString(3, appointment.getTreatmentType());
            ps.setDate(4, appointment.getAppointmentDate());
            ps.setTime(5, appointment.getAppointmentTime());
            ps.setString(6, appointment.getStatus());
            ps.setInt(7, appointment.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Safely delete any linked bill if bills table exists
                try (PreparedStatement ps = conn.prepareStatement("DELETE FROM bills WHERE appointment_id = ?")) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                } catch (SQLException ignored) {
                    // Ignore if bills table is absent or not linked
                }

                // Delete the appointment
                String deleteAppSql = "DELETE FROM appointments WHERE id = ?";
                boolean success;
                try (PreparedStatement ps = conn.prepareStatement(deleteAppSql)) {
                    ps.setInt(1, id);
                    success = ps.executeUpdate() > 0;
                }

                conn.commit();
                return success;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public int countAll() throws SQLException {
        return countByCondition("");
    }

    public int countToday() throws SQLException {
        Date today = new Date(System.currentTimeMillis());
        String sql = "SELECT COUNT(*) FROM appointments WHERE appointment_date = ? OR appointment_date = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, today);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countByDate(Date date) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointments WHERE appointment_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int countByDateAndStatus(Date date, String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointments WHERE appointment_date = ? AND status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public String generateNextAppointmentNo() throws SQLException {
        String sql = "SELECT appointment_no FROM appointments ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                String last = rs.getString("appointment_no");
                int num = Integer.parseInt(last.replace("APT-", ""));
                return String.format("APT-%03d", num + 1);
            }
        }
        return "APT-001";
    }

    public boolean isSlotTaken(int dentistId, Date appointmentDate, Time appointmentTime, int excludeAppointmentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointments "
                   + "WHERE dentist_id = ? AND appointment_date = ? AND appointment_time = ? "
                   + "AND status != 'Cancelled' AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dentistId);
            ps.setDate(2, appointmentDate);
            ps.setTime(3, appointmentTime);
            ps.setInt(4, excludeAppointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public Appointment findConflictingAppointment(int dentistId, Date appointmentDate, Time appointmentTime, int excludeAppointmentId) throws SQLException {
        String sql = BASE_SELECT
                   + "WHERE a.dentist_id = ? AND a.appointment_date = ? AND a.appointment_time = ? "
                   + "AND a.status != 'Cancelled' AND a.id != ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dentistId);
            ps.setDate(2, appointmentDate);
            ps.setTime(3, appointmentTime);
            ps.setInt(4, excludeAppointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAppointment(rs);
                }
            }
        }
        return null;
    }

    private int countByCondition(String condition) throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointments " + condition;
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private List<Appointment> queryList(String sql) throws SQLException {
        List<Appointment> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapAppointment(rs));
            }
        }
        return list;
    }

    private Appointment mapAppointment(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setId(rs.getInt("id"));
        a.setAppointmentNo(rs.getString("appointment_no"));
        a.setPatientId(rs.getInt("patient_id"));
        a.setDentistId(rs.getInt("dentist_id"));
        a.setTreatmentType(rs.getString("treatment_type"));
        a.setAppointmentDate(rs.getDate("appointment_date"));
        a.setAppointmentTime(rs.getTime("appointment_time"));
        a.setStatus(rs.getString("status"));
        a.setPatientName(rs.getString("patient_name"));
        a.setPatientContact(rs.getString("patient_contact"));
        try {
            a.setPatientEmail(rs.getString("patient_email"));
        } catch (SQLException ignored) {
        }
        a.setPatientAddress(rs.getString("patient_address"));
        a.setDentistName(rs.getString("dentist_name"));
        return a;
    }
}
