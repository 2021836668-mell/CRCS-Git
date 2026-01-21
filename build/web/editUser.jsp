<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
    if (session.getAttribute("user_id") == null ||
        !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    int userId = Integer.parseInt(request.getParameter("id"));
    Connection con = DBConnection.getConnection();

    PreparedStatement ps = con.prepareStatement(
        "SELECT name, email, status FROM users WHERE user_id=?");
    ps.setInt(1, userId);

    ResultSet rs = ps.executeQuery();
    rs.next();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; }
        .container {
            width: 400px;
            margin: 80px auto;
            background: white;
            padding: 25px;
            border-radius: 6px;
            box-shadow: 0 0 12px #ccc;
        }
        label { font-weight: bold; display: block; margin-top: 12px; }
        input, select, button {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            box-sizing: border-box;
        }
        button {
            background: #2c7;
            color: white;
            border: none;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit User</h2>

    <form action="UpdateUserServlet" method="post">
        <input type="hidden" name="user_id" value="<%= userId %>">

        <label>Name</label>
        <input type="text" value="<%= rs.getString("name") %>" disabled>

        <label>Email</label>
        <input type="email" value="<%= rs.getString("email") %>" disabled>

        <label>New Password</label>
        <input type="password" name="password"
               placeholder="Leave blank to keep current password">

        <label>Status</label>
        <select name="status">
            <option value="active" <%= "active".equals(rs.getString("status")) ? "selected" : "" %>>Active</option>
            <option value="disabled" <%= "disabled".equals(rs.getString("status")) ? "selected" : "" %>>Disabled</option>
        </select>

        <button type="submit">Update User</button>
    </form>

    <p style="text-align:center;">
        <a href="userList.jsp">Back</a>
    </p>
</div>

</body>
</html>
