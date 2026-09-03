package com.sunrisedental.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DisplayName("PasswordUtil Tests")
public class PasswordUtilTest {

    @Test
    @DisplayName("Should generate a 64-character lowercase SHA-256 hex string")
    void testHashFormatAndLength() {
        String hash = PasswordUtil.hash("securePassword123");
        assertNotNull(hash, "Hash should not be null");
        assertEquals(64, hash.length(), "SHA-256 hash must be 64 characters long");
        assertTrue(hash.matches("^[0-9a-f]{64}$"), "Hash must contain only lowercase hexadecimal characters");
    }

    @Test
    @DisplayName("Should compute accurate known SHA-256 hash value")
    void testKnownHashValue() {
        // SHA-256("admin123") in lowercase hex
        String expectedHash = "240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9";
        String actualHash = PasswordUtil.hash("admin123");
        assertEquals(expectedHash, actualHash, "Hash must match standard SHA-256 output");
    }

    @Test
    @DisplayName("Should produce consistent deterministic hash for identical input")
    void testDeterministicHashing() {
        String input = "SunriseDental#2026";
        String hash1 = PasswordUtil.hash(input);
        String hash2 = PasswordUtil.hash(input);
        assertEquals(hash1, hash2, "Hashing same input multiple times must return identical hash");
    }

    @Test
    @DisplayName("Should produce different hashes for different inputs (Case sensitivity)")
    void testHashDifferenceAndCaseSensitivity() {
        String hashLower = PasswordUtil.hash("password");
        String hashUpper = PasswordUtil.hash("Password");
        String hashOther = PasswordUtil.hash("admin");

        assertNotEquals(hashLower, hashUpper, "Hashing must be case-sensitive");
        assertNotEquals(hashLower, hashOther, "Different passwords must produce distinct hashes");
    }

    @Test
    @DisplayName("Should correctly hash empty and special character strings")
    void testEmptyAndSpecialCharacterHashing() {
        String emptyHash = PasswordUtil.hash("");
        assertNotNull(emptyHash);
        assertEquals(64, emptyHash.length());
        // Standard SHA-256 of empty string
        assertEquals("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", emptyHash);

        String specialHash = PasswordUtil.hash("!@#$%^&*()_+~`|}{[]:;?><,./");
        assertNotNull(specialHash);
        assertEquals(64, specialHash.length());
    }

    @Test
    @DisplayName("matches() should return true when raw password matches hashed password")
    void testMatchesPositive() {
        String rawPassword = "mySecretPassword";
        String hashedPassword = PasswordUtil.hash(rawPassword);

        assertTrue(PasswordUtil.matches(rawPassword, hashedPassword),
                "matches() should return true when raw password matches hash");
    }

    @Test
    @DisplayName("matches() should return false when raw password does not match hash")
    void testMatchesNegative() {
        String correctPassword = "correctSecret";
        String wrongPassword = "wrongSecret";
        String hashedPassword = PasswordUtil.hash(correctPassword);

        assertFalse(PasswordUtil.matches(wrongPassword, hashedPassword),
                "matches() should return false for incorrect password");
        assertFalse(PasswordUtil.matches("", hashedPassword),
                "matches() should return false for empty password against non-empty hash");
        assertFalse(PasswordUtil.matches(correctPassword, "invalid_hash_value"),
                "matches() should return false for invalid hash string");
    }
}
