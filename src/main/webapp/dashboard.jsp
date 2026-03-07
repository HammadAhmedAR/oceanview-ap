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
    <link href="css/guests.css" rel="stylesheet">
    <link href="css/reservations.css" rel="stylesheet">
    <link href="css/billing.css" rel="stylesheet">
    <link href="css/help.css" rel="stylesheet">
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
                <div class="d-flex gap-2 flex-wrap">
                    <a href="staff-list" class="btn-manage-staff" id="manageStaffBtn">
                        <i class="bi bi-people-fill"></i> Manage Staff
                    </a>
                    <a href="guests" class="btn-manage-guests" id="manageGuestsBtn">
                        <i class="bi bi-person-vcard"></i> Manage Guests
                    </a>
                    <a href="reservations" class="btn-manage-reservations" id="manageReservationsBtn">
                        <i class="bi bi-calendar-week"></i> Manage Reservations
                    </a>
                    <a href="payment-history" class="btn-manage-billing" id="paymentHistoryBtn">
                        <i class="bi bi-receipt"></i> Payment History
                    </a>
                    <a href="help" class="btn-help" id="helpBtn">
                        <i class="bi bi-question-circle"></i> Help
                    </a>
                </div>
            <% } else { %>
                <p>Staff Dashboard &mdash; Manage guests and reservations from here.</p>
                <div class="d-flex gap-2 flex-wrap">
                    <a href="guests" class="btn-manage-guests" id="manageGuestsBtn">
                        <i class="bi bi-person-vcard"></i> Manage Guests
                    </a>
                    <a href="reservations" class="btn-manage-reservations" id="manageReservationsBtn">
                        <i class="bi bi-calendar-week"></i> Manage Reservations
                    </a>
                    <a href="payment-history" class="btn-manage-billing" id="paymentHistoryBtn">
                        <i class="bi bi-receipt"></i> Payment History
                    </a>
                    <a href="help" class="btn-help" id="helpBtn">
                        <i class="bi bi-question-circle"></i> Help
                    </a>
                </div>
            <% } %>
        </div>

        <!-- Stat Cards -->
        <%
            Integer totalRooms = (Integer) request.getAttribute("totalRooms");
            Integer bookedToday = (Integer) request.getAttribute("bookedToday");
            Integer totalGuests = (Integer) request.getAttribute("totalGuests");
            Integer availableRooms = (Integer) request.getAttribute("availableRooms");
        %>
        <div class="row g-4">
            <div class="col-md-3 col-sm-6">
                <a href="rooms?filter=all" style="text-decoration:none; color:inherit;">
                <div class="stat-card" style="cursor:pointer; transition:transform 0.2s;" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='translateY(0)'">
                    <div class="stat-icon blue"><i class="bi bi-door-open"></i></div>
                    <h5>Total Rooms</h5>
                    <div class="stat-value"><%= totalRooms != null ? totalRooms : 0 %></div>
                </div>
                </a>
            </div>
            <div class="col-md-3 col-sm-6">
                <a href="rooms?filter=booked" style="text-decoration:none; color:inherit;">
                <div class="stat-card" style="cursor:pointer; transition:transform 0.2s;" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='translateY(0)'">
                    <div class="stat-icon green"><i class="bi bi-calendar-check"></i></div>
                    <h5>Booked</h5>
                    <div class="stat-value"><%= bookedToday != null ? bookedToday : 0 %></div>
                </div>
                </a>
            </div>
            <div class="col-md-3 col-sm-6">
                <a href="guests" style="text-decoration:none; color:inherit;">
                <div class="stat-card" style="cursor:pointer; transition:transform 0.2s;" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='translateY(0)'">
                    <div class="stat-icon orange"><i class="bi bi-people"></i></div>
                    <h5>Guests</h5>
                    <div class="stat-value"><%= totalGuests != null ? totalGuests : 0 %></div>
                </div>
                </a>
            </div>
            <div class="col-md-3 col-sm-6">
                <a href="rooms?filter=available" style="text-decoration:none; color:inherit;">
                <div class="stat-card" style="cursor:pointer; transition:transform 0.2s;" onmouseover="this.style.transform='translateY(-4px)'" onmouseout="this.style.transform='translateY(0)'">
                    <div class="stat-icon purple"><i class="bi bi-check-circle"></i></div>
                    <h5>Available</h5>
                    <div class="stat-value"><%= availableRooms != null ? availableRooms : 0 %></div>
                </div>
                </a>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>