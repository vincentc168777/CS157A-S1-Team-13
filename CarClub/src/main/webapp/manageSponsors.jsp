<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Manage Sponsors - Car Club</title>
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
    .form-group select {
      width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0;
      padding: 12px 16px; font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: border-color 0.2s; appearance: none;
    }
    .form-group select option { background: #1a1a1a; }
    .form-group select:focus { border-color: #e8b44b; }
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

    .sponsor-section-label { font-size: 11px; letter-spacing: 2px; text-transform: uppercase; color: #555; margin-bottom: 16px; margin-top: 40px; padding-bottom: 12px; border-bottom: 0.5px solid #1a1a1a; }
    .sponsor-list { display: flex; flex-direction: column; gap: 10px; }
    .sponsor-item { background: #111; border: 0.5px solid #1e1e1e; padding: 14px 18px; display: flex; justify-content: space-between; align-items: center; }
    .sponsor-name { font-size: 14px; color: #f0f0f0; letter-spacing: 0.5px; }
    .no-sponsors { color: #444; font-size: 13px; padding: 20px 0; }
    .no-events-notice { background: #111; border: 0.5px solid #2a2a2a; padding: 28px; text-align: center; color: #555; font-size: 13px; line-height: 1.7; }
    .no-events-notice a { color: #e8b44b; text-decoration: none; }

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

  // Only club managers need this page
  List<String[]> managedClubs = MysqlCon.getManagedClubs(sessionUserID);

  // Build list of events belonging to clubs this user manages
  List<String[]> managedEvents = new java.util.ArrayList<>();
  if (!managedClubs.isEmpty()) {
    for (String[] event : MysqlCon.getEvents()) {
      if (String.valueOf(sessionUserID).equals(event[8])) {
        managedEvents.add(event);
      }
    }
  }

  // All available companies
  List<String[]> allCompanies = MysqlCon.getAllCompanies();

  String successMsg = null;
  String errorMsg   = null;

  // ── Handle POST ────────────────────────────────────────────────────────────
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String action      = request.getParameter("action");
    String eventIDStr  = request.getParameter("eventID");
    String companyIDStr = request.getParameter("companyID");

    if (eventIDStr == null || eventIDStr.trim().isEmpty()) {
      errorMsg = "Please select an event.";
    } else {
      try {
        int eventID = Integer.parseInt(eventIDStr.trim());

        // ── Remove sponsor ────────────────────────────────────────────────
        if ("remove".equals(action) && companyIDStr != null) {
          int companyID = Integer.parseInt(companyIDStr.trim());
          boolean ok = MysqlCon.removeSponsor(eventID, companyID, sessionUserID);
          if (ok) successMsg = "Sponsor removed successfully.";
          else    errorMsg   = "Could not remove sponsor.";

        // ── Add sponsor ───────────────────────────────────────────────────
        } else if (companyIDStr != null && !companyIDStr.trim().isEmpty()) {
          int companyID = Integer.parseInt(companyIDStr.trim());
          boolean ok = MysqlCon.addSponsor(eventID, companyID, sessionUserID);
          if (ok) successMsg = "Sponsor added successfully!";
          else    errorMsg   = "Failed to add sponsor. Make sure you manage this event's club.";
        } else {
          errorMsg = "Please select a company.";
        }

      } catch (NumberFormatException e) {
        errorMsg = "Invalid selection.";
      }
    }
  }

  // ── Selected event for sponsor preview ────────────────────────────────────
  String selectedEventIDStr = request.getParameter("eventID");
  if (selectedEventIDStr == null && !managedEvents.isEmpty()) {
    selectedEventIDStr = managedEvents.get(0)[0];
  }
  int selectedEventID = -1;
  String selectedEventName = "";
  List<String[]> currentSponsors = new java.util.ArrayList<>();
  if (selectedEventIDStr != null) {
    try {
      selectedEventID = Integer.parseInt(selectedEventIDStr);
      for (String[] e : managedEvents) {
        if (e[0].equals(String.valueOf(selectedEventID))) {
          selectedEventName = e[3]; // Event_Name
          break;
        }
      }
      currentSponsors = MysqlCon.getEventSponsors(selectedEventID);
    } catch (NumberFormatException ignored) {}
  }

  // Filter available companies to show only those NOT already sponsoring
  List<String[]> availableCompanies = new java.util.ArrayList<>();
  for (String[] company : allCompanies) {
    boolean alreadySponsor = false;
    for (String[] sponsor : currentSponsors) {
      if (sponsor[0].equals(company[0])) {
        alreadySponsor = true;
        break;
      }
    }
    if (!alreadySponsor) {
      availableCompanies.add(company);
    }
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
    <div class="left-tag">Events</div>
    <h1 class="left-title">Event<br><span>Sponsors</span></h1>
    <p class="left-sub">
      Link sponsor companies to your events. Sponsors are displayed publicly on the event listing page.
    </p>
    <div class="perks">
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Club Admins Only</strong> – you must manage the event's club.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Multiple Sponsors</strong> – add as many as you need per event.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Easy Management</strong> – add or remove sponsors anytime.</div>
      </div>
    </div>
  </div>

  <!-- RIGHT – form + sponsor list -->
  <div class="right-panel">

    <% if (successMsg != null) { %>
      <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <% if (managedEvents.isEmpty()) { %>
      <div class="no-events-notice">
        You don't manage any events yet.<br>
        <a href="createEvent.jsp">Create an event first</a> to add sponsors.
      </div>
    <% } else { %>

      <div class="form-heading">Add a sponsor</div>

      <form method="POST" action="manageSponsors.jsp" novalidate>
        <input type="hidden" name="action" value="add"/>

        <div class="form-group">
          <label for="eventID">Select Event <span class="required-mark">*</span></label>
          <select id="eventID" name="eventID" required onchange="this.form.submit()">
            <% for (String[] e : managedEvents) {
               boolean sel = e[0].equals(String.valueOf(selectedEventID)); %>
              <option value="<%= e[0] %>" <%= sel ? "selected" : "" %>>
                <%= e[3] %> — <%= e[4] %>
              </option>
            <% } %>
          </select>
          <div class="hint">Only events from clubs you manage are shown.</div>
        </div>

        <div class="form-group">
          <label for="companyID">Select Company <span class="required-mark">*</span></label>
          <select id="companyID" name="companyID" required>
            <option value="">— Choose a sponsor —</option>
            <% for (String[] company : availableCompanies) { %>
              <option value="<%= company[0] %>"><%= company[1] %></option>
            <% } %>
          </select>
          <div class="hint">
            <% if (availableCompanies.isEmpty()) { %>
              All companies are already sponsoring this event.
            <% } else { %>
              Companies not already sponsoring this event.
            <% } %>
          </div>
        </div>

        <div class="form-actions">
          <button type="submit" class="btn-primary" <%= availableCompanies.isEmpty() ? "disabled" : "" %>>
            Add Sponsor
          </button>
          <a href="events.jsp" class="btn-ghost">Back to Events</a>
        </div>
      </form>

      <!-- ── Current sponsors for selected event ──────────────────────────── -->
      <% if (selectedEventID > 0) { %>
        <div class="sponsor-section-label">
          Current Sponsors for "<%= selectedEventName %>" (<%= currentSponsors.size() %>)
        </div>

        <% if (currentSponsors.isEmpty()) { %>
          <p class="no-sponsors">No sponsors yet for this event. Add one above.</p>
        <% } else { %>
          <div class="sponsor-list">
            <% for (String[] sponsor : currentSponsors) { %>
              <div class="sponsor-item">
                <span class="sponsor-name"><%= sponsor[1] %></span>
                <form method="POST" action="manageSponsors.jsp" style="display:inline;"
                      onsubmit="return confirm('Remove <%= sponsor[1] %> as sponsor?');">
                  <input type="hidden" name="action"     value="remove"/>
                  <input type="hidden" name="eventID"    value="<%= selectedEventID %>"/>
                  <input type="hidden" name="companyID"  value="<%= sponsor[0] %>"/>
                  <button type="submit" class="btn-danger">Remove</button>
                </form>
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
