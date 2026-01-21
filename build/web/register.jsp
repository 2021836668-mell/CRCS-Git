<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    if (session.getAttribute("user_id") == null ||
        !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Register User</title>
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

        /* 🔑 IMPORTANT FIX */
        input, select, button {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            box-sizing: border-box; /* ✅ makes all same width */
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

        .msg {
            margin-top: 15px;
            text-align: center;
            font-size: 14px;
        }
        .error { color: red; }
        .success { color: green; }

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
    <h2>Register New User</h2>

    <form action="RegisterServlet" method="post">

        <label>Full Name</label>
        <input type="text" name="name" placeholder="Enter full name" required />

        <label>Email Address</label>
        <input type="email" name="email" placeholder="Enter email address" required />

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter password" required />

        <label>User Role</label>
        <select name="role_id" required>
            <option value="">Select role</option>
            <option value="1">Admin</option>
            <option value="2">User</option>
            <option value="3">Collector</option>
        </select>

        <button type="submit">Create User</button>
    </form>

    <!-- Messages -->
    <div class="msg error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>

    <div class="msg success">
        <%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %>
    </div>

    <div class="back">
        <a href="dashboard.jsp">⬅ Back to Dashboard</a>
    </div>
</div>

</body>
</html>
