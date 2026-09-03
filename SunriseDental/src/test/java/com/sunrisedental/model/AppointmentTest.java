package com.sunrisedental.model;

import java.sql.Date;
import java.sql.Time;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@DisplayName("Appointment Model Tests")
public class AppointmentTest {

    @Test
    @DisplayName("Should initialize properly and support getters and setters for all appointment properties")
    void testGettersAndSetters() {
        Appointment appt = new Appointment();
        Date testDate = Date.valueOf("2026-09-15");
        Time testTime = Time.valueOf("10:30:00");

        appt.setId(101);
        appt.setAppointmentNo("APT-101");
        appt.setPatientId(5);
        appt.setDentistId(2);
        appt.setPatientName("Nuwantha Perera");
        appt.setPatientContact("0779876543");
        appt.setPatientEmail("nuwantha@example.com");
        appt.setPatientAddress("Colombo 07");
        appt.setDentistName("Dr. Kamal Silva");
        appt.setTreatmentType("Root Canal Therapy");
        appt.setAppointmentDate(testDate);
        appt.setAppointmentTime(testTime);
        appt.setStatus("Confirmed");
        appt.setPatientUsername("APT-101");
        appt.setPatientPasswordHash("hashedSecret123");

        assertEquals(101, appt.getId());
        assertEquals("APT-101", appt.getAppointmentNo());
        assertEquals(5, appt.getPatientId());
        assertEquals(2, appt.getDentistId());
        assertEquals("Nuwantha Perera", appt.getPatientName());
        assertEquals("0779876543", appt.getPatientContact());
        assertEquals("nuwantha@example.com", appt.getPatientEmail());
        assertEquals("Colombo 07", appt.getPatientAddress());
        assertEquals("Dr. Kamal Silva", appt.getDentistName());
        assertEquals("Root Canal Therapy", appt.getTreatmentType());
        assertEquals(testDate, appt.getAppointmentDate());
        assertEquals(testTime, appt.getAppointmentTime());
        assertEquals("Confirmed", appt.getStatus());
        assertEquals("APT-101", appt.getPatientUsername());
        assertEquals("hashedSecret123", appt.getPatientPasswordHash());
    }

    @Test
    @DisplayName("Should handle appointment status values properly")
    void testAppointmentStatuses() {
        Appointment appt = new Appointment();

        appt.setStatus("Pending");
        assertEquals("Pending", appt.getStatus());

        appt.setStatus("Confirmed");
        assertEquals("Confirmed", appt.getStatus());

        appt.setStatus("Completed");
        assertEquals("Completed", appt.getStatus());

        appt.setStatus("Cancelled");
        assertEquals("Cancelled", appt.getStatus());
    }
}
