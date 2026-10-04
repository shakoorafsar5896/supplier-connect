package com.supplierconnect.service;

import com.supplierconnect.model.Supplier;
import com.supplierconnect.repository.SupplierRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class SupplierServiceImpl implements SupplierService {

    private final SupplierRepository supplierRepository;

    public SupplierServiceImpl(SupplierRepository supplierRepository) {
        this.supplierRepository = supplierRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Supplier> getAllSuppliers() {
        return supplierRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Supplier> getActiveSuppliers() {
        return supplierRepository.findByStatus("ACTIVE");
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Supplier> getSupplierById(Long id) {
        return supplierRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Supplier> getSupplierByCode(String code) {
        return supplierRepository.findBySupplierCode(code);
    }

    @Override
    public Supplier saveSupplier(Supplier supplier) {
        if (supplier.getId() == null && supplierRepository.existsBySupplierCode(supplier.getSupplierCode())) {
            throw new IllegalArgumentException("Supplier code already exists");
        }
        return supplierRepository.save(supplier);
    }

    @Override
    public Supplier updateSupplier(Supplier supplier) {
        Supplier existing = supplierRepository.findById(supplier.getId())
                .orElseThrow(() -> new IllegalArgumentException("Supplier not found"));
        existing.setName(supplier.getName());
        existing.setContactPerson(supplier.getContactPerson());
        existing.setEmail(supplier.getEmail());
        existing.setPhone(supplier.getPhone());
        existing.setAddress(supplier.getAddress());
        existing.setStatus(supplier.getStatus());
        return supplierRepository.save(existing);
    }

    @Override
    public void deleteSupplier(Long id) {
        supplierRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Supplier> searchSuppliers(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllSuppliers();
        }
        return supplierRepository.findByNameContainingIgnoreCaseOrSupplierCodeContainingIgnoreCase(query, query);
    }
}
