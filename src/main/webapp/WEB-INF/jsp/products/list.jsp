<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="Inventory Catalog - SupplierConnect"/>
<c:set var="activePage" value="products"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-box text-primary me-2"></i> Inventory Product Catalog</h5>
            <sec:authorize access="hasRole('ADMIN')">
                <div>
                    <a href="<c:url value='/products/new'/>" class="btn btn-primary-gradient px-3">
                        <i class="fa-solid fa-plus me-1"></i> Add Product
                    </a>
                </div>
            </sec:authorize>
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

            <!-- Search & Low Stock Toggle Bar -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body py-3">
                    <form action="<c:url value='/products'/>" method="get" class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                <input type="text" name="search" value="${search}" class="form-control border-start-0" placeholder="Search product name or code...">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Search Catalog</button>
                        </div>
                        <div class="col-md-3">
                            <a href="<c:url value='/products?lowStock=true'/>" class="btn ${lowStockOnly ? 'btn-danger' : 'btn-outline-danger'} w-100">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i> Low Stock Warning Only
                            </a>
                        </div>
                        <c:if test="${not empty search || lowStockOnly}">
                            <div class="col-md-2">
                                <a href="<c:url value='/products'/>" class="btn btn-link text-muted">Reset Filters</a>
                            </div>
                        </c:if>
                    </form>
                </div>
            </div>

            <!-- Products Table -->
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle table-custom mb-0">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Unit Price</th>
                                    <th>Stock Level</th>
                                    <th>Reorder Threshold</th>
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <th class="text-end">Actions</th>
                                    </sec:authorize>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="prd" items="${products}">
                                    <tr>
                                        <td class="fw-bold text-primary">${prd.productCode}</td>
                                        <td class="fw-bold">${prd.name}</td>
                                        <td><span class="badge bg-light text-dark border">${prd.category}</span></td>
                                        <td class="fw-semibold">$<fmt:formatNumber value="${prd.unitPrice}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${prd.lowStock}">
                                                    <span class="badge bg-danger text-white px-2 py-1"><i class="fa-solid fa-triangle-exclamation me-1"></i> ${prd.stockQuantity} (Low)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success text-white px-2 py-1">${prd.stockQuantity} in stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted">${prd.reorderLevel}</td>
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <td class="text-end">
                                                <a href="<c:url value='/products/edit/${prd.id}'/>" class="btn btn-sm btn-light border me-1" title="Edit Product">
                                                    <i class="fa-solid fa-pen-to-square text-primary"></i>
                                                </a>
                                                <button type="button" class="btn btn-sm btn-light border text-danger" data-bs-toggle="modal" data-bs-target="#deletePrdModal-${prd.id}" title="Delete Product">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>

                                                <!-- Delete Confirmation Modal -->
                                                <div class="modal fade text-start" id="deletePrdModal-${prd.id}" tabindex="-1">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header border-0">
                                                                <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i> Confirm Product Deletion</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                Are you sure you want to remove product <strong>${prd.name}</strong> (${prd.productCode}) from the catalog?
                                                            </div>
                                                            <div class="modal-footer border-0">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                                <a href="<c:url value='/products/delete/${prd.id}'/>" class="btn btn-danger">Confirm Delete</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </sec:authorize>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty products}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            No products found matching criteria.
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
