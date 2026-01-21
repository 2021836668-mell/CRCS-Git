<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
    // ---- LOGIN PROTECTION ----
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int userId = (int) session.getAttribute("user_id");
    String role = (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Monthly Recycling Report</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; }
        table {
            width: 90%;
            margin: 40px auto;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #2c7;
            color: white;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>

<h2>Monthly Recycling Report</h2>

<table>
<tr>
    <th>Month</th>
    <th>Total Pickups</th>
    <th>Total Weight (kg)</th>
    <th>Pending</th>
    <th>Completed</th>
</tr>

<%
    Connection con = DBConnection.getConnection();
    PreparedStatement ps;

    if ("admin".equals(role)) {
        ps = con.prepareStatement(
            "SELECT DATE_FORMAT(pickup_date, '%Y-%m') AS month, " +
            "COUNT(*) AS total_pickups, " +
            "IFNULL(SUM(weight),0) AS total_weight, " +
            "SUM(status='Pending') AS pending, " +
            "SUM(status='Completed') AS completed " +
            "FROM pickups " +
            "GROUP BY month " +
            "ORDER BY month DESC"
        );
    } else {
        ps = con.prepareStatement(
            "SELECT DATE_FORMAT(pickup_date, '%Y-%m') AS month, " +
            "COUNT(*) AS total_pickups, " +
            "IFNULL(SUM(weight),0) AS total_weight, " +
            "SUM(status='Pending') AS pending, " +
            "SUM(status='Completed') AS completed " +
            "FROM pickups WHERE user_id=? " +
            "GROUP BY month " +
            "ORDER BY month DESC"
        );
        ps.setInt(1, userId);
    }

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("month") %></td>
    <td><%= rs.getInt("total_pickups") %></td>
    <td><%= rs.getDouble("total_weight") %></td>
    <td><%= rs.getInt("pending") %></td>
    <td><%= rs.getInt("completed") %></td>
</tr>
<%
    }

    rs.close();
    ps.close();
    con.close();
%>

</table>

<p style="text-align:center;">
    <a href="dashboard.jsp">⬅ Back to Dashboard</a>
</p>

</body>
</html>
