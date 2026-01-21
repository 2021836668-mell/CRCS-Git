<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
    if (session.getAttribute("user_id") == null ||
        !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    int currentAdminId = (int) session.getAttribute("user_id");
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; }
        table {
            width: 95%;
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
        select, button {
            padding: 5px;
        }
        .action a {
            margin: 0 6px;
            text-decoration: none;
            font-weight: bold;
        }
        .edit { color: #2c7; }
        .delete { color: red; }

        .status-active {
            color: green;
            font-weight: bold;
        }
        .status-disabled {
            color: red;
            font-weight: bold;
        }

        .back {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<h2 style="text-align:center;">User Management (Admin Only)</h2>

<table>
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Role</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
    Connection con = DBConnection.getConnection();

    String sql =
        "SELECT u.user_id, u.name, u.email, u.status, r.role_name " +
        "FROM users u JOIN roles r ON u.role_id = r.role_id";

    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();

    while (rs.next()) {
        int uid = rs.getInt("user_id");
        String roleName = rs.getString("role_name");
        String status = rs.getString("status");
%>
<tr>
    <td><%= uid %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getString("email") %></td>

    <td>
        <% if (uid != currentAdminId) { %>
            <form action="UpdateRoleServlet" method="post">
                <input type="hidden" name="user_id" value="<%= uid %>">
                <select name="role_id">
                    <option value="1" <%= "admin".equals(roleName) ? "selected" : "" %>>Admin</option>
                    <option value="2" <%= "user".equals(roleName) ? "selected" : "" %>>User</option>
                </select>
                <button type="submit">Update</button>
            </form>
        <% } else { %>
            <strong>Admin</strong>
        <% } %>
    </td>

    <!-- STATUS COLUMN -->
    <td>
        <% if ("active".equals(status)) { %>
            <span class="status-active">Active</span>
        <% } else { %>
            <span class="status-disabled">Disabled</span>
        <% } %>
    </td>

    <td class="action">
        <% if (uid != currentAdminId) { %>
            <a class="edit" href="editUser.jsp?id=<%= uid %>">Edit</a>
            |
            <a class="delete"
               href="DeleteUserServlet?id=<%= uid %>"
               onclick="return confirm('Are you sure you want to delete this user?');">
               Delete
            </a>
        <% } else { %>
            —
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

<div class="back">
    <a href="dashboard.jsp">⬅ Back to Dashboard</a>
</div>

</body>
</html>
