<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Events - Car Club</title>
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

    /* Page header */
    .page-header { padding: 56px 56px 0; max-width: 1100px; margin: 0 auto; }
    .page-tag { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #e8b44b; margin-bottom: 14px; }
    .page-title { font-family: 'Bebas Neue', sans-serif; font-size: 56px; letter-spacing: 2px; line-height: 1; margin-bottom: 28px; }
    .page-title span { color: #e8b44b; }

    /* Controls bar */
    .controls { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; margin-bottom: 40px; }
    .search-wrap { flex: 1; min-width: 220px; }
    .search-wrap input { width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0; padding: 11px 16px; font-family: 'DM Sans', sans-serif; font-size: 13px; outline: none; transition: border-color 0.2s; }
    .search-wrap input::placeholder { color: #444; }
    .search-wrap input:focus { border-color: #e8b44b; }
    .filter-wrap select { background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0; padding: 11px 16px; font-family: 'DM Sans', sans-serif; font-size: 13px; outline: none; appearance: none; cursor: pointer; min-width: 160px; transition: border-color 0.2s; }
    .filter-wrap select:focus { border-color: #e8b44b; }
    .filter-wrap select option { background: #1a1a1a; }
    .btn-create { background: #e8b44b; color: #0a0a0a; border: none; padding: 11px 24px; font-family: 'DM Sans', sans-serif; font-size: 11px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; text-decoration: none; display: inline-block; white-space: nowrap; cursor: pointer; transition: background 0.2s; }
    .btn-create:hover { background: #f5c76a; }

    /* Events section */
    .events-section { max-width: 1100px; margin: 0 auto; padding: 0 56px 80px; }
    .section-label { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 24px; padding-bottom: 14px; border-bottom: 0.5px solid #1a1a1a; }

    /* Grid */
    .events-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1px; background: #1a1a1a; }
    .event-card { background: #0e0e0e; padding: 28px; display: flex; flex-direction: column; gap: 0; }
    .event-type-badge { font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #e8b44b; margin-bottom: 10px; }
    .event-name { font-family: 'Bebas Neue', sans-serif; font-size: 30px; letter-spacing: 1px; line-height: 1.1; margin-bottom: 10px; }
    .event-meta { display: flex; flex-direction: column; gap: 5px; margin-bottom: 14px; }
    .event-meta span { font-size: 12px; color: #555; letter-spacing: 0.5px; }
    .event-meta .highlight { color: #888; }
    .event-desc { font-size: 13px; color: #555; line-height: 1.6; flex: 1; margin-bottom: 18px; }
    .event-footer { display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px; margin-top: auto; }
    .attendee-count { font-size: 11px; color: #444; letter-spacing: 0.5px; text-transform: uppercase; }

    /* Action buttons */
    .btn-register { background: #e8b44b; color: #0a0a0a; border: none; padding: 8px 20px; font-family: 'DM Sans', sans-serif; font-size: 11px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-register:hover { background: #f5c76a; }
    .btn-unregister { background: transparent; color: #888; border: 0.5px solid #333; padding: 8px 20px; font-family: 'DM Sans', sans-serif; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: border-color 0.2s, color 0.2s; }
    .btn-unregister:hover { border-color: #666; color: #f0f0f0; }
    .btn-edit { background: transparent; color: #e8b44b; border: 0.5px solid #e8b44b; padding: 8px 20px; font-family: 'DM Sans', sans-serif; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; text-decoration: none; display: inline-block; transition: background 0.2s, color 0.2s; }
    .btn-edit:hover { background: #e8b44b; color: #0a0a0a; }
    .badge-registered { font-size: 10px; letter-spacing: 1.5px; text-transform: uppercase; color: #2d7a48; border: 0.5px solid #2d7a48; padding: 4px 10px; display: inline-block; }

    .empty-state { padding: 60px; text-align: center; background: #0e0e0e; border: 0.5px solid #1a1a1a; color: #444; font-size: 13px; }
    .no-results { display: none; padding: 60px; text-align: center; background: #0e0e0e; border: 0.5px solid #1a1a1a; color: #444; font-size: 13px; }

    .alert { padding: 14px 18px; font-size: 13px; margin-bottom: 28px; border-left: 3px solid; letter-spacing: 0.3px; }
    .alert-success { background: #0b1c12; border-color: #2d7a48; color: #5ecf8a; }
    .alert-error   { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }

    .login-notice { background: #111; border: 0.5px solid #2a2a2a; padding: 10px 16px; font-size: 12px; color: #555; }
    .login-notice a { color: #e8b44b; text-decoration: none; }

    @media (max-width: 900px) {
      nav { padding: 18px 24px; }
      .page-header, .events-section { padding-left: 24px; padding-right: 24px; }
    }
  </style>
</head>
<body>

<%
  // ── Session (optional – visitors can browse) ───────────────────────────────
  Integer sessionUserID   = (Integer) session.getAttribute("userID");
  String  sessionUsername = (String)  session.getAttribute("username");

  String actionMsg   = null;
  String actionError = null;

  // ── Handle POST (register / unregister) ───────────────────────────────────
  if ("POST".equalsIgnoreCase(request.getMethod()) && sessionUserID != null) {
    String regIDStr   = request.getParameter("registerEventID");
    String unregIDStr = request.getParameter("unregisterEventID");

    if (regIDStr != null) {
      try {
        int eid = Integer.parseInt(regIDStr);
        if (MysqlCon.isUserRegisteredForEvent(eid, sessionUserID)) {
          actionError = "You are already registered for this event.";
        } else {
          boolean ok = MysqlCon.registerForEvent(eid, sessionUserID);
          actionMsg = ok ? "You're registered! See you there." : "Registration failed. Please try again.";
          if (!ok) actionError = actionMsg;
        }
      } catch (NumberFormatException e) { actionError = "Invalid event."; }

    } else if (unregIDStr != null) {
      try {
        int eid = Integer.parseInt(unregIDStr);
        boolean ok = MysqlCon.unregisterFromEvent(eid, sessionUserID);
        actionMsg = ok ? "You've cancelled your registration." : "Could not cancel registration.";
        if (!ok) actionError = actionMsg;
      } catch (NumberFormatException e) { actionError = "Invalid event."; }
    }
  }

  // ── Load events (search or all) ────────────────────────────────────────────
  String keyword    = request.getParameter("q");
  String typeFilter = request.getParameter("type");
  List<String[]> events;

  if (keyword != null && !keyword.trim().isEmpty()) {
    events = MysqlCon.searchEvents(keyword.trim());
  } else {
    events = MysqlCon.getEvents();
  }

  // Apply client-side type filter (we do it server-side too for simplicity)
  if (typeFilter != null && !typeFilter.trim().isEmpty() && !typeFilter.equals("All")) {
    java.util.List<String[]> filtered = new java.util.ArrayList<>();
    for (String[] ev : events) {
      if (typeFilter.equalsIgnoreCase(ev[5])) filtered.add(ev);
    }
    events = filtered;
  }

  // Does the logged-in user manage any clubs? (to show "Create Event" button)
  boolean isClubManager = sessionUserID != null &&
                          !MysqlCon.getManagedClubs(sessionUserID).isEmpty();
%>

<nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <% if (sessionUserID != null) { %>
      <a href="viewProfile.jsp?id=<%= sessionUserID %>">My Profile</a>
      <a href="createClub.jsp">Clubs</a>
      <a href="events.jsp">Events</a>
      <a href="logout.jsp">Logout</a>
    <% } else { %>
      <a href="createClub.jsp">Clubs</a>
      <a href="events.jsp">Events</a>
      <a href="login.jsp">Login</a>
      <a href="register.jsp">Register</a>
    <% } %>
  </div>
</nav>

<!-- Page header -->
<div class="page-header">
  <div class="page-tag">Community</div>
  <h1 class="page-title">Upcoming <span>Events</span></h1>

  <% if (actionMsg   != null && actionError == null) { %><div class="alert alert-success"><%= actionMsg %></div><% } %>
  <% if (actionError != null) { %><div class="alert alert-error"><%= actionError %></div><% } %>

  <!-- Controls -->
  <form method="GET" action="events.jsp">
    <div class="controls">
      <div class="search-wrap">
        <input type="text" name="q" placeholder="Search events by name, type, location, or club…"
               value="<%= keyword != null ? keyword : "" %>"/>
      </div>
      <div class="filter-wrap">
        <select name="type" onchange="this.form.submit()">
          <option value="All"      <%= "All".equals(typeFilter)      || typeFilter == null ? "selected" : "" %>>All Types</option>
          <option value="Car Show" <%= "Car Show".equals(typeFilter) ? "selected" : "" %>>Car Show</option>
          <option value="Race"     <%= "Race".equals(typeFilter)     ? "selected" : "" %>>Race</option>
          <option value="Meetup"   <%= "Meetup".equals(typeFilter)   ? "selected" : "" %>>Meetup</option>
        </select>
      </div>
      <button type="submit" style="display:none;"></button>
      <% if (isClubManager) { %>
        <a href="createEvent.jsp" class="btn-create">+ Create Event</a>
      <% } %>
    </div>
  </form>

  <% if (sessionUserID == null) { %>
    <div class="login-notice" style="margin-bottom:28px;">
      <a href="login.jsp">Log in</a> to register for events. Visitors can browse freely.
    </div>
  <% } %>
</div>

<!-- Events grid -->
<div class="events-section">
  <div class="section-label" id="eventsLabel">
    <%= events.isEmpty() ? "No events found" : events.size() + " event" + (events.size() == 1 ? "" : "s") %>
    <%= (keyword != null && !keyword.trim().isEmpty()) ? " matching \"" + keyword + "\"" : "" %>
  </div>

  <% if (events.isEmpty()) { %>
    <div class="empty-state">
      <% if (keyword != null && !keyword.trim().isEmpty()) { %>
        No events match your search. <a href="events.jsp" style="color:#e8b44b;text-decoration:none;">Clear search →</a>
      <% } else { %>
        No events yet.
        <% if (isClubManager) { %>
          <a href="createEvent.jsp" style="color:#e8b44b;text-decoration:none;">Create the first one →</a>
        <% } %>
      <% } %>
    </div>
  <% } else { %>
    <div class="events-grid" id="eventsGrid">
      <%
        for (String[] ev : events) {
          // ev: [0]=Event_ID, [1]=Club_ID, [2]=Club_Name, [3]=Event_Name,
          //     [4]=Event_Date, [5]=Event_Type, [6]=Location, [7]=Description, [8]=Manager_ID
          int    evID       = Integer.parseInt(ev[0]);
          String evName     = ev[3];
          String evDate     = ev[4] != null ? ev[4].substring(0, 10) : "TBD";
          String evType     = ev[5] != null ? ev[5] : "";
          String evLocation = ev[6] != null ? ev[6] : "";
          String evClub     = ev[2] != null ? ev[2] : "";
          String evDesc     = (ev[7] != null && !ev[7].isEmpty()) ? ev[7] : null;
          boolean isManager = sessionUserID != null && ev[8] != null &&
                              ev[8].equals(String.valueOf(sessionUserID));
          boolean isReg     = sessionUserID != null &&
                              MysqlCon.isUserRegisteredForEvent(evID, sessionUserID);
          int attendees     = MysqlCon.getEventAttendeeCount(evID);
      %>
        <div class="event-card">
          <div class="event-type-badge"><%= evType %></div>
          <div class="event-name"><%= evName %></div>
          <div class="event-meta">
            <span class="highlight">📅 <%= evDate %></span>
            <span class="highlight">📍 <%= evLocation %></span>
            <span>Hosted by <strong style="color:#e8b44b;"><%= evClub %></strong></span>
          </div>
          <% if (evDesc != null) { %>
            <div class="event-desc"><%= evDesc %></div>
          <% } %>
          <div class="event-footer">
            <span class="attendee-count"><%= attendees %> going</span>
            <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
              <% if (isManager) { %>
                <!-- Club manager sees Edit -->
                <a href="createEvent.jsp?edit=<%= evID %>" class="btn-edit">Edit</a>
                <span class="badge-registered" style="color:#e8b44b;border-color:#e8b44b;">Your Event</span>
              <% } else if (sessionUserID != null) { %>
                <% if (isReg) { %>
                  <!-- Already registered: show Unregister -->
                  <span class="badge-registered">✓ Going</span>
                  <form method="POST" action="events.jsp" style="display:inline;">
                    <input type="hidden" name="unregisterEventID" value="<%= evID %>"/>
                    <button type="submit" class="btn-unregister">Cancel</button>
                  </form>
                <% } else { %>
                  <!-- Not registered: show Register -->
                  <form method="POST" action="events.jsp" style="display:inline;">
                    <input type="hidden" name="registerEventID" value="<%= evID %>"/>
                    <button type="submit" class="btn-register">Register</button>
                  </form>
                <% } %>
              <% } else { %>
                <!-- Visitor -->
                <a href="login.jsp" class="btn-register" style="text-decoration:none;">Login to Register</a>
              <% } %>
            </div>
          </div>
        </div>
      <% } %>
    </div>
    <div id="noResults" class="no-results">No events match your filter.</div>
  <% } %>
</div>

<script>
  // Client-side live filter by keyword (supplements the server-side search)
  (function () {
    var input = document.querySelector('input[name="q"]');
    if (!input) return;
    // Only run live filter when there's no server-side search active (page already loaded)
    input.addEventListener('input', function () {
      var q = this.value.toLowerCase().trim();
      var cards = document.querySelectorAll('.event-card');
      var visible = 0;
      cards.forEach(function (card) {
        var match = !q || card.textContent.toLowerCase().indexOf(q) !== -1;
        card.parentElement.style.display = match ? '' : 'none';
        if (match) visible++;
      });
      var label = document.getElementById('eventsLabel');
      if (label) label.textContent = q
        ? 'Showing ' + visible + ' of ' + cards.length + ' events'
        : cards.length + ' event' + (cards.length === 1 ? '' : 's');
      var noRes = document.getElementById('noResults');
      if (noRes) noRes.style.display = (q && visible === 0) ? 'block' : 'none';
    });
  }());
</script>

</body>
</html>
