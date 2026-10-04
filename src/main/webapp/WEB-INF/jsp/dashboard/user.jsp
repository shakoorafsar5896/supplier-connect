<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Supplier Dashboard - SupplierConnect"/>
<c:set var="activePage" value="dashboard"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <!-- Top Navbar -->
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-house-user text-primary me-2"></i> Supplier Staff Portal</h5>
            <div class="user-profile-badge">
                <div class="text-end me-2">
                    <div class="fw-bold small">${pageContext.request.userPrincipal.name}</div>
                    <span class="badge bg-secondary style-xs">Staff User</span>
                </div>
                <div class="avatar-circle">U</div>
            </div>
        </header>

        <div class="container-fluid p-4">
            <!-- Welcome Banner -->
            <div class="p-4 rounded-4 text-white mb-4" style="background: linear-gradient(135deg, #1e293b 0%, #334155 100%);">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h4 class="fw-bold mb-1">Welcome back, ${pageContext.request.userPrincipal.name}!</h4>
                        <p class="text-white-50 mb-0">Create purchase orders, monitor shipment status, and check current stock availability.</p>
                    </div>
                    <div class="col-md-4 text-md-end mt-3 mt-md-0">
                        <a href="<c:url value='/orders/new'/>" class="btn btn-primary-gradient px-4 py-2.5 rounded-3">
                            <i class="fa-solid fa-cart-plus me-2"></i> Create New Order
                        </a>
                    </div>
                </div>
            </div>

            <!-- Summary Card & Inventory Search -->
            <div class="row g-4 mb-4">
                <div class="col-md-4">
                    <div class="stat-card d-flex align-items-center justify-content-between h-100">
                        <div>
                            <div class="text-muted small fw-medium">Your Active Orders</div>
                            <h2 class="fw-bold m-0 mt-1 text-primary">${userActiveOrders}</h2>
                            <div class="text-muted style-xs mt-1">Pending process or delivery</div>
                        </div>
                        <div class="stat-icon icon-blue">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card border-0 shadow-sm rounded-4 h-100">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="fa-solid fa-magnifying-glass me-2 text-primary"></i> Inventory Search Widget</h6>
                            <form action="<c:url value='/products'/>" method="get" class="row g-2">
                                <div class="col-md-9">
                                    <input type="text" name="search" class="form-control" placeholder="Search by Product Name or Code (e.g., PRD-5001)">
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-search me-1"></i> Search Catalog</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- User's Recent Orders -->
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-header bg-white py-3 border-0 d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold m-0"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Your Recent Purchase Orders</h6>
                    <a href="<c:url value='/orders'/>" class="btn btn-sm btn-outline-primary rounded-pill">View All My Orders</a>
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
                                        <td>${order.formattedOrderDate}</td>
                                        <td class="fw-semibold">$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td>
                                            <span class="badge badge-status badge-${order.status.name().toLowerCase()}">${order.status}</span>
                                        </td>
                                        <td>
                                            <a href="<c:url value='/orders/${order.id}'/>" class="btn btn-sm btn-light border"><i class="fa-solid fa-eye text-secondary"></i> View</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentOrders}">
                                    <tr><td colspan="6" class="text-center py-4 text-muted">You have not created any purchase orders yet. <a href="<c:url value='/orders/new'/>">Create one now</a>.</td></tr>
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
