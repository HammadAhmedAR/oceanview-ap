<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Reservation Details</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/dashboard.css" rel="stylesheet">
    <link href="css/staff.css" rel="stylesheet">
    <link href="css/reservations.css" rel="stylesheet">
    <link href="css/billing.css" rel="stylesheet">
</head>

<body>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";
    Reservation reservation = (Reservation) request.getAttribute("reservation");
    if (reservation == null) {
        response.sendRedirect("reservations");
        return;
    }
%>

<!-- Navbar -->
<nav class="navbar navbar-ocean">
    <div class="container">
        <span class="navbar-brand">
            <span class="brand-dot"></span> OceanView
        </span>
        <div class="d-flex align-items-center gap-3">
            <span class="role-badge"><%= displayRole %></span>
            <a href="logout" class="btn btn-logout">
                <i class="bi bi-box-arrow-right me-1"></i>Logout
            </a>
        </div>
    </div>
</nav>

<!-- Content -->
<div class="content-section">
    <div class="container">

        <div class="details-card">

            <h2><i class="bi bi-receipt"></i> Reservation Details</h2>

            <div class="detail-row">
                <span class="detail-label">Reservation Number</span>
                <span class="detail-value highlight"><%= reservation.getReservationNumber() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Status</span>
                <span class="detail-value">
                    <% if ("ACTIVE".equals(reservation.getStatus())) { %>
                        <span class="status-active">Active</span>
                    <% } else { %>
                        <span class="status-cancelled">Cancelled</span>
                    <% } %>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Guest Name</span>
                <span class="detail-value"><%= reservation.getGuestName() != null ? reservation.getGuestName() : "-" %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Guest Phone</span>
                <span class="detail-value"><%= reservation.getGuestPhone() != null ? reservation.getGuestPhone() : "-" %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Guest Email</span>
                <span class="detail-value"><%= reservation.getGuestEmail() != null ? reservation.getGuestEmail() : "-" %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Room Number</span>
                <span class="detail-value"><%= reservation.getRoomCode() != null ? reservation.getRoomCode() : "-" %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Room Type</span>
                <span class="detail-value"><%= reservation.getRoomType() != null ? reservation.getRoomType() : "-" %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Check-in Date</span>
                <span class="detail-value"><%= reservation.getCheckInDate() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Check-out Date</span>
                <span class="detail-value"><%= reservation.getCheckOutDate() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Number of Nights</span>
                <span class="detail-value"><%= reservation.getNumberOfNights() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Price per Night</span>
                <span class="detail-value">$<%= reservation.getPricePerNight() != null ? reservation.getPricePerNight() : "-" %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Total Amount</span>
                <span class="detail-value amount-highlight">$<%= reservation.getTotalAmount() %></span>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex gap-2 mt-4 flex-wrap">
                <a href="reservations" class="btn-back flex-grow-1 justify-content-center">
                    <i class="bi bi-arrow-left me-1"></i> Back to List
                </a>
                <% if ("ACTIVE".equals(reservation.getStatus())) { %>
                <a href="generate-bill?reservationId=<%= reservation.getReservationId() %>"
                   class="btn-generate-bill flex-grow-1 justify-content-center d-flex align-items-center">
                    <i class="bi bi-receipt me-1"></i> Generate Bill
                </a>
                <a href="cancel-reservation?reservationId=<%= reservation.getReservationId() %>"
                   class="btn-cancel flex-grow-1 justify-content-center d-flex align-items-center"
                   onclick="return confirm('Are you sure you want to cancel this reservation?')">
                    <i class="bi bi-x-circle me-1"></i> Cancel Reservation
                </a>
                <% } %>
            </div>

        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
