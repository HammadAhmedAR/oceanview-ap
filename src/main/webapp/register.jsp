<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OceanView &mdash; Register</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- OceanView Theme -->
    <link href="css/oceanview-common.css" rel="stylesheet">
    <link href="css/register.css" rel="stylesheet">
</head>

<body class="page-auth">

    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>
    <div class="bubble"></div>

    <div class="glass-card">

        <div class="brand-icon green">
            <i class="bi bi-person-plus"></i>
        </div>
        <h3>Create Account</h3>
        <p class="subtitle">Join the OceanView team</p>

        <%-- Error message from RegisterServlet --%>
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

        <!-- REGISTER FORM -->
        <form method="post" action="register" id="registerForm">

            <div class="mb-3">
                <label class="form-label">Username</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                    <input type="text" class="form-control" name="username"
                           placeholder="Choose a username" required id="regUsername">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" name="password"
                           placeholder="Create a password" required id="regPassword">
                </div>
            </div>

            <button type="submit" class="btn btn-register w-100" id="registerSubmit">
                <i class="bi bi-person-check me-2"></i>Create Account
            </button>

        </form>

        <div class="divider"><span>or</span></div>

        <div class="link-row">
            Already have an account?
            <a href="login.jsp">Sign in</a>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>