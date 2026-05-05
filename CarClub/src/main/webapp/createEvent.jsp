<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Create Event - Car Club</title>
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

    .right-panel { padding: 60px 56px; display: flex; flex-direction: column; justify-content: center; overflow-y: auto; }
    .form-heading { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 36px; padding-bottom: 16px; border-bottom: 0.5px solid #1e1e1e; }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; color: #ffffff; margin-bottom: 8px; }
    .required-mark { color: #e8b44b; margin-left: 2px; }
    .form-group input, .form-group textarea, .form-group select {
      width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0;
      padding: 12px 16px; font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: border-color 0.2s; resize: none; appearance: none;
    }
    .form-group select option { background: #1a1a1a; }
    .form-group input::placeholder, .form-group textarea::placeholder { color: #444; }
    .form-group input:focus, .form-group textarea:focus, .form-group select:focus { border-color: #e8b44b; }
    .form-group .hint { font-size: 11px; color: #444; margin-top: 6px; letter-spacing: 0.3px; }
    .char-count { font-size: 11px; color: #444; margin-top: 6px; text-align: right; }
    .section-divider { font-size: 11px; letter-spacing: 2px; text-transform: uppercase; color: #333; margin: 8px 0 24px; padding-bottom: 12px; border-bottom: 0.5px solid #1a1a1a; }
    .form-actions { margin-top: 8px; display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .btn-primary { background: #e8b44b; color: #fff; border: none; padding: 13px 36px; font-family: 'DM Sans', sans-serif; font-size: 12px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #f5c76a; }
    .btn-danger { background: #7a2d2d; color: #f0f0f0; border: none; padding: 13px 28px; font-family: 'DM Sans', sans-serif; font-size: 12px; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-danger:hover { background: #a03535; }
    .btn-ghost { background: transparent; color: #555; border: 0.5px solid #2a2a2a; padding: 13px 28px; font-family: 'DM Sans', sans-serif; font-size: 12px; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; text-decoration: none; display: inline-block; transition: border-color 0.2s, color 0.2s; }
    .btn-ghost:hover { border-color: #555; color: #f0f0f0; }
    .alert { padding: 14px 18px; font-size: 13px; margin-bottom: 28px; border-left: 3px solid; letter-spacing: 0.3px; }
    .alert-success { background: #0b1c12; border-color: #2d7a48; color: #5ecf8a; }
    .alert-error   { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }
    .no-clubs-notice { background: #111; border: 0.5px solid #2a2a2a; padding: 28px; text-align: center; color: #555; font-size: 13px; line-height: 1.7; }
    .no-clubs-notice a { color: #e8b44b; text-decoration: none; }

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

  // ── Edit mode: ?edit=<eventID> pre-fills the form ─────────────────────────
  String   editIDStr  = request.getParameter("edit");
  boolean  editMode   = false;
  String[] editEvent  = null;

  if (editIDStr != null && !editIDStr.trim().isEmpty()) {
    try {
      int eid = Integer.parseInt(editIDStr.trim());
      editEvent = MysqlCon.getEventByID(eid);
      // Only the club manager may edit
      if (editEvent != null && editEvent[8] != null &&
          editEvent[8].equals(String.valueOf(sessionUserID))) {
        editMode = true;
      } else {
        editEvent = null; // access denied silently
      }
    } catch (NumberFormatException ignored) {}
  }

  String successMsg = null;
  String errorMsg   = null;

  // ── Handle POST ────────────────────────────────────────────────────────────
  if ("POST".equalsIgnoreCase(request.getMethod())) {

    String action       = request.getParameter("action");        // "create" | "update" | "delete"
    String eventIDStr   = request.getParameter("eventID");
    String clubIDStr    = request.getParameter("clubID");
    String eventName    = request.getParameter("eventName");
    String eventDate    = request.getParameter("eventDate");
    String location     = request.getParameter("location");
    String eventType    = request.getParameter("eventType");
    String description  = request.getParameter("description");

    eventName   = (eventName   != null) ? eventName.trim()   : "";
    eventDate   = (eventDate   != null) ? eventDate.trim()   : "";
    location    = (location    != null) ? location.trim()    : "";
    eventType   = (eventType   != null) ? eventType.trim()   : "";
    description = (description != null) ? description.trim() : "";

    // ── Delete ──────────────────────────────────────────────────────────────
    if ("delete".equals(action) && eventIDStr != null) {
      try {
        int delID = Integer.parseInt(eventIDStr);
        String[] ev = MysqlCon.getEventByID(delID);
        if (ev != null && ev[8] != null && ev[8].equals(String.valueOf(sessionUserID))) {
          boolean ok = MysqlCon.deleteEvent(delID);
          if (ok) {
            successMsg = "Event deleted successfully.";
          } else {
            errorMsg = "Could not delete event.";
          }
        } else {
          errorMsg = "You do not have permission to delete this event.";
        }
      } catch (NumberFormatException e) {
        errorMsg = "Invalid event ID.";
      }

    // ── Update ──────────────────────────────────────────────────────────────
    } else if ("update".equals(action) && eventIDStr != null) {
      try {
        int updID = Integer.parseInt(eventIDStr);
        String[] ev = MysqlCon.getEventByID(updID);
        if (ev == null || !ev[8].equals(String.valueOf(sessionUserID))) {
          errorMsg = "You do not have permission to edit this event.";
        } else if (eventName.isEmpty() || eventDate.isEmpty() || location.isEmpty() || eventType.isEmpty()) {
          errorMsg = "Event name, date, location, and type are required.";
        } else {
          boolean ok = MysqlCon.updateEvent(updID, eventName, eventDate, location, eventType, description);
          if (ok) {
            successMsg = "\"" + eventName + "\" updated successfully.";
            editMode  = false;
            editEvent = null;
          } else {
            errorMsg = "Update failed. Please try again.";
          }
        }
      } catch (NumberFormatException e) {
        errorMsg = "Invalid event ID.";
      }

    // ── Create ──────────────────────────────────────────────────────────────
    } else {
      if (clubIDStr == null || clubIDStr.isEmpty()) {
        errorMsg = "Please select a club to host the event.";
      } else if (eventName.isEmpty()) {
        errorMsg = "Event name is required.";
      } else if (eventDate.isEmpty()) {
        errorMsg = "Event date is required.";
      } else if (location.isEmpty()) {
        errorMsg = "Location is required.";
      } else if (eventType.isEmpty()) {
        errorMsg = "Event type is required.";
      } else {
        try {
          int cid = Integer.parseInt(clubIDStr);
          // Verify the user actually manages this club
          List<String[]> managed = MysqlCon.getManagedClubs(sessionUserID);
          boolean owns = false;
          for (String[] mc : managed) { if (mc[0].equals(String.valueOf(cid))) { owns = true; break; } }
          if (!owns) {
            errorMsg = "You can only create events for clubs you manage.";
          } else {
            boolean ok = MysqlCon.createEvent(cid, eventName, eventDate, location, eventType, description);
            if (ok) {
              successMsg = "\"" + eventName + "\" has been created and listed publicly.";
            } else {
              errorMsg = "Event creation failed. Please try again.";
            }
          }
        } catch (NumberFormatException e) {
          errorMsg = "Invalid club selection.";
        }
      }
    }
  }

  // ── Load user's managed clubs for the dropdown ─────────────────────────────
  List<String[]> managedClubs = MysqlCon.getManagedClubs(sessionUserID);
%>

<nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <a href="viewProfile.jsp?id=<%= sessionUserID %>">My Profile</a>
    <a href="createClub.jsp">Clubs</a>
    <a href="events.jsp">Events</a>
    <a href="logout.jsp">Logout</a>
  </div>
</nav>

<div class="page-layout">

  <!-- LEFT – branding -->
  <div class="left-panel">
    <div class="left-tag">Events</div>
    <h1 class="left-title"><%= editMode ? "Edit<br><span>Event</span>" : "Host an<br><span>Event</span>" %></h1>
    <p class="left-sub">
      <%= editMode
          ? "Update the details below. Changes are reflected immediately on the public events page."
          : "Organise a car show, race, or meetup for your club. Events are listed publicly as soon as you create them." %>
    </p>
    <% if (!editMode) { %>
    <div class="perks">
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Club Owners Only</strong> – you must manage a club to host events.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Three Types</strong> – Car Show, Race, or Meetup.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Instant Listing</strong> – your event appears on the events page immediately.</div>
      </div>
    </div>
    <% } %>
  </div>

  <!-- RIGHT – form -->
  <div class="right-panel">

    <% if (successMsg != null) { %>
      <div class="alert alert-success"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
      <div class="alert alert-error"><%= errorMsg %></div>
    <% } %>

    <% if (managedClubs.isEmpty() && !editMode) { %>
      <div class="no-clubs-notice">
        You don't manage any clubs yet.<br>
        <a href="createClub.jsp">Create a club first</a> to start hosting events.
      </div>
    <% } else { %>

      <div class="form-heading"><%= editMode ? "Edit event details" : "Event details" %></div>

      <form method="POST" action="createEvent.jsp" novalidate>

        <% if (editMode) { %>
          <input type="hidden" name="action"  value="update"/>
          <input type="hidden" name="eventID" value="<%= editEvent[0] %>"/>
        <% } %>

        <!-- Host Club (create only) -->
        <% if (!editMode) { %>
        <div class="form-group">
          <label for="clubID">Host Club <span class="required-mark">*</span></label>
          <select id="clubID" name="clubID" required>
            <option value="">— Select a club you manage —</option>
            <% for (String[] mc : managedClubs) { %>
              <option value="<%= mc[0] %>"><%= mc[1] %></option>
            <% } %>
          </select>
        </div>
        <% } else { %>
          <!-- Show club name read-only in edit mode -->
          <div class="form-group">
            <label>Host Club</label>
            <input type="text" value="<%= editEvent[2] %>" disabled style="color:#555;"/>
          </div>
        <% } %>

        <div class="form-group">
          <label for="eventName">Event Name <span class="required-mark">*</span></label>
          <input type="text" id="eventName" name="eventName" maxlength="150"
                 placeholder="e.g. Bay Area JDM Meetup"
                 value="<%= editMode ? editEvent[3] : "" %>" required/>
        </div>

        <div class="form-group">
          <label for="eventDate">Event Date <span class="required-mark">*</span></label>
          <input type="date" id="eventDate" name="eventDate"
                 value="<%= editMode ? editEvent[4] : "" %>" required/>
        </div>

        <div class="form-group">
          <label for="eventType">Event Type <span class="required-mark">*</span></label>
          <select id="eventType" name="eventType" required>
            <option value="">— Select type —</option>
            <option value="Car Show"  <%= (editMode && "Car Show".equals(editEvent[5]))  ? "selected" : "" %>>Car Show</option>
            <option value="Race"      <%= (editMode && "Race".equals(editEvent[5]))      ? "selected" : "" %>>Race</option>
            <option value="Meetup"    <%= (editMode && "Meetup".equals(editEvent[5]))    ? "selected" : "" %>>Meetup</option>
          </select>
        </div>

        <div class="form-group">
          <label for="location">Location <span class="required-mark">*</span></label>
          <input type="text" id="location" name="location" maxlength="150"
                 placeholder="e.g. Eastridge Parking Lot, San Jose, CA"
                 value="<%= editMode ? editEvent[6] : "" %>" required/>
        </div>

        <div class="section-divider">Optional</div>

        <div class="form-group">
          <label for="description">Description</label>
          <textarea id="description" name="description" rows="4" maxlength="500"
                    placeholder="What should attendees know? Parking info, rules, highlights..."
                    oninput="updateCharCount(this,'descCount',500)"><%= editMode && editEvent[7] != null ? editEvent[7] : "" %></textarea>
          <div class="char-count"><span id="descCount"><%= editMode && editEvent[7] != null ? editEvent[7].length() : 0 %></span> / 500</div>
        </div>

        <div class="form-actions">
          <button type="submit" class="btn-primary"><%= editMode ? "Save Changes" : "Create Event" %></button>
          <a href="events.jsp" class="btn-ghost">Cancel</a>

          <!-- Delete button (edit mode only) -->
          <% if (editMode) { %>
            <form method="POST" action="createEvent.jsp" style="display:inline;"
                  onsubmit="return confirm('Delete this event? This cannot be undone.');">
              <input type="hidden" name="action"  value="delete"/>
              <input type="hidden" name="eventID" value="<%= editEvent[0] %>"/>
              <button type="submit" class="btn-danger">Delete Event</button>
            </form>
          <% } %>
        </div>

      </form>
    <% } %>
  </div>
</div>

<script>
  function updateCharCount(el, countId, max) {
    document.getElementById(countId).textContent = el.value.length;
  }
</script>

</body>
</html>
