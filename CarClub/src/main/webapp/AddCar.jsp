<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Add a Car - Car Club</title>
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
    .left-sub { color: #666; font-size: 14px; line-height: 1.8; margin-bottom: 48px; max-width: 340px; }
    .right-panel { padding: 60px 56px; overflow-y: auto; }
    .form-heading { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 36px; padding-bottom: 16px; border-bottom: 0.5px solid #1e1e1e; }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; color: #ffffff; margin-bottom: 8px; }
    .required-mark { color: #e8b44b; margin-left: 2px; }
    .form-group input, .form-group textarea { width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0; padding: 12px 16px; font-family: 'DM Sans', sans-serif; font-size: 14px; outline: none; transition: border-color 0.2s; resize: none; }
    .form-group input::placeholder, .form-group textarea::placeholder { color: #444; }
    .form-group input:focus, .form-group textarea:focus { border-color: #e8b44b; }
    .form-group .hint { font-size: 11px; color: #444; margin-top: 6px; letter-spacing: 0.3px; }
    .form-actions { margin-top: 8px; display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .btn-primary { background: #e8b44b; color: #ffffff; border: none; padding: 13px 36px; font-family: 'DM Sans', sans-serif; font-size: 12px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #f5c76a; }
    .login-link { font-size: 13px; color: #555; }
    .login-link a { color: #e8b44b; text-decoration: none; }
    .login-link a:hover { text-decoration: underline; }
    .alert { padding: 14px 18px; font-size: 13px; margin-bottom: 28px; border-left: 3px solid; letter-spacing: 0.3px; }
    .alert-success { background: #0b1c12; border-color: #2d7a48; color: #5ecf8a; }
    .alert-error { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }
    @media (max-width: 900px) {
      .page-layout { grid-template-columns: 1fr; }
      .left-panel { display: none; }
      .right-panel { padding: 40px 28px; }
      nav { padding: 18px 24px; }
      .form-row { grid-template-columns: 1fr; }
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
  String successMsg = null;
  String errorMsg   = null;

  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String make        = request.getParameter("make");
    String model       = request.getParameter("model");
    String yearStr     = request.getParameter("year");
    String description = request.getParameter("description");

    // TODO: replace with (Integer) session.getAttribute("userID") once login is implemented
    int userID = (Integer) session.getAttribute("userID");

    if (make == null || make.trim().isEmpty() ||
        model == null || model.trim().isEmpty() ||
        yearStr == null || yearStr.trim().isEmpty()) {
      errorMsg = "Make, model, and year are required.";
    } else {
      try {
        int year = Integer.parseInt(yearStr.trim());
        boolean added = MysqlCon.addCar(
          userID,
          make.trim(),
          model.trim(),
          year,
          description != null ? description.trim() : ""
        );
        if (added) {
          successMsg = make.trim() + " " + model.trim() + " added to your garage!";
        } else {
          errorMsg = "Failed to add car. Please try again.";
        }
      } catch (NumberFormatException e) {
        errorMsg = "Year must be a valid number.";
      }
    }
  }
%>

<div class="page-layout">

  <div class="left-panel">
    <div class="left-tag">Digital Garage</div>
    <h1 class="left-title">Add Your<br><span>Car</span></h1>
    <p class="left-sub">Register a vehicle to your profile. Make, model, year, and any mods you want to show off.</p>
  </div>

  <div class="right-panel">

    <% if (successMsg != null) { %>
      <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <div class="form-heading">Vehicle details</div>

    <form method="POST" action="AddCar.jsp" novalidate>

      <div class="form-row">
        <div class="form-group">
          <label for="make">Make <span class="required-mark">*</span></label>
          <input type="text" id="make" name="make" placeholder="e.g. Toyota" maxlength="50" required />
        </div>
        <div class="form-group">
          <label for="model">Model <span class="required-mark">*</span></label>
          <input type="text" id="model" name="model" placeholder="e.g. Supra" maxlength="50" required />
        </div>
      </div>

      <div class="form-group">
        <label for="year">Year <span class="required-mark">*</span></label>
        <input type="number" id="year" name="year" placeholder="e.g. 1998" min="1886" max="2100" required />
      </div>

      <div class="form-group">
        <label for="description">Description</label>
        <textarea id="description" name="description" rows="3"
          placeholder="Mods, specs, anything you want to share..." maxlength="500"></textarea>
        <div class="hint">Max 500 characters - optional</div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-primary">Add to Garage</button>
        <span class="login-link"><a href="index.jsp">Back to Garage</a></span>
      </div>

    </form>
  </div>
</div>

</body>
</html>