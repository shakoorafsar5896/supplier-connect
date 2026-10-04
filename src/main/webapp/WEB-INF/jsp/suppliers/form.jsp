<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="pageTitle" value="${isEdit ? 'Edit Supplier' : 'Add New Supplier'} - SupplierConnect"/>
<c:set var="activePage" value="suppliers"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-truck-field text-primary me-2"></i> ${isEdit ? 'Edit Supplier Details' : 'Add New Supplier Master'}</h5>
            <a href="<c:url value='/suppliers'/>" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Back to Directory</a>
        </header>

        <div class="container-fluid p-4">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-body p-4">
                            <form:form action="${pageContext.request.contextPath}/suppliers/save" method="post" modelAttribute="supplier">
                                <form:hidden path="id"/>

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Supplier Code <span class="text-danger">*</span></label>
                                        <form:input path="supplierCode" class="form-control" placeholder="e.g. SUP-1004" required="true" readonly="${isEdit}"/>
                                        <form:errors path="supplierCode" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Supplier Name <span class="text-danger">*</span></label>
                                        <form:input path="name" class="form-control" placeholder="e.g. Acme Corporation" required="true"/>
                                        <form:errors path="name" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Contact Person</label>
                                        <form:input path="contactPerson" class="form-control" placeholder="Primary contact name"/>
                                        <form:errors path="contactPerson" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Email Address</label>
                                        <form:input path="email" type="email" class="form-control" placeholder="supplier@domain.com"/>
                                        <form:errors path="email" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Phone Number</label>
                                        <form:input path="phone" class="form-control" placeholder="+1-555-0100"/>
                                        <form:errors path="phone" cssClass="text-danger small mt-1" element="div"/>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Account Status</label>
                                        <form:select path="status" class="form-select">
                                            <form:option value="ACTIVE">ACTIVE</form:option>
                                            <form:option value="INACTIVE">INACTIVE</form:option>
                                        </form:select>
                                    </div>

                                    <div class="col-12">
                                        <label class="form-label fw-semibold">Office Address</label>
                                        <form:textarea path="address" class="form-control" rows="3" placeholder="Full street address, city, state, zip"/>
                                        <form:errors path="address" cssClass="text-danger small mt-1" element="div"/>
                                    </div>
                                </div>

                                <div class="mt-4 text-end">
                                    <a href="<c:url value='/suppliers'/>" class="btn btn-light border me-2">Cancel</a>
                                    <button type="submit" class="btn btn-primary-gradient px-4">
                                        <i class="fa-solid fa-floppy-disk me-1"></i> Save Supplier
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
