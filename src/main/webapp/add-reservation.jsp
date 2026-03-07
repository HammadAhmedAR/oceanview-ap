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
                    <div class="d-flex gap-2">
                        <div class="input-group flex-grow-1">
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
                        <button type="button" class="btn" data-bs-toggle="modal" data-bs-target="#quickGuestModal"
                                style="background:rgba(81,207,102,0.15); color:#51cf66; border:1px solid rgba(81,207,102,0.3); border-radius:10px; font-weight:600; white-space:nowrap;">
                            <i class="bi bi-plus-lg"></i> New
                        </button>
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

<!-- Quick Add Guest Modal -->
<div class="modal fade" id="quickGuestModal" tabindex="-1" aria-labelledby="quickGuestLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background:#1a2332; border:1px solid rgba(255,255,255,0.12); border-radius:20px;">
            <div class="modal-header" style="border-bottom:1px solid rgba(255,255,255,0.08);">
                <h5 class="modal-title" id="quickGuestLabel" style="color:#fff; font-weight:600;">
                    <i class="bi bi-person-plus" style="color:#51cf66"></i> Quick Add Guest
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="quick-add-guest">
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label">First Name *</label>
                            <input type="text" class="form-control" name="firstName" required
                                   placeholder="First name" id="quickFirstName">
                        </div>
                        <div class="col-6">
                            <label class="form-label">Last Name *</label>
                            <input type="text" class="form-control" name="lastName" required
                                   placeholder="Last name" id="quickLastName">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" class="form-control" name="phone"
                               placeholder="Phone number" id="quickPhone">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email"
                               placeholder="Email address" id="quickEmail">
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid rgba(255,255,255,0.08);">
                    <button type="button" class="btn btn-sm" data-bs-dismiss="modal"
                            style="color:rgba(255,255,255,0.6);">Cancel</button>
                    <button type="submit" class="btn btn-sm"
                            style="background:linear-gradient(135deg,#51cf66,#2b8a3e); color:#fff; font-weight:600; border-radius:10px; padding:0.4rem 1.2rem;">
                        <i class="bi bi-check-lg me-1"></i>Add Guest
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
