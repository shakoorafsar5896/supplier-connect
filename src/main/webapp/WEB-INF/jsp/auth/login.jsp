<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SupplierConnect</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body class="auth-bg">

    <div class="auth-card">
        <div class="text-center mb-4">
            <div class="d-inline-flex align-items-center justify-content-center bg-indigo p-3 rounded-circle text-primary mb-3" style="background: rgba(79, 70, 229, 0.1);">
                <i class="fa-solid fa-boxes-packing fa-2x" style="color: #4f46e5;"></i>
            </div>
            <h3 class="fw-bold mb-1">SupplierConnect</h3>
            <p class="text-muted small">Sign in to manage inventory & orders</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="<c:url value='/login'/>" method="post">
            <div class="mb-3">
                <label for="username" class="form-label fw-semibold text-secondary">Username</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-user text-muted"></i></span>
                    <input type="text" id="username" name="username" class="form-control border-start-0 ps-0" placeholder="Enter username" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <label for="password" class="form-label fw-semibold text-secondary">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0"><i class="fa-solid fa-lock text-muted"></i></span>
                    <input type="password" id="password" name="password" class="form-control border-start-0 ps-0" placeholder="Enter password" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary-gradient w-100 py-2.5 rounded-3 mb-3">
                Sign In <i class="fa-solid fa-arrow-right ms-2"></i>
            </button>
        </form>

        <div class="mt-4 p-3 rounded-3 bg-light border border-secondary border-opacity-10 text-center">
            <div class="fw-semibold text-secondary mb-1" style="font-size: 0.85rem;"><i class="fa-solid fa-key me-1"></i> Demo Login Credentials:</div>
            <div class="d-flex justify-content-around text-muted small mt-2">
                <div><strong>Admin:</strong> <code>admin / admin123</code></div>
                <div><strong>User:</strong> <code>user1 / user123</code></div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
