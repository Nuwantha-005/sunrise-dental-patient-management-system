package com.sunrisedental.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

@DisplayName("Patient Model Tests")
public class PatientTest {

    @Test
    @DisplayName("Should initialize with default constructor and allow getters/setters")
    void testDefaultConstructorAndSetters() {
        Patient patient = new Patient();
        patient.setId(10);
        patient.setPatientCode("PAT-010");
        patient.setName("John Doe");
        patient.setContact("0771234567");
        patient.setEmail("john@example.com");
        patient.setAddress("Colombo 03");

        assertEquals(10, patient.getId());
        assertEquals("PAT-010", patient.getPatientCode());
        assertEquals("John Doe", patient.getName());
        assertEquals("0771234567", patient.getContact());
        assertEquals("john@example.com", patient.getEmail());
        assertEquals("Colombo 03", patient.getAddress());
    }

    @Test
    @DisplayName("Should initialize properly using 6-parameter constructor")
    void testSixParamConstructor() {
        Patient patient = new Patient(5, "PAT-005", "Alice Smith", "0719876543", "alice@example.com", "Kandy");

        assertEquals(5, patient.getId());
        assertEquals("PAT-005", patient.getPatientCode());
        assertEquals("Alice Smith", patient.getName());
        assertEquals("0719876543", patient.getContact());
        assertEquals("alice@example.com", patient.getEmail());
        assertEquals("Kandy", patient.getAddress());
    }

    @Test
    @DisplayName("Should auto-generate patient code in 5-parameter constructor when id is provided")
    void testFiveParamConstructor() {
        Patient patient = new Patient(8, "Bob Johnson", "0751122334", "bob@example.com", "Galle");

        assertEquals(8, patient.getId());
        assertEquals("PAT-008", patient.getPatientCode());
        assertEquals("Bob Johnson", patient.getName());
        assertEquals("0751122334", patient.getContact());
        assertEquals("bob@example.com", patient.getEmail());
        assertEquals("Galle", patient.getAddress());
    }

    @Test
    @DisplayName("Should initialize with 4-parameter constructor leaving email as null")
    void testFourParamConstructor() {
        Patient patient = new Patient(12, "Charlie Brown", "0763344556", "Kurunegala");

        assertEquals(12, patient.getId());
        assertEquals("PAT-012", patient.getPatientCode());
        assertEquals("Charlie Brown", patient.getName());
        assertEquals("0763344556", patient.getContact());
        assertNull(patient.getEmail(), "Email should be null in 4-parameter constructor");
        assertEquals("Kurunegala", patient.getAddress());
    }

    @Test
    @DisplayName("getPatientCode() should handle fallback when code is null and id is 0 or positive")
    void testPatientCodeFallbackLogic() {
        Patient newPatient = new Patient();
        assertEquals("PAT-NEW", newPatient.getPatientCode(), "New unsaved patient with id 0 should return PAT-NEW");

        newPatient.setId(1);
        assertEquals("PAT-001", newPatient.getPatientCode(), "Patient with id 1 should format to PAT-001");

        newPatient.setPatientCode("CUSTOM-999");
        assertEquals("CUSTOM-999", newPatient.getPatientCode(), "Explicitly set patientCode should take precedence");
    }
}
