package com.supplierconnect.service;

import com.supplierconnect.model.Order;
import com.supplierconnect.model.OrderStatus;
import com.supplierconnect.model.User;

import java.util.List;
import java.util.Optional;

public interface OrderService {

    List<Order> getAllOrders();

    List<Order> getOrdersByUser(User user);

    Optional<Order> getOrderById(Long id);

    Optional<Order> getOrderByNumber(String orderNumber);

    Order createOrder(Order order, List<Long> productIds, List<Integer> quantities);

    Order updateOrderStatus(Long orderId, OrderStatus status);

    void deleteOrder(Long id);

    long countTotalOrders();

    long countOrdersByStatus(OrderStatus status);

    long countUserOrdersByStatus(User user, OrderStatus status);

    List<Order> getRecentOrders();

    List<Order> getRecentOrdersByUser(User user);
}
