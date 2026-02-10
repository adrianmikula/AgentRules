package com.example.fast;

import com.example.app.domain.User;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class FastTests {
    
    @Test
    public void testUserCreation() {
        User user = new User(1L, "Test User", "test@example.com");
        assertEquals(1L, user.getId());
        assertEquals("Test User", user.getName());
        assertEquals("test@example.com", user.getEmail());
    }
    
    @Test
    public void testUserSetters() {
        User user = new User();
        user.setId(2L);
        user.setName("Updated User");
        user.setEmail("updated@example.com");
        
        assertEquals(2L, user.getId());
        assertEquals("Updated User", user.getName());
        assertEquals("updated@example.com", user.getEmail());
    }
    
    @Test
    public void testUserDefaultConstructor() {
        User user = new User();
        assertNull(user.getId());
        assertNull(user.getName());
        assertNull(user.getEmail());
    }
}
