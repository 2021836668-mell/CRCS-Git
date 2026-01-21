<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
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
    <title>Pickup List</title>
    <style>
        table {
            width: 90%;
            margin: 30px auto;
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

        select, button {
            padding: 4px;
        }

        .locked {
            color: gray;
            font-style: italic;
        }
    </style>
</head>
<body>

<h2 style="text-align:center;">Recycling Pickups</h2>

<table>
<tr>
    <th>ID</th>
    <th>User</th>
    <th>Type</th>
    <th>Weight (kg)</th>
    <th>Date</th>
    <th>Status</th>
    <th>Edit</th>
</tr>

<%
    Connection con = DBConnection.getConnection();
    PreparedStatement ps;

    if ("admin".equals(role)) {
        ps = con.prepareStatement(
            "SELECT p.*, u.name FROM pickups p JOIN users u ON p.user_id = u.user_id");
    } else {
        ps = con.prepareStatement(
            "SELECT p.*, u.name FROM pickups p JOIN users u ON p.user_id = u.user_id WHERE p.user_id=?");
        ps.setInt(1, userId);
    }

    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        int pickupId = rs.getInt("pickup_id");
        String status = rs.getString("status");
%>
<tr>
    <td><%= pickupId %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getString("recycling_type") %></td>
    <td><%= rs.getDouble("weight") %></td>
    <td><%= rs.getDate("pickup_date") %></td>

    <!-- STATUS -->
    <td>
        <% if ("admin".equals(role)) { %>
            <form action="UpdatePickupStatusServlet" method="post">
                <input type="hidden" name="pickup_id" value="<%= pickupId %>">
                <select name="status">
                    <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                    <option value="In Progress" <%= "In Progress".equals(status) ? "selected" : "" %>>In Progress</option>
                    <option value="On Hold" <%= "On Hold".equals(status) ? "selected" : "" %>>On Hold</option>
                    <option value="Completed" <%= "Completed".equals(status) ? "selected" : "" %>>Completed</option>
                </select>
                <button type="submit">Update</button>
            </form>
        <% } else { %>
            <%= status %>
        <% } %>
    </td>

    <!-- EDIT -->
    <td>
        <% if (!"admin".equals(role)) { %>
            <% if ("Pending".equals(status)) { %>
                <a href="editPickup.jsp?id=<%= pickupId %>">Edit</a>
            <% } else { %>
                <span class="locked">Locked</span>
            <% } %>
        <% } else { %>
            N/A
        <% } %>
    </td>
</tr>
<%
    }
    rs.close();
    ps.close();
    con.close();
%>

</table>

<p style="text-align:center;">
    <a href="dashboard.jsp">Back to Dashboard</a>
</p>

</body>
</html>
