<%@ page import="carClubJava.MysqlCon, java.util.List" %>
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
    List<String[]> cars = MysqlCon.getCars();
    for (String[] car : cars) {
  %>
  <tr>
    <td><%= car[0] %></td>
    <td><%= car[1] %></td>
  </tr>
  <% } %>
</table>

</body>
</html>