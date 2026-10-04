package com.supplierconnect.controller;

import com.supplierconnect.model.OrderStatus;
import com.supplierconnect.model.User;
import com.supplierconnect.service.OrderService;
import com.supplierconnect.service.ProductService;
import com.supplierconnect.service.SupplierService;
import com.supplierconnect.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    private final OrderService orderService;
    private final SupplierService supplierService;
    private final ProductService productService;
    private final UserService userService;

    public DashboardController(OrderService orderService,
                               SupplierService supplierService,
                               ProductService productService,
                               UserService userService) {
        this.orderService = orderService;
        this.supplierService = supplierService;
        this.productService = productService;
        this.userService = userService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        if (authentication == null) {
            return "redirect:/login";
        }

        String username = authentication.getName();
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (isAdmin) {
            model.addAttribute("totalOrders", orderService.countTotalOrders());
            model.addAttribute("pendingOrders", orderService.countOrdersByStatus(OrderStatus.PENDING));
            model.addAttribute("totalSuppliers", supplierService.getAllSuppliers().size());
            model.addAttribute("lowStockCount", productService.getLowStockCount());
            model.addAttribute("recentOrders", orderService.getRecentOrders());
            model.addAttribute("lowStockProducts", productService.getLowStockProducts());
            return "dashboard/admin";
        } else {
            User currentUser = userService.getUserByUsername(username).orElse(null);
            if (currentUser != null) {
                model.addAttribute("userActiveOrders", orderService.countUserOrdersByStatus(currentUser, OrderStatus.PENDING));
                model.addAttribute("recentOrders", orderService.getRecentOrdersByUser(currentUser));
            }
            model.addAttribute("products", productService.getAllProducts());
            return "dashboard/user";
        }
    }
}
