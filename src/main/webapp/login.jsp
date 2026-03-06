<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Login</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- OceanView Theme -->
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/login.css" rel="stylesheet">
</head>

<body class="page-auth">

    <div class="glass-card">

        <div class="brand-icon blue">
            <i class="bi bi-water"></i>
        </div>
        <h3>OceanView</h3>
        <p class="subtitle">Room Reservation System</p>

        <%-- Error message from LoginServlet --%>
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

        <%-- Success message from registration --%>
        <%
            String registered = request.getParameter("registered");
            if ("true".equals(registered)) {
        %>
        <div class="alert alert-success d-flex align-items-center" role="alert">
            <i class="bi bi-check-circle me-2"></i>
            Account created successfully. Please log in.
        </div>
        <%
            }
        %>

        <!-- LOGIN FORM -->
        <form method="post" action="login" id="loginForm">

            <div class="mb-3">
                <label class="form-label">Username</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" name="username"
                           placeholder="Enter your username" required id="loginUsername">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" name="password"
                           placeholder="Enter your password" required id="loginPassword">
                </div>
            </div>

            <button type="submit" class="btn btn-ocean w-100" id="loginSubmit">
                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
            </button>

        </form>

        <div class="divider"><span>or</span></div>

        <div class="link-row">
            New staff member?
            <a href="register.jsp">Create an account</a>
        </div>

    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>