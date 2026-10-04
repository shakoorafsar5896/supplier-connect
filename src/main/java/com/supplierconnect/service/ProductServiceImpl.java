package com.supplierconnect.service;

import com.supplierconnect.model.Product;
import com.supplierconnect.repository.ProductRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;

    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Product> getProductByCode(String code) {
        return productRepository.findByProductCode(code);
    }

    @Override
    public Product saveProduct(Product product) {
        if (product.getId() == null && productRepository.existsByProductCode(product.getProductCode())) {
            throw new IllegalArgumentException("Product code already exists");
        }
        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Product product) {
        Product existing = productRepository.findById(product.getId())
                .orElseThrow(() -> new IllegalArgumentException("Product not found"));
        existing.setName(product.getName());
        existing.setCategory(product.getCategory());
        existing.setUnitPrice(product.getUnitPrice());
        existing.setStockQuantity(product.getStockQuantity());
        existing.setReorderLevel(product.getReorderLevel());
        existing.setDescription(product.getDescription());
        return productRepository.save(existing);
    }

    @Override
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> searchProducts(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllProducts();
        }
        return productRepository.findByNameContainingIgnoreCaseOrProductCodeContainingIgnoreCase(query, query);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Product> getLowStockProducts() {
        return productRepository.findLowStockProducts();
    }

    @Override
    @Transactional(readOnly = true)
    public long getLowStockCount() {
        return productRepository.findLowStockProducts().size();
    }

    @Override
    public void updateStock(Long productId, Integer quantityDelta) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalArgumentException("Product not found"));
        int updatedStock = (product.getStockQuantity() != null ? product.getStockQuantity() : 0) + quantityDelta;
        if (updatedStock < 0) {
            throw new IllegalArgumentException("Insufficient inventory for product: " + product.getName());
        }
        product.setStockQuantity(updatedStock);
        productRepository.save(product);
    }
}
