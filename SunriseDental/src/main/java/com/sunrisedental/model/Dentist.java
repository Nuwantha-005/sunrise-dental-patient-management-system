package com.sunrisedental.model;

public class Dentist {
    private int id;
    private String dentistCode;
    private String name;
    private String specialization;
    private String contact;

    public Dentist() {
    }

    public Dentist(int id, String name, String specialization, String contact) {
        this.id = id;
        this.dentistCode = String.format("DOC-%03d", id);
        this.name = name;
        this.specialization = specialization;
        this.contact = contact;
    }

    public Dentist(int id, String dentistCode, String name, String specialization, String contact) {
        this.id = id;
        this.dentistCode = (dentistCode != null && !dentistCode.isBlank()) 
                           ? dentistCode : String.format("DOC-%03d", id);
        this.name = name;
        this.specialization = specialization;
        this.contact = contact;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getDentistCode() {
        if (dentistCode == null || dentistCode.isBlank()) {
            return id > 0 ? String.format("DOC-%03d", id) : "DOC-NEW";
        }
        return dentistCode;
    }
    public void setDentistCode(String dentistCode) { this.dentistCode = dentistCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
}
