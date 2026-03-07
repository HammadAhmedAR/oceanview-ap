<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oceanview.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Help</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/dashboard.css" rel="stylesheet">
    <link href="css/staff.css" rel="stylesheet">
    <link href="css/help.css" rel="stylesheet">
</head>
<body>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    String displayRole = loggedUser.getRole() != null ? loggedUser.getRole() : "STAFF";
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

        <div class="help-container">

            <div class="page-header">
                <h2><i class="bi bi-question-circle"></i> System Help</h2>
                <a href="dashboard" class="btn-back"><i class="bi bi-arrow-left"></i> Dashboard</a>
            </div>

            <!-- Quick Navigation -->
            <div class="help-nav">
                <a href="#login">Login</a>
                <a href="#staff">Staff Management</a>
                <a href="#guests">Guest Management</a>
                <a href="#reservations">Reservations</a>
                <a href="#billing">Billing</a>
                <a href="#payments">Payments</a>
                <a href="#logout">Logout</a>
            </div>

            <!-- Login -->
            <div class="help-card" id="login">
                <h4><i class="bi bi-box-arrow-in-right"></i> System Login</h4>
                <p>To access the system, enter your username and password on the login page. After successful authentication you will be redirected to the dashboard.</p>
                <ol>
                    <li>Open the application in your browser.</li>
                    <li>Click <strong>Sign In</strong> on the landing page.</li>
                    <li>Enter your username and password.</li>
                    <li>Click <strong>Login</strong> to access the dashboard.</li>
                </ol>
            </div>

            <!-- Staff Management -->
            <div class="help-card" id="staff">
                <h4><i class="bi bi-people-fill"></i> Staff Management (Admin Only)</h4>
                <p>Administrators can manage staff accounts from the dashboard. Regular staff members do not have access to this feature.</p>
                <ol>
                    <li>Click <strong>Manage Staff</strong> on the dashboard.</li>
                    <li>View the list of all staff members.</li>
                    <li>Click <strong>Add Staff</strong> to create a new account.</li>
                    <li>Use <strong>Edit</strong> to update a staff member's details.</li>
                    <li>Use <strong>Delete</strong> to remove a staff account.</li>
                </ol>
            </div>

            <!-- Guest Management -->
            <div class="help-card" id="guests">
                <h4><i class="bi bi-person-vcard"></i> Guest Management</h4>
                <p>Before creating a reservation, the guest must be registered in the system. Both admin and staff users can manage guests.</p>
                <ol>
                    <li>Click <strong>Manage Guests</strong> on the dashboard.</li>
                    <li>Click <strong>Add Guest</strong> to register a new guest.</li>
                    <li>Fill in first name, last name, phone, email, and address.</li>
                    <li>Use <strong>Edit</strong> to update guest details.</li>
                    <li>Use <strong>Delete</strong> to remove a guest record.</li>
                </ol>
            </div>

            <!-- Reservations -->
            <div class="help-card" id="reservations">
                <h4><i class="bi bi-calendar-week"></i> Reservation Management</h4>
                <p>Create reservations by assigning a registered guest to an available room for specific dates. The system automatically calculates the number of nights and total cost.</p>
                <ol>
                    <li>Click <strong>Manage Reservations</strong> on the dashboard.</li>
                    <li>Click <strong>Add Reservation</strong>.</li>
                    <li>Enter a unique reservation number.</li>
                    <li>Select a guest and a room from the dropdowns.</li>
                    <li>Pick check-in and check-out dates.</li>
                    <li>Submit &mdash; the system validates availability and calculates the total.</li>
                    <li>Use <strong>View</strong> to see reservation details.</li>
                    <li>Use <strong>Cancel</strong> to cancel a reservation (the room becomes available again).</li>
                </ol>
            </div>

            <!-- Billing -->
            <div class="help-card" id="billing">
                <h4><i class="bi bi-receipt-cutoff"></i> Billing</h4>
                <p>After a reservation is created, generate a bill to prepare an invoice for the guest. Each reservation can have only one bill.</p>
                <ol>
                    <li>Go to <strong>Manage Reservations</strong> and click <strong>View</strong> on a reservation.</li>
                    <li>Click <strong>Generate Bill</strong> on the reservation details page.</li>
                    <li>The invoice page displays guest details, room details, dates, rate per night, and total amount.</li>
                    <li>Use <strong>Print</strong> to print the invoice.</li>
                </ol>
            </div>

            <!-- Payments -->
            <div class="help-card" id="payments">
                <h4><i class="bi bi-credit-card"></i> Payments</h4>
                <p>Record payment against a generated bill. Once payment is recorded, the bill status changes to Paid.</p>
                <ol>
                    <li>Open an invoice and click <strong>Record Payment</strong>.</li>
                    <li>Select payment method: Cash, Card, or Online.</li>
                    <li>Confirm the payment amount matches the bill.</li>
                    <li>Click <strong>Submit Payment</strong>.</li>
                    <li>View all payments from <strong>Payment History</strong> on the dashboard.</li>
                </ol>
            </div>

            <!-- Logout -->
            <div class="help-card" id="logout">
                <h4><i class="bi bi-box-arrow-right"></i> Logging Out</h4>
                <p>Always log out after completing your work to keep the system secure. Click the <strong>Logout</strong> button in the top-right corner of any page. You will be redirected to the login screen.</p>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
