<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Create Purchase Order - SupplierConnect"/>
<c:set var="activePage" value="orders"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-cart-plus text-primary me-2"></i> Create Purchase Order</h5>
            <a href="<c:url value='/orders'/>" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Back to Orders</a>
        </header>

        <div class="container-fluid p-4">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="<c:url value='/orders/save'/>" method="post">
                <div class="row g-4">
                    <!-- Order Header Info -->
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-header bg-white py-3 border-0">
                                <h6 class="fw-bold m-0 text-primary"><i class="fa-solid fa-circle-info me-2"></i> Order Header Details</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Supplier <span class="text-danger">*</span></label>
                                    <select name="supplier.id" class="form-select" required>
                                        <option value="">-- Select Supplier --</option>
                                        <c:forEach var="sup" items="${suppliers}">
                                            <option value="${sup.id}">${sup.name} (${sup.supplierCode})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Expected Delivery Date</label>
                                    <input type="date" name="expectedDeliveryDate" class="form-control">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Order Notes / Instructions</label>
                                    <textarea name="notes" class="form-control" rows="4" placeholder="Special packaging or shipping directions..."></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Line Items Table -->
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                                <h6 class="fw-bold m-0 text-primary"><i class="fa-solid fa-boxes-stacked me-2"></i> Line Items</h6>
                                <button type="button" id="add-item-btn" class="btn btn-sm btn-outline-primary rounded-pill">
                                    <i class="fa-solid fa-plus me-1"></i> Add Product Line
                                </button>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table align-middle table-custom mb-0">
                                        <thead>
                                            <tr>
                                                <th style="width: 45%;">Product</th>
                                                <th style="width: 20%;">Unit Price ($)</th>
                                                <th style="width: 15%;">Quantity</th>
                                                <th style="width: 15%;">Subtotal</th>
                                                <th style="width: 5%;">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="order-items-container">
                                            <!-- Default First Row -->
                                            <tr class="order-item-row">
                                                <td>
                                                    <select name="productIds" class="form-select product-select" required>
                                                        <option value="">-- Choose Product --</option>
                                                        <c:forEach var="prd" items="${products}">
                                                            <option value="${prd.id}" data-price="${prd.unitPrice}">${prd.name} (${prd.productCode}) - Stock: ${prd.stockQuantity}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td>
                                                    <input type="number" step="0.01" class="form-control unit-price-input" readonly placeholder="0.00">
                                                </td>
                                                <td>
                                                    <input type="number" name="quantities" class="form-control qty-input" min="1" value="1" required>
                                                </td>
                                                <td>
                                                    <span class="fw-bold text-dark item-subtotal">$0.00</span>
                                                </td>
                                                <td class="text-center">
                                                    <button type="button" class="btn btn-sm btn-link text-danger remove-item-btn"><i class="fa-solid fa-trash"></i></button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                                <div class="h5 m-0 fw-bold text-secondary">
                                    Grand Total: <span id="grand-total" class="text-primary fw-extrabold">$0.00</span>
                                </div>
                                <button type="submit" class="btn btn-primary-gradient px-4 py-2 rounded-3">
                                    <i class="fa-solid fa-paper-plane me-2"></i> Submit Order
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Template for Dynamic Row Addition -->
<template id="order-item-template">
    <tr class="order-item-row">
        <td>
            <select name="productIds" class="form-select product-select" required>
                <option value="">-- Choose Product --</option>
                <c:forEach var="prd" items="${products}">
                    <option value="${prd.id}" data-price="${prd.unitPrice}">${prd.name} (${prd.productCode}) - Stock: ${prd.stockQuantity}</option>
                </c:forEach>
            </select>
        </td>
        <td>
            <input type="number" step="0.01" class="form-control unit-price-input" readonly placeholder="0.00">
        </td>
        <td>
            <input type="number" name="quantities" class="form-control qty-input" min="1" value="1" required>
        </td>
        <td>
            <span class="fw-bold text-dark item-subtotal">$0.00</span>
        </td>
        <td class="text-center">
            <button type="button" class="btn btn-sm btn-link text-danger remove-item-btn"><i class="fa-solid fa-trash"></i></button>
        </td>
    </tr>
</template>

<%@ include file="../common/footer.jsp" %>
