<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="carClubJava.MysqlCon, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Create a Club - Car Club</title>
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
    .form-group input, .form-group textarea {
      width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0;
      padding: 12px 16px; font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: border-color 0.2s; resize: none;
    }
    .form-group input::placeholder, .form-group textarea::placeholder { color: #444; }
    .form-group input:focus, .form-group textarea:focus { border-color: #e8b44b; }
    .form-group .hint { font-size: 11px; color: #444; margin-top: 6px; letter-spacing: 0.3px; }
    .char-count { font-size: 11px; color: #444; margin-top: 6px; text-align: right; }
    .section-divider { font-size: 11px; letter-spacing: 2px; text-transform: uppercase; color: #333; margin: 8px 0 24px; padding-bottom: 12px; border-bottom: 0.5px solid #1a1a1a; }
    .form-actions { margin-top: 8px; display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .btn-primary { background: #e8b44b; color: #ffffff; border: none; padding: 13px 36px; font-family: 'DM Sans', sans-serif; font-size: 12px; font-weight: 500; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; transition: background 0.2s; }
    .btn-primary:hover { background: #f5c76a; }
    .btn-ghost { background: transparent; color: #555; border: 0.5px solid #2a2a2a; padding: 13px 28px; font-family: 'DM Sans', sans-serif; font-size: 12px; letter-spacing: 1.5px; text-transform: uppercase; cursor: pointer; text-decoration: none; display: inline-block; transition: border-color 0.2s, color 0.2s; }
    .btn-ghost:hover { border-color: #555; color: #f0f0f0; }
    .alert { padding: 14px 18px; font-size: 13px; margin-bottom: 28px; border-left: 3px solid; letter-spacing: 0.3px; }
    .alert-success { background: #0b1c12; border-color: #2d7a48; color: #5ecf8a; }
    .alert-error   { background: #1c0b0b; border-color: #7a2d2d; color: #cf5e5e; }

    /* Clubs listing below the fold */
    .clubs-section { max-width: 900px; margin: 0 auto; padding: 0 32px 80px; }
    .clubs-header { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #555; margin-bottom: 24px; padding-bottom: 14px; border-bottom: 0.5px solid #1a1a1a; }
    .clubs-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 1px; background: #1a1a1a; }
    .club-card { background: #0e0e0e; padding: 28px; }
    .club-name { font-family: 'Bebas Neue', sans-serif; font-size: 28px; letter-spacing: 1px; margin-bottom: 8px; color: #f0f0f0; }
    .club-desc { font-size: 13px; color: #666; line-height: 1.6; margin-bottom: 14px; }
    .club-meta { display: flex; gap: 16px; font-size: 11px; color: #444; letter-spacing: 0.5px; text-transform: uppercase; flex-wrap: wrap; }
    .club-owner { color: #e8b44b; }
    .empty-state { padding: 40px; text-align: center; background: #0e0e0e; border: 0.5px solid #1a1a1a; color: #444; font-size: 13px; }

    .club-search { margin-bottom: 24px; }
    .club-search input { width: 100%; background: #131313; border: 0.5px solid #2a2a2a; color: #f0f0f0; padding: 10px 16px; font-family: 'DM Sans', sans-serif; font-size: 13px; outline: none; transition: border-color 0.2s; }
    .club-search input::placeholder { color: #444; }
    .club-search input:focus { border-color: #e8b44b; }

    @media (max-width: 900px) {
      .page-layout { grid-template-columns: 1fr; }
      .left-panel { display: none; }
      .right-panel { padding: 40px 28px; }
      nav { padding: 18px 24px; }
      .clubs-section { padding: 0 20px 60px; }
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

  String successMsg = null;
  String errorMsg   = null;

  // ── Handle POST ────────────────────────────────────────────────────────────
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String clubName    = request.getParameter("clubName");
    String description = request.getParameter("description");
    String location    = request.getParameter("location");

    clubName    = (clubName    != null) ? clubName.trim()    : "";
    description = (description != null) ? description.trim() : "";
    location    = (location    != null) ? location.trim()    : "";

    if (clubName.isEmpty()) {
      errorMsg = "Club name is required.";
    } else if (description.isEmpty()) {
      errorMsg = "Description is required.";
    } else if (clubName.length() > 100) {
      errorMsg = "Club name must be 100 characters or fewer.";
    } else if (description.length() > 500) {
      errorMsg = "Description must be 500 characters or fewer.";
    } else if (location.length() > 100) {
      errorMsg = "Location must be 100 characters or fewer.";
    } else {
      boolean ok = MysqlCon.createClub(sessionUserID, clubName, description, location);
      if (ok) {
        successMsg = "\"" + clubName + "\" has been created. You are the club owner.";
      } else {
        // Most likely a UNIQUE constraint violation on Club_Name
        errorMsg = "Club creation failed. That club name may already be taken.";
      }
    }
  }

  // Load all clubs for the directory listing
  List<String[]> clubs = MysqlCon.getClubs();
%>

<nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <a href="viewProfile.jsp?id=<%= sessionUserID %>">My Profile</a>
    <a href="createClub.jsp">Clubs</a>
    <a href="logout.jsp">Logout</a>
  </div>
</nav>

<!-- Create Club Form -->
<div class="page-layout">

  <!-- LEFT – branding -->
  <div class="left-panel">
    <div class="left-tag">Community</div>
    <h1 class="left-title">Start a<br><span>Club</span></h1>
    <p class="left-sub">Create a club to bring local enthusiasts together, organise meets, and build a community around your passion.</p>
    <div class="perks">
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>You're the Owner</strong> – you'll be automatically assigned as club manager.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Public Listing</strong> – your club appears on the public directory below.</div>
      </div>
      <div class="perk">
        <div class="perk-dot"></div>
        <div class="perk-text"><strong>Unique Name Required</strong> – club names must be distinct across the platform.</div>
      </div>
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

    <div class="form-heading">Club details</div>

    <form method="POST" action="createClub.jsp" novalidate>

      <div class="form-group">
        <label for="clubName">Club Name <span class="required-mark">*</span></label>
        <input
          type="text"
          id="clubName"
          name="clubName"
          placeholder="e.g. Bay Area JDM Collective"
          maxlength="100"
          required
        />
        <div class="hint">Unique · max 100 characters</div>
      </div>

      <div class="form-group">
        <label for="description">Description <span class="required-mark">*</span></label>
        <textarea
          id="description"
          name="description"
          rows="4"
          maxlength="500"
          placeholder="What's the club about? What kind of cars or events does it focus on?"
          oninput="updateCharCount(this, 'descCount', 500)"
          required
        ></textarea>
        <div class="char-count"><span id="descCount">0</span> / 500</div>
      </div>

      <div class="section-divider">Optional</div>

      <div class="form-group">
        <label for="location">Location</label>
        <input
          type="text"
          id="location"
          name="location"
          placeholder="City, State"
          maxlength="100"
        />
        <div class="hint">Helps nearby members discover your club</div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-primary">Create Club</button>
        <a href="index.jsp" class="btn-ghost">Cancel</a>
      </div>

    </form>
  </div>
</div>

<!-- All Clubs Listing -->
<div class="clubs-section">

  <div class="club-search">
    <input type="text" id="clubFilter" placeholder="Filter clubs by name, description, or location..."/>
  </div>

  <div class="clubs-header" id="clubsHeader" data-total="<%= clubs.size() %>">All Clubs (<%= clubs.size() %>)</div>

  <% if (clubs.isEmpty()) { %>
    <div class="empty-state">No clubs yet. Be the first to create one above.</div>
  <% } else { %>
    <div class="clubs-grid">
      <% for (String[] club : clubs) {
        // club: [0]=Club_ID, [1]=Manager_ID, [2]=Club_Name, [3]=Description, [4]=Location, [5]=Manager_Username
        String cName    = club[2];
        String cDesc    = club[3] != null ? club[3] : "";
        String cLoc     = (club[4] != null && !club[4].isEmpty()) ? club[4] : null;
        String cOwner   = club[5];
        boolean isOwner = club[1] != null && club[1].equals(String.valueOf(sessionUserID));
      %>
        <div class="club-card">
          <div class="club-name"><%= cName %></div>
          <div class="club-desc"><%= cDesc %></div>
          <div class="club-meta">
            <% if (cLoc != null) { %><span>📍 <%= cLoc %></span><% } %>
            <span class="club-owner">Owner: <%= isOwner ? "You" : "@" + cOwner %></span>
          </div>
        </div>
      <% } %>
    </div>
    <div id="noResults" class="empty-state" style="display:none;">No clubs match your filter.</div>
  <% } %>
</div>

<script>
  function updateCharCount(el, countId, max) {
    document.getElementById(countId).textContent = el.value.length;
  }

  (function () {
    var input = document.getElementById('clubFilter');
    if (!input) return;
    var total = parseInt(document.getElementById('clubsHeader').getAttribute('data-total'), 10);

    input.addEventListener('input', function () {
      var q = this.value.toLowerCase().trim();
      var cards = document.querySelectorAll('.club-card');
      var visible = 0;

      cards.forEach(function (card) {
        var matches = !q || card.textContent.toLowerCase().indexOf(q) !== -1;
        card.style.display = matches ? '' : 'none';
        if (matches) visible++;
      });

      document.getElementById('clubsHeader').textContent =
        q ? 'Showing ' + visible + ' of ' + total + ' clubs'
          : 'All Clubs (' + total + ')';

      var noResults = document.getElementById('noResults');
      if (noResults) noResults.style.display = (q && visible === 0) ? '' : 'none';
    });
  }());
</script>

</body>
</html>
