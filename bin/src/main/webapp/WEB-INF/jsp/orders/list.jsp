<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="Purchase Orders - SupplierConnect"/>
<c:set var="activePage" value="orders"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-file-invoice-dollar text-primary me-2"></i> Purchase Orders Management</h5>
            <div>
                <a href="<c:url value='/orders/new'/>" class="btn btn-primary-gradient px-3">
                    <i class="fa-solid fa-plus me-1"></i> New Purchase Order
                </a>
            </div>
        </header>

        <div class="container-fluid p-4">
            <!-- Flash Message Banner -->
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

            <!-- Filter Bar -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body py-3">
                    <form action="<c:url value='/orders'/>" method="get" class="row g-3 align-items-center">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-secondary m-0 me-2">Filter by Status:</label>
                            <select name="status" class="form-select form-select-sm d-inline-block w-auto" onchange="this.form.submit()">
                                <option value="">-- All Statuses --</option>
                                <c:forEach var="st" items="${statuses}">
                                    <option value="${st}" ${selectedStatus == st ? 'selected' : ''}>${st}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <c:if test="${not empty selectedStatus}">
                            <div class="col-md-2">
                                <a href="<c:url value='/orders'/>" class="btn btn-sm btn-link text-muted">Clear Filter</a>
                            </div>
                        </c:if>
                    </form>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle table-custom mb-0">
                            <thead>
                                <tr>
                                    <th>Order #</th>
                                    <th>Supplier</th>
                                    <th>Created By</th>
                                    <th>Order Date</th>
                                    <th>Expected Delivery</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td class="fw-bold text-primary">#${order.orderNumber}</td>
                                        <td>${order.supplier != null ? order.supplier.name : 'N/A'}</td>
                                        <td>${order.createdBy != null ? order.createdBy.username : 'System'}</td>
                                        <td><fmt:parseDate value="${order.orderDate}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both"/><fmt:formatDate value="${pDate}" pattern="MMM dd, yyyy"/></td>
                                        <td>${order.expectedDeliveryDate != null ? order.expectedDeliveryDate : 'N/A'}</td>
                                        <td class="fw-bold">$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td>
                                            <span class="badge badge-status badge-${order.status.name().toLowerCase()}">${order.status}</span>
                                        </td>
                                        <td class="text-end">
                                            <a href="<c:url value='/orders/${order.id}'/>" class="btn btn-sm btn-outline-primary me-1" title="View Details">
                                                <i class="fa-solid fa-eye"></i> View
                                            </a>
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteModal-${order.id}" title="Delete Order">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>

                                                <!-- Delete Confirmation Modal -->
                                                <div class="modal fade text-start" id="deleteModal-${order.id}" tabindex="-1">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header border-0">
                                                                <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i> Confirm Order Deletion</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                Are you sure you want to delete purchase order <strong>#${order.orderNumber}</strong>? This action cannot be undone.
                                                            </div>
                                                            <div class="modal-footer border-0">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                                <a href="<c:url value='/orders/delete/${order.id}'/>" class="btn btn-danger">Confirm Delete</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </sec:authorize>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty orders}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="fa-solid fa-box-open fa-2x mb-3 text-secondary"></i>
                                            <div>No purchase orders found.</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
