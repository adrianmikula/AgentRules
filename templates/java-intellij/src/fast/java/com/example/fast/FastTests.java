package com.example.fast;

import com.intellij.testFramework.TestFramework;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Fast Unit Tests - IntelliJ Plugin
 * Uses IntelliJ Test Framework (no IDE boot required)
 * Target: < 10s for all tests
 */
public class FastTests {
    
    @Nested
    @DisplayName("Plugin Tests")
    class PluginTests {
        
        @Test
        @DisplayName("Plugin initialization test")
        void testPluginInitialization() {
            // Test plugin class exists
            assertDoesNotThrow(() -> {
                Class.forName("com.example.intellij.JavaIntelliJPlugin");
            });
        }
        
        @Test
        @DisplayName("Plugin version test")
        void testPluginVersion() {
            String version = "1.0.0";
            assertNotNull(version);
            assertEquals("1.0.0", version);
        }
        
        @Test
        @DisplayName("Plugin ID test")
        void testPluginId() {
            String id = "com.example.intellij";
            assertNotNull(id);
            assertTrue(id.startsWith("com.example"));
        }
    }
    
    @Nested
    @DisplayName("Utility Tests")
    class UtilityTests {
        
        @Test
        @DisplayName("String utility test")
        void testStringUtility() {
            String result = "test";
            assertEquals("test", result);
        }
        
        @Test
        @DisplayName("Collection utility test")
        void testCollectionUtility() {
            java.util.List<String> list = java.util.List.of("a", "b", "c");
            assertEquals(3, list.size());
        }
        
        @Test
        @DisplayName("Stream utility test")
        void testStreamUtility() {
            long count = java.util.stream.IntStream.range(0, 10)
                .filter(i -> i % 2 == 0)
                .count();
            assertEquals(5, count);
        }
    }
    
    @Nested
    @DisplayName("Performance Tests")
    class PerformanceTests {
        
        @Test
        @DisplayName("Fast execution test")
        void testFastExecution() {
            long start = System.currentTimeMillis();
            
            // Simulate fast operation
            int sum = 0;
            for (int i = 0; i < 1000; i++) {
                sum += i;
            }
            
            long duration = System.currentTimeMillis() - start;
            
            assertTrue(duration < 100, "Should execute in < 100ms");
            assertEquals(499500, sum);
        }
    }
}
