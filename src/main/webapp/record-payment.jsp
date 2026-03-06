<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Bill" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Record Payment</title>
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
        <div class="reservation-form-card">

            <h3><i class="bi bi-credit-card" style="color:#51cf66"></i> Record Payment</h3>

            <div class="detail-row mb-3">
                <span class="detail-label">Bill</span>
                <span class="detail-value"><%= bill.getBillNumber() %></span>
            </div>
            <div class="detail-row mb-3">
                <span class="detail-label">Amount Due</span>
                <span class="detail-value amount-highlight">$<%= bill.getBillAmount() %></span>
            </div>

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="bi bi-exclamation-circle me-2"></i><%= errorMessage %>
            </div>
            <% } %>

            <form method="post" action="record-payment" id="paymentForm">
                <input type="hidden" name="billId" value="<%= bill.getBillId() %>">

                <div class="mb-3">
                    <label class="form-label">Payment Method *</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-wallet2"></i></span>
                        <select class="form-select" name="paymentMethod" required id="paymentMethod">
                            <option value="" selected disabled>Select method</option>
                            <option value="Cash">Cash</option>
                            <option value="Card">Card</option>
                            <option value="Online">Online</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Payment Amount *</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-currency-dollar"></i></span>
                        <input type="number" step="0.01" class="form-control" name="paymentAmount"
                               value="<%= bill.getBillAmount() %>" required id="paymentAmount">
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-submit-payment flex-grow-1" id="submitPaymentBtn">
                        <i class="bi bi-check-lg me-2"></i>Submit Payment
                    </button>
                    <a href="bill-details?billId=<%= bill.getBillId() %>" class="btn-back d-flex align-items-center">
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
