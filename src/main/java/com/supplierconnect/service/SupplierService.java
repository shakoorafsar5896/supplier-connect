package com.supplierconnect.service;

import com.supplierconnect.model.Supplier;

import java.util.List;
import java.util.Optional;

public interface SupplierService {

    List<Supplier> getAllSuppliers();

    List<Supplier> getActiveSuppliers();

    Optional<Supplier> getSupplierById(Long id);

    Optional<Supplier> getSupplierByCode(String code);

    Supplier saveSupplier(Supplier supplier);

    Supplier updateSupplier(Supplier supplier);

    void deleteSupplier(Long id);

    List<Supplier> searchSuppliers(String query);
}
