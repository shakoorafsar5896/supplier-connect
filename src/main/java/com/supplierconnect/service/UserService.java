package com.supplierconnect.service;

import com.supplierconnect.model.User;

import java.util.List;
import java.util.Optional;

public interface UserService {

    List<User> getAllUsers();

    Optional<User> getUserById(Long id);

    Optional<User> getUserByUsername(String username);

    User createUser(User user);

    User updateUser(User user);

    void toggleUserEnabled(Long id);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);
}
