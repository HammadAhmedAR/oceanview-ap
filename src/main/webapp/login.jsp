<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Login</title></head>
<body>
  <h2>Login</h2>
  <form method="post" action="login">
    <label>Username:</label>
    <input name="username" required />
    <br/>
    <label>Password:</label>
    <input name="password" type="password" required />
    <br/>
    <button type="submit">Login</button>
  </form>
</body>
</html>