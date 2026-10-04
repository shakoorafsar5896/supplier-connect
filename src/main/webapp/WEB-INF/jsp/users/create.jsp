<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="pageTitle" value="Create User Account - SupplierConnect"/>
<c:set var="activePage" value="users"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-user-plus text-primary me-2"></i> Provision New User Account</h5>
            <a href="<c:url value='/users'/>" class="btn btn-outline-secondary btn-sm"><i class="fa-solid fa-arrow-left me-1"></i> Back to User List</a>
        </header>

        <div class="container-fluid p-4">
            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4">
                        <div class="card-body p-4">
                            <form:form action="${pageContext.request.contextPath}/users/save" method="post" modelAttribute="user">
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                                        <i class="fa-solid fa-circle-exclamation me-2"></i> ${errorMessage}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Username <span class="text-danger">*</span></label>
                                    <form:input path="username" class="form-control" placeholder="Choose unique username" required="true"/>
                                    <form:errors path="username" cssClass="text-danger small mt-1" element="div"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                                    <form:input path="email" type="email" class="form-control" placeholder="user@company.com" required="true"/>
                                    <form:errors path="email" cssClass="text-danger small mt-1" element="div"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Initial Password <span class="text-danger">*</span></label>
                                    <form:password path="password" class="form-control" placeholder="Set temporary password" required="true"/>
                                    <form:errors path="password" cssClass="text-danger small mt-1" element="div"/>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Assign Role <span class="text-danger">*</span></label>
                                    <form:select path="role" class="form-select" required="true">
                                        <form:option value="USER">USER (Supplier/Staff Access)</form:option>
                                        <form:option value="ADMIN">ADMIN (Full System Administrator)</form:option>
                                    </form:select>
                                    <form:errors path="role" cssClass="text-danger small mt-1" element="div"/>
                                </div>

                                <div class="mb-4 form-check">
                                    <form:checkbox path="enabled" class="form-check-input" id="enabledCheck" checked="checked"/>
                                    <label class="form-check-label fw-semibold" for="enabledCheck">
                                        Enable Account Immediately
                                    </label>
                                </div>

                                <div class="text-end">
                                    <a href="<c:url value='/users'/>" class="btn btn-light border me-2">Cancel</a>
                                    <button type="submit" class="btn btn-primary-gradient px-4">
                                        <i class="fa-solid fa-user-check me-1"></i> Provision Account
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
