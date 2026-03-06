<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Guest" %>
<%@ page import="com.oceanview.model.Room" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Add Reservation</title>

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
    List<Guest> guests = (List<Guest>) request.getAttribute("guests");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
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

        <div class="reservation-form-card">

            <h3><i class="bi bi-calendar-plus"></i> New Reservation</h3>

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

            <form method="post" action="add-reservation" id="addReservationForm">

                <div class="mb-3">
                    <label class="form-label">Reservation Number *</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-hash"></i></span>
                        <input type="text" class="form-control" name="reservationNumber"
                               placeholder="e.g. RES-001" required id="resNumber">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Guest *</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <select class="form-select" name="guestId" required id="guestSelect">
                            <option value="" selected disabled>Select a guest</option>
                            <% if (guests != null) {
                                for (Guest g : guests) { %>
                            <option value="<%= g.getGuestId() %>">
                                <%= g.getFullName() %> (<%= g.getPhone() %>)
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Room *</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-door-open"></i></span>
                        <select class="form-select" name="roomId" required id="roomSelect">
                            <option value="" selected disabled>Select a room</option>
                            <% if (rooms != null) {
                                for (Room r : rooms) { %>
                            <option value="<%= r.getRoomId() %>">
                                Room <%= r.getRoomCode() %> &mdash; <%= r.getRoomType() %> ($<%= r.getPricePerNight() %>/night)
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Check-in Date *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-event"></i></span>
                            <input type="date" class="form-control" name="checkInDate"
                                   required id="checkInDate">
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Check-out Date *</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-calendar-check"></i></span>
                            <input type="date" class="form-control" name="checkOutDate"
                                   required id="checkOutDate">
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-create-reservation flex-grow-1" id="createResBtn">
                        <i class="bi bi-check-lg me-2"></i>Create Reservation
                    </button>
                    <a href="reservations" class="btn-back d-flex align-items-center">
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
