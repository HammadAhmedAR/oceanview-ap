<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Reservation" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Reservations</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/dashboard.css" rel="stylesheet">
    <link href="css/staff.css" rel="stylesheet">
    <link href="css/reservations.css" rel="stylesheet">
</head>

<body>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
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

        <div class="page-header">
            <h2><i class="bi bi-calendar-week"></i> Reservations</h2>
            <div class="d-flex gap-2">
                <a href="dashboard" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Dashboard
                </a>
                <a href="add-reservation" class="btn-add-reservation" id="addReservationBtn">
                    <i class="bi bi-plus-circle"></i> Add Reservation
                </a>
            </div>
        </div>

        <div class="glass-table-wrapper">
            <% if (reservations != null && !reservations.isEmpty()) { %>
            <table class="glass-table" id="reservationTable">
                <thead>
                    <tr>
                        <th>Res. Number</th>
                        <th>Guest Name</th>
                        <th>Room</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Reservation res : reservations) { %>
                    <tr>
                        <td><strong><%= res.getReservationNumber() %></strong></td>
                        <td><%= res.getGuestName() != null ? res.getGuestName() : "-" %></td>
                        <td><%= res.getRoomCode() != null ? res.getRoomCode() : "-" %></td>
                        <td><%= res.getCheckInDate() %></td>
                        <td><%= res.getCheckOutDate() %></td>
                        <td><strong>$<%= res.getTotalAmount() %></strong></td>
                        <td>
                            <% if ("ACTIVE".equals(res.getStatus())) { %>
                                <span class="status-active">Active</span>
                            <% } else { %>
                                <span class="status-cancelled">Cancelled</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="d-flex gap-2">
                                <a href="reservation-details?resNumber=<%= res.getReservationNumber() %>"
                                   class="btn-view">
                                    <i class="bi bi-eye me-1"></i>View
                                </a>
                                <% if ("ACTIVE".equals(res.getStatus())) { %>
                                <a href="cancel-reservation?reservationId=<%= res.getReservationId() %>"
                                   class="btn-cancel"
                                   onclick="return confirm('Are you sure you want to cancel this reservation?')">
                                    <i class="bi bi-x-circle me-1"></i>Cancel
                                </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <i class="bi bi-calendar-week"></i>
                <p>No reservations found. Click <strong>Add Reservation</strong> to create one.</p>
            </div>
            <% } %>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
