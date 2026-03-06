<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Guest" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Edit Guest</title>

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
    Guest guest = (Guest) request.getAttribute("guest");
    if (guest == null) {
        response.sendRedirect("guests");
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

        <div class="staff-form-card guest-form-card">

            <h3><i class="bi bi-pencil-square"></i> Edit Guest</h3>

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i>
                <%= errorMessage %>
            </div>
            <%
                }
            %>

            <form method="post" action="update-guest" id="editGuestForm">
                <input type="hidden" name="guestId" value="<%= guest.getGuestId() %>">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">First Name *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="firstName"
                                   value="<%= guest.getFirstName() %>"
                                   required id="editFirstName">
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Last Name *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="lastName"
                                   value="<%= guest.getLastName() %>"
                                   required id="editLastName">
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                        <input type="tel" class="form-control" name="phone"
                               value="<%= guest.getPhone() != null ? guest.getPhone() : "" %>"
                               id="editPhone">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" class="form-control" name="email"
                               value="<%= guest.getEmail() != null ? guest.getEmail() : "" %>"
                               id="editEmail">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                        <input type="text" class="form-control" name="address"
                               value="<%= guest.getAddress() != null ? guest.getAddress() : "" %>"
                               id="editAddress">
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-save-guest flex-grow-1" id="updateGuestBtn">
                        <i class="bi bi-check-lg me-2"></i>Update Guest
                    </button>
                    <a href="guests" class="btn-back d-flex align-items-center">
                        <i class="bi bi-arrow-left me-1"></i>Cancel
                    </a>
                </div>

            </form>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
