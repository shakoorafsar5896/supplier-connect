<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="pageTitle" value="${isEdit ? 'Edit Product' : 'Add New Product'} - SupplierConnect"/>
<c:set var="activePage" value="products"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-box text-primary me-2"></i> ${isEdit ? 'Edit Inventory Item' : 'Add New Product to Catalog'}</h5>
            <a href="<c:url value='/products'/>" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Back to Catalog</a>
        </header>

        <div class="container-fluid p-4">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-body p-4">
                            <form:form action="${pageContext.request.contextPath}/products/save" method="post" modelAttribute="product">
                                <form:hidden path="id"/>

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Product Code / SKU <span class="text-danger">*</span></label>
                                        <form:input path="productCode" class="form-control" placeholder="e.g. PRD-5005" required="true" readonly="${isEdit}"/>
                                        <form:errors path="productCode" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Product Name <span class="text-danger">*</span></label>
                                        <form:input path="name" class="form-control" placeholder="e.g. Fiber Optic Transceiver" required="true"/>
                                        <form:errors path="name" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Category</label>
                                        <form:input path="category" class="form-control" placeholder="e.g. Electronics, Hardware, Fasteners"/>
                                        <form:errors path="category" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Unit Price ($) <span class="text-danger">*</span></label>
                                        <form:input path="unitPrice" type="number" step="0.01" min="0" class="form-control" placeholder="0.00" required="true"/>
                                        <form:errors path="unitPrice" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Current Stock Quantity <span class="text-danger">*</span></label>
                                        <form:input path="stockQuantity" type="number" min="0" class="form-control" placeholder="0" required="true"/>
                                        <form:errors path="stockQuantity" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Reorder Warning Threshold <span class="text-danger">*</span></label>
                                        <form:input path="reorderLevel" type="number" min="0" class="form-control" placeholder="10" required="true"/>
                                        <form:errors path="reorderLevel" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Description</label>
                                        <form:textarea path="description" class="form-control" rows="3" placeholder="Technical specifications or item notes..."/>
                                        <form:errors path="description" cssClass="text-danger small mt-1" element="div"/>
                                    </div>
                                </div>

                                <div class="mt-4 text-end">
                                    <a href="<c:url value='/products'/>" class="btn btn-light border me-2">Cancel</a>
                                    <button type="submit" class="btn btn-primary-gradient px-4">
                                        <i class="fa-solid fa-floppy-disk me-1"></i> Save Product
                                    </button>
                                </div>
                            </form:form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
