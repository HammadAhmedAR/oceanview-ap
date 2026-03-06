<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/dashboard.css" rel="stylesheet">
    <link href="css/staff.css" rel="stylesheet">
</head>

<body>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String displayName = loggedUser.getUsername();
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";
    boolean isAdmin = "ADMIN".equals(displayRole);
%>

<!-- Navbar -->
<nav class="navbar navbar-ocean">
    <div class="container">
        <span class="navbar-brand">
            <span class="brand-dot"></span> OceanView
        </span>
        <div class="d-flex align-items-center gap-3">
            <span class="role-badge"><%= displayRole %></span>
            <a href="logout" class="btn btn-logout" id="logoutBtn">
                <i class="bi bi-box-arrow-right me-1"></i>Logout
            </a>
        </div>
    </div>
</nav>

<!-- Welcome Section -->
<div class="welcome-section">
    <div class="container">

        <div class="welcome-card mb-4">
            <h1>Welcome back, <span><%= displayName %></span>!</h1>
            <% if (isAdmin) { %>
                <p>Admin Dashboard &mdash; Manage rooms, bookings, guests, and staff from here.</p>
                <a href="staff-list" class="btn-manage-staff" id="manageStaffBtn">
                    <i class="bi bi-people-fill"></i> Manage Staff
                </a>
            <% } else { %>
                <p>Staff Dashboard &mdash; View your assigned rooms and bookings from here.</p>
            <% } %>
        </div>

        <!-- Stat Cards -->
        <div class="row g-4">
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="bi bi-door-open"></i></div>
                    <h5>Total Rooms</h5>
                    <div class="stat-value">24</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-calendar-check"></i></div>
                    <h5>Booked Today</h5>
                    <div class="stat-value">18</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon orange"><i class="bi bi-people"></i></div>
                    <h5>Guests</h5>
                    <div class="stat-value">42</div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="bi bi-check-circle"></i></div>
                    <h5>Available</h5>
                    <div class="stat-value">6</div>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>