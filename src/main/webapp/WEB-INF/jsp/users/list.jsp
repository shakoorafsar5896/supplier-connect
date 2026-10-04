<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="User Management - SupplierConnect"/>
<c:set var="activePage" value="users"/>
<%@ include file="../common/header.jsp" %>

<div class="main-wrapper">
    <%@ include file="../common/sidebar.jsp" %>

    <div class="content-area">
        <header class="top-navbar">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-users-gear text-primary me-2"></i> System User Management</h5>
            <div>
                <a href="<c:url value='/users/new'/>" class="btn btn-primary-gradient px-3">
                    <i class="fa-solid fa-user-plus me-1"></i> Create New User
                </a>
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

            <div class="card border-0 shadow-sm rounded-4">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle table-custom mb-0">
                            <thead>
                                <tr>
                                    <th>User ID</th>
                                    <th>Username</th>
                                    <th>Email Address</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Registered Date</th>
                                    <th class="text-end">Account Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td class="fw-bold text-secondary">#${u.id}</td>
                                        <td class="fw-bold text-dark">${u.username}</td>
                                        <td>${u.email}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.role.name() == 'ADMIN'}">
                                                    <span class="badge bg-primary text-white"><i class="fa-solid fa-user-shield me-1"></i> ADMIN</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary text-white"><i class="fa-solid fa-user me-1"></i> USER</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${u.enabled}">
                                                    <span class="badge badge-active">ENABLED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-inactive">DISABLED</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${u.formattedCreatedAt}</td>
                                        <td class="text-end">
                                            <c:if test="${u.username != pageContext.request.userPrincipal.name}">
                                                <a href="<c:url value='/users/toggle/${u.id}'/>" class="btn btn-sm ${u.enabled ? 'btn-outline-danger' : 'btn-outline-success'}">
                                                    <i class="fa-solid ${u.enabled ? 'fa-user-slash' : 'fa-user-check'} me-1"></i>
                                                    ${u.enabled ? 'Disable' : 'Enable'}
                                                </a>
                                            </c:if>
                                            <c:if test="${u.username == pageContext.request.userPrincipal.name}">
                                                <span class="badge bg-light text-muted border">Current Session</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
