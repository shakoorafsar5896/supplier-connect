package com.supplierconnect.controller;

import com.supplierconnect.model.Product;
import com.supplierconnect.service.ProductService;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public String listProducts(@RequestParam(value = "search", required = false) String search,
                               @RequestParam(value = "lowStock", required = false, defaultValue = "false") boolean lowStock,
                               Model model) {
        List<Product> products;
        if (lowStock) {
            products = productService.getLowStockProducts();
        } else {
            products = productService.searchProducts(search);
        }

        model.addAttribute("products", products);
        model.addAttribute("search", search);
        model.addAttribute("lowStockOnly", lowStock);
        return "products/list";
    }

    @GetMapping("/new")
    @PreAuthorize("hasRole('ADMIN')")
    public String showCreateForm(Model model) {
        model.addAttribute("product", new Product());
        model.addAttribute("isEdit", false);
        return "products/form";
    }

    @GetMapping("/edit/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String showEditForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        return productService.getProductById(id)
                .map(product -> {
                    model.addAttribute("product", product);
                    model.addAttribute("isEdit", true);
                    return "products/form";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("errorMessage", "Product not found");
                    return "redirect:/products";
                });
    }

    @PostMapping("/save")
    @PreAuthorize("hasRole('ADMIN')")
    public String saveProduct(@Valid @ModelAttribute("product") Product product,
                              BindingResult bindingResult,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("isEdit", product.getId() != null);
            return "products/form";
        }

        try {
            if (product.getId() == null) {
                productService.saveProduct(product);
                redirectAttributes.addFlashAttribute("successMessage", "Product created successfully!");
            } else {
                productService.updateProduct(product);
                redirectAttributes.addFlashAttribute("successMessage", "Product updated successfully!");
            }
            return "redirect:/products";
        } catch (IllegalArgumentException ex) {
            bindingResult.rejectValue("productCode", "error.productCode", ex.getMessage());
            model.addAttribute("isEdit", product.getId() != null);
            return "products/form";
        }
    }

    @GetMapping("/delete/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteProduct(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            productService.deleteProduct(id);
            redirectAttributes.addFlashAttribute("successMessage", "Product removed from catalog.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Cannot delete product referenced in existing order line items.");
        }
        return "redirect:/products";
    }
}
