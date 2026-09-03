package com.sunrisedental.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Patient;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DisplayName("PatientDAO Integration / CRUD Tests")
public class PatientDAOTest {

    private PatientDAO patientDAO;
    private List<Integer> createdPatientIds;

    @BeforeEach
    void setUp() {
        patientDAO = new PatientDAO();
        createdPatientIds = new ArrayList<>();
    }

    @AfterEach
    void tearDown() {
        // Clean up all test patients created during testing
        if (createdPatientIds != null) {
            for (int id : createdPatientIds) {
                try {
                    patientDAO.delete(id);
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private Patient createTestPatient(String nameSuffix) throws SQLException {
        Patient p = new Patient();
        p.setName("TestPatient_" + nameSuffix);
        p.setContact("077000" + (int) (Math.random() * 9000 + 1000));
        p.setEmail("test_" + nameSuffix.toLowerCase() + "@example.com");
        p.setAddress("Test Address " + nameSuffix);
        int id = patientDAO.insert(p);
        assertTrue(id > 0, "Insert should return a positive generated primary key");
        createdPatientIds.add(id);
        return p;
    }

    @Test
    @DisplayName("Should insert a new patient and auto-generate unique patient code")
    void testInsertPatient() throws SQLException {
        Patient p = createTestPatient("Insert");
        assertTrue(p.getId() > 0, "Patient ID should be set on insertion");
        assertNotNull(p.getPatientCode(), "Patient code should be auto-assigned");
        assertTrue(p.getPatientCode().startsWith("PAT-"), "Patient code should match PAT-xxx format");
    }

    @Test
    @DisplayName("Should find an existing patient by ID (Positive test)")
    void testFindByIdSuccess() throws SQLException {
        Patient created = createTestPatient("FindById");
        Patient found = patientDAO.findById(created.getId());

        assertNotNull(found, "Patient should be found by existing ID");
        assertEquals(created.getId(), found.getId());
        assertEquals(created.getName(), found.getName());
        assertEquals(created.getContact(), found.getContact());
        assertEquals(created.getEmail(), found.getEmail());
        assertEquals(created.getAddress(), found.getAddress());
        assertEquals(created.getPatientCode(), found.getPatientCode());
    }

    @Test
    @DisplayName("Should return null when finding by non-existent ID (Negative test)")
    void testFindByIdNotFound() throws SQLException {
        Patient found = patientDAO.findById(-9999);
        assertNull(found, "Non-existent patient ID should return null");
    }

    @Test
    @DisplayName("Should find patient by unique patient code case-insensitively (Positive test)")
    void testFindByPatientCodeSuccess() throws SQLException {
        Patient created = createTestPatient("FindByCode");
        String code = created.getPatientCode();

        // Exact match
        Patient found1 = patientDAO.findByPatientCode(code);
        assertNotNull(found1);
        assertEquals(created.getId(), found1.getId());

        // Lowercase match
        Patient found2 = patientDAO.findByPatientCode(code.toLowerCase());
        assertNotNull(found2);
        assertEquals(created.getId(), found2.getId());
    }

    @Test
    @DisplayName("Should return null for non-existent or blank patient code (Negative test)")
    void testFindByPatientCodeNotFound() throws SQLException {
        assertNull(patientDAO.findByPatientCode("PAT-NONEXISTENT-9999"));
        assertNull(patientDAO.findByPatientCode(null));
        assertNull(patientDAO.findByPatientCode("   "));
    }

    @Test
    @DisplayName("Should retrieve all patients and verify total count")
    void testFindAllAndCountAll() throws SQLException {
        Patient p1 = createTestPatient("All1");
        Patient p2 = createTestPatient("All2");

        List<Patient> all = patientDAO.findAll();
        assertNotNull(all);
        assertTrue(all.size() >= 2, "List should contain at least the 2 test patients");

        int count = patientDAO.countAll();
        assertTrue(count >= 2, "Total count should be at least 2");
    }

    @Test
    @DisplayName("Should search patients by name, code, contact, and email")
    void testSearch() throws SQLException {
        Patient p = createTestPatient("SearchTarget");

        List<Patient> byName = patientDAO.search("SearchTarget");
        assertFalse(byName.isEmpty(), "Should find patient by name keyword");

        List<Patient> byCode = patientDAO.search(p.getPatientCode());
        assertFalse(byCode.isEmpty(), "Should find patient by patientCode keyword");

        List<Patient> byEmail = patientDAO.search(p.getEmail());
        assertFalse(byEmail.isEmpty(), "Should find patient by email keyword");

        List<Patient> notFound = patientDAO.search("NonExistentKeywordXYZ12345");
        assertTrue(notFound.isEmpty(), "Search with random gibberish should return empty list");
    }

    @Test
    @DisplayName("Should update patient details successfully")
    void testUpdatePatient() throws SQLException {
        Patient p = createTestPatient("PreUpdate");

        p.setName("Updated Patient Name");
        p.setContact("0778889999");
        p.setEmail("updated_email@example.com");
        p.setAddress("Updated City");

        boolean updated = patientDAO.update(p);
        assertTrue(updated, "Update operation should return true");

        Patient retrieved = patientDAO.findById(p.getId());
        assertNotNull(retrieved);
        assertEquals("Updated Patient Name", retrieved.getName());
        assertEquals("0778889999", retrieved.getContact());
        assertEquals("updated_email@example.com", retrieved.getEmail());
        assertEquals("Updated City", retrieved.getAddress());
    }

    @Test
    @DisplayName("Should delete patient by ID successfully and return false for non-existent ID")
    void testDeletePatient() throws SQLException {
        Patient p = createTestPatient("ToDelete");
        int id = p.getId();

        boolean deleted = patientDAO.delete(id);
        assertTrue(deleted, "Delete should return true for existing patient");
        assertNull(patientDAO.findById(id), "Deleted patient should no longer be found");

        // Negative test: deleting non-existent ID
        boolean secondDelete = patientDAO.delete(id);
        assertFalse(secondDelete, "Deleting an already deleted ID should return false");
    }
}
