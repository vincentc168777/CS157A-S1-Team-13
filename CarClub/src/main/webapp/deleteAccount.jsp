<%@ page import="carClubJava.MysqlCon" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Get session safely
    HttpSession currentSession = request.getSession(false);
    Integer userIDObj = (currentSession != null) ? (Integer) currentSession.getAttribute("userID") : null;
    String username = (currentSession != null) ? (String) currentSession.getAttribute("username") : null;

    // Redirect if not logged in
    if (userIDObj == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean attempted = false;
    boolean deleted = false;

    // Handle POST request
    if ("POST".equalsIgnoreCase(request.getMethod()) &&
        "1".equals(request.getParameter("confirmDelete"))) {

        attempted = true;
        deleted = MysqlCon.deleteAccount(userIDObj);

        if (deleted) {
            currentSession.invalidate(); // log user out
            response.sendRedirect("index.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Delete Account - Car Club</title>
  <style>
    body {
      background: #0a0a0a;
      color: #fff;
      font-family: 'DM Sans', sans-serif;
    }
    .container {
      max-width: 420px;
      margin: 60px auto;
      background: #181818;
      border-radius: 10px;
      box-shadow: 0 2px 12px #0004;
      padding: 32px;
    }
    h2 {
      color: #e8b44b;
      margin-bottom: 18px;
      text-align: center;
    }
    .warning {
      color: #fff;
      background: #a00;
      border-radius: 6px;
      padding: 14px;
      margin-bottom: 18px;
      font-size: 15px;
      text-align: center;
    }
    .btn-danger {
      background: #a00;
      color: #fff;
      border: none;
      padding: 12px 32px;
      border-radius: 4px;
      font-size: 15px;
      cursor: pointer;
      text-transform: uppercase;
      letter-spacing: 1px;
      transition: background 0.2s;
    }
    .btn-danger:hover {
      background: #e8b44b;
      color: #181818;
    }
    .btn-cancel {
      background: transparent;
      color: #e8b44b;
      border: 1px solid #e8b44b;
      padding: 12px 32px;
      border-radius: 4px;
      font-size: 15px;
      cursor: pointer;
      margin-left: 10px;
      text-transform: uppercase;
      letter-spacing: 1px;
      text-decoration: none;
      transition: background 0.2s, color 0.2s;
    }
    .btn-cancel:hover {
      background: #e8b44b;
      color: #181818;
    }
    .center {
      text-align: center;
    }
  </style>
</head>

<body>
  <div class="container">
    <h2>Delete Account</h2>

    <div class="warning">
      Warning: This action is <b>permanent</b> and will delete your account and all your cars.<br>
      This cannot be undone.<br><br>
      Are you sure you want to continue?
    </div>

    <form method="post" class="center">
      <input type="hidden" name="confirmDelete" value="1" />
      <button type="submit" class="btn-danger">Yes, Delete My Account</button>
      <a href="index.jsp" class="btn-cancel">Cancel</a>
    </form>

    <% if (attempted && !deleted) { %>
      <div style="color:#e8b44b; margin-top:18px; text-align:center;">
        Error: Could not delete account.
      </div>
    <% } %>

  </div>
</body>
</html>