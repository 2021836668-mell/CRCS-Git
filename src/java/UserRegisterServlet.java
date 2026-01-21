import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        int roleId = 2;

        try {
            Connection con = DBConnection.getConnection();

            String checkSql = "SELECT user_id FROM users WHERE email=?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Email already registered.");
                request.getRequestDispatcher("userRegister.jsp")
                       .forward(request, response);
                rs.close();
                checkPs.close();
                con.close();
                return;
            }

            rs.close();
            checkPs.close();

            String insertSql =
                "INSERT INTO users (name, email, password, role_id) VALUES (?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(insertSql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setInt(4, roleId);

            ps.executeUpdate();

            ps.close();
            con.close();

            request.setAttribute("success", "Registration successful. Please login.");
            request.getRequestDispatcher("index.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error. Please try again.");
            request.getRequestDispatcher("userRegister.jsp")
                   .forward(request, response);
        }
    }
}
