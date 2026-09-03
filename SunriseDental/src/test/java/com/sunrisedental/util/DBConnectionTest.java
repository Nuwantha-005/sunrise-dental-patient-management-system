package com.sunrisedental.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DisplayName("DBConnection Utility Tests")
public class DBConnectionTest {

    @Test
    @DisplayName("Should successfully obtain a valid and open database connection")
    void testGetConnectionSuccess() throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            assertNotNull(conn, "Connection should not be null");
            assertFalse(conn.isClosed(), "Connection should be active and open");
            assertTrue(conn.isValid(3), "Connection should be valid within timeout");
        }
    }

    @Test
    @DisplayName("Should retrieve database metadata from active connection")
    void testConnectionMetadata() throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            assertNotNull(conn);
            DatabaseMetaData metaData = conn.getMetaData();
            assertNotNull(metaData, "Database metadata should not be null");
            assertNotNull(metaData.getDatabaseProductName(), "Database product name should be available");
            assertNotNull(metaData.getURL(), "Database URL should be available");
        }
    }

    @Test
    @DisplayName("Should support multiple sequential connection requests")
    void testSequentialConnections() throws SQLException {
        for (int i = 0; i < 3; i++) {
            try (Connection conn = DBConnection.getConnection()) {
                assertNotNull(conn, "Connection " + i + " should not be null");
                assertFalse(conn.isClosed(), "Connection " + i + " should be open");
            }
        }
    }

    @Test
    @DisplayName("Closing one connection should not affect subsequent getConnection calls")
    void testConnectionLifecycle() {
        assertDoesNotThrow(() -> {
            Connection conn1 = DBConnection.getConnection();
            assertNotNull(conn1);
            conn1.close();
            assertTrue(conn1.isClosed(), "First connection should be closed");

            Connection conn2 = DBConnection.getConnection();
            assertNotNull(conn2, "Second connection should still be created successfully");
            assertFalse(conn2.isClosed(), "Second connection should be open");
            conn2.close();
        });
    }
}
