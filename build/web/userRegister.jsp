<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
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
        input, button {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            box-sizing: border-box;
            font-size: 14px;
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
            margin-top: 12px;
            text-align: center;
            font-size: 14px;
        }
        .error { color: red; }
        .success { color: green; }
    </style>

    <script>
        function validatePassword() {
            const pwd = document.getElementById("password").value;
            const confirmPwd = document.getElementById("confirm_password").value;

            if (pwd !== confirmPwd) {
                alert("Passwords do not match.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

<div class="container">
    <h2>Create Account</h2>

    <form action="UserRegisterServlet" method="post" onsubmit="return validatePassword();">

        <label>Full Name</label>
        <input type="text" name="name" placeholder="Enter full name" required />

        <label>Email Address</label>
        <input type="email" name="email" placeholder="Enter email address" required />

        <label>Password</label>
        <input type="password" id="password" name="password"
               placeholder="Enter password" required />

        <label>Re-confirm Password</label>
        <input type="password" id="confirm_password"
               placeholder="Re-enter password" required />

        <input type="hidden" name="role_id" value="2" />

        <button type="submit">Register</button>
    </form>

    <div class="msg error">
        <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
    </div>

    <div class="msg success">
        <%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %>
    </div>

    <div class="msg">
        <a href="index.jsp">⬅ Back to Login</a>
    </div>
</div>

</body>
</html>
