<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Guest" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Guests</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/dashboard.css" rel="stylesheet">
    <link href="css/staff.css" rel="stylesheet">
    <link href="css/guests.css" rel="stylesheet">
</head>

<body>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";
    List<Guest> guestList = (List<Guest>) request.getAttribute("guestList");
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
            <h2><i class="bi bi-person-vcard"></i> Guest Management</h2>
            <div class="d-flex gap-2">
                <a href="dashboard" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Dashboard
                </a>
                <a href="add-guest" class="btn-add-guest" id="addGuestBtn">
                    <i class="bi bi-person-plus"></i> Add Guest
                </a>
            </div>
        </div>

        <div class="glass-table-wrapper">
            <% if (guestList != null && !guestList.isEmpty()) { %>
            <table class="glass-table" id="guestTable">
                <thead>
                    <tr>
                        <th>Guest ID</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Guest guest : guestList) { %>
                    <tr>
                        <td><%= guest.getGuestId() %></td>
                        <td><%= guest.getFullName() %></td>
                        <td><%= guest.getPhone() %></td>
                        <td><span class="email-text"><%= guest.getEmail() %></span></td>
                        <td>
                            <div class="d-flex gap-2">
                                <a href="update-guest?guestId=<%= guest.getGuestId() %>"
                                   class="btn-edit">
                                    <i class="bi bi-pencil me-1"></i>Edit
                                </a>
                                <a href="delete-guest?guestId=<%= guest.getGuestId() %>"
                                   class="btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this guest?')">
                                    <i class="bi bi-trash me-1"></i>Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <i class="bi bi-person-vcard"></i>
                <p>No guests registered yet. Click <strong>Add Guest</strong> to register one.</p>
            </div>
            <% } %>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
