package com.sunrisedental.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String contact;
    private String role = "ADMIN"; // "ADMIN" or "RECEPTIONIST"

    public User() {
    }

    public User(int id, String username, String fullName, String email, String contact) {
        this.id = id;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.contact = contact;
        this.role = "ADMIN";
    }

    public User(int id, String username, String fullName, String email, String contact, String role) {
        this.id = id;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.contact = contact;
        this.role = role != null ? role : "ADMIN";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getRole() { return role != null ? role : "ADMIN"; }
    public void setRole(String role) { this.role = role; }

    public boolean isAdmin() {
        return role == null || "ADMIN".equalsIgnoreCase(role.trim());
    }

    public boolean isReceptionist() {
        return "RECEPTIONIST".equalsIgnoreCase(role != null ? role.trim() : "");
    }
}
