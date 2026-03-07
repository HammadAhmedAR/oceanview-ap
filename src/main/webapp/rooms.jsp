<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Room" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Rooms</title>
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
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";

    List<Object[]> roomsWithInfo = (List<Object[]>) request.getAttribute("roomsWithInfo");
    String filter = (String) request.getAttribute("filter");
    if (filter == null) filter = "all";
%>

<nav class="navbar navbar-ocean">
    <div class="container">
        <span class="navbar-brand"><span class="brand-dot"></span> OceanView</span>
        <div class="d-flex align-items-center gap-3">
            <span class="role-badge"><%= displayRole %></span>
            <a href="logout" class="btn btn-logout"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
        </div>
    </div>
</nav>

<div class="content-section">
    <div class="container">

        <div class="page-header">
            <h2><i class="bi bi-door-open"></i>
                <% if ("booked".equals(filter)) { %>
                    Booked Rooms
                <% } else if ("available".equals(filter)) { %>
                    Available Rooms
                <% } else { %>
                    All Rooms
                <% } %>
            </h2>
            <div class="d-flex gap-2">
                <a href="dashboard" class="btn-back"><i class="bi bi-arrow-left"></i> Dashboard</a>
            </div>
        </div>

        <!-- Filter Tabs -->
        <div class="d-flex gap-2 mb-3 flex-wrap">
            <a href="rooms?filter=all"
               class="btn btn-sm <%= "all".equals(filter) ? "btn-light" : "btn-outline-light" %>"
               style="border-radius:10px; font-size:0.85rem;">All</a>
            <a href="rooms?filter=booked"
               class="btn btn-sm <%= "booked".equals(filter) ? "btn-light" : "btn-outline-light" %>"
               style="border-radius:10px; font-size:0.85rem;">Booked</a>
            <a href="rooms?filter=available"
               class="btn btn-sm <%= "available".equals(filter) ? "btn-light" : "btn-outline-light" %>"
               style="border-radius:10px; font-size:0.85rem;">Available</a>
        </div>

        <div class="glass-table-wrapper">
            <% if (roomsWithInfo != null && !roomsWithInfo.isEmpty()) {
                boolean hasRows = false;
            %>
            <table class="glass-table" id="roomsTable">
                <thead>
                    <tr>
                        <th>Room Code</th>
                        <th>Type</th>
                        <th>Price / Night</th>
                        <th>Status</th>
                        <th>Guest</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Object[] row : roomsWithInfo) {
                        Room room = (Room) row[0];
                        String bookingStatus = (String) row[1];
                        String guestName = (String) row[2];

                        // Apply filter
                        if ("booked".equals(filter) && !"BOOKED".equals(bookingStatus)) continue;
                        if ("available".equals(filter) && !"AVAILABLE".equals(bookingStatus)) continue;
                        hasRows = true;
                    %>
                    <tr>
                        <td><strong><%= room.getRoomCode() %></strong></td>
                        <td><%= room.getRoomType() %></td>
                        <td>$<%= room.getPricePerNight() %></td>
                        <td>
                            <% if ("BOOKED".equals(bookingStatus)) { %>
                                <span style="display:inline-block; background:rgba(220,53,69,0.15); color:#ff6b6b; font-size:0.7rem; font-weight:600; padding:0.2rem 0.6rem; border-radius:6px; text-transform:uppercase; letter-spacing:0.5px;">Booked</span>
                            <% } else { %>
                                <span style="display:inline-block; background:rgba(81,207,102,0.15); color:#51cf66; font-size:0.7rem; font-weight:600; padding:0.2rem 0.6rem; border-radius:6px; text-transform:uppercase; letter-spacing:0.5px;">Available</span>
                            <% } %>
                        </td>
                        <td><%= guestName != null ? guestName : "&mdash;" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% if (!hasRows) { %>
            <div class="empty-state">
                <i class="bi bi-door-open"></i>
                <p>No rooms match the selected filter.</p>
            </div>
            <% }
            } else { %>
            <div class="empty-state">
                <i class="bi bi-door-open"></i>
                <p>No rooms found in the system.</p>
            </div>
            <% } %>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
