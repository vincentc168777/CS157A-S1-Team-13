<%@ page import="carClubJava.MysqlCon" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Register — Car Club</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'DM Sans', sans-serif;
      background: #0a0a0a;
      color: #f0f0f0;
      min-height: 100vh;
    }

    nav {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 18px 48px;
      border-bottom: 0.5px solid #2a2a2a;
    }
    .logo {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 26px;
      letter-spacing: 3px;
      color: #e8b44b;
      text-decoration: none;
    }
    .nav-links { display: flex; gap: 28px; align-items: center; }
    .nav-links a {
      color: #888;
      font-size: 12px;
      text-decoration: none;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      transition: color 0.2s;
    }
    .nav-links a:hover { color: #e8b44b; }

    /* TWO-COLUMN LAYOUT */
    .page-layout {
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: calc(100vh - 63px);
    }

    /* LEFT PANEL */
    .left-panel {
      background: #0d0d0d;
      border-right: 0.5px solid #1e1e1e;
      padding: 72px 56px;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }
    .left-tag {
      font-size: 11px;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: #e8b44b;
      margin-bottom: 20px;
    }
    .left-title {
      font-family: 'Bebas Neue', sans-serif;
      font-size: 64px;
      line-height: 1;
      letter-spacing: 2px;
      margin-bottom: 28px;
    }
    .left-title span { color: #e8b44b; }
    .left-sub {
      color: #666;
      font-size: 14px;
      line-height: 1.8;
      margin-bottom: 48px;
      max-width: 340px;
    }
    .perks { display: flex; flex-direction: column; gap: 16px; }
    .perk {
      display: flex;
      align-items: flex-start;
      gap: 14px;
    }
    .perk-dot {
      width: 6px;
      height: 6px;
      background: #e8b44b;
      border-radius: 50%;
      margin-top: 6px;
      flex-shrink: 0;
    }
    .perk-text {
      font-size: 13px;
      color: #888;
      line-height: 1.5;
    }
    .perk-text strong { color: #ccc; font-weight: 500; }

    /* RIGHT PANEL — FORM */
    .right-panel {
      padding: 60px 56px;
      overflow-y: auto;
    }
    .form-heading {
      font-size: 11px;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: #555;
      margin-bottom: 36px;
      padding-bottom: 16px;
      border-bottom: 0.5px solid #1e1e1e;
    }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    .form-group { margin-bottom: 24px; }
    .form-group label {
      display: block;
      font-size: 11px;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      color: #555;
      margin-bottom: 8px;
    }
    .required-mark { color: #e8b44b; margin-left: 2px; }
    .form-group input,
    .form-group textarea {
      width: 100%;
      background: #131313;
      border: 0.5px solid #2a2a2a;
      color: #f0f0f0;
      padding: 12px 16px;
      font-family: 'DM Sans', sans-serif;
      font-size: 14px;
      outline: none;
      transition: border-color 0.2s;
      resize: none;
    }
    .form-group input::placeholder,
    .form-group textarea::placeholder { color: #444; }
    .form-group input:focus,
    .form-group textarea:focus { border-color: #e8b44b; }
    .form-group .hint {
      font-size: 11px;
      color: #444;
      margin-top: 6px;
      letter-spacing: 0.3px;
    }

    .section-divider {
      font-size: 11px;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: #333;
      margin: 8px 0 24px;
      padding-bottom: 12px;
      border-bottom: 0.5px solid #1a1a1a;
    }

    .form-actions { margin-top: 8px; display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .btn-primary {
      background: #e8b44b;
      color: #0a0a0a;
      border: none;
      padding: 13px 36px;
      font-family: 'DM Sans', sans-serif;
      font-size: 12px;
      font-weight: 500;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      cursor: pointer;
      transition: background 0.2s;
    }
    .btn-primary:hover { background: #f5c76a; }
    .login-link {
      font-size: 13px;
      color: #555;
    }
    .login-link a { color: #e8b44b; text-decoration: none; }
    .login-link a:hover { text-decoration: underline; }

    /* ALERTS */
    .alert {
      padding: 14px 18px;
      font-size: 13px;
      margin-bottom: 28px;
      border-left: 3px solid;
      letter-spacing: 0.3px;
    }
    .alert-success { background: #0b1c12; border-color: #2d7a48; color: #5ecf8a; }
    .alert-error   { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }

    /* PASSWORD STRENGTH */
    .strength-bar {
      height: 2px;
      background: #1e1e1e;
      margin-top: 8px;
      position: relative;
      overflow: hidden;
    }
    .strength-fill {
      height: 100%;
      width: 0%;
      transition: width 0.3s, background 0.3s;
    }
    .strength-label {
      font-size: 11px;
      color: #444;
      margin-top: 4px;
      transition: color 0.3s;
    }

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
  /* ── Handle POST ── */
  String successMsg = null;
  String errorMsg   = null;

  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username    = request.getParameter("username");
    String email       = request.getParameter("email");
    String password    = request.getParameter("password");
    String displayName = request.getParameter("displayName");
    String bio         = request.getParameter("bio");
    String location    = request.getParameter("location");

    /* Basic server-side validation */
    if (username == null || username.trim().isEmpty() ||
        email    == null || email.trim().isEmpty()    ||
        password == null || password.trim().isEmpty()) {
      errorMsg = "Username, email, and password are required.";
    } else {
      /* Hash the password before storing */
      String hashedPassword = MysqlCon.hashPassword(password);

      boolean registered = MysqlCon.registerUser(
        username.trim(),
        email.trim(),
        hashedPassword,
        displayName != null ? displayName.trim() : "",
        bio         != null ? bio.trim()         : "",
        location    != null ? location.trim()    : ""
      );

      if (registered) {
        successMsg = "Welcome to Car Club, " + username.trim() + ". Your profile has been created.";
      } else {
        errorMsg = "Registration failed. Username or email may already be in use.";
      }
    }
  }
%>

<div class="page-layout">

  <!-- LEFT — branding panel -->
  <div class="left-panel">
    <div class="left-tag">Member Registration</div>
    <h1 class="left-title">Join the<br><span>Club</span></h1>
    <p class="left-sub">Create your profile and become part of the Car Club community. Track your collection, connect with other enthusiasts.</p>
    <div class="perks">
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Personal Garage</strong> — manage your registered vehicles in one place.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Community Profile</strong> — display name, bio, and location visible to other members.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Secure by default</strong> — passwords are cryptographically hashed, never stored in plain text.</div>
      </div>
    </div>
  </div>

  <!-- RIGHT — form -->
  <div class="right-panel">

    <% if (successMsg != null) { %>
      <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <div class="form-heading">Create your account</div>

    <form method="POST" action="register.jsp" novalidate>

      <!-- REQUIRED FIELDS -->
      <div class="form-row">
        <div class="form-group">
          <label for="username">Username <span class="required-mark">*</span></label>
          <input type="text" id="username" name="username" placeholder="e.g. street_racer99" maxlength="30" required />
          <div class="hint">Unique · max 30 characters</div>
        </div>
        <div class="form-group">
          <label for="email">Email <span class="required-mark">*</span></label>
          <input type="email" id="email" name="email" placeholder="you@example.com" required />
          <div class="hint">Used for login · never shared</div>
        </div>
      </div>

      <div class="form-group">
        <label for="password">Password <span class="required-mark">*</span></label>
        <input type="password" id="password" name="password" placeholder="Minimum 8 characters" minlength="8" required oninput="checkStrength(this.value)" />
        <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
        <div class="strength-label" id="strengthLabel">Enter a password</div>
      </div>

      <!-- OPTIONAL PROFILE FIELDS -->
      <div class="section-divider">Profile details — optional</div>

      <div class="form-row">
        <div class="form-group">
          <label for="displayName">Display Name</label>
          <input type="text" id="displayName" name="displayName" placeholder="Shown on your profile" maxlength="50" />
        </div>
        <div class="form-group">
          <label for="location">Location</label>
          <input type="text" id="location" name="location" placeholder="City, State" maxlength="100" />
        </div>
      </div>

      <div class="form-group">
        <label for="bio">Bio</label>
        <textarea id="bio" name="bio" rows="3" placeholder="Tell the community a little about yourself and your cars..." maxlength="300"></textarea>
        <div class="hint">Max 300 characters</div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-primary">Create Profile</button>
        <span class="login-link">Already a member? <a href="login.jsp">Sign in</a></span>
      </div>

    </form>
  </div>
</div>

<script>
  function checkStrength(val) {
    const fill  = document.getElementById('strengthFill');
    const label = document.getElementById('strengthLabel');
    let score = 0;
    if (val.length >= 8)                          score++;
    if (/[A-Z]/.test(val))                        score++;
    if (/[0-9]/.test(val))                        score++;
    if (/[^A-Za-z0-9]/.test(val))                score++;

    const levels = [
      { pct: '0%',   color: '#2a2a2a', text: 'Enter a password' },
      { pct: '25%',  color: '#cf5e5e', text: 'Weak' },
      { pct: '50%',  color: '#e8944b', text: 'Fair' },
      { pct: '75%',  color: '#e8c44b', text: 'Good' },
      { pct: '100%', color: '#5ecf8a', text: 'Strong' },
    ];
    const lvl = val.length === 0 ? levels[0] : levels[score];
    fill.style.width      = lvl.pct;
    fill.style.background = lvl.color;
    label.style.color     = lvl.color;
    label.textContent     = lvl.text;
  }
</script>

</body>
</html>
