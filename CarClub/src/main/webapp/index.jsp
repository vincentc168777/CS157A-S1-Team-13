<%@ page import="carClubJava.MysqlCon, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Car Club</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'DM Sans', sans-serif;
      background: #0a0a0a;
      color: #ffffff
      min-height: 100vh;
    }

    /* NAV */
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
    .nav-links { display: flex; gap: 28px; }
    .nav-links a {
      color: #888;
      font-size: 12px;
      text-decoration: none;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      transition: color 0.2s;
    }
    .nav-links a:hover { color: #e8b44b; }

    /* HERO */
    .hero {
      padding: 80px 48px 60px;
      border-bottom: 0.5px solid #1a1a1a;
    }
    .hero-tag {
      font-size: 11px;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: #e8b44b;
      margin-bottom: 20px;
    }
    .hero-title {
      font-family: 'Bebas Neue', sans-serif;
      font-size: clamp(52px, 8vw, 90px);
      line-height: 1;
      letter-spacing: 2px;
      margin-bottom: 24px;
    }
    .hero-title span { color: #e8b44b; }
    .hero-sub {
      color: #888;
      font-size: 15px;
      max-width: 500px;
      line-height: 1.7;
      margin-bottom: 40px;
    }
    .hero-btns { display: flex; gap: 12px; flex-wrap: wrap; }
    .btn-primary {
      background: #e8b44b;
      color: #0a0a0a;
      border: none;
      padding: 13px 32px;
      font-family: 'DM Sans', sans-serif;
      font-size: 12px;
      font-weight: 500;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: background 0.2s;
    }
    .btn-primary:hover { background: #f5c76a; }
    .btn-outline {
      background: transparent;
      color: #f0f0f0;
      border: 0.5px solid #444;
      padding: 13px 32px;
      font-family: 'DM Sans', sans-serif;
      font-size: 12px;
      font-weight: 500;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: border-color 0.2s, color 0.2s;
    }
    .btn-outline:hover { border-color: #e8b44b; color: #e8b44b; }

    /* SEARCH BAR */
    .search-section {
      padding: 28px 48px;
      background: #0e0e0e;
      border-bottom: 0.5px solid #1a1a1a;
      display: flex;
      gap: 12px;
      align-items: center;
    }
    .search-section input {
      flex: 1;
      max-width: 520px;
      background: #1a1a1a;
      border: 0.5px solid #333;
      color: #f0f0f0;
      padding: 11px 18px;
      font-family: 'DM Sans', sans-serif;
      font-size: 14px;
      outline: none;
      transition: border-color 0.2s;
    }
    .search-section input::placeholder { color: #555; }
    .search-section input:focus { border-color: #e8b44b; }
    .search-label {
      font-size: 11px;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: #555;
    }

    /* TABLE SECTION */
    .garage-section { padding: 40px 48px; }
    .section-header {
      display: flex;
      align-items: baseline;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    .section-title {
      font-size: 11px;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: #555;
    }
    .car-count {
      font-size: 11px;
      letter-spacing: 1px;
      color: #444;
    }
    table { width: 100%; border-collapse: collapse; }
    thead th {
      font-size: 11px;
      letter-spacing: 2px;
      text-transform: uppercase;
      color: #555;
      text-align: left;
      padding: 10px 14px;
      border-bottom: 0.5px solid #222;
    }
    tbody tr { transition: background 0.15s; }
    tbody tr:hover td { background: #111; }
    tbody td {
      font-size: 14px;
      color: #bbb;
      padding: 14px 14px;
      border-bottom: 0.5px solid #161616;
    }
    tbody td:first-child { color: #555; font-size: 12px; letter-spacing: 1px; }
    tbody td:nth-child(2) { color: #e8e8e8; font-weight: 500; }
    .status-badge {
      display: inline-block;
      font-size: 10px;
      padding: 3px 10px;
      background: #1a1a1a;
      color: #e8b44b;
      letter-spacing: 1.5px;
      text-transform: uppercase;
      border: 0.5px solid #2e2e2e;
    }
    .no-results {
      padding: 40px 14px;
      color: #444;
      font-size: 14px;
      display: none;
    }

    /* FOOTER */
    footer {
      border-top: 0.5px solid #1a1a1a;
      padding: 24px 48px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: #444;
      font-size: 12px;
      letter-spacing: 0.5px;
    }
    
    /* IMAGE */
    .hero img {
        width: 100%;
        max-width: 500px;
        height: auto;
        margin: 20px auto;
        display: block;
        border: 0.5px solid #2a2a2a;
    }
  </style>
</head>
<body>

  <nav>
  <a class="logo" href="index.jsp">Car Club</a>
  <div class="nav-links">
    <a href="index.jsp">Garage</a>
    <a href="AddCar.jsp">Add Car</a>
    <%
      String loggedInUser = (String) session.getAttribute("username");
      if (loggedInUser != null) {
    %>
      <a href="logout.jsp">Logout (<%= loggedInUser %>)</a>
    <% } else { %>
      <a href="login.jsp">Login</a>
      <a href="register.jsp">Register</a>
    <% } %>
  </div>
</nav>

  <div class="hero">
    <div class="hero-tag">CarClub</div>
    <h1 class="hero-title">The <span>Ultimate</span><br>Car Registry</h1>
    <p class="hero-sub">Browse, search, and manage your car collection. Built for enthusiasts who take their fleet seriously.</p>
    
    <img src="<%= request.getContextPath() %>/images/dom.jpg" alt="A descriptive text for the image">
    
    <div class="hero-btns">
      <a href="#garage" class="btn-primary">View Garage</a>
      <a href="addCar.jsp" class="btn-outline">+ Add a Car</a>
    </div>
  </div>

  <div class="search-section">
    <span class="search-label">Search</span>
    <input
      type="text"
      id="searchInput"
      placeholder="Search by name..."
      oninput="filterTable()"
    />
  </div>

  <div class="garage-section" id="garage">
    <div class="section-header">
      <span class="section-title">Registered Vehicles</span>
      <span class="car-count" id="carCount"></span>
    </div>

    <%
      List<String[]> cars = MysqlCon.getCars();
    %>

    <table id="carTable">
  <thead>
    <tr>
      <th>Car ID</th>
      <th>Owner ID</th>
      <th>Make</th>
      <th>Model</th>
      <th>Year</th>
      <th>Description</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody id="carTableBody">
    <%
      for (String[] car : cars) {
    %>
    <tr>
      <td><%= car[0] %></td>  <%-- Car_ID --%>
      <td><%= car[1] %></td>  <%-- User_ID --%>
      <td><%= car[2] %></td>  <%-- Make --%>
      <td><%= car[3] %></td>  <%-- Model --%>
      <td><%= car[4] %></td>  <%-- Year --%>
      <td><%= car[5] %></td>  <%-- Description --%>
      <td><span class="status-badge">Active</span></td>
    </tr>
    <% } %>
  </tbody>
</table>
    <div class="no-results" id="noResults">No vehicles match your search.</div>
  </div>

  <footer>
    <span>Car Club &copy; 2024</span>
    <span id="totalCount"></span>
  </footer>

  <script>
    const rows = Array.from(document.querySelectorAll('#carTableBody tr'));
    const totalCars = rows.length;

    document.getElementById('carCount').textContent = totalCars + ' vehicles';
    document.getElementById('totalCount').textContent = totalCars + ' vehicles registered';

    function filterTable() {
      const query = document.getElementById('searchInput').value.toLowerCase().trim();
      let visible = 0;

      rows.forEach(row => {
        const name = row.cells[1].textContent.toLowerCase();
        const id = row.cells[0].textContent.toLowerCase();
        const match = name.includes(query) || id.includes(query);
        row.style.display = match ? '' : 'none';
        if (match) visible++;
      });

      document.getElementById('carCount').textContent = visible + ' vehicles';
      document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
    }
  </script>
</body>
</html>
