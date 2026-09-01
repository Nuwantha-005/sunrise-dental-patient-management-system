package com.sunrisedental.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Treatment;
import com.sunrisedental.util.DBConnection;

public class TreatmentDAO {

    private static final String BASE_SELECT =
            "SELECT t.id, t.dentist_id, t.treatment_name, t.price, t.description, t.created_at, "
            + "d.name AS dentist_name, d.dentist_code "
            + "FROM treatments t "
            + "JOIN dentists d ON t.dentist_id = d.id ";

    public List<Treatment> findAll() throws SQLException {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT t.id, t.dentist_id, t.treatment_name, t.price, t.available_days, t.description, t.created_at, "
                + "d.name AS dentist_name, d.dentist_code "
                + "FROM treatments t JOIN dentists d ON t.dentist_id = d.id "
                + "ORDER BY d.name ASC, t.treatment_name ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapTreatment(rs, true));
            }
        } catch (SQLException e) {
            // Fallback for DB schemas before available_days column migration
            try (Connection conn = DBConnection.getConnection();
                 Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(BASE_SELECT + "ORDER BY d.name ASC, t.treatment_name ASC")) {
                while (rs.next()) {
                    list.add(mapTreatment(rs, false));
                }
            } catch (SQLException ignored) {}
        }
        return list;
    }

    public List<Treatment> findByDentistId(int dentistId) throws SQLException {
        List<Treatment> list = new ArrayList<>();
        String sql = "SELECT t.id, t.dentist_id, t.treatment_name, t.price, t.available_days, t.description, t.created_at, "
                + "d.name AS dentist_name, d.dentist_code "
                + "FROM treatments t JOIN dentists d ON t.dentist_id = d.id "
                + "WHERE t.dentist_id = ? ORDER BY t.treatment_name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dentistId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTreatment(rs, true));
                }
            }
        } catch (SQLException e) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(BASE_SELECT + "WHERE t.dentist_id = ? ORDER BY t.treatment_name ASC")) {
                ps.setInt(1, dentistId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        list.add(mapTreatment(rs, false));
                    }
                }
            } catch (SQLException ignored) {}
        }
        return list;
    }

    public Treatment findById(int id) throws SQLException {
        String sql = "SELECT t.id, t.dentist_id, t.treatment_name, t.price, t.available_days, t.description, t.created_at, "
                + "d.name AS dentist_name, d.dentist_code "
                + "FROM treatments t JOIN dentists d ON t.dentist_id = d.id "
                + "WHERE t.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTreatment(rs, true);
                }
            }
        } catch (SQLException e) {
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(BASE_SELECT + "WHERE t.id = ?")) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return mapTreatment(rs, false);
                    }
                }
            } catch (SQLException ignored) {}
        }
        return null;
    }

    public BigDecimal findPriceByDentistAndName(int dentistId, String treatmentName) throws SQLException {
        String sql = "SELECT price FROM treatments WHERE dentist_id = ? AND LOWER(TRIM(treatment_name)) = LOWER(TRIM(?))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dentistId);
            ps.setString(2, treatmentName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("price");
                }
            }
        } catch (SQLException ignored) {}

        // Fallback search by treatment name across any doctor
        String fallbackSql = "SELECT price FROM treatments WHERE LOWER(TRIM(treatment_name)) = LOWER(TRIM(?)) LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
            ps.setString(1, treatmentName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("price");
                }
            }
        } catch (SQLException ignored) {}

        return null;
    }

    public int insert(Treatment treatment) throws SQLException {
        ensureAvailableDaysColumnExists();
        String sql = "INSERT INTO treatments (dentist_id, treatment_name, price, available_days, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, treatment.getDentistId());
            ps.setString(2, treatment.getTreatmentName().trim());
            ps.setBigDecimal(3, treatment.getPrice());
            ps.setString(4, treatment.getAvailableDays());
            ps.setString(5, treatment.getDescription() != null ? treatment.getDescription().trim() : null);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            // Fallback for legacy schema
            String fallbackSql = "INSERT INTO treatments (dentist_id, treatment_name, price, description) VALUES (?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, treatment.getDentistId());
                ps.setString(2, treatment.getTreatmentName().trim());
                ps.setBigDecimal(3, treatment.getPrice());
                ps.setString(4, treatment.getDescription() != null ? treatment.getDescription().trim() : null);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    public boolean update(Treatment treatment) throws SQLException {
        ensureAvailableDaysColumnExists();
        String sql = "UPDATE treatments SET dentist_id = ?, treatment_name = ?, price = ?, available_days = ?, description = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, treatment.getDentistId());
            ps.setString(2, treatment.getTreatmentName().trim());
            ps.setBigDecimal(3, treatment.getPrice());
            ps.setString(4, treatment.getAvailableDays());
            ps.setString(5, treatment.getDescription() != null ? treatment.getDescription().trim() : null);
            ps.setInt(6, treatment.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            String fallbackSql = "UPDATE treatments SET dentist_id = ?, treatment_name = ?, price = ?, description = ? WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(fallbackSql)) {
                ps.setInt(1, treatment.getDentistId());
                ps.setString(2, treatment.getTreatmentName().trim());
                ps.setBigDecimal(3, treatment.getPrice());
                ps.setString(4, treatment.getDescription() != null ? treatment.getDescription().trim() : null);
                ps.setInt(5, treatment.getId());
                return ps.executeUpdate() > 0;
            }
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM treatments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private void ensureAvailableDaysColumnExists() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate("ALTER TABLE treatments ADD COLUMN available_days VARCHAR(255) DEFAULT 'Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday'");
        } catch (SQLException ignored) {}
    }

    private Treatment mapTreatment(ResultSet rs, boolean hasAvailableDays) throws SQLException {
        Treatment t = new Treatment();
        t.setId(rs.getInt("id"));
        t.setDentistId(rs.getInt("dentist_id"));
        t.setTreatmentName(rs.getString("treatment_name"));
        t.setPrice(rs.getBigDecimal("price"));
        if (hasAvailableDays) {
            try {
                String days = rs.getString("available_days");
                if (days != null && !days.isBlank()) {
                    t.setAvailableDays(days);
                }
            } catch (SQLException ignored) {}
        }
        t.setDescription(rs.getString("description"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setDentistName(rs.getString("dentist_name"));
        t.setDentistCode(rs.getString("dentist_code"));
        return t;
    }
}
