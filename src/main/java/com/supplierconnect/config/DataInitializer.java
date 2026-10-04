package com.supplierconnect.config;

import com.supplierconnect.model.Role;
import com.supplierconnect.model.User;
import com.supplierconnect.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.logging.Logger;

@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = Logger.getLogger(DataInitializer.class.getName());


    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public DataInitializer(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        logger.info("Initializing/verifying system seed accounts...");

        User admin = userRepository.findByUsername("admin").orElse(new User());
        admin.setUsername("admin");
        admin.setPassword(passwordEncoder.encode("admin123"));
        admin.setEmail("admin@supplierconnect.com");
        admin.setRole(Role.ADMIN);
        admin.setEnabled(true);
        userRepository.save(admin);
        logger.info("Admin account initialized: admin / admin123");

        User user1 = userRepository.findByUsername("user1").orElse(new User());
        user1.setUsername("user1");
        user1.setPassword(passwordEncoder.encode("user123"));
        user1.setEmail("user1@supplierconnect.com");
        user1.setRole(Role.USER);
        user1.setEnabled(true);
        userRepository.save(user1);
        logger.info("User account initialized: user1 / user123");
    }
}
