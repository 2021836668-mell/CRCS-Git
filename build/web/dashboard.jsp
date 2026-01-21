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
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    int totalPickups = 0;
    double totalWeight = 0;
    int pending = 0;
    int completed = 0;

    Connection con = DBConnection.getConnection();
    PreparedStatement ps;

    if ("admin".equals(role)) {
        ps = con.prepareStatement(
            "SELECT COUNT(*) total_pickups, " +
            "IFNULL(SUM(weight),0) total_weight, " +
            "SUM(status='Pending') pending, " +
            "SUM(status='Completed') completed " +
            "FROM pickups");
    } else {
        ps = con.prepareStatement(
            "SELECT COUNT(*) total_pickups, " +
            "IFNULL(SUM(weight),0) total_weight, " +
            "SUM(status='Pending') pending, " +
            "SUM(status='Completed') completed " +
            "FROM pickups WHERE user_id=?");
        ps.setInt(1, userId);
    }

    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        totalPickups = rs.getInt("total_pickups");
        totalWeight = rs.getDouble("total_weight");
        pending = rs.getInt("pending");
        completed = rs.getInt("completed");
    }

    rs.close();
    ps.close();
    con.close();
%>

<!DOCTYPE html>
<html>
<head>
    <title>CRCS Dashboard</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; }
        .container {
            width: 850px;
            margin: 40px auto;
            background: white;
            padding: 25px;
            border-radius: 6px;
            box-shadow: 0 0 12px #ccc;
        }
        .stats {
            display: flex;
            justify-content: space-between;
            margin: 25px 0;
        }
        .card {
            width: 23%;
            background: #f9f9f9;
            padding: 15px;
            text-align: center;
            border-radius: 5px;
            border-left: 5px solid #2c7;
        }
        .card h3 { margin: 0; color: #2c7; }
        .menu {
            margin-top: 20px;
        }
        .menu a {
            display: block;
            margin: 8px 0;
            text-decoration: none;
            color: #2c7;
        }
        .menu h4 {
            margin-top: 15px;
        }
        .logout {
            margin-top: 25px;
            text-align: right;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Welcome, <%= name %></h2>
    <p><strong>Role:</strong> <%= role %></p>

    <!-- STATISTICS -->
    <div class="stats">
        <div class="card">
            <h3><%= totalPickups %></h3>
            <p>Total Pickups</p>
        </div>
        <div class="card">
            <h3><%= totalWeight %> kg</h3>
            <p>Total Recycled</p>
        </div>
        <div class="card">
            <h3><%= pending %></h3>
            <p>Pending</p>
        </div>
        <div class="card">
            <h3><%= completed %></h3>
            <p>Completed</p>
        </div>
    </div>

    <hr>

    <!-- COMMON MENU -->
    <div class="menu">
        <a href="pickupList.jsp">View Pickups</a>

        <%-- ✅ ONLY USERS CAN SCHEDULE PICKUP --%>
        <% if (!"admin".equals(role)) { %>
            <a href="pickupForm.jsp">Schedule Recycling Pickup</a>
        <% } %>

        <a href="monthlyReport.jsp">Monthly Recycling Report</a>

        <% if ("admin".equals(role)) { %>
            <hr>
            <h4>Admin Management</h4>
            <a href="userList.jsp">Manage Users</a>
            <a href="register.jsp">Register New User</a>
            <a href="pickupList.jsp">Pickup Status Control</a>
        <% } %>
    </div>

    <div class="logout">
        <a href="logout.jsp">Logout</a>
    </div>
</div>

</body>
</html>
