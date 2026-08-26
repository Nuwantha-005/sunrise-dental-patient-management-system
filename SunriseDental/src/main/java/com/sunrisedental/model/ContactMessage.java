package com.sunrisedental.model;

import java.sql.Timestamp;

public class ContactMessage {

    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String subject;
    private String message;
    private boolean read;
    private Timestamp createdAt;

    public ContactMessage() {}

    // ── Getters ────────────────────────────────────────────────
    public int getId()            { return id; }
    public String getFirstName()  { return firstName; }
    public String getLastName()   { return lastName; }
    public String getEmail()      { return email; }
    public String getPhone()      { return phone; }
    public String getSubject()    { return subject; }
    public String getMessage()    { return message; }
    public boolean isRead()       { return read; }
    public Timestamp getCreatedAt(){ return createdAt; }

    /** Convenience: full sender name */
    public String getFullName()   { return firstName + " " + lastName; }

    // ── Setters ────────────────────────────────────────────────
    public void setId(int id)                   { this.id = id; }
    public void setFirstName(String firstName)  { this.firstName = firstName; }
    public void setLastName(String lastName)    { this.lastName = lastName; }
    public void setEmail(String email)          { this.email = email; }
    public void setPhone(String phone)          { this.phone = phone; }
    public void setSubject(String subject)      { this.subject = subject; }
    public void setMessage(String message)      { this.message = message; }
    public void setRead(boolean read)           { this.read = read; }
    public void setCreatedAt(Timestamp createdAt){ this.createdAt = createdAt; }
}
