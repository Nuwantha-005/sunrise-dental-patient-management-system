package com.sunrisedental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.User;
import com.sunrisedental.util.DBConnection;
import com.sunrisedental.util.PasswordUtil;

public class UserDAO {

    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, password, full_name, email, contact, role FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = mapUser(rs);
                    user.setPassword(rs.getString("password"));
                    return user;
                }
            }
        }
        return null;
    }

    public User findById(int id) throws SQLException {
        String sql = "SELECT id, username, full_name, email, contact, role FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        }
        return null;
    }

    public List<User> findAllReceptionists() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, username, full_name, email, contact, role FROM users WHERE role = 'RECEPTIONIST' ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        }
        return list;
    }

    public List<User> findAllStaff() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, username, full_name, email, contact, role FROM users ORDER BY id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        }
        return list;
    }

    public int insertStaff(User user, String rawPassword) throws SQLException {
        String sql = "INSERT INTO users (username, password, full_name, email, contact, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername().trim());
            ps.setString(2, PasswordUtil.hash(rawPassword));
            ps.setString(3, user.getFullName().trim());
            ps.setString(4, user.getEmail() != null ? user.getEmail().trim() : null);
            ps.setString(5, user.getContact() != null ? user.getContact().trim() : null);
            ps.setString(6, user.getRole() != null ? user.getRole() : "RECEPTIONIST");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updateStaff(User user, String newRawPassword) throws SQLException {
        boolean updatePwd = (newRawPassword != null && !newRawPassword.isBlank());
        String sql;
        if (updatePwd) {
            sql = "UPDATE users SET full_name = ?, email = ?, contact = ?, role = ?, password = ? WHERE id = ? AND role != 'ADMIN'";
        } else {
            sql = "UPDATE users SET full_name = ?, email = ?, contact = ?, role = ? WHERE id = ? AND role != 'ADMIN'";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getContact());
            ps.setString(4, user.getRole() != null ? user.getRole() : "RECEPTIONIST");
            if (updatePwd) {
                ps.setString(5, PasswordUtil.hash(newRawPassword));
                ps.setInt(6, user.getId());
            } else {
                ps.setInt(5, user.getId());
            }
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteStaff(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ? AND role = 'RECEPTIONIST'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean isUsernameTaken(String username, int excludeUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ? AND id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username.trim());
            ps.setInt(2, excludeUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean updateProfile(User user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, email = ?, contact = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getContact());
            ps.setInt(4, user.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public String getPasswordHash(int userId) throws SQLException {
        String sql = "SELECT password FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password");
                }
            }
        }
        return null;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setContact(rs.getString("contact"));
        try {
            String role = rs.getString("role");
            user.setRole(role != null && !role.isBlank() ? role : "ADMIN");
        } catch (SQLException ignored) {
            user.setRole("ADMIN");
        }
        return user;
    }
}
