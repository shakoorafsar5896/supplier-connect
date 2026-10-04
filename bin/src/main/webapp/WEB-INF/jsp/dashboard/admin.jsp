<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Admin Executive Dashboard - SupplierConnect"/>
<c:set var="activePage" value="dashboard"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <!-- Top Header -->
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-gauge-high text-primary me-2"></i> Admin Executive Dashboard</h5>
            <div class="user-profile-badge">
                <div class="text-end me-2">
                    <div class="fw-bold small">${pageContext.request.userPrincipal.name}</div>
                    <span class="badge bg-primary style-xs">System Administrator</span>
                </div>
                <div class="avatar-circle">A</div>
            </div>
        </header>

        <div class="container-fluid p-4">
            <!-- Analytics Summary Cards -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted small fw-medium">Total Orders</div>
                            <h3 class="fw-bold m-0 mt-1">${totalOrders}</h3>
                        </div>
                        <div class="stat-icon icon-blue">
                            <i class="fa-solid fa-cart-shopping"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted small fw-medium">Pending Approval</div>
                            <h3 class="fw-bold m-0 mt-1 text-warning">${pendingOrders}</h3>
                        </div>
                        <div class="stat-icon icon-amber">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted small fw-medium">Active Suppliers</div>
                            <h3 class="fw-bold m-0 mt-1">${totalSuppliers}</h3>
                        </div>
                        <div class="stat-icon icon-green">
                            <i class="fa-solid fa-truck-field"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <div class="text-muted small fw-medium">Low Stock Alerts</div>
                            <h3 class="fw-bold m-0 mt-1 text-danger">${lowStockCount}</h3>
                        </div>
                        <div class="stat-icon icon-rose">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- Recent Orders Table -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                            <h6 class="fw-bold m-0"><i class="fa-solid fa-list-check me-2 text-primary"></i> Recent Purchase Orders</h6>
                            <a href="<c:url value='/orders'/>" class="btn btn-sm btn-outline-primary rounded-pill">View All Orders</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle table-custom mb-0">
                                    <thead>
                                        <tr>
                                            <th>Order #</th>
                                            <th>Supplier</th>
                                            <th>Date</th>
                                            <th>Amount</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="order" items="${recentOrders}">
                                            <tr>
                                                <td class="fw-bold text-primary">#${order.orderNumber}</td>
                                                <td>${order.supplier != null ? order.supplier.name : 'N/A'}</td>
                                                <td><fmt:parseDate value="${order.orderDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/><fmt:formatDate value="${parsedDate}" pattern="MMM dd, yyyy"/></td>
                                                <td class="fw-semibold">$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                                <td>
                                                    <span class="badge badge-status badge-${order.status.name().toLowerCase()}">${order.status}</span>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/orders/${order.id}'/>" class="btn btn-sm btn-light border"><i class="fa-solid fa-eye text-secondary"></i></a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty recentOrders}">
                                            <tr><td colspan="6" class="text-center py-4 text-muted">No recent orders found.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Low Stock Alert Panel -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 mb-4">
                        <div class="card-header bg-white py-3 border-0">
                            <h6 class="fw-bold m-0 text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i> Low Stock Warnings</h6>
                        </div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <c:forEach var="prod" items="${lowStockProducts}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                        <div>
                                            <div class="fw-semibold small">${prod.name}</div>
                                            <div class="text-muted style-xs">${prod.productCode} &bull; Threshold: ${prod.reorderLevel}</div>
                                        </div>
                                        <span class="badge bg-danger rounded-pill">${prod.stockQuantity} in stock</span>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty lowStockProducts}">
                                    <li class="list-group-item text-center py-4 text-muted small">All catalog items have healthy inventory levels.</li>
                                </c:if>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
