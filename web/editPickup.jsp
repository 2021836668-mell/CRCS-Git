<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM pickups WHERE pickup_id=?");
    ps.setInt(1, id);

    ResultSet rs = ps.executeQuery();
    rs.next();

    String currentType = rs.getString("recycling_type");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Pickup</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
        }
        .container {
            width: 420px;
            margin: 80px auto;
            background: white;
            padding: 25px;
            border-radius: 6px;
            box-shadow: 0 0 12px #ccc;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #2c7;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 12px;
        }
        input, select, button {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }
        select {
            background: #fff;
        }
        button {
            background: #2c7;
            color: white;
            border: none;
            margin-top: 20px;
            cursor: pointer;
            font-size: 15px;
            border-radius: 4px;
        }
        button:hover {
            background: #249f5f;
        }
        .back {
            text-align: center;
            margin-top: 15px;
        }
        .back a {
            text-decoration: none;
            color: #555;
        }
        .back a:hover {
            text-decoration: underline;
        }
        .status-view {
            margin-top: 12px;
            padding: 8px;
            background: #f1f1f1;
            border-radius: 4px;
            text-align: center;
            font-style: italic;
            color: #666;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Pickup</h2>

    <form action="PickupServlet" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="pickup_id" value="<%= id %>">

        <label>Recycling Type</label>
        <select name="recycling_type" required>
            <option value="Plastic" <%= "Plastic".equals(currentType) ? "selected" : "" %>>Plastic</option>
            <option value="Paper"   <%= "Paper".equals(currentType) ? "selected" : "" %>>Paper</option>
            <option value="Glass"   <%= "Glass".equals(currentType) ? "selected" : "" %>>Glass</option>
            <option value="Metal"   <%= "Metal".equals(currentType) ? "selected" : "" %>>Metal</option>
        </select>

        <label>Weight (kg)</label>
        <input type="number" name="weight" step="0.01" min="0.01"
               value="<%= rs.getDouble("weight") %>" required />

        <label>Pickup Date</label>
        <input type="date" name="pickup_date"
               value="<%= rs.getDate("pickup_date") %>" required />

        <!-- STATUS DISPLAY ONLY -->
        <label>Status</label>
        <div class="status-view">
            <%= rs.getString("status") %> (Admin Controlled)
        </div>

        <button type="submit">Update Pickup</button>
    </form>

    <div class="back">
        <a href="pickupList.jsp">Back to Pickup List</a>
    </div>
</div>

</body>
</html>
