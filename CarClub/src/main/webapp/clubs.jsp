<%@ page import="java.util.List" %>
<%@ page import="carClubJava.MysqlCon" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Clubs</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>All Clubs</h1>
    </header>

    <main>
        <div class="search-section">
            <form method="GET" action="clubs.jsp">
                <input type="text" name="clubSearch" placeholder="Search clubs..." class="search-input" value="<%= request.getParameter("clubSearch") != null ? request.getParameter("clubSearch") : "" %>" />
                <button type="submit" class="btn-gold">Search</button>
            </form>
        </div>

        <%
            String clubSearch = request.getParameter("clubSearch");
            List<String[]> clubs;

            if (clubSearch != null && !clubSearch.trim().isEmpty()) {
                clubs = MysqlCon.searchClubs(clubSearch.trim());
            } else {
                clubs = MysqlCon.getClubs();
            }
        %>

        <div class="club-list">
            <% if (clubs != null && !clubs.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Club Name</th>
                            <th>Description</th>
                            <th>Location</th>
                            <th>Manager</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (String[] club : clubs) { %>
                            <tr>
                                <td><%= club[2] %></td>
                                <td><%= club[3] %></td>
                                <td><%= club[4] %></td>
                                <td><%= club[5] %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p>No clubs found.</p>
            <% } %>
        </div>
    </main>
</body>
</html>