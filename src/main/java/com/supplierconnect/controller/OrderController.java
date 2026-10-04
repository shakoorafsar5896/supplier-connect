package com.supplierconnect.controller;

import com.supplierconnect.model.*;
import com.supplierconnect.service.OrderService;
import com.supplierconnect.service.ProductService;
import com.supplierconnect.service.SupplierService;
import com.supplierconnect.service.UserService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;
    private final SupplierService supplierService;
    private final ProductService productService;
    private final UserService userService;

    public OrderController(OrderService orderService,
                           SupplierService supplierService,
                           ProductService productService,
                           UserService userService) {
        this.orderService = orderService;
        this.supplierService = supplierService;
        this.productService = productService;
        this.userService = userService;
    }

    @GetMapping
    public String listOrders(@RequestParam(value = "status", required = false) OrderStatus status,
                             Authentication authentication,
                             Model model) {
        String username = authentication.getName();
        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        List<Order> orders;
        if (isAdmin) {
            if (status != null) {
                orders = orderService.getAllOrders().stream()
                        .filter(o -> o.getStatus() == status)
                        .toList();
            } else {
                orders = orderService.getAllOrders();
            }
        } else {
            User currentUser = userService.getUserByUsername(username).orElse(null);
            if (status != null) {
                orders = orderService.getOrdersByUser(currentUser).stream()
                        .filter(o -> o.getStatus() == status)
                        .toList();
            } else {
                orders = orderService.getOrdersByUser(currentUser);
            }
        }

        model.addAttribute("orders", orders);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("statuses", OrderStatus.values());
        return "orders/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        Order order = new Order();
        model.addAttribute("order", order);
        model.addAttribute("suppliers", supplierService.getActiveSuppliers());
        model.addAttribute("products", productService.getAllProducts());
        return "orders/create";
    }

    @PostMapping("/save")
    public String saveOrder(@ModelAttribute("order") Order order,
                            @RequestParam(value = "productIds", required = false) List<Long> productIds,
                            @RequestParam(value = "quantities", required = false) List<Integer> quantities,
                            Authentication authentication,
                            RedirectAttributes redirectAttributes) {
        try {
            String username = authentication.getName();
            User currentUser = userService.getUserByUsername(username).orElse(null);
            order.setCreatedBy(currentUser);

            Order savedOrder = orderService.createOrder(order, productIds, quantities);
            redirectAttributes.addFlashAttribute("successMessage", "Order #" + savedOrder.getOrderNumber() + " created successfully!");
            return "redirect:/orders/" + savedOrder.getId();
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/orders/new";
        }
    }

    @GetMapping("/{id}")
    public String viewOrderDetail(@PathVariable("id") Long id, Authentication authentication, Model model, RedirectAttributes redirectAttributes) {
        return orderService.getOrderById(id)
                .map(order -> {
                    String username = authentication.getName();
                    boolean isAdmin = authentication.getAuthorities().stream()
                            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

                    // Access check for normal user viewing orders
                    if (!isAdmin && (order.getCreatedBy() == null || !order.getCreatedBy().getUsername().equals(username))) {
                        redirectAttributes.addFlashAttribute("errorMessage", "Access Denied: You do not have permission to view this order.");
                        return "redirect:/orders";
                    }

                    model.addAttribute("order", order);
                    model.addAttribute("statuses", OrderStatus.values());
                    return "orders/detail";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("errorMessage", "Order not found");
                    return "redirect:/orders";
                });
    }

    @PostMapping("/{id}/status")
    public String updateStatus(@PathVariable("id") Long id,
                               @RequestParam("status") OrderStatus newStatus,
                               RedirectAttributes redirectAttributes) {
        try {
            orderService.updateOrderStatus(id, newStatus);
            redirectAttributes.addFlashAttribute("successMessage", "Order status updated to " + newStatus.name());
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update order status: " + ex.getMessage());
        }
        return "redirect:/orders/" + id;
    }

    @GetMapping("/delete/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String deleteOrder(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            orderService.deleteOrder(id);
            redirectAttributes.addFlashAttribute("successMessage", "Order deleted successfully.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete order: " + ex.getMessage());
        }
        return "redirect:/orders";
    }
}
