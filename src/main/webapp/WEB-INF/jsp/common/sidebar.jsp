<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-boxes-packing"></i>
        <span>SupplierConnect</span>
    </div>

    <ul class="nav flex-column mt-3">
        <li class="nav-item">
            <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="<c:url value='/dashboard'/>">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activePage == 'orders' ? 'active' : ''}" href="<c:url value='/orders'/>">
                <i class="fa-solid fa-file-invoice-dollar"></i> Purchase Orders
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activePage == 'products' ? 'active' : ''}" href="<c:url value='/products'/>">
                <i class="fa-solid fa-box"></i> Inventory Catalog
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activePage == 'suppliers' ? 'active' : ''}" href="<c:url value='/suppliers'/>">
                <i class="fa-solid fa-truck-field"></i> Supplier Master
            </a>
        </li>

        <!-- Exclusive Access for ADMIN Only: User Management module -->
        <sec:authorize access="hasRole('ADMIN')">
            <li class="nav-item mt-2">
                <span class="px-3 text-uppercase text-muted fw-bold style-xs" style="font-size: 0.7rem; letter-spacing: 1px;">Administration</span>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activePage == 'users' ? 'active' : ''}" href="<c:url value='/users'/>">
                    <i class="fa-solid fa-users-gear"></i> User Management
                </a>
            </li>
        </sec:authorize>
    </ul>

    <div class="mt-auto p-3 border-top border-secondary border-opacity-25" style="position: absolute; bottom: 0; width: 260px;">
        <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center gap-2 overflow-hidden">
                <div class="avatar-circle">
                    <sec:authentication property="name" var="loggedUser"/>
                    <c:out value="${loggedUser != null && loggedUser.length() > 0 ? loggedUser.substring(0, 1).toUpperCase() : 'U'}"/>
                </div>
                <div class="text-truncate">
                    <div class="fw-bold text-white small"><sec:authentication property="name"/></div>
                    <div class="text-muted style-xs" style="font-size: 0.75rem;">
                        <sec:authorize access="hasRole('ADMIN')">Admin</sec:authorize>
                        <sec:authorize access="hasRole('USER')">Supplier Staff</sec:authorize>
                    </div>
                </div>
            </div>
            <a href="<c:url value='/logout'/>" class="btn btn-sm btn-outline-light border-0" title="Logout">
                <i class="fa-solid fa-right-from-bracket"></i>
            </a>
        </div>
    </div>
</div>
