package com.supplierconnect.service;

import com.supplierconnect.model.Product;

import java.util.List;
import java.util.Optional;

public interface ProductService {

    List<Product> getAllProducts();

    Optional<Product> getProductById(Long id);

    Optional<Product> getProductByCode(String code);

    Product saveProduct(Product product);

    Product updateProduct(Product product);

    void deleteProduct(Long id);

    List<Product> searchProducts(String query);

    List<Product> getLowStockProducts();

    long getLowStockCount();

    void updateStock(Long productId, Integer quantityDelta);
}
