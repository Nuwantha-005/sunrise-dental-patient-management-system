package com.sunrisedental.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.Appointment;
import com.sunrisedental.model.Bill;
import com.sunrisedental.model.Dentist;
import com.sunrisedental.model.Patient;
import com.sunrisedental.util.DBConnection;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DisplayName("BillDAO Integration / CRUD Tests")
public class BillDAOTest {

    private BillDAO billDAO;
    private AppointmentDAO appointmentDAO;
    private PatientDAO patientDAO;
    private DentistDAO dentistDAO;

    private Patient testPatient;
    private Dentist testDentist;
    private Appointment testAppointment;
    private List<Integer> createdBillIds;

    @BeforeEach
    void setUp() throws SQLException {
        billDAO = new BillDAO();
        appointmentDAO = new AppointmentDAO();
        patientDAO = new PatientDAO();
        dentistDAO = new DentistDAO();
        createdBillIds = new ArrayList<>();

        // Create test patient
        testPatient = new Patient();
        testPatient.setName("Bill Test Patient");
        testPatient.setContact("0775556666");
        testPatient.setEmail("billtest@example.com");
        testPatient.setAddress("Kandy Road");
        int pId = patientDAO.insert(testPatient);
        testPatient.setId(pId);

        // Get or create dentist
        List<Dentist> dentists = dentistDAO.findAll();
        if (!dentists.isEmpty()) {
            testDentist = dentists.get(0);
        } else {
            testDentist = new Dentist();
            testDentist.setName("Dr. Bill Test Dentist");
            testDentist.setSpecialization("Orthodontics");
            testDentist.setContact("0119876543");
            int dId = dentistDAO.insert(testDentist);
            testDentist.setId(dId);
        }

        // Create test appointment
        testAppointment = new Appointment();
        testAppointment.setAppointmentNo(appointmentDAO.generateNextAppointmentNo());
        testAppointment.setPatientId(testPatient.getId());
        testAppointment.setDentistId(testDentist.getId());
        testAppointment.setTreatmentType("Tooth Extraction");
        testAppointment.setAppointmentDate(Date.valueOf("2026-11-01"));
        testAppointment.setAppointmentTime(Time.valueOf("09:00:00"));
        testAppointment.setStatus("Completed");
        int aId = appointmentDAO.insert(testAppointment);
        testAppointment.setId(aId);
    }

    @AfterEach
    void tearDown() {
        // Clean up created bills
        if (createdBillIds != null) {
            for (int billId : createdBillIds) {
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement("DELETE FROM bills WHERE id = ?")) {
                    ps.setInt(1, billId);
                    ps.executeUpdate();
                } catch (SQLException ignored) {
                }
            }
        }

        // Clean up test appointment
        if (testAppointment != null && testAppointment.getId() > 0) {
            try {
                appointmentDAO.delete(testAppointment.getId());
            } catch (SQLException ignored) {
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

    private Bill createTestBill(String billNo) throws SQLException {
        Bill bill = new Bill();
        bill.setBillNo(billNo != null ? billNo : billDAO.generateNextBillNo());
        bill.setAppointmentId(testAppointment.getId());
        bill.setTreatmentAmount(new BigDecimal("5000.00"));
        bill.setConsultationFee(new BigDecimal("1500.00"));
        bill.setOtherCharges(new BigDecimal("500.00"));
        bill.setTotalAmount(new BigDecimal("7000.00"));

        int id = billDAO.insert(bill);
        assertTrue(id > 0, "Bill insertion should return positive ID");
        bill.setId(id);
        createdBillIds.add(id);
        return bill;
    }

    @Test
    @DisplayName("Should generate a valid bill number formatted as BILL-xxx")
    void testGenerateNextBillNo() throws SQLException {
        String billNo = billDAO.generateNextBillNo();
        assertNotNull(billNo);
        assertTrue(billNo.startsWith("BILL-"), "Bill number must start with BILL-");
    }

    @Test
    @DisplayName("Should insert a bill and find by appointment ID with joined details")
    void testInsertAndFindByAppointmentId() throws SQLException {
        Bill bill = createTestBill(null);

        Bill found = billDAO.findByAppointmentId(testAppointment.getId());
        assertNotNull(found, "Bill should be found by appointment ID");
        assertEquals(bill.getBillNo(), found.getBillNo());
        assertEquals(testAppointment.getId(), found.getAppointmentId());
        assertEquals(0, new BigDecimal("5000.00").compareTo(found.getTreatmentAmount()));
        assertEquals(0, new BigDecimal("1500.00").compareTo(found.getConsultationFee()));
        assertEquals(0, new BigDecimal("500.00").compareTo(found.getOtherCharges()));
        assertEquals(0, new BigDecimal("7000.00").compareTo(found.getTotalAmount()));

        // Check joined fields
        assertEquals(testAppointment.getAppointmentNo(), found.getAppointmentNo());
        assertEquals(testPatient.getName(), found.getPatientName());
        assertEquals(testDentist.getName(), found.getDentistName());
        assertEquals("Tooth Extraction", found.getTreatmentType());
    }

    @Test
    @DisplayName("Should return null when finding bill for non-existent appointment (Negative test)")
    void testFindByAppointmentIdNotFound() throws SQLException {
        Bill found = billDAO.findByAppointmentId(-9999);
        assertNull(found, "Non-existent appointment ID should return null bill");
    }

    @Test
    @DisplayName("Should find bill by bill number (Positive and Negative tests)")
    void testFindByBillNo() throws SQLException {
        Bill bill = createTestBill(null);

        Bill found = billDAO.findByBillNo(bill.getBillNo());
        assertNotNull(found, "Bill should be found by billNo");
        assertEquals(bill.getId(), found.getId());

        assertNull(billDAO.findByBillNo("BILL-NONEXISTENT-9999"), "Should return null for unknown bill number");
    }

    @Test
    @DisplayName("Should calculate and return total revenue as a non-negative BigDecimal")
    void testGetTotalRevenue() throws SQLException {
        createTestBill(null);

        BigDecimal revenue = billDAO.getTotalRevenue();
        assertNotNull(revenue, "Total revenue should not be null");
        assertTrue(revenue.compareTo(BigDecimal.ZERO) >= 0, "Revenue should be non-negative");
    }

    @Test
    @DisplayName("Should retrieve all bills and filter by keyword correctly")
    void testFindAllWithKeyword() throws SQLException {
        Bill bill = createTestBill(null);

        // Test without keyword
        List<Bill> allBills = billDAO.findAll(null);
        assertNotNull(allBills);
        assertTrue(allBills.stream().anyMatch(b -> b.getId() == bill.getId()), "Created bill should be in findAll list");

        // Test with matching keyword (patient name)
        List<Bill> filteredByPatient = billDAO.findAll(testPatient.getName());
        assertNotNull(filteredByPatient);
        assertTrue(filteredByPatient.stream().anyMatch(b -> b.getId() == bill.getId()), "Bill should match patient name search");

        // Test with matching keyword (bill no)
        List<Bill> filteredByBillNo = billDAO.findAll(bill.getBillNo());
        assertNotNull(filteredByBillNo);
        assertTrue(filteredByBillNo.stream().anyMatch(b -> b.getId() == bill.getId()), "Bill should match billNo search");

        // Test with non-matching keyword
        List<Bill> noMatch = billDAO.findAll("NON_EXISTING_XYZ_9999");
        assertNotNull(noMatch);
        assertTrue(noMatch.isEmpty(), "Non-matching keyword should return empty list");
    }
}
