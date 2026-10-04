<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="Order #${order.orderNumber} Details - SupplierConnect"/>
<c:set var="activePage" value="orders"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <div class="d-flex align-items-center gap-3">
                <a href="<c:url value='/orders'/>" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left"></i></a>
                <h5 class="fw-bold m-0">Order #${order.orderNumber}</h5>
                <span class="badge badge-status badge-${order.status.name().toLowerCase()}">${order.status}</span>
            </div>
            <div>
                <button type="button" onclick="window.print()" class="btn btn-light border btn-sm me-2"><i class="fa-solid fa-print me-1"></i> Print PO</button>
            </div>
        </header>

        <div class="container-fluid p-4">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4 mb-4">
                <!-- Supplier & Meta Info Card -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-body p-4">
                            <div class="row g-3">
                                <div class="col-md-6 border-end">
                                    <h6 class="text-uppercase text-muted fw-bold style-xs mb-2" style="font-size: 0.75rem;">Supplier Information</h6>
                                    <h5 class="fw-bold text-dark mb-1">${order.supplier != null ? order.supplier.name : 'N/A'}</h5>
                                    <div class="text-secondary small">Code: ${order.supplier.supplierCode}</div>
                                    <div class="text-secondary small"><i class="fa-solid fa-user me-1 text-muted"></i> Contact: ${order.supplier.contactPerson}</div>
                                    <div class="text-secondary small"><i class="fa-solid fa-envelope me-1 text-muted"></i> ${order.supplier.email}</div>
                                    <div class="text-secondary small"><i class="fa-solid fa-phone me-1 text-muted"></i> ${order.supplier.phone}</div>
                                </div>
                                <div class="col-md-6 ps-md-4">
                                    <h6 class="text-uppercase text-muted fw-bold style-xs mb-2" style="font-size: 0.75rem;">Order Metadata</h6>
                                    <div class="mb-1 small"><strong>Created By:</strong> ${order.createdBy != null ? order.createdBy.username : 'System'}</div>
                                    <div class="mb-1 small"><strong>Order Date:</strong> <fmt:parseDate value="${order.orderDate}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both"/><fmt:formatDate value="${pDate}" pattern="MMMM dd, yyyy - HH:mm"/></div>
                                    <div class="mb-1 small"><strong>Expected Delivery:</strong> ${order.expectedDeliveryDate != null ? order.expectedDeliveryDate : 'Not specified'}</div>
                                    <c:if test="${not empty order.notes}">
                                        <div class="mt-2 p-2 rounded bg-light small text-muted">
                                            <strong>Notes:</strong> ${order.notes}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Status Lifecycle Update Control -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-header bg-white py-3 border-0">
                            <h6 class="fw-bold m-0 text-primary"><i class="fa-solid fa-sliders me-2"></i> Update Order Status</h6>
                        </div>
                        <div class="card-body">
                            <form action="<c:url value='/orders/${order.id}/status'/>" method="post">
                                <div class="mb-3">
                                    <label class="form-label small fw-semibold text-secondary">Change Order Status</label>
                                    <select name="status" class="form-select">
                                        <c:forEach var="st" items="${statuses}">
                                            <option value="${st}" ${order.status == st ? 'selected' : ''}>${st}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary w-100 py-2">
                                    <i class="fa-solid fa-arrows-rotate me-1"></i> Update Status
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Line Items Table -->
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-header bg-white py-3 border-0">
                    <h6 class="fw-bold m-0"><i class="fa-solid fa-boxes-packing me-2 text-primary"></i> Order Items Breakdown</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle table-custom mb-0">
                            <thead>
                                <tr>
                                    <th>Item #</th>
                                    <th>Product Code</th>
                                    <th>Product Description</th>
                                    <th>Unit Price</th>
                                    <th>Quantity</th>
                                    <th class="text-end">Line Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.orderItems}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td class="fw-semibold text-secondary">${item.product.productCode}</td>
                                        <td class="fw-bold">${item.product.name}</td>
                                        <td>$<fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td><span class="badge bg-light text-dark border px-3 py-2 fs-6">${item.quantity}</span></td>
                                        <td class="text-end fw-bold">$<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr class="table-light">
                                    <td colspan="5" class="text-end fw-bold fs-5 text-secondary">Grand Total Amount:</td>
                                    <td class="text-end fw-bold fs-4 text-primary">$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
