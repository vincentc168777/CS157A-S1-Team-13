<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login - Car Club</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'DM Sans', sans-serif; background: #0a0a0a; color: #f0f0f0; min-height: 100vh; }
    nav { display: flex; align-items: center; justify-content: space-between; padding: 18px 48px; border-bottom: 0.5px solid #2a2a2a; }
    .logo { font-family: 'Bebas Neue', sans-serif; font-size: 26px; letter-spacing: 3px; color: #e8b44b; text-decoration: none; }
    .nav-links { display: flex; gap: 28px; align-items: center; }
    .nav-links a { color: #888; font-size: 12px; text-decoration: none; letter-spacing: 1.5px; text-transform: uppercase; transition: color 0.2s; }
    .nav-links a:hover { color: #e8b44b; }
    .page-layout { display: grid; grid-template-columns: 1fr 1fr; min-height: calc(100vh - 63px); }
    .left-panel { background: #0d0d0d; border-right: 0.5px solid #1e1e1e; padding: 72px 56px; display: flex; flex-direction: column; justify-content: center; }
    .left-tag { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #e8b44b; margin-bottom: 20px; }
    .left-title { font-family: 'Bebas Neue', sans-serif; font-size: 64px; line-height: 1; letter-spacing: 2px; margin-bottom: 28px; }
    .left-title span { color: #e8b44b; }
    .left-sub { color: #666; font-size: 14px; line-height: 1.8; max-width: 340px; }
    .right-panel { padding: 60px 56px; display: flex; flex-direction: column; justify-content: center; }
    .form-heading { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 36px; padding-bottom: 16px; border-bottom: 0.5px solid #1e1e1e; }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; color: #ffffff; margin-bottom: 8px; }
    .required-mark { color: #e8b44b; margin-left: 2px; }
    .form-group input { width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0; padding: 12px 16px; font-family: 'DM Sans', sans-serif; font-size: 14px; outline: none; transition: border-color 0.2s; }
    .form-group input::placeholder { color: #444; }
    .form-group input:focus { border-color: #e8b44b; }
    .form-actions { margin-top: 8px; display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .btn-primary { background: #e8b44b; color: #ffffff; border: none; padding: 13px 36px; font-family: 'DM Sans', sans-serif; font-size: 12px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #f5c76a; }
    .register-link { font-size: 13px; color: #555; }
    .register-link a { color: #e8b44b; text-decoration: none; }
    .register-link a:hover { text-decoration: underline; }
    .alert { padding: 14px 18px; font-size: 13px; margin-bottom: 28px; border-left: 3px solid; letter-spacing: 0.3px; }
    .alert-error { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }
    @media (max-width: 900px) {
      .page-layout { grid-template-columns: 1fr; }
      .left-panel { display: none; }
      .right-panel { padding: 40px 28px; }
      nav { padding: 18px 24px; }
    }
  </style>
</head>
<body>

<nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <a href="register.jsp">Register</a>
  </div>
</nav>

<%
  String errorMsg = null;

  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username == null || username.trim().isEmpty() ||
        password == null || password.trim().isEmpty()) {
      errorMsg = "Username and password are required.";
    } else {
      String hashedPass = MysqlCon.hashPassword(password);
      int userID = MysqlCon.loginUser(username.trim(), hashedPass);

      if (userID != -1) {
        session.setAttribute("userID", userID);
        session.setAttribute("username", username.trim());
        response.sendRedirect("index.jsp");
        return;
      } else {
        errorMsg = "Invalid username or password.";
      }
    }
  }
%>

<div class="page-layout">

  <div class="left-panel">
    <div class="left-tag">Member Login</div>
    <h1 class="left-title">Welcome<br><span>Back</span></h1>
    <p class="left-sub">Sign in to manage your garage, join clubs, and discover local car events.</p>
  </div>

  <div class="right-panel">

    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <div class="form-heading">Sign in to your account</div>

    <form method="POST" action="login.jsp" novalidate>

      <div class="form-group">
        <label for="username">Username <span class="required-mark">*</span></label>
        <input type="text" id="username" name="username" placeholder="Your username" maxlength="30" required />
      </div>

      <div class="form-group">
        <label for="password">Password <span class="required-mark">*</span></label>
        <input type="password" id="password" name="password" placeholder="Your password" required />
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-primary">Sign In</button>
        <span class="register-link">No account? <a href="register.jsp">Register here</a></span>
      </div>

    </form>
  </div>
</div>

</body>
</html>