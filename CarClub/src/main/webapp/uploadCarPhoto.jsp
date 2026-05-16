<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Car Photos - Car Club</title>
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
    .perks { display: flex; flex-direction: column; gap: 16px; }
    .perk { display: flex; align-items: flex-start; gap: 14px; }
    .perk-dot { width: 6px; height: 6px; background: #e8b44b; border-radius: 50%; margin-top: 6px; flex-shrink: 0; }
    .perk-text { font-size: 13px; color: #888; line-height: 1.5; }
    .perk-text strong { color: #ccc; font-weight: 500; }

    .right-panel { padding: 60px 56px; display: flex; flex-direction: column; overflow-y: auto; }
    .form-heading { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 36px; padding-bottom: 16px; border-bottom: 0.5px solid #1e1e1e; }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; color: #ffffff; margin-bottom: 8px; }
    .required-mark { color: #e8b44b; margin-left: 2px; }
    .form-group input, .form-group select {
      width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0;
      padding: 12px 16px; font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: border-color 0.2s; appearance: none;
    }
    .form-group select option { background: #1a1a1a; }
    .form-group input::placeholder { color: #444; }
    .form-group input:focus, .form-group select:focus { border-color: #e8b44b; }
    .form-group .hint { font-size: 11px; color: #444; margin-top: 6px; letter-spacing: 0.3px; }
    .form-actions { margin-top: 8px; display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .btn-primary { background: #e8b44b; color: #fff; border: none; padding: 13px 36px; font-family: 'DM Sans', sans-serif; font-size: 12px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #f5c76a; }
    .btn-danger { background: transparent; color: #cf5e5e; border: 0.5px solid #7a2d2d; padding: 6px 14px; font-family: 'DM Sans', sans-serif; font-size: 11px; letter-spacing: 1px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-danger:hover { background: #7a2d2d; color: #f0f0f0; }
    .btn-ghost { background: transparent; color: #555; border: 0.5px solid #2a2a2a; padding: 13px 28px; font-family: 'DM Sans', sans-serif; font-size: 12px; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; text-decoration: none; display: inline-block; transition: border-color 0.2s, color 0.2s; }
    .btn-ghost:hover { border-color: #555; color: #f0f0f0; }
    .alert { padding: 14px 18px; font-size: 13px; margin-bottom: 28px; border-left: 3px solid; letter-spacing: 0.3px; }
    .alert-success { background: #0b1c12; border-color: #2d7a48; color: #5ecf8a; }
    .alert-error   { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }
    .section-divider { font-size: 11px; letter-spacing: 2px; text-transform: uppercase; color: #333; margin: 8px 0 24px; padding-bottom: 12px; border-bottom: 0.5px solid #1a1a1a; }

    /* Photo gallery grid */
    .photo-section-label { font-size: 11px; letter-spacing: 2px; text-transform: uppercase; color: #555; margin-bottom: 16px; margin-top: 40px; padding-bottom: 12px; border-bottom: 0.5px solid #1a1a1a; }
    .photo-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 12px; margin-bottom: 16px; }
    .photo-card { background: #111; border: 0.5px solid #1e1e1e; overflow: hidden; }
    .photo-card img { width: 100%; height: 120px; object-fit: cover; display: block; background: #1a1a1a; }
    .photo-card-footer { padding: 8px 10px; display: flex; justify-content: space-between; align-items: center; }
    .photo-url-label { font-size: 10px; color: #444; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100px; }
    .no-photos { color: #444; font-size: 13px; padding: 20px 0; }
    .no-cars-notice { background: #111; border: 0.5px solid #2a2a2a; padding: 28px; text-align: center; color: #555; font-size: 13px; line-height: 1.7; }
    .no-cars-notice a { color: #e8b44b; text-decoration: none; }

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

  List<String[]> userCars = MysqlCon.getUserCars(sessionUserID);

  String successMsg = null;
  String errorMsg   = null;

  // ── Handle POST ────────────────────────────────────────────────────────────
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String action   = request.getParameter("action");
    String carIDStr = request.getParameter("carID");
    String photoURL = request.getParameter("photoURL");

    // ── Delete photo ──────────────────────────────────────────────────────
    if ("delete".equals(action)) {
      String photoIDStr = request.getParameter("photoID");
      if (photoIDStr != null && !photoIDStr.trim().isEmpty()) {
        try {
          int photoID = Integer.parseInt(photoIDStr.trim());
          boolean ok = MysqlCon.deleteCarPhoto(photoID, sessionUserID);
          successMsg = ok ? "Photo removed." : "Could not remove photo.";
          if (!ok) errorMsg = "Could not remove photo.";
          else successMsg = "Photo removed successfully.";
        } catch (NumberFormatException e) {
          errorMsg = "Invalid photo ID.";
        }
      }

    // ── Add photo ─────────────────────────────────────────────────────────
    } else {
      if (carIDStr == null || carIDStr.trim().isEmpty()) {
        errorMsg = "Please select a car.";
      } else if (photoURL == null || photoURL.trim().isEmpty()) {
        errorMsg = "Please enter a photo URL.";
      } else {
        try {
          int carID = Integer.parseInt(carIDStr.trim());
          boolean ok = MysqlCon.addCarPhoto(carID, sessionUserID, photoURL.trim());
          if (ok) {
            successMsg = "Photo added successfully!";
          } else {
            errorMsg = "Failed to add photo. Make sure you own this car.";
          }
        } catch (NumberFormatException e) {
          errorMsg = "Invalid car selection.";
        }
      }
    }
  }

  // ── Selected car for gallery preview ──────────────────────────────────────
  String selectedCarIDStr = request.getParameter("carID");
  if (selectedCarIDStr == null && !userCars.isEmpty()) {
    selectedCarIDStr = userCars.get(0)[0]; // default to first car
  }
  int selectedCarID = -1;
  String selectedCarName = "";
  List<String[]> currentPhotos = new java.util.ArrayList<>();
  if (selectedCarIDStr != null) {
    try {
      selectedCarID = Integer.parseInt(selectedCarIDStr);
      for (String[] c : userCars) {
        if (c[0].equals(String.valueOf(selectedCarID))) {
          selectedCarName = c[2] + " " + c[1] + " (" + c[3] + ")";
          break;
        }
      }
      currentPhotos = MysqlCon.getCarPhotos(selectedCarID);
    } catch (NumberFormatException ignored) {}
  }
%>

<nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <% if (sessionUsername != null) { %>
      <a href="AddCar.jsp">Add Car</a>
      <a href="createClub.jsp">Clubs</a>
      <a href="events.jsp">Events</a>
      <a href="viewProfile.jsp?id=<%= sessionUserID %>">My Profile</a>
      <a href="logout.jsp">Logout (<%= sessionUsername %>)</a>
    <% } else { %>
      <a href="createClub.jsp">Clubs</a>
      <a href="events.jsp">Events</a>
      <a href="login.jsp">Login</a>
      <a href="register.jsp">Register</a>
    <% } %>
  </div>
</nav>

<div class="page-layout">

  <!-- LEFT – branding -->
  <div class="left-panel">
    <div class="left-tag">Digital Garage</div>
    <h1 class="left-title">Car<br><span>Photos</span></h1>
    <p class="left-sub">
      Showcase your build. Add photo URLs to any car in your Digital Garage and let the community see your ride.
    </p>
    <div class="perks">
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Your Cars Only</strong> – you can only add photos to cars you own.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>URL-Based</strong> – paste a direct link to any hosted image.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Visible on Profile</strong> – photos appear on your public profile page.</div>
      </div>
    </div>
  </div>

  <!-- RIGHT – form + gallery -->
  <div class="right-panel">

    <% if (successMsg != null) { %>
      <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <% if (userCars.isEmpty()) { %>
      <div class="no-cars-notice">
        You don't have any cars in your garage yet.<br>
        <a href="AddCar.jsp">Add a car first</a> before uploading photos.
      </div>
    <% } else { %>

      <div class="form-heading">Add a photo</div>

      <form method="POST" action="uploadCarPhoto.jsp" novalidate>
        <input type="hidden" name="action" value="add"/>

        <div class="form-group">
          <label for="carID">Select Car <span class="required-mark">*</span></label>
          <select id="carID" name="carID" required onchange="this.form.submit()">
            <% for (String[] c : userCars) {
               boolean sel = c[0].equals(String.valueOf(selectedCarID)); %>
              <option value="<%= c[0] %>" <%= sel ? "selected" : "" %>>
                <%= c[3] %> <%= c[1] %> <%= c[2] %>
              </option>
            <% } %>
          </select>
          <div class="hint">Choose which car to add a photo to.</div>
        </div>

        <div class="form-group">
          <label for="photoURL">Photo URL <span class="required-mark">*</span></label>
          <input type="url" id="photoURL" name="photoURL"
                 placeholder="https://example.com/my-car.jpg" maxlength="255" required/>
          <div class="hint">Direct link to an image (JPG, PNG, WebP, etc.)</div>
        </div>

        <div class="form-actions">
          <button type="submit" class="btn-primary">Add Photo</button>
          <a href="index.jsp" class="btn-ghost">Back to Garage</a>
        </div>
      </form>

      <!-- ── Current photos for selected car ─────────────────────────────── -->
      <% if (selectedCarID > 0) { %>
        <div class="photo-section-label">
          Photos for <%= selectedCarName %> (<%= currentPhotos.size() %>)
        </div>

        <% if (currentPhotos.isEmpty()) { %>
          <p class="no-photos">No photos yet for this car. Add one above.</p>
        <% } else { %>
          <div class="photo-grid">
            <% for (String[] photo : currentPhotos) { %>
              <div class="photo-card">
                <img src="<%= photo[2] %>" alt="Car photo"
                     onerror="this.style.background='#1a1a1a';this.style.height='120px';this.alt='Image not found';" />
                <div class="photo-card-footer">
                  <span class="photo-url-label" title="<%= photo[2] %>"><%= photo[2] %></span>
                  <form method="POST" action="uploadCarPhoto.jsp" style="display:inline;"
                        onsubmit="return confirm('Remove this photo?');">
                    <input type="hidden" name="action"  value="delete"/>
                    <input type="hidden" name="photoID" value="<%= photo[0] %>"/>
                    <input type="hidden" name="carID"   value="<%= selectedCarID %>"/>
                    <button type="submit" class="btn-danger">Remove</button>
                  </form>
                </div>
              </div>
            <% } %>
          </div>
        <% } %>
      <% } %>

    <% } %>
  </div>
</div>

</body>
</html>
