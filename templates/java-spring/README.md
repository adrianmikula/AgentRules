# Java+Spring Boilerplate - Agentic Dev Velocity

## Structure

```
java-spring-boilerplate/
├── src/
│   ├── main/
│   │   ├── java/com/example/app/
│   │   │   ├── App.java              # Spring entrypoint (CI only)
│   │   │   ├── domain/
│   │   │   │   └── User.java         # Pure JPA entity
│   │   │   ├── service/
│   │   │   │   └── UserService.java  # Business logic (no Spring in loop)
│   │   │   ├── dto/
│   │   │   │   └── UserDTO.java     # Data transfer
│   │   │   └── repository/
│   │   │       └── UserRepository.java
│   │   └── resources/
│   │       └── application.yml       # Full config (CI)
│   ├── fast/
│   │   └── java/com/example/fast/
│   │       ├── FastUserService.java  # Plain Java, no Spring
│   │       └── FastTests.java        # Agent-fast tests
│   └── test/
│       └── java/com/example/
│           └── AppTests.java          # CI-only integration tests
├── build.gradle                       # Gradle with config cache
├── settings.gradle
├── gradle.properties
├── .gradle/
│   └── config.properties             # Optimized Gradle
└── Makefile
```

## Key Optimizations Applied

### 1. Disable Annotation Processors Locally

```gradle
// build.gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
}

// Agent-fast configuration
fastImplementation {
    exclude group: 'org.springframework.boot', module: 'spring-boot-starter-data-jpa'
    exclude group: 'org.springframework.boot', module: 'spring-boot-starter-web'
}

tasks.withType(JavaCompile).configureEach {
    options.annotationProcessorPath = configurations.fastAnnotationProcessor
    options.compilerArgs += [
        '-Amapstruct.defaultComponentModel=simple',
        '-Ajpa.default.package-access=FORBIDDEN'
    ]
}

// Disable annotation processors for fast builds
tasks.named('compileJava').configure {
    options.annotationProcessorPaths = []
    options.compilerArgs << '-proc:none'
}
```

### 2. No Spring in Inner Loop

```java
// src/fast/java/com/example/fast/FastUserService.java
// Plain Java - no Spring, no DI, no context

package com.example.fast;

import com.example.app.domain.User;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class FastUserService {
    
    private final List<User> users = new ArrayList<>();
    
    // Plain constructor - no DI container
    public FastUserService() {
        // No Spring initialization
    }
    
    public User createUser(String name, String email) {
        User user = new User();
        user.setId(System.currentTimeMillis());
        user.setName(name);
        user.setEmail(email);
        users.add(user);
        return user;
    }
    
    public Optional<User> getUser(Long id) {
        return users.stream()
            .filter(u -> u.getId().equals(id))
            .findFirst();
    }
    
    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }
}
```

### 3. Gradle Configuration Cache + DevFast Task

```gradle
// build.gradle - Optimized for agents
tasks.register('devFast', JavaExec) {
    group = 'development'
    description = 'Run fast unit tests without Spring'
    
    mainClass = 'com.example.fast.FastTests'
    
    classpath = sourceSets.fast.runtimeClasspath
    
    jvmArgs = [
        '-XX:+UseSerialGC',
        '-Xms256m',
        '-Xmx512m',
        '-Djava.awt.headless=true'
    ]
}

tasks.register('typecheck') {
    group = 'verification'
    description = 'Fast type check without full build'
    dependsOn classes
}

test {
    useJUnitPlatform()
    exclude '**/*IntegrationTest*'
    exclude '**/*SlowTest*'
}

// CI-only full test
tasks.register('testFull') {
    group = 'verification'
    description = 'Full test suite including integration tests'
    dependsOn test
}
```

### 4. JUnit 5 Fast Tests

```java
// src/fast/java/com/example/fast/FastTests.java
// Fast unit tests - no Spring context

package com.example.fast;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

import com.example.app.domain.User;

class FastUserServiceTest {
    
    private FastUserService service;
    
    @BeforeEach
    void setUp() {
        // Plain Java setup - no Spring context
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
        
        var allUsers = service.getAllUsers();
        assertEquals(2, allUsers.size());
    }
}
```

### 5. Pure Domain Model

```java
// src/main/java/com/example/app/domain/User.java
package com.example.app.domain;

import jakarta.persistence.*;
import java.time.Instant;

@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String email;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = Instant.now();
    }
    
    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public Instant getCreatedAt() { return createdAt; }
}
```

## Commands

```makefile
# Agent-fast command (seconds) - ALWAYS run this
fast-test:
	@./gradlew devFast

# Type check only (instant feedback)
typecheck:
	@./gradlew compileJava --incremental

# Full test suite (CI only - slow)
test-full:
	@./gradlew testFull

# Build JAR
build:
	@./gradlew bootJar

# Clean
clean:
	@./gradlew clean
```

## Key Principles

1. **No Spring in inner loop** - Plain constructors, manual wiring
2. **Disable annotation processors** - 10× compile speedup
3. **Gradle configuration cache** - No build reconfiguration
4. **Separate fast/test classpath** - Minimal dependencies
5. **JUnit 5 with Launcher** - Persistent JVM for tests
6. **Pure domain models** - No framework magic in hot path
