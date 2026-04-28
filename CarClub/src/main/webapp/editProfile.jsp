<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Edit Profile - Car Club</title>
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
    .left-sub { color: #666; font-size: 14px; line-height: 1.8; max-width: 340px; margin-bottom: 40px; }
    .profile-preview { background: #111; border: 0.5px solid #1e1e1e; padding: 24px; }
    .preview-label { font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #444; margin-bottom: 16px; }
    .preview-name { font-family: 'Bebas Neue', sans-serif; font-size: 28px; letter-spacing: 1px; color: #f0f0f0; margin-bottom: 4px; }
    .preview-username { font-size: 12px; color: #555; margin-bottom: 12px; }
    .preview-bio { font-size: 13px; color: #777; line-height: 1.6; margin-bottom: 10px; }
    .preview-location { font-size: 11px; color: #444; letter-spacing: 1px; text-transform: uppercase; }
    .right-panel { padding: 60px 56px; display: flex; flex-direction: column; justify-content: center; overflow-y: auto; }
    .form-heading { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 36px; padding-bottom: 16px; border-bottom: 0.5px solid #1e1e1e; }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; color: #ffffff; margin-bottom: 8px; }
    .form-group input, .form-group textarea {
      width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0;
      padding: 12px 16px; font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: border-color 0.2s; resize: none;
    }
    .form-group input::placeholder, .form-group textarea::placeholder { color: #444; }
    .form-group input:focus, .form-group textarea:focus { border-color: #e8b44b; }
    .form-group .hint { font-size: 11px; color: #444; margin-top: 6px; letter-spacing: 0.3px; }
    .char-count { font-size: 11px; color: #444; margin-top: 6px; text-align: right; }
    .form-actions { margin-top: 8px; display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .btn-primary { background: #e8b44b; color: #ffffff; border: none; padding: 13px 36px; font-family: 'DM Sans', sans-serif; font-size: 12px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #f5c76a; }
    .btn-ghost { background: transparent; color: #555; border: 0.5px solid #2a2a2a; padding: 13px 28px; font-family: 'DM Sans', sans-serif; font-size: 12px; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; text-decoration: none; display: inline-block; transition: border-color 0.2s, color 0.2s; }
    .btn-ghost:hover { border-color: #555; color: #f0f0f0; }
    .alert { padding: 14px 18px; font-size: 13px; margin-bottom: 28px; border-left: 3px solid; letter-spacing: 0.3px; }
    .alert-success { background: #0b1c12; border-color: #2d7a48; color: #5ecf8a; }
    .alert-error   { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }
    @media (max-width: 900px) {
      .page-layout { grid-template-columns: 1fr; }
      .left-panel { display: none; }
      .right-panel { padding: 40px 28px; }
      nav { padding: 18px 24px; }
    }
  </style>
</head>
<body>

<%
  // ── Session guard ──────────────────────────────────────────────────────────
  Integer sessionUserID = (Integer) session.getAttribute("userID");
  String  sessionUsername = (String) session.getAttribute("username");
  if (sessionUserID == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  // ── Load current profile ───────────────────────────────────────────────────
  String[] profile = MysqlCon.getUserProfile(sessionUserID);
  String currentDisplay  = (profile != null && profile[1] != null) ? profile[1] : "";
  String currentBio      = (profile != null && profile[2] != null) ? profile[2] : "";
  String currentLocation = (profile != null && profile[3] != null) ? profile[3] : "";

  String successMsg = null;
  String errorMsg   = null;

  // ── Handle POST ────────────────────────────────────────────────────────────
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String newDisplay  = request.getParameter("displayName");
    String newBio      = request.getParameter("bio");
    String newLocation = request.getParameter("location");

    newDisplay  = (newDisplay  != null) ? newDisplay.trim()  : "";
    newBio      = (newBio      != null) ? newBio.trim()      : "";
    newLocation = (newLocation != null) ? newLocation.trim() : "";

    // Basic length guards matching DB column sizes
    if (newDisplay.length() > 100) {
      errorMsg = "Display name must be 100 characters or fewer.";
    } else if (newBio.length() > 500) {
      errorMsg = "Bio must be 500 characters or fewer.";
    } else if (newLocation.length() > 100) {
      errorMsg = "Location must be 100 characters or fewer.";
    } else {
      boolean ok = MysqlCon.updateProfile(sessionUserID, newDisplay, newBio, newLocation);
      if (ok) {
        successMsg     = "Profile updated successfully.";
        currentDisplay  = newDisplay;
        currentBio      = newBio;
        currentLocation = newLocation;
      } else {
        errorMsg = "Update failed. Please try again.";
      }
    }
  }
%>

<nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <a href="viewProfile.jsp?id=<%= sessionUserID %>">My Profile</a>
    <a href="logout.jsp">Logout</a>
  </div>
</nav>

<div class="page-layout">

  <!-- LEFT – live preview panel -->
  <div class="left-panel">
    <div class="left-tag">Profile Settings</div>
    <h1 class="left-title">Edit Your<br><span>Profile</span></h1>
    <p class="left-sub">Your display name, bio, and location are visible to other members on your public profile page.</p>

    <div class="profile-preview">
      <div class="preview-label">Preview</div>
      <div class="preview-name" id="prevName"><%= currentDisplay.isEmpty() ? sessionUsername : currentDisplay %></div>
      <div class="preview-username">@<%= sessionUsername %></div>
      <div class="preview-bio" id="prevBio"><%= currentBio.isEmpty() ? "No bio yet." : currentBio %></div>
      <div class="preview-location" id="prevLoc"><%= currentLocation.isEmpty() ? "Location not set" : "📍 " + currentLocation %></div>
    </div>
  </div>

  <!-- RIGHT – form -->
  <div class="right-panel">

    <% if (successMsg != null) { %>
      <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <div class="form-heading">Update your public profile</div>

    <form method="POST" action="editProfile.jsp" novalidate>

      <div class="form-group">
        <label for="displayName">Display Name</label>
        <input
          type="text"
          id="displayName"
          name="displayName"
          placeholder="Your public display name"
          maxlength="100"
          value="<%= currentDisplay %>"
          oninput="updatePreview()"
        />
        <div class="hint">Shown in place of your username on your profile</div>
      </div>

      <div class="form-group">
        <label for="location">Location</label>
        <input
          type="text"
          id="location"
          name="location"
          placeholder="City, State"
          maxlength="100"
          value="<%= currentLocation %>"
          oninput="updatePreview()"
        />
      </div>

      <div class="form-group">
        <label for="bio">Bio</label>
        <textarea
          id="bio"
          name="bio"
          rows="4"
          maxlength="500"
          placeholder="Tell the community about yourself and your cars..."
          oninput="updatePreview(); updateCharCount(this, 'bioCount', 500)"
        ><%= currentBio %></textarea>
        <div class="char-count"><span id="bioCount"><%= currentBio.length() %></span> / 500</div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-primary">Save Changes</button>
        <a href="viewProfile.jsp?id=<%= sessionUserID %>" class="btn-ghost">View Profile</a>
      </div>

    </form>
  </div>
</div>

<script>
  function updatePreview() {
    const name     = document.getElementById('displayName').value.trim();
    const bio      = document.getElementById('bio').value.trim();
    const location = document.getElementById('location').value.trim();

    document.getElementById('prevName').textContent = name || '<%= sessionUsername %>';
    document.getElementById('prevBio').textContent  = bio  || 'No bio yet.';
    document.getElementById('prevLoc').textContent  = location ? '📍 ' + location : 'Location not set';
  }

  function updateCharCount(el, countId, max) {
    document.getElementById(countId).textContent = el.value.length;
  }
</script>

</body>
</html>
