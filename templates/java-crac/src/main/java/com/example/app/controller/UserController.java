package com.example.app.controller;

import com.example.app.domain.User;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private final List<User> users = Arrays.asList(
        new User(1L, "User 1", "user1@example.com"),
        new User(2L, "User 2", "user2@example.com"),
        new User(3L, "User 3", "user3@example.com")
    );
    
    @GetMapping
    public List<User> getUsers() {
        return users;
    }
    
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return new User(id, "User " + id, "user" + id + "@example.com");
    }
}
