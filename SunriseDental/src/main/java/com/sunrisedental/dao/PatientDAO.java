package com.sunrisedental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Patient;
import com.sunrisedental.util.DBConnection;

public class PatientDAO {

    public PatientDAO() {
        ensureSchema();
    }

    private void ensureSchema() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            try { st.execute("ALTER TABLE patients ADD COLUMN patient_code VARCHAR(20) NULL"); } catch (SQLException ignored) {}
            try { st.execute("UPDATE patients SET patient_code = CONCAT('PAT-', LPAD(id, 3, '0')) WHERE patient_code IS NULL OR patient_code = ''"); } catch (SQLException ignored) {}
        } catch (SQLException ignored) {}
    }

    public List<Patient> findAll() throws SQLException {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT id, patient_code, name, contact, email, address FROM patients ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                patients.add(mapPatient(rs));
            }
        }
        return patients;
    }

    public List<Patient> search(String keyword) throws SQLException {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT id, patient_code, name, contact, email, address FROM patients "
                + "WHERE patient_code LIKE ? OR name LIKE ? OR contact LIKE ? OR email LIKE ? ORDER BY id";
        String pattern = "%" + keyword + "%";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    patients.add(mapPatient(rs));
                }
            }
        }
        return patients;
    }

    public Patient findById(int id) throws SQLException {
        String sql = "SELECT id, patient_code, name, contact, email, address FROM patients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPatient(rs);
                }
            }
        }
        return null;
    }

    public Patient findByPatientCode(String code) throws SQLException {
        if (code == null || code.isBlank()) return null;
        String sql = "SELECT id, patient_code, name, contact, email, address FROM patients WHERE UPPER(patient_code) = UPPER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPatient(rs);
                }
            }
        }
        return null;
    }

    public int insert(Patient patient) throws SQLException {
        ensureSchema();
        String sql = "INSERT INTO patients (name, contact, email, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, patient.getName());
            ps.setString(2, patient.getContact());
            ps.setString(3, patient.getEmail());
            ps.setString(4, patient.getAddress());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int generatedId = keys.getInt(1);
                    String generatedCode = String.format("PAT-%03d", generatedId);
                    // Save auto-generated code
                    try (PreparedStatement updatePs = conn.prepareStatement("UPDATE patients SET patient_code = ? WHERE id = ?")) {
                        updatePs.setString(1, generatedCode);
                        updatePs.setInt(2, generatedId);
                        updatePs.executeUpdate();
                    }
                    patient.setId(generatedId);
                    patient.setPatientCode(generatedCode);
                    return generatedId;
                }
            }
        }
        return -1;
    }

    public boolean update(Patient patient) throws SQLException {
        String sql = "UPDATE patients SET name = ?, contact = ?, email = ?, address = ?, patient_code = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patient.getName());
            ps.setString(2, patient.getContact());
            ps.setString(3, patient.getEmail());
            ps.setString(4, patient.getAddress());
            ps.setString(5, patient.getPatientCode());
            ps.setInt(6, patient.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM patients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM patients";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private Patient mapPatient(ResultSet rs) throws SQLException {
        String code = null;
        try { code = rs.getString("patient_code"); } catch (SQLException ignored) {}
        int id = rs.getInt("id");
        if (code == null || code.isBlank()) {
            code = String.format("PAT-%03d", id);
        }
        String email = null;
        try { email = rs.getString("email"); } catch (SQLException ignored) {}
        return new Patient(
                id,
                code,
                rs.getString("name"),
                rs.getString("contact"),
                email,
                rs.getString("address"));
    }
}

