<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Room Reservation System</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- OceanView Theme -->
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/index.css" rel="stylesheet">
</head>

<body class="page-landing">

    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>

    <div class="hero-card">
        <div class="hero-icon">
            <i class="bi bi-water"></i>
        </div>

        <h1>Ocean<span>View</span></h1>
        <p>Your all-in-one room reservation management system. Manage bookings, rooms, and guests with ease.</p>

        <div class="d-flex justify-content-center gap-3 flex-wrap">
            <a href="login.jsp" class="btn btn-hero btn-hero-primary" id="heroLogin">
                <i class="bi bi-box-arrow-in-right"></i> Sign In
            </a>
            <a href="register.jsp" class="btn btn-hero btn-hero-outline" id="heroRegister">
                <i class="bi bi-person-plus"></i> Register
            </a>
        </div>

        <div class="status-badge">
            <span class="dot"></span> System Online
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>