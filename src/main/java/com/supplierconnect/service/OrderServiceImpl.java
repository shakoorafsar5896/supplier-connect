package com.supplierconnect.service;

import com.supplierconnect.model.*;
import com.supplierconnect.repository.OrderRepository;
import com.supplierconnect.repository.ProductRepository;
import com.supplierconnect.repository.SupplierRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;
    private final SupplierRepository supplierRepository;
    private final ProductService productService;

    public OrderServiceImpl(OrderRepository orderRepository,
                            ProductRepository productRepository,
                            SupplierRepository supplierRepository,
                            ProductService productService) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
        this.supplierRepository = supplierRepository;
        this.productService = productService;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> getOrdersByUser(User user) {
        return orderRepository.findByCreatedBy(user);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Order> getOrderById(Long id) {
        return orderRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Order> getOrderByNumber(String orderNumber) {
        return orderRepository.findByOrderNumber(orderNumber);
    }

    @Override
    public Order createOrder(Order order, List<Long> productIds, List<Integer> quantities) {
        if (order.getSupplier() == null || order.getSupplier().getId() == null) {
            throw new IllegalArgumentException("A valid supplier must be selected for the order");
        }

        Supplier supplier = supplierRepository.findById(order.getSupplier().getId())
                .orElseThrow(() -> new IllegalArgumentException("Selected supplier does not exist"));
        order.setSupplier(supplier);

        if (productIds == null || productIds.isEmpty() || quantities == null || quantities.size() != productIds.size()) {
            throw new IllegalArgumentException("At least one product item with a valid quantity must be added to the order");
        }

        order.setStatus(OrderStatus.PENDING);
        List<OrderItem> items = new ArrayList<>();

        for (int i = 0; i < productIds.size(); i++) {
            Long pId = productIds.get(i);
            Integer qty = quantities.get(i);

            if (pId == null || qty == null || qty <= 0) {
                continue;
            }

            Product product = productRepository.findById(pId)
                    .orElseThrow(() -> new IllegalArgumentException("Product not found with ID: " + pId));

            OrderItem item = new OrderItem(order, product, qty, product.getUnitPrice());
            items.add(item);
        }

        if (items.isEmpty()) {
            throw new IllegalArgumentException("Order must contain at least one valid product line item");
        }

        order.setOrderItems(items);
        order.calculateTotalAmount();

        return orderRepository.save(order);
    }

    @Override
    public Order updateOrderStatus(Long orderId, OrderStatus newStatus) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new IllegalArgumentException("Order not found with ID: " + orderId));

        OrderStatus previousStatus = order.getStatus();

        if (previousStatus == newStatus) {
            return order;
        }

        // If transition to APPROVED or DELIVERED, deduct stock if not already deducted
        if ((newStatus == OrderStatus.APPROVED || newStatus == OrderStatus.DELIVERED) && previousStatus == OrderStatus.PENDING) {
            for (OrderItem item : order.getOrderItems()) {
                productService.updateStock(item.getProduct().getId(), -item.getQuantity());
            }
        }

        // If order is CANCELLED after being APPROVED or DELIVERED, restore stock
        if (newStatus == OrderStatus.CANCELLED && (previousStatus == OrderStatus.APPROVED || previousStatus == OrderStatus.DELIVERED || previousStatus == OrderStatus.SHIPPED)) {
            for (OrderItem item : order.getOrderItems()) {
                productService.updateStock(item.getProduct().getId(), item.getQuantity());
            }
        }

        order.setStatus(newStatus);
        return orderRepository.save(order);
    }

    @Override
    public void deleteOrder(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Order not found with ID: " + id));
        
        // If order was active/approved, restore stock before deleting
        if (order.getStatus() == OrderStatus.APPROVED || order.getStatus() == OrderStatus.SHIPPED) {
            for (OrderItem item : order.getOrderItems()) {
                productService.updateStock(item.getProduct().getId(), item.getQuantity());
            }
        }
        
        orderRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public long countTotalOrders() {
        return orderRepository.count();
    }

    @Override
    @Transactional(readOnly = true)
    public long countOrdersByStatus(OrderStatus status) {
        return orderRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public long countUserOrdersByStatus(User user, OrderStatus status) {
        return orderRepository.findByCreatedByAndStatus(user, status).size();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> getRecentOrders() {
        return orderRepository.findTop5ByOrderByOrderDateDesc();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> getRecentOrdersByUser(User user) {
        return orderRepository.findTop5ByCreatedByOrderByOrderDateDesc(user);
    }
}
