package com.sunrisedental.dao;

import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Dentist;
import com.sunrisedental.model.Patient;
import com.sunrisedental.util.PasswordUtil;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DisplayName("AppointmentDAO Integration / CRUD Tests")
public class AppointmentDAOTest {

    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private DentistDAO dentistDAO;

    private Patient testPatient;
    private Dentist testDentist;
    private List<Integer> createdAppointmentIds;

    @BeforeEach
    void setUp() throws SQLException {
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
        dentistDAO = new DentistDAO();
        createdAppointmentIds = new ArrayList<>();

        // Create test patient
        testPatient = new Patient();
        testPatient.setName("Appt Test Patient");
        testPatient.setContact("0771239999");
        testPatient.setEmail("appttest@example.com");
        testPatient.setAddress("Colombo Test");
        int pId = patientDAO.insert(testPatient);
        testPatient.setId(pId);

        // Retrieve existing dentist or create one
        List<Dentist> dentists = dentistDAO.findAll();
        if (!dentists.isEmpty()) {
            testDentist = dentists.get(0);
        } else {
            testDentist = new Dentist();
            testDentist.setName("Dr. Test Dentist");
            testDentist.setSpecialization("General Dentistry");
            testDentist.setContact("0112345678");
            int dId = dentistDAO.insert(testDentist);
            testDentist.setId(dId);
        }
    }

    @AfterEach
    void tearDown() {
        // Clean up test appointments
        if (createdAppointmentIds != null) {
            for (int id : createdAppointmentIds) {
                try {
                    appointmentDAO.delete(id);
                } catch (SQLException ignored) {
                }
            }
        }

        // Clean up test patient
        if (testPatient != null && testPatient.getId() > 0) {
            try {
                patientDAO.delete(testPatient.getId());
            } catch (SQLException ignored) {
            }
        }
    }

    private Appointment createTestAppointment(String customNo, Date date, Time time, String status) throws SQLException {
        Appointment appt = new Appointment();
        appt.setAppointmentNo(customNo != null ? customNo : appointmentDAO.generateNextAppointmentNo());
        appt.setPatientId(testPatient.getId());
        appt.setDentistId(testDentist.getId());
        appt.setTreatmentType("Teeth Cleaning");
        appt.setAppointmentDate(date);
        appt.setAppointmentTime(time);
        appt.setStatus(status != null ? status : "Pending");

        int id = appointmentDAO.insert(appt);
        assertTrue(id > 0, "Appointment insert should return positive generated key");
        appt.setId(id);
        createdAppointmentIds.add(id);
        return appt;
    }

    @Test
    @DisplayName("Should generate a valid appointment number formatted as APT-xxx")
    void testGenerateNextAppointmentNo() throws SQLException {
        String nextNo = appointmentDAO.generateNextAppointmentNo();
        assertNotNull(nextNo);
        assertTrue(nextNo.startsWith("APT-"), "Appointment number should start with APT-");
    }

    @Test
    @DisplayName("Should insert appointment and retrieve by ID with joined details (Positive test)")
    void testInsertAndFindById() throws SQLException {
        Date date = Date.valueOf("2026-10-01");
        Time time = Time.valueOf("09:00:00");
        Appointment appt = createTestAppointment(null, date, time, "Pending");

        Appointment found = appointmentDAO.findById(appt.getId());
        assertNotNull(found, "Appointment should be found by ID");
        assertEquals(appt.getAppointmentNo(), found.getAppointmentNo());
        assertEquals(testPatient.getId(), found.getPatientId());
        assertEquals(testDentist.getId(), found.getDentistId());
        assertEquals("Teeth Cleaning", found.getTreatmentType());
        assertEquals(date, found.getAppointmentDate());
        assertEquals(time, found.getAppointmentTime());
        assertEquals("Pending", found.getStatus());
        // Verify joined details
        assertEquals(testPatient.getName(), found.getPatientName());
        assertEquals(testDentist.getName(), found.getDentistName());
    }

    @Test
    @DisplayName("Should return null for non-existent appointment ID (Negative test)")
    void testFindByIdNotFound() throws SQLException {
        Appointment found = appointmentDAO.findById(-9999);
        assertNull(found, "Non-existent appointment ID must return null");
    }

    @Test
    @DisplayName("Should find appointment by appointment number")
    void testFindByAppointmentNo() throws SQLException {
        Date date = Date.valueOf("2026-10-02");
        Time time = Time.valueOf("10:00:00");
        Appointment appt = createTestAppointment(null, date, time, "Confirmed");

        Appointment found = appointmentDAO.findByAppointmentNo(appt.getAppointmentNo());
        assertNotNull(found);
        assertEquals(appt.getId(), found.getId());

        assertNull(appointmentDAO.findByAppointmentNo("APT-NONEXISTENT-9999"), "Should return null for unknown number");
    }

    @Test
    @DisplayName("Should update appointment details and update status")
    void testUpdateAndStatusUpdate() throws SQLException {
        Date date = Date.valueOf("2026-10-03");
        Time time = Time.valueOf("11:00:00");
        Appointment appt = createTestAppointment(null, date, time, "Pending");

        // Test update full details
        Date newDate = Date.valueOf("2026-10-04");
        Time newTime = Time.valueOf("14:00:00");
        appt.setAppointmentDate(newDate);
        appt.setAppointmentTime(newTime);
        appt.setTreatmentType("Root Canal Therapy");
        appt.setStatus("Confirmed");

        boolean updated = appointmentDAO.update(appt);
        assertTrue(updated, "Update should return true");

        Appointment retrieved = appointmentDAO.findById(appt.getId());
        assertNotNull(retrieved);
        assertEquals(newDate, retrieved.getAppointmentDate());
        assertEquals(newTime, retrieved.getAppointmentTime());
        assertEquals("Root Canal Therapy", retrieved.getTreatmentType());
        assertEquals("Confirmed", retrieved.getStatus());

        // Test updateStatus method
        boolean statusUpdated = appointmentDAO.updateStatus(appt.getId(), "Completed");
        assertTrue(statusUpdated);
        Appointment afterStatus = appointmentDAO.findById(appt.getId());
        assertEquals("Completed", afterStatus.getStatus());
    }

    @Test
    @DisplayName("Should detect slot conflicts and check availability")
    void testSlotAvailabilityAndConflict() throws SQLException {
        Date date = Date.valueOf("2026-10-10");
        Time time = Time.valueOf("15:00:00");
        Appointment appt = createTestAppointment(null, date, time, "Confirmed");

        // Same slot for same dentist should be taken
        boolean isTaken = appointmentDAO.isSlotTaken(testDentist.getId(), date, time, 0);
        assertTrue(isTaken, "Slot should be marked as taken");

        Appointment conflict = appointmentDAO.findConflictingAppointment(testDentist.getId(), date, time, 0);
        assertNotNull(conflict, "Conflict appointment should be returned");
        assertEquals(appt.getId(), conflict.getId());

        // Excluding current appointment should not conflict
        boolean selfExclude = appointmentDAO.isSlotTaken(testDentist.getId(), date, time, appt.getId());
        assertFalse(selfExclude, "Excluding own ID should not conflict");

        // Different time should not conflict
        Time freeTime = Time.valueOf("16:00:00");
        boolean freeSlot = appointmentDAO.isSlotTaken(testDentist.getId(), date, freeTime, 0);
        assertFalse(freeSlot, "Unbooked time slot should be available");
    }

    @Test
    @DisplayName("Should save patient credentials and authenticate patient portal login")
    void testPatientCredentialsAndLogin() throws SQLException {
        Date date = Date.valueOf("2026-10-15");
        Time time = Time.valueOf("09:30:00");
        Appointment appt = createTestAppointment(null, date, time, "Confirmed");

        String rawPassword = "PatientPass123";
        String hashedPassword = PasswordUtil.hash(rawPassword);

        // Save credentials (username = appointmentNo)
        boolean saved = appointmentDAO.savePatientCredentials(appt.getId(), appt.getAppointmentNo(), hashedPassword);
        assertTrue(saved, "savePatientCredentials should return true");

        // Test login with Appointment number (Positive)
        Appointment loginByApptNo = appointmentDAO.findByPatientLogin(appt.getAppointmentNo(), hashedPassword);
        assertNotNull(loginByApptNo, "Login by appointment number should succeed");
        assertEquals(appt.getId(), loginByApptNo.getId());

        // Test login with Patient Code (Positive)
        Appointment loginByPatientCode = appointmentDAO.findByPatientLogin(testPatient.getPatientCode(), hashedPassword);
        assertNotNull(loginByPatientCode, "Login by patient code should succeed");
        assertEquals(appt.getId(), loginByPatientCode.getId());

        // Test login with wrong password (Negative)
        String wrongHash = PasswordUtil.hash("WrongPassword");
        Appointment loginFailed = appointmentDAO.findByPatientLogin(appt.getAppointmentNo(), wrongHash);
        assertNull(loginFailed, "Login with wrong password must return null");

        // Test login with non-existent username (Negative)
        Appointment loginUnknownUser = appointmentDAO.findByPatientLogin("APT-UNKNOWN-999", hashedPassword);
        assertNull(loginUnknownUser, "Login with unknown user must return null");
    }

    @Test
    @DisplayName("Should find all appointments by patient email")
    void testFindAllByPatientEmail() throws SQLException {
        Date date = Date.valueOf("2026-10-20");
        Time time = Time.valueOf("10:00:00");
        createTestAppointment(null, date, time, "Pending");

        List<Appointment> list = appointmentDAO.findAllByPatientEmail(testPatient.getEmail());
        assertNotNull(list);
        assertFalse(list.isEmpty(), "Should return appointments for patient email");
        assertEquals(testPatient.getEmail(), list.get(0).getPatientEmail());
    }

    @Test
    @DisplayName("Should delete appointment successfully")
    void testDeleteAppointment() throws SQLException {
        Date date = Date.valueOf("2026-10-25");
        Time time = Time.valueOf("11:30:00");
        Appointment appt = createTestAppointment(null, date, time, "Pending");

        boolean deleted = appointmentDAO.delete(appt.getId());
        assertTrue(deleted, "delete should return true");
        assertNull(appointmentDAO.findById(appt.getId()), "Deleted appointment should not be found");
    }
}
