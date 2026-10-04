package com.supplierconnect.controller;

import com.supplierconnect.model.Role;
import com.supplierconnect.model.User;
import com.supplierconnect.service.UserService;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/users")
@PreAuthorize("hasRole('ADMIN')")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public String listUsers(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        return "users/list";
    }

    @GetMapping("/new")
    public String showCreateUserForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("roles", Role.values());
        return "users/create";
    }

    @PostMapping("/save")
    public String saveUser(@Valid @ModelAttribute("user") User user,
                           BindingResult bindingResult,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("roles", Role.values());
            return "users/create";
        }

        try {
            userService.createUser(user);
            redirectAttributes.addFlashAttribute("successMessage", "User account '" + user.getUsername() + "' created successfully!");
            return "redirect:/users";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("roles", Role.values());
            model.addAttribute("errorMessage", ex.getMessage());
            return "users/create";
        }
    }

    @GetMapping("/toggle/{id}")
    public String toggleUserStatus(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            userService.toggleUserEnabled(id);
            redirectAttributes.addFlashAttribute("successMessage", "User account status toggled successfully.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error modifying user status: " + ex.getMessage());
        }
        return "redirect:/users";
    }
}
