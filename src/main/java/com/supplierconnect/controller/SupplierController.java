package com.supplierconnect.controller;

import com.supplierconnect.model.Supplier;
import com.supplierconnect.service.SupplierService;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/suppliers")
public class SupplierController {

    private final SupplierService supplierService;

    public SupplierController(SupplierService supplierService) {
        this.supplierService = supplierService;
    }

    @GetMapping
    public String listSuppliers(@RequestParam(value = "search", required = false) String search, Model model) {
        List<Supplier> suppliers = supplierService.searchSuppliers(search);
        model.addAttribute("suppliers", suppliers);
        model.addAttribute("search", search);
        return "suppliers/list";
    }

    @GetMapping("/new")
    @PreAuthorize("hasRole('ADMIN')")
    public String showCreateForm(Model model) {
        model.addAttribute("supplier", new Supplier());
        model.addAttribute("isEdit", false);
        return "suppliers/form";
    }

    @GetMapping("/edit/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String showEditForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        return supplierService.getSupplierById(id)
                .map(supplier -> {
                    model.addAttribute("supplier", supplier);
                    model.addAttribute("isEdit", true);
                    return "suppliers/form";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("errorMessage", "Supplier not found");
                    return "redirect:/suppliers";
                });
    }

    @PostMapping("/save")
    @PreAuthorize("hasRole('ADMIN')")
    public String saveSupplier(@Valid @ModelAttribute("supplier") Supplier supplier,
                               BindingResult bindingResult,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("isEdit", supplier.getId() != null);
            return "suppliers/form";
        }

        try {
            if (supplier.getId() == null) {
                supplierService.saveSupplier(supplier);
                redirectAttributes.addFlashAttribute("successMessage", "Supplier created successfully!");
            } else {
                supplierService.updateSupplier(supplier);
                redirectAttributes.addFlashAttribute("successMessage", "Supplier updated successfully!");
            }
            return "redirect:/suppliers";
        } catch (IllegalArgumentException ex) {
            bindingResult.rejectValue("supplierCode", "error.supplierCode", ex.getMessage());
            model.addAttribute("isEdit", supplier.getId() != null);
            return "suppliers/form";
        }
    }

    @GetMapping("/delete/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteSupplier(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            supplierService.deleteSupplier(id);
            redirectAttributes.addFlashAttribute("successMessage", "Supplier deleted successfully.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cannot delete supplier associated with active orders.");
        }
        return "redirect:/suppliers";
    }
}
