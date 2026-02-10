# Java+Tomcat Boilerplate - Agentic Dev Velocity

## Structure

```
java-tomcat-boilerplate/
├── src/
│   ├── main/
│   │   ├── java/com/example/
│   │   │   ├── servlet/
│   │   │   │   └── UserServlet.java       # Tomcat servlet (CI/deploy)
│   │   │   ├── model/
│   │   │   │   └── User.java              # Plain POJO
│   │   │   ├── service/
│   │   │   │   └── UserService.java      # Business logic
│   │   │   └── listener/
│   │   │       └── AppListener.java       # Tomcat lifecycle
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml                # Deployment descriptor
│   │       └── index.jsp                  # JSP view (CI)
│   ├── fast/
│   │   └── java/com/example/fast/
│   │       ├── FastUserService.java       # Plain Java, no Tomcat
│   │       └── FastTests.java             # Agent-fast tests
│   └── test/
│       └── java/com/example/
│           └── UserServletTest.java       # CI-only tests
├── pom.xml                                # Maven (Tomcat optimized)
├── Makefile
└── .maven/
    └── settings.xml                       # Optimized Maven settings
```

## Key Optimizations Applied

### 1. Pure Java for Inner Loop (No Tomcat in Loop)

```java
// src/fast/java/com/example/fast/FastUserService.java
// Plain Java - no servlet API, no Tomcat, no container

package com.example.fast;

import com.example.model.User;
import java.util.*;

public class FastUserService {
    
    private final Map<Long, User> users = new HashMap<>();
    private final AtomicLong idGenerator = new AtomicLong(1);
    
    // Plain constructor - no container dependency
    public FastUserService() {
        // No Tomcat initialization
    }
    
    public User createUser(String name, String email) {
        User user = new User();
        user.setId(idGenerator.getAndIncrement());
        user.setName(name);
        user.setEmail(email);
        users.put(user.getId(), user);
        return user;
    }
    
    public Optional<User> getUser(Long id) {
        return Optional.ofNullable(users.get(id));
    }
    
    public List<User> getAllUsers() {
        return new ArrayList<>(users.values());
    }
}
```

### 2. Minimal Maven Configuration

```xml
<!-- pom.xml - Optimized for Tomcat -->
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>java-tomcat-boilerplate</artifactId>
    <version>1.0.0</version>
    <packaging>war</packaging>
    
    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <!-- Disable annotation processing for fast compile -->
        <maven.compiler.proc>none</maven.compiler.proc>
    </properties>
    
    <dependencies>
        <!-- Servlet API (provided by Tomcat) -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>5.0.0</version>
            <scope>provided</scope>
        </dependency>
        
        <!-- Fast test dependencies -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-engine</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <!-- Fast compiler -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>11</source>
                    <target>11</target>
                    <proc>none</proc>
                    <fork>true</fork>
                    <useIncrementalCompilation>false</useIncrementalCompilation>
                </configuration>
            </plugin>
            
            <!-- Tomcat plugin for deployment -->
            <plugin>
                <groupId>org.apache.tomcat.maven</groupId>
                <artifactId>tomcat7-maven-plugin</artifactId>
                <version>2.2</version>
                <configuration>
                    <path>/</path>
                    <port>8080</port>
                    <contextFile>src/main/webapp/WEB-INF/context.xml</contextFile>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

### 3. JUnit 5 Fast Tests

```java
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
    @DisplayName("Get all users returns all created")
    void testGetAllUsers() {
        service.createUser("User1", "user1@example.com");
        service.createUser("User2", "user2@example.com");
        
        List<User> allUsers = service.getAllUsers();
        assertEquals(2, allUsers.size());
    }
}
```

### 4. Plain POJO Model

```java
// src/main/java/com/example/model/User.java
// Plain POJO - no annotations for inner loop

package com.example.model;

import java.time.Instant;

public class User {
    
    private Long id;
    private String name;
    private String email;
    private Instant createdAt;
    
    public User() {
        this.createdAt = Instant.now();
    }
    
    // Getters and setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public Instant getCreatedAt() {
        return createdAt;
    }
}
```

## Commands

```makefile
# Agent-fast command (seconds) - ALWAYS run this
fast-test:
	@mvn test -Dtest=FastTests -DfailIfNoTests=false

# Type check only (instant feedback)
typecheck:
	@mvn compile -q

# Full test suite (CI only - slow)
test-full:
	@mvn test

# Run Tomcat (CI/deploy only)
run:
	@mvn tomcat7:run

# Build WAR
build:
	@mvn package -DskipTests

# Clean
clean:
	@mvn clean
```

## Key Principles

1. **No Tomcat in inner loop** - Plain Java servlets, no container
2. **Minimal annotation processing** - Pure POJOs
3. **Separate fast/test classpath** - No servlet API in fast tests
4. **JVM reuse** - Don't fork JVM per test
5. **Plain POJO models** - No framework magic in hot path
6. **Fast Maven compiler** - Disable annotation processing locally
