<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="pageTitle" value="Supplier Master - SupplierConnect"/>
<c:set var="activePage" value="suppliers"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-truck-field text-primary me-2"></i> Supplier Master Directory</h5>
            <sec:authorize access="hasRole('ADMIN')">
                <div>
                    <a href="<c:url value='/suppliers/new'/>" class="btn btn-primary-gradient px-3">
                        <i class="fa-solid fa-plus me-1"></i> Add Supplier
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

            <!-- Search Bar -->
            <div class="card border-0 shadow-sm rounded-4 mb-4">
                <div class="card-body py-3">
                    <form action="<c:url value='/suppliers'/>" method="get" class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                                <input type="text" name="search" value="${search}" class="form-control border-start-0" placeholder="Search by supplier name or code...">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Search</button>
                        </div>
                        <c:if test="${not empty search}">
                            <div class="col-md-2">
                                <a href="<c:url value='/suppliers'/>" class="btn btn-link text-muted">Reset</a>
                            </div>
                        </c:if>
                    </form>
                </div>
            </div>

            <!-- Suppliers Table -->
            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle table-custom mb-0">
                            <thead>
                                <tr>
                                    <th>Supplier Code</th>
                                    <th>Supplier Name</th>
                                    <th>Contact Person</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <th class="text-end">Actions</th>
                                    </sec:authorize>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sup" items="${suppliers}">
                                    <tr>
                                        <td class="fw-bold text-primary">${sup.supplierCode}</td>
                                        <td class="fw-bold">${sup.name}</td>
                                        <td>${sup.contactPerson != null ? sup.contactPerson : '-'}</td>
                                        <td><a href="mailto:${sup.email}" class="text-decoration-none">${sup.email}</a></td>
                                        <td>${sup.phone}</td>
                                        <td>
                                            <span class="badge badge-status badge-${sup.status.toLowerCase()}">${sup.status}</span>
                                        </td>
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <td class="text-end">
                                                <a href="<c:url value='/suppliers/edit/${sup.id}'/>" class="btn btn-sm btn-light border me-1" title="Edit Supplier">
                                                    <i class="fa-solid fa-pen-to-square text-primary"></i>
                                                </a>
                                                <button type="button" class="btn btn-sm btn-light border text-danger" data-bs-toggle="modal" data-bs-target="#deleteSupModal-${sup.id}" title="Delete Supplier">
                                                    <i class="fa-solid fa-trash-can"></i>
                                                </button>

                                                <!-- Delete Confirmation Modal -->
                                                <div class="modal fade text-start" id="deleteSupModal-${sup.id}" tabindex="-1">
                                                    <div class="modal-dialog modal-dialog-centered">
                                                        <div class="modal-content">
                                                            <div class="modal-header border-0">
                                                                <h5 class="modal-title fw-bold text-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i> Confirm Supplier Deletion</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                Are you sure you want to delete supplier <strong>${sup.name}</strong> (${sup.supplierCode})?
                                                            </div>
                                                            <div class="modal-footer border-0">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                                <a href="<c:url value='/suppliers/delete/${sup.id}'/>" class="btn btn-danger">Confirm Delete</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </sec:authorize>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty suppliers}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            No suppliers found in directory.
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
