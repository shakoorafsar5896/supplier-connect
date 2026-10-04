package com.supplierconnect.repository;

import com.supplierconnect.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    Optional<Product> findByProductCode(String productCode);

    boolean existsByProductCode(String productCode);

    List<Product> findByNameContainingIgnoreCaseOrProductCodeContainingIgnoreCase(String name, String productCode);

    @Query("SELECT p FROM Product p WHERE p.stockQuantity <= p.reorderLevel")
    List<Product> findLowStockProducts();

    long countByStockQuantityLessThanEqual(Integer threshold);
}
