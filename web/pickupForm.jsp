<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Schedule Pickup</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
        }
        .container {
            width: 400px;
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
    </style>
</head>
<body>

<div class="container">
    <h2>Schedule Recycling Pickup</h2>

    <form action="PickupServlet" method="post">
        <input type="hidden" name="action" value="create">

        <label>Recycling Type</label>
        <select name="recycling_type" required>
            <option value="">Select type</option>
            <option>Plastic</option>
            <option>Paper</option>
            <option>Glass</option>
            <option>Metal</option>
        </select>

        <label>Estimated Weight (kg)</label>
        <input type="number" step="0.01" name="weight" placeholder="e.g. 2.50" required />

        <label>Pickup Date</label>
        <input type="date" name="pickup_date" required />

        <button type="submit">Submit Pickup Request</button>
    </form>

    <div class="back">
        <a href="dashboard.jsp">⬅ Back to Dashboard</a>
    </div>
</div>

</body>
</html>
