<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Car Club</title>
</head>
<body>
<img src="<%= request.getContextPath() %>/images/dom.jpg" alt="A descriptive text for the image">
<h1>Welcome to Car Club</h1>

<table border="1">
  <tr>
    <td>Car ID</td>
    <td>Name</td>
  </tr>
    <%
     String db = "Car Club's";
        String user; // assumes database name is the same as username
          user = "root";
        String password = "root";
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cheng?autoReconnect=true&useSSL=false",user, password);

            out.println(db + " database successfully opened.<br/><br/>");

            out.println("Initial entries in table \"Cars\": <br/>");

            Statement stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM Cars");

            while (rs.next()) {
         out.println("<tr>" + "<td>" +  rs.getString(1) + "</td>"+ "<td>" +  rs.getString(2) + "</td>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch(SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        }
    %>
</body>
</html>