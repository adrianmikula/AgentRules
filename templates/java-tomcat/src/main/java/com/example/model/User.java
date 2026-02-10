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
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
