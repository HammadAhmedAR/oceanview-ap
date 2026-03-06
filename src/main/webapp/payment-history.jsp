<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Payment" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Payment History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/dashboard.css" rel="stylesheet">
    <link href="css/staff.css" rel="stylesheet">
    <link href="css/billing.css" rel="stylesheet">
</head>
<body>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";
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

        <div class="page-header">
            <h2><i class="bi bi-clock-history"></i> Payment History</h2>
            <a href="dashboard" class="btn-back"><i class="bi bi-arrow-left"></i> Dashboard</a>
        </div>

        <div class="glass-table-wrapper">
            <% if (payments != null && !payments.isEmpty()) { %>
            <table class="glass-table" id="paymentTable">
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Bill Number</th>
                        <th>Method</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Payment p : payments) { %>
                    <tr>
                        <td><%= p.getPaymentId() %></td>
                        <td><strong><%= p.getBillNumber() != null ? p.getBillNumber() : "-" %></strong></td>
                        <td><%= p.getPaymentMethod() %></td>
                        <td><strong>$<%= p.getPaymentAmount() %></strong></td>
                        <td>
                            <% if ("COMPLETED".equals(p.getPaymentStatus())) { %>
                                <span class="payment-completed">Completed</span>
                            <% } else { %>
                                <span class="payment-pending"><%= p.getPaymentStatus() %></span>
                            <% } %>
                        </td>
                        <td><%= p.getPaymentDate() != null ? p.getPaymentDate().toString().substring(0, 16) : "-" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <i class="bi bi-clock-history"></i>
                <p>No payments recorded yet.</p>
            </div>
            <% } %>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
