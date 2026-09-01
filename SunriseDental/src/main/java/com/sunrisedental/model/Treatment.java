package com.sunrisedental.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Treatment {
    private int id;
    private int dentistId;
    private String dentistName;
    private String dentistCode;
    private String treatmentName;
    private BigDecimal price;
    private String availableDays = "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday";
    private String description;
    private Timestamp createdAt;

    public Treatment() {
    }

    public Treatment(int id, int dentistId, String treatmentName, BigDecimal price, String availableDays, String description) {
        this.id = id;
        this.dentistId = dentistId;
        this.treatmentName = treatmentName;
        this.price = price;
        this.availableDays = (availableDays != null && !availableDays.isBlank()) ? availableDays : "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday";
        this.description = description;
    }

    public Treatment(int id, int dentistId, String dentistName, String dentistCode, String treatmentName, BigDecimal price, String availableDays, String description) {
        this.id = id;
        this.dentistId = dentistId;
        this.dentistName = dentistName;
        this.dentistCode = dentistCode;
        this.treatmentName = treatmentName;
        this.price = price;
        this.availableDays = (availableDays != null && !availableDays.isBlank()) ? availableDays : "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday";
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDentistId() { return dentistId; }
    public void setDentistId(int dentistId) { this.dentistId = dentistId; }

    public String getDentistName() { return dentistName; }
    public void setDentistName(String dentistName) { this.dentistName = dentistName; }

    public String getDentistCode() { return dentistCode; }
    public void setDentistCode(String dentistCode) { this.dentistCode = dentistCode; }

    public String getTreatmentName() { return treatmentName; }
    public void setTreatmentName(String treatmentName) { this.treatmentName = treatmentName; }

    public BigDecimal getPrice() { return price != null ? price : BigDecimal.ZERO; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getAvailableDays() {
        return (availableDays != null && !availableDays.isBlank()) ? availableDays : "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday";
    }
    public void setAvailableDays(String availableDays) { this.availableDays = availableDays; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
