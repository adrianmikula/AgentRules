// src/fast/java/com/example/fast/FastUserService.java
// Plain Java - no servlet API, no Tomcat, no container

package com.example.fast;

import com.example.model.User;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

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
    
    public boolean deleteUser(Long id) {
        return users.remove(id) != null;
    }
    
    public int getUserCount() {
        return users.size();
    }
}
