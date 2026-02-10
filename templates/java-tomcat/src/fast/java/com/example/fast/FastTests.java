// src/fast/java/com/example/fast/FastTests.java
// Fast unit tests - no servlet API, no container

package com.example.fast;

import com.example.model.User;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Optional;
import java.util.List;

class FastUserServiceTest {
    
    private FastUserService service;
    
    @BeforeEach
    void setUp() {
        service = new FastUserService();
    }
    
    @Test
    @DisplayName("Create user with valid data")
    void testCreateUser() {
        User user = service.createUser("Test User", "test@example.com");
        
        assertNotNull(user.getId());
        assertEquals("Test User", user.getName());
        assertEquals("test@example.com", user.getEmail());
    }
    
    @Test
    @DisplayName("Get existing user by ID")
    void testGetUser() {
        User created = service.createUser("Jane", "jane@example.com");
        Optional<User> retrieved = service.getUser(created.getId());
        
        assertTrue(retrieved.isPresent());
        assertEquals("Jane", retrieved.get().getName());
    }
    
    @Test
    @DisplayName("Get non-existent user returns empty")
    void testGetNonExistentUser() {
        Optional<User> result = service.getUser(999L);
        assertTrue(result.isEmpty());
    }
    
    @Test
    @DisplayName("Get all users returns all created")
    void testGetAllUsers() {
        service.createUser("User1", "user1@example.com");
        service.createUser("User2", "user2@example.com");
        
        List<User> allUsers = service.getAllUsers();
        assertEquals(2, allUsers.size());
    }
    
    @Test
    @DisplayName("Delete user removes from collection")
    void testDeleteUser() {
        User created = service.createUser("ToDelete", "delete@example.com");
        Long id = created.getId();
        
        boolean deleted = service.deleteUser(id);
        assertTrue(deleted);
        
        Optional<User> result = service.getUser(id);
        assertTrue(result.isEmpty());
    }
    
    @Test
    @DisplayName("Delete non-existent user returns false")
    void testDeleteNonExistentUser() {
        boolean deleted = service.deleteUser(999L);
        assertFalse(deleted);
    }
    
    @Test
    @DisplayName("User count reflects number of users")
    void testGetUserCount() {
        assertEquals(0, service.getUserCount());
        
        service.createUser("User1", "user1@example.com");
        assertEquals(1, service.getUserCount());
        
        service.createUser("User2", "user2@example.com");
        assertEquals(2, service.getUserCount());
    }
}
