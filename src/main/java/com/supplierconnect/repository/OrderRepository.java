package com.supplierconnect.repository;

import com.supplierconnect.model.Order;
import com.supplierconnect.model.OrderStatus;
import com.supplierconnect.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    Optional<Order> findByOrderNumber(String orderNumber);

    List<Order> findByCreatedBy(User user);

    List<Order> findByStatus(OrderStatus status);

    List<Order> findByCreatedByAndStatus(User user, OrderStatus status);

    long countByStatus(OrderStatus status);

    List<Order> findTop5ByOrderByOrderDateDesc();

    List<Order> findTop5ByCreatedByOrderByOrderDateDesc(User createdBy);
}
