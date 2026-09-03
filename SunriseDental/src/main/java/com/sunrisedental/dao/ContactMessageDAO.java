package com.sunrisedental.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.ContactMessage;
import com.sunrisedental.util.DBConnection;

public class ContactMessageDAO {

    /** Save a new contact form submission */
    public void save(ContactMessage msg) throws SQLException {
        String sql = "INSERT INTO contact_messages "
                   + "(first_name, last_name, email, phone, subject, message) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, msg.getFirstName());
            ps.setString(2, msg.getLastName());
            ps.setString(3, msg.getEmail());
            ps.setString(4, msg.getPhone());
            ps.setString(5, msg.getSubject());
            ps.setString(6, msg.getMessage());
            ps.executeUpdate();
        }
    }

    /** Fetch recent messages for dashboard (most recent first) */
    public List<ContactMessage> findRecent(int limit) throws SQLException {
        String sql = "SELECT * FROM contact_messages ORDER BY created_at DESC LIMIT ?";
        List<ContactMessage> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /** Count unread messages (for badge indicator) */
    public int countUnread() throws SQLException {
        String sql = "SELECT COUNT(*) FROM contact_messages WHERE is_read = 0";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Mark a message as read */
    public void markRead(int id) throws SQLException {
        String sql = "UPDATE contact_messages SET is_read = 1 WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    /** Mark all messages as read */
    public void markAllRead() throws SQLException {
        String sql = "UPDATE contact_messages SET is_read = 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.executeUpdate();
        }
    }

    /** Delete a contact message by ID */
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM contact_messages WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private ContactMessage map(ResultSet rs) throws SQLException {
        ContactMessage m = new ContactMessage();
        m.setId(rs.getInt("id"));
        m.setFirstName(rs.getString("first_name"));
        m.setLastName(rs.getString("last_name"));
        m.setEmail(rs.getString("email"));
        m.setPhone(rs.getString("phone"));
        m.setSubject(rs.getString("subject"));
        m.setMessage(rs.getString("message"));
        m.setRead(rs.getBoolean("is_read"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        return m;
    }
}
