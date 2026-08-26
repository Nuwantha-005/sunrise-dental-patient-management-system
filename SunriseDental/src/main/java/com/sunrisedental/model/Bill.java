package com.sunrisedental.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Bill {
    private int id;
    private String billNo;
    private int appointmentId;
    private String appointmentNo;
    private String patientName;
    private String dentistName;
    private String treatmentType;
    private BigDecimal treatmentAmount;
    private BigDecimal consultationFee;
    private BigDecimal otherCharges;
    private BigDecimal totalAmount;
    private Timestamp createdAt;

    public Bill() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getBillNo() { return billNo; }
    public void setBillNo(String billNo) { this.billNo = billNo; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public String getAppointmentNo() { return appointmentNo; }
    public void setAppointmentNo(String appointmentNo) { this.appointmentNo = appointmentNo; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getDentistName() { return dentistName; }
    public void setDentistName(String dentistName) { this.dentistName = dentistName; }

    public String getTreatmentType() { return treatmentType; }
    public void setTreatmentType(String treatmentType) { this.treatmentType = treatmentType; }

    public BigDecimal getTreatmentAmount() { return treatmentAmount; }
    public void setTreatmentAmount(BigDecimal treatmentAmount) { this.treatmentAmount = treatmentAmount; }

    public BigDecimal getConsultationFee() { return consultationFee; }
    public void setConsultationFee(BigDecimal consultationFee) { this.consultationFee = consultationFee; }

    public BigDecimal getOtherCharges() { return otherCharges; }
    public void setOtherCharges(BigDecimal otherCharges) { this.otherCharges = otherCharges; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
