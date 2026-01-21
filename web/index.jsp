<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>CRCS Login</title>
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

        .error {
            margin-top: 12px;
            color: red;
            text-align: center;
            font-size: 14px;
        }

        .register-link {
            margin-top: 18px;
            text-align: center;
            font-size: 14px;
            color: #555;
        }
        .register-link a {
            color: #2c7;
            text-decoration: none;
            font-weight: bold;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>CRCS Login</h2>

    <form action="LoginServlet" method="post">

        <label>Email Address</label>
        <input type="email" name="email" placeholder="Enter email address" required />

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter password" required />

        <button type="submit">Login</button>
    </form>

    <div class="error">
        <%= request.getAttribute("error") != null
                ? request.getAttribute("error")
                : "" %>
    </div>

    <div class="register-link">
        New user? <a href="userRegister.jsp">Create an account</a>
    </div>
</div>

</body>
</html>
