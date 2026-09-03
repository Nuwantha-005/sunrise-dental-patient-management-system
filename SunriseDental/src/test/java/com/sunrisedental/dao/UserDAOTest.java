package com.sunrisedental.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.sunrisedental.model.User;
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

@DisplayName("UserDAO Integration / CRUD Tests")
public class UserDAOTest {

    private UserDAO userDAO;
    private List<Integer> createdUserIds;

    @BeforeEach
    void setUp() {
        userDAO = new UserDAO();
        createdUserIds = new ArrayList<>();
    }

    @AfterEach
    void tearDown() {
        // Clean up created test users
        if (createdUserIds != null) {
            for (int id : createdUserIds) {
                try {
                    userDAO.deleteStaff(id);
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private User createTestUser(String usernamePrefix, String role) throws SQLException {
        User u = new User();
        String uniqueSuffix = "_" + System.currentTimeMillis() + "_" + (int) (Math.random() * 1000);
        u.setUsername(usernamePrefix + uniqueSuffix);
        u.setFullName("Test User " + usernamePrefix);
        u.setEmail(usernamePrefix.toLowerCase() + uniqueSuffix + "@sunrisedental.lk");
        u.setContact("0771122334");
        u.setRole(role != null ? role : "RECEPTIONIST");

        int id = userDAO.insertStaff(u, "InitialPassword123");
        assertTrue(id > 0, "Insert staff should return positive generated key");
        u.setId(id);
        createdUserIds.add(id);
        return u;
    }

    @Test
    @DisplayName("Should insert a new staff user and hash the raw password")
    void testInsertStaff() throws SQLException {
        User user = createTestUser("receptionist_test", "RECEPTIONIST");
        assertTrue(user.getId() > 0);

        String storedHash = userDAO.getPasswordHash(user.getId());
        assertNotNull(storedHash);
        assertTrue(PasswordUtil.matches("InitialPassword123", storedHash),
                "Stored password hash must match the raw password used during insertion");
    }

    @Test
    @DisplayName("Should find user by username with password (Positive and Negative tests)")
    void testFindByUsername() throws SQLException {
        User user = createTestUser("find_user_test", "RECEPTIONIST");

        // Positive test
        User found = userDAO.findByUsername(user.getUsername());
        assertNotNull(found, "User should be found by username");
        assertEquals(user.getId(), found.getId());
        assertEquals(user.getFullName(), found.getFullName());
        assertEquals(user.getEmail(), found.getEmail());
        assertEquals("RECEPTIONIST", found.getRole());
        assertNotNull(found.getPassword(), "findByUsername should populate the password hash");

        // Negative test
        User notFound = userDAO.findByUsername("non_existent_username_xyz999");
        assertNull(notFound, "Non-existent username should return null");
    }

    @Test
    @DisplayName("Should find user by ID (Positive and Negative tests)")
    void testFindById() throws SQLException {
        User user = createTestUser("find_id_test", "RECEPTIONIST");

        User found = userDAO.findById(user.getId());
        assertNotNull(found);
        assertEquals(user.getUsername(), found.getUsername());
        assertEquals(user.getFullName(), found.getFullName());

        assertNull(userDAO.findById(-9999), "Non-existent ID must return null");
    }

    @Test
    @DisplayName("Should detect taken usernames and ignore when excluding user's own ID")
    void testIsUsernameTaken() throws SQLException {
        User user = createTestUser("unique_user_check", "RECEPTIONIST");

        // Taken for another user (exclude ID = 0)
        boolean taken = userDAO.isUsernameTaken(user.getUsername(), 0);
        assertTrue(taken, "Username should be recognized as taken");

        // Available when excluding the user's own ID
        boolean ownExcluded = userDAO.isUsernameTaken(user.getUsername(), user.getId());
        assertFalse(ownExcluded, "Username should be allowed when excluding own ID");

        // Available for non-existent username
        boolean available = userDAO.isUsernameTaken("completely_free_username_9999", 0);
        assertFalse(available, "Non-existent username should not be taken");
    }

    @Test
    @DisplayName("Should retrieve all staff and all receptionists in list")
    void testFindAllStaffAndReceptionists() throws SQLException {
        User user = createTestUser("staff_list_test", "RECEPTIONIST");

        List<User> receptionists = userDAO.findAllReceptionists();
        assertNotNull(receptionists);
        assertTrue(receptionists.stream().anyMatch(u -> u.getId() == user.getId()),
                "Created receptionist should be in receptionists list");

        List<User> allStaff = userDAO.findAllStaff();
        assertNotNull(allStaff);
        assertTrue(allStaff.stream().anyMatch(u -> u.getId() == user.getId()),
                "Created user should be in all staff list");
    }

    @Test
    @DisplayName("Should update staff information and optionally update password")
    void testUpdateStaff() throws SQLException {
        User user = createTestUser("update_staff_test", "RECEPTIONIST");

        user.setFullName("Updated Staff Name");
        user.setEmail("updated_staff@sunrisedental.lk");
        user.setContact("0779998888");

        // Update without password change
        boolean updated = userDAO.updateStaff(user, null);
        assertTrue(updated, "Update without password should succeed");

        User retrieved = userDAO.findById(user.getId());
        assertEquals("Updated Staff Name", retrieved.getFullName());
        assertEquals("updated_staff@sunrisedental.lk", retrieved.getEmail());
        assertEquals("0779998888", retrieved.getContact());

        // Update with new password
        boolean updatedWithPwd = userDAO.updateStaff(user, "NewSecretPassword99");
        assertTrue(updatedWithPwd);

        String newHash = userDAO.getPasswordHash(user.getId());
        assertTrue(PasswordUtil.matches("NewSecretPassword99", newHash),
                "New password must match updated hash");
    }

    @Test
    @DisplayName("Should update profile and update password independently")
    void testUpdateProfileAndPassword() throws SQLException {
        User user = createTestUser("profile_test", "RECEPTIONIST");

        user.setFullName("Profile Changed Name");
        user.setEmail("changed_profile@sunrisedental.lk");
        user.setContact("0712233445");

        boolean profileUpdated = userDAO.updateProfile(user);
        assertTrue(profileUpdated);

        boolean pwdUpdated = userDAO.updatePassword(user.getId(), "DirectNewPassword#1");
        assertTrue(pwdUpdated);

        String updatedHash = userDAO.getPasswordHash(user.getId());
        assertTrue(PasswordUtil.matches("DirectNewPassword#1", updatedHash));
    }

    @Test
    @DisplayName("Should delete staff user by ID and return false for non-existent ID")
    void testDeleteStaff() throws SQLException {
        User user = createTestUser("delete_test", "RECEPTIONIST");
        int id = user.getId();

        boolean deleted = userDAO.deleteStaff(id);
        assertTrue(deleted, "deleteStaff should return true for existing receptionist");
        assertNull(userDAO.findById(id), "Deleted staff should no longer be found");

        // Negative test: deleting again
        boolean secondDelete = userDAO.deleteStaff(id);
        assertFalse(secondDelete, "Deleting non-existent user should return false");
    }
}
