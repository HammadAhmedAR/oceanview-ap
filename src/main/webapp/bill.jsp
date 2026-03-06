<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Bill" %>
<%@ page import="com.oceanview.model.Payment" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Invoice</title>
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
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";
    Bill bill = (Bill) request.getAttribute("bill");
    if (bill == null) { response.sendRedirect("reservations"); return; }
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
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
        <div class="invoice-card">

            <div class="d-flex justify-content-between align-items-start mb-3">
                <h2><i class="bi bi-receipt-cutoff"></i> Invoice</h2>
                <div class="d-flex gap-2">
                    <button class="btn-print" onclick="window.print()"><i class="bi bi-printer me-1"></i>Print</button>
                </div>
            </div>

            <!-- Bill Info -->
            <div class="invoice-section-title">Bill Information</div>
            <div class="detail-row">
                <span class="detail-label">Bill Number</span>
                <span class="detail-value highlight"><%= bill.getBillNumber() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Status</span>
                <span class="detail-value">
                    <% if ("PAID".equals(bill.getBillStatus())) { %>
                        <span class="bill-paid">Paid</span>
                    <% } else if ("CANCELLED".equals(bill.getBillStatus())) { %>
                        <span class="bill-cancelled">Cancelled</span>
                    <% } else { %>
                        <span class="bill-generated">Generated</span>
                    <% } %>
                </span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Reservation</span>
                <span class="detail-value"><%= bill.getReservationNumber() != null ? bill.getReservationNumber() : "-" %></span>
            </div>

            <!-- Guest Info -->
            <div class="invoice-section-title">Guest Information</div>
            <div class="detail-row">
                <span class="detail-label">Guest Name</span>
                <span class="detail-value"><%= bill.getGuestName() != null ? bill.getGuestName() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Phone</span>
                <span class="detail-value"><%= bill.getGuestPhone() != null ? bill.getGuestPhone() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Email</span>
                <span class="detail-value"><%= bill.getGuestEmail() != null ? bill.getGuestEmail() : "-" %></span>
            </div>

            <!-- Room Info -->
            <div class="invoice-section-title">Room Information</div>
            <div class="detail-row">
                <span class="detail-label">Room</span>
                <span class="detail-value"><%= bill.getRoomCode() != null ? bill.getRoomCode() : "-" %> &mdash; <%= bill.getRoomType() != null ? bill.getRoomType() : "" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Check-in</span>
                <span class="detail-value"><%= bill.getCheckInDate() != null ? bill.getCheckInDate() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Check-out</span>
                <span class="detail-value"><%= bill.getCheckOutDate() != null ? bill.getCheckOutDate() : "-" %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Nights</span>
                <span class="detail-value"><%= bill.getNumberOfNights() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Rate / Night</span>
                <span class="detail-value">$<%= bill.getRatePerNight() != null ? bill.getRatePerNight() : "-" %></span>
            </div>

            <!-- Total -->
            <div class="invoice-section-title">Total</div>
            <div class="detail-row">
                <span class="detail-label">Total Amount</span>
                <span class="detail-value amount-highlight">$<%= bill.getBillAmount() %></span>
            </div>

            <!-- Payment History -->
            <% if (payments != null && !payments.isEmpty()) { %>
            <div class="invoice-section-title">Payment History</div>
            <% for (Payment p : payments) { %>
            <div class="detail-row">
                <span class="detail-label"><%= p.getPaymentMethod() %></span>
                <span class="detail-value">
                    $<%= p.getPaymentAmount() %>
                    <span class="payment-completed ms-2">Completed</span>
                </span>
            </div>
            <% } %>
            <% } %>

            <!-- Actions -->
            <div class="d-flex gap-2 mt-4 flex-wrap">
                <a href="reservations" class="btn-back flex-grow-1 justify-content-center">
                    <i class="bi bi-arrow-left me-1"></i> Back to Reservations
                </a>
                <% if ("GENERATED".equals(bill.getBillStatus())) { %>
                <a href="record-payment?billId=<%= bill.getBillId() %>"
                   class="btn-record-payment flex-grow-1 justify-content-center d-flex align-items-center">
                    <i class="bi bi-credit-card me-1"></i> Record Payment
                </a>
                <% } %>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
