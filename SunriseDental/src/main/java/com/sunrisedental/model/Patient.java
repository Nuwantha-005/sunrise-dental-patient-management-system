package com.sunrisedental.model;

public class Patient {
    private int id;
    private String patientCode;
    private String name;
    private String contact;
    private String email;
    private String address;

    public Patient() {
    }

    public Patient(int id, String patientCode, String name, String contact, String email, String address) {
        this.id = id;
        this.patientCode = patientCode != null && !patientCode.isBlank() ? patientCode : (id > 0 ? String.format("PAT-%03d", id) : null);
        this.name = name;
        this.contact = contact;
        this.email = email;
        this.address = address;
    }

    public Patient(int id, String name, String contact, String email, String address) {
        this(id, id > 0 ? String.format("PAT-%03d", id) : null, name, contact, email, address);
    }

    public Patient(int id, String name, String contact, String address) {
        this(id, id > 0 ? String.format("PAT-%03d", id) : null, name, contact, null, address);
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientCode() {
        if (patientCode != null && !patientCode.isBlank()) {
            return patientCode;
        }
        return id > 0 ? String.format("PAT-%03d", id) : "PAT-NEW";
    }
    public void setPatientCode(String patientCode) { this.patientCode = patientCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}

