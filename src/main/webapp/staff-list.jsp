<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Staff List</title>

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
    if (loggedUser == null || !"ADMIN".equals(loggedUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<User> staffList = (List<User>) request.getAttribute("staffList");
%>

<!-- Navbar -->
<nav class="navbar navbar-ocean">
    <div class="container">
        <span class="navbar-brand">
            <span class="brand-dot"></span> OceanView
        </span>
        <div class="d-flex align-items-center gap-3">
            <span class="role-badge">ADMIN</span>
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
            <h2><i class="bi bi-people-fill"></i> Staff Management</h2>
            <div class="d-flex gap-2">
                <a href="dashboard.jsp" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Dashboard
                </a>
                <a href="add-staff" class="btn-add-staff" id="addStaffBtn">
                    <i class="bi bi-person-plus"></i> Add Staff
                </a>
            </div>
        </div>

        <div class="glass-table-wrapper">
            <% if (staffList != null && !staffList.isEmpty()) { %>
            <table class="glass-table" id="staffTable">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (User staff : staffList) { %>
                    <tr>
                        <td><%= staff.getUserId() %></td>
                        <td><%= staff.getUsername() %></td>
                        <td><span class="table-role-badge"><%= staff.getRole() %></span></td>
                        <td>
                            <div class="d-flex gap-2">
                                <a href="edit-staff?userId=<%= staff.getUserId() %>"
                                   class="btn-edit">
                                    <i class="bi bi-pencil me-1"></i>Edit
                                </a>
                                <a href="delete-staff?userId=<%= staff.getUserId() %>"
                                   class="btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this staff member?')">
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
                <i class="bi bi-people"></i>
                <p>No staff members found. Click <strong>Add Staff</strong> to create one.</p>
            </div>
            <% } %>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
