<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Profile - Car Club</title>
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

    .profile-wrapper { max-width: 900px; margin: 0 auto; padding: 60px 32px; }

    /* Hero */
    .profile-hero { display: flex; align-items: flex-end; gap: 36px; margin-bottom: 48px; padding-bottom: 40px; border-bottom: 0.5px solid #1e1e1e; }
    .avatar { width: 88px; height: 88px; background: #1a1a1a; border: 0.5px solid #2a2a2a; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
    .avatar-letter { font-family: 'Bebas Neue', sans-serif; font-size: 48px; color: #e8b44b; line-height: 1; }
    .profile-info { flex: 1; }
    .profile-display-name { font-family: 'Bebas Neue', sans-serif; font-size: 48px; letter-spacing: 2px; line-height: 1; margin-bottom: 6px; }
    .profile-username { font-size: 13px; color: #555; margin-bottom: 12px; }
    .profile-location { font-size: 12px; color: #444; letter-spacing: 1px; text-transform: uppercase; margin-bottom: 14px; }
    .profile-bio { font-size: 14px; color: #888; line-height: 1.7; max-width: 520px; }
    .profile-actions { display: flex; gap: 12px; margin-top: 20px; }
    .btn-sm { padding: 9px 22px; font-family: 'DM Sans', sans-serif; font-size: 11px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; text-decoration: none; display: inline-block; cursor: pointer; border: none; transition: background 0.2s, color 0.2s; }
    .btn-gold { background: #e8b44b; color: #fff; }
    .btn-gold:hover { background: #f5c76a; }
    .btn-outline { background: transparent; color: #555; border: 0.5px solid #2a2a2a; }
    .btn-outline:hover { border-color: #555; color: #f0f0f0; }
    .btn-danger { background: transparent; color: #7a2d2d; border: 0.5px solid #7a2d2d; }
    .btn-danger:hover { background: #7a2d2d; color: #f0f0f0; }
    .member-since { font-size: 11px; color: #333; letter-spacing: 1px; text-transform: uppercase; margin-top: 16px; }

    /* Section */
    .section-title { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 24px; padding-bottom: 14px; border-bottom: 0.5px solid #1a1a1a; }
    .section { margin-bottom: 56px; }

    /* Car grid */
    .car-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 1px; background: #1a1a1a; }
    .car-card { background: #0e0e0e; padding: 24px; }
    .car-year { font-size: 11px; letter-spacing: 2px; color: #e8b44b; text-transform: uppercase; margin-bottom: 8px; }
    .car-name { font-family: 'Bebas Neue', sans-serif; font-size: 26px; letter-spacing: 1px; margin-bottom: 8px; }
    .car-desc { font-size: 13px; color: #666; line-height: 1.5; }
    .empty-state { padding: 40px; text-align: center; background: #0e0e0e; border: 0.5px solid #1a1a1a; color: #444; font-size: 13px; letter-spacing: 0.5px; }

    /* Club grid */
    .club-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 1px; background: #1a1a1a; }
    .club-card { background: #0e0e0e; padding: 24px; }
    .club-badge { font-size: 10px; letter-spacing: 2px; color: #e8b44b; text-transform: uppercase; margin-bottom: 8px; }
    .club-card-name { font-family: 'Bebas Neue', sans-serif; font-size: 26px; letter-spacing: 1px; margin-bottom: 6px; }
    .club-card-desc { font-size: 13px; color: #666; line-height: 1.5; margin-bottom: 10px; }
    .club-card-meta { display: flex; gap: 12px; font-size: 11px; color: #444; letter-spacing: 0.5px; text-transform: uppercase; flex-wrap: wrap; }

    /* Event grid */
    .event-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 1px; background: #1a1a1a; }
    .event-card { background: #0e0e0e; padding: 24px; display: flex; flex-direction: column; gap: 6px; }
    .event-type-label { font-size: 10px; letter-spacing: 2px; color: #e8b44b; text-transform: uppercase; margin-bottom: 4px; }
    .event-card-name { font-family: 'Bebas Neue', sans-serif; font-size: 26px; letter-spacing: 1px; line-height: 1.1; margin-bottom: 6px; }
    .event-card-meta { font-size: 12px; color: #555; line-height: 1.8; }
    .event-card-meta span { display: block; }
    .event-badge { font-size: 10px; letter-spacing: 2px; color: #e8b44b; text-transform: uppercase; margin-bottom: 8px; }
    .event-card-actions { margin-top: 12px; }
    .btn-edit-sm { font-size: 11px; letter-spacing: 1.5px; text-transform: uppercase; color: #e8b44b; border: 0.5px solid #e8b44b; padding: 5px 14px; text-decoration: none; display: inline-block; transition: background 0.2s, color 0.2s; }
    .btn-edit-sm:hover { background: #e8b44b; color: #0a0a0a; }

    /* Not found */
    .not-found { text-align: center; padding: 120px 32px; }
    .not-found h2 { font-family: 'Bebas Neue', sans-serif; font-size: 48px; color: #333; margin-bottom: 16px; }
    .not-found p { color: #555; }

    @media (max-width: 700px) {
      .profile-hero { flex-direction: column; align-items: flex-start; gap: 20px; }
      nav { padding: 18px 24px; }
      .profile-wrapper { padding: 40px 20px; }
    }
  </style>
</head>
<body>

<%
  Integer sessionUserID = (Integer) session.getAttribute("userID");
  String  sessionUsername = (String) session.getAttribute("username");

  // Resolve the profile to display
  int targetID = -1;
  String idParam = request.getParameter("id");
  if (idParam != null && !idParam.trim().isEmpty()) {
    try { targetID = Integer.parseInt(idParam.trim()); } catch (NumberFormatException ignored) {}
  } else if (sessionUserID != null) {
    targetID = sessionUserID;  // Default: own profile
  }

  String[] profile = (targetID != -1) ? MysqlCon.getUserProfile(targetID) : null;
  boolean isOwnProfile = sessionUserID != null && sessionUserID == targetID;
%>

<nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <% String  _navUser = (String)  session.getAttribute("username");
       Integer _navID   = (Integer) session.getAttribute("userID");
       if (_navUser != null) { %>
      <a href="AddCar.jsp">Add Car</a>
      <a href="createClub.jsp">Clubs</a>
      <a href="events.jsp">Events</a>
      <a href="viewProfile.jsp?id=<%= _navID %>">My Profile</a>
<a href="logout.jsp">Logout (<%= _navUser %>)</a>
    <% } else { %>
      <a href="createClub.jsp">Clubs</a>
      <a href="events.jsp">Events</a>
      <a href="login.jsp">Login</a>
      <a href="register.jsp">Register</a>
    <% } %>
  </div>
</nav>

<% if (profile == null) { %>
  <div class="not-found">
    <h2>Profile Not Found</h2>
    <p>This user doesn't exist or may have been removed.</p>
  </div>
<% } else {
  // profile: [0]=Username, [1]=Display_Name, [2]=Bio, [3]=Location, [4]=Date_Created
  String pUsername    = profile[0];
  String pDisplayName = (profile[1] != null && !profile[1].isEmpty()) ? profile[1] : pUsername;
  String pBio         = (profile[2] != null && !profile[2].isEmpty()) ? profile[2] : null;
  String pLocation    = (profile[3] != null && !profile[3].isEmpty()) ? profile[3] : null;
  String pDate        = profile[4];
  char   avatarChar   = pDisplayName.toUpperCase().charAt(0);

  // Load this user's cars
  List<String[]> allCars = MysqlCon.getCars();
  java.util.List<String[]> userCars = new java.util.ArrayList<>();
  for (String[] car : allCars) {
    if (car[1] != null && car[1].equals(String.valueOf(targetID))) {
      userCars.add(car);
    }
  }

  // Load this user's clubs
  List<String[]> userClubs = MysqlCon.getUserClubs(targetID);

  // Load events this user manages (created via their clubs)
  List<String[]> allEvents = MysqlCon.getEvents();
  java.util.List<String[]> managedEvents = new java.util.ArrayList<>();
  java.util.List<String[]> registeredEvents = new java.util.ArrayList<>();
  for (String[] ev : allEvents) {
    if (ev[8] != null && ev[8].equals(String.valueOf(targetID))) {
      managedEvents.add(ev);
    } else if (MysqlCon.isUserRegisteredForEvent(Integer.parseInt(ev[0]), targetID)) {
      registeredEvents.add(ev);
    }
  }
%>

<div class="profile-wrapper">

  <!-- Hero -->
  <div class="profile-hero">
    <div class="avatar">
      <span class="avatar-letter"><%= avatarChar %></span>
    </div>
    <div class="profile-info">
      <div class="profile-display-name"><%= pDisplayName %></div>
      <div class="profile-username">@<%= pUsername %></div>
      <% if (pLocation != null) { %>
        <div class="profile-location">📍 <%= pLocation %></div>
      <% } %>
      <% if (pBio != null) { %>
        <div class="profile-bio"><%= pBio %></div>
      <% } %>
      <% if (isOwnProfile) { %>
        <div class="profile-actions">
          <a href="editProfile.jsp" class="btn-sm btn-gold">Edit Profile</a>
          <a href="addCar.jsp" class="btn-sm btn-outline">Add Car</a>
          <a href="createEvent.jsp" class="btn-sm btn-outline">Create Event</a>
          <a href="deleteAccount.jsp" class="btn-sm btn-danger">Delete Account</a>
        </div>
      <% } %>
      <% if (pDate != null) { %>
        <div class="member-since">Member since <%= pDate.substring(0, 10) %></div>
      <% } %>
    </div>
  </div>

  <!-- Cars section -->
  <div class="section">
    <div class="section-title">Garage (<%= userCars.size() %> <%= userCars.size() == 1 ? "car" : "cars" %>)</div>
    <% if (userCars.isEmpty()) { %>
      <div class="empty-state">
        <%= isOwnProfile ? "Your garage is empty. <a href='addCar.jsp' style='color:#e8b44b;text-decoration:none;'>Add your first car →</a>" : "No cars listed yet." %>
      </div>
    <% } else { %>
      <div class="car-grid">
        <% for (String[] car : userCars) {
          // car: [0]=Car_ID, [1]=User_ID, [2]=Make, [3]=Model, [4]=Year, [5]=Description
          String desc = (car[5] != null && !car[5].isEmpty()) ? car[5] : "No description provided.";
        %>
          <div class="car-card">
            <div class="car-year"><%= car[4] %></div>
            <div class="car-name"><%= car[2] %> <%= car[3] %></div>
            <div class="car-desc"><%= desc %></div>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>

  <!-- Clubs section -->
  <div class="section">
    <div class="section-title">Clubs (<%= userClubs.size() %>)</div>
    <% if (userClubs.isEmpty()) { %>
      <div class="empty-state">
        <%= isOwnProfile ? "You haven't joined any clubs. <a href='createClub.jsp' style='color:#e8b44b;text-decoration:none;'>Browse clubs →</a>" : "Not a member of any clubs yet." %>
      </div>
    <% } else { %>
      <div class="club-grid">
        <% for (String[] uc : userClubs) {
          boolean ucIsOwner = uc[1] != null && uc[1].equals(String.valueOf(targetID));
          String  ucDesc    = (uc[3] != null && !uc[3].isEmpty()) ? uc[3] : "No description.";
          String  ucLoc     = (uc[4] != null && !uc[4].isEmpty()) ? uc[4] : null;
          int     ucCount   = MysqlCon.getClubMemberCount(Integer.parseInt(uc[0]));
        %>
          <div class="club-card">
            <% if (ucIsOwner) { %><div class="club-badge">Owner</div><% } %>
            <div class="club-card-name"><%= uc[2] %></div>
            <div class="club-card-desc"><%= ucDesc %></div>
            <div class="club-card-meta">
              <% if (ucLoc != null) { %><span>📍 <%= ucLoc %></span><% } %>
              <span><%= ucCount %> member<%= ucCount != 1 ? "s" : "" %></span>
            </div>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>

  <!-- My Events section (events the user manages) -->
  <div class="section">
    <div class="section-title">My Events (<%= managedEvents.size() %>)</div>
    <% if (managedEvents.isEmpty()) { %>
      <div class="empty-state">
        <%= isOwnProfile
            ? "You haven't created any events. <a href='createEvent.jsp' style='color:#e8b44b;text-decoration:none;'>Create one →</a>"
            : "No events hosted yet." %>
      </div>
    <% } else { %>
      <div class="event-grid">
        <% for (String[] ev : managedEvents) {
          // ev: [0]=Event_ID, [1]=Club_ID, [2]=Club_Name, [3]=Event_Name,
          //     [4]=Event_Date, [5]=Event_Type, [6]=Location, [7]=Description, [8]=Manager_ID
          String evDate     = ev[4] != null ? ev[4].substring(0, 10) : "TBD";
          String evLoc      = ev[6] != null ? ev[6] : "";
          int    attendees  = MysqlCon.getEventAttendeeCount(Integer.parseInt(ev[0]));
        %>
          <div class="event-card">
            <div class="event-badge">Host</div>
            <div class="event-type-label"><%= ev[5] %></div>
            <div class="event-card-name"><%= ev[3] %></div>
            <div class="event-card-meta">
              <span>📅 <%= evDate %></span>
              <span>📍 <%= evLoc %></span>
              <span style="color:#e8b44b;"><%= ev[2] %></span>
              <span><%= attendees %> going</span>
            </div>
            <% if (isOwnProfile) { %>
              <div class="event-card-actions">
                <a href="createEvent.jsp?edit=<%= ev[0] %>" class="btn-edit-sm">Edit Event</a>
              </div>
            <% } %>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>

  <!-- Registered Events section (events the user signed up for) -->
  <div class="section">
    <div class="section-title">Registered Events (<%= registeredEvents.size() %>)</div>
    <% if (registeredEvents.isEmpty()) { %>
      <div class="empty-state">
        <%= isOwnProfile
            ? "You haven't registered for any events. <a href='events.jsp' style='color:#e8b44b;text-decoration:none;'>Browse events →</a>"
            : "Not registered for any events yet." %>
      </div>
    <% } else { %>
      <div class="event-grid">
        <% for (String[] ev : registeredEvents) {
          String evDate = ev[4] != null ? ev[4].substring(0, 10) : "TBD";
          String evLoc  = ev[6] != null ? ev[6] : "";
        %>
          <div class="event-card">
            <div class="event-type-label"><%= ev[5] %></div>
            <div class="event-card-name"><%= ev[3] %></div>
            <div class="event-card-meta">
              <span>📅 <%= evDate %></span>
              <span>📍 <%= evLoc %></span>
              <span style="color:#e8b44b;"><%= ev[2] %></span>
            </div>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>

</div>

<% } %>

</body>
</html>
