package com.sunrisedental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Dentist;
import com.sunrisedental.util.DBConnection;

public class DentistDAO {

    public List<Dentist> findAll() throws SQLException {
        List<Dentist> dentists = new ArrayList<>();
        String sql = "SELECT id, name, specialization, contact FROM dentists ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                dentists.add(mapDentist(rs));
            }
        }
        return dentists;
    }

    public Dentist findById(int id) throws SQLException {
        String sql = "SELECT id, name, specialization, contact FROM dentists WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapDentist(rs);
                }
            }
        }
        return null;
    }

    public int insert(Dentist dentist) throws SQLException {
        String sql = "INSERT INTO dentists (name, specialization, contact) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, dentist.getName());
            ps.setString(2, dentist.getSpecialization());
            ps.setString(3, dentist.getContact());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean update(Dentist dentist) throws SQLException {
        String sql = "UPDATE dentists SET name = ?, specialization = ?, contact = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dentist.getName());
            ps.setString(2, dentist.getSpecialization());
            ps.setString(3, dentist.getContact());
            ps.setInt(4, dentist.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM dentists WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Dentist mapDentist(ResultSet rs) throws SQLException {
        return new Dentist(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("specialization"),
                rs.getString("contact"));
    }
}
