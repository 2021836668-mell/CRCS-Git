<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
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
    int inProgress = 0;
    int onHold = 0;
    int completed = 0;

    Connection con = DBConnection.getConnection();
    PreparedStatement ps;

    if ("admin".equals(role)) {
        ps = con.prepareStatement(
            "SELECT COUNT(*) total_pickups, " +
            "IFNULL(SUM(weight),0) total_weight, " +
            "SUM(status='Pending') pending, " +
            "SUM(status='In Progress') in_progress, " +
            "SUM(status='On Hold') on_hold, " +
            "SUM(status='Completed') completed " +
            "FROM pickups");
    } else {
        ps = con.prepareStatement(
            "SELECT COUNT(*) total_pickups, " +
            "IFNULL(SUM(weight),0) total_weight, " +
            "SUM(status='Pending') pending, " +
            "SUM(status='In Progress') in_progress, " +
            "SUM(status='On Hold') on_hold, " +
            "SUM(status='Completed') completed " +
            "FROM pickups WHERE user_id=?");
        ps.setInt(1, userId);
    }

    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        totalPickups = rs.getInt("total_pickups");
        totalWeight = rs.getDouble("total_weight");
        pending = rs.getInt("pending");
        inProgress = rs.getInt("in_progress");
        onHold = rs.getInt("on_hold");
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
            width: 1000px;
            margin: 40px auto;
            background: white;
            padding: 20px;
            border-radius: 6px;
            box-shadow: 0 0 12px #ccc;
        }

        /* ✅ COMPACT ONE-LINE STATS */
        .stats {
            display: flex;
            justify-content: space-between;
            gap: 8px;
            margin: 15px 0 25px;
        }

        .card {
            flex: 1;
            background: #f9f9f9;
            padding: 10px 5px;
            text-align: center;
            border-radius: 5px;
            border-left: 4px solid #2c7;
        }

        .card h3 {
            margin: 0;
            font-size: 18px;
            color: #2c7;
        }

        .card p {
            margin: 4px 0 0;
            font-size: 12px;
            color: #555;
        }

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

    <!-- STATISTICS (ONE LINE) -->
    <div class="stats">
        <div class="card">
            <h3><%= totalPickups %></h3>
            <p>Total</p>
        </div>
        <div class="card">
            <h3><%= totalWeight %> kg</h3>
            <p>Recycled</p>
        </div>
        <div class="card">
            <h3><%= pending %></h3>
            <p>Pending</p>
        </div>
        <div class="card">
            <h3><%= inProgress %></h3>
            <p>In Progress</p>
        </div>
        <div class="card">
            <h3><%= onHold %></h3>
            <p>On Hold</p>
        </div>
        <div class="card">
            <h3><%= completed %></h3>
            <p>Completed</p>
        </div>
    </div>

    <hr>

    <!-- MENU -->
    <div class="menu">

        <% if (!"admin".equals(role)) { %>
            <a href="pickupList.jsp">View Pickups</a>
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
