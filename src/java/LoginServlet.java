import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

import util.DBConnection;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            String sql =
                "SELECT u.user_id, u.name, r.role_name " +
                "FROM users u " +
                "JOIN roles r ON u.role_id = r.role_id " +
                "WHERE u.email = ? AND u.password = ? AND u.status = 'active'";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("role", rs.getString("role_name"));

                response.sendRedirect("dashboard.jsp");

            } else {
                String checkSql =
                    "SELECT status FROM users WHERE email = ?";
                PreparedStatement checkPs = con.prepareStatement(checkSql);
                checkPs.setString(1, email);
                ResultSet checkRs = checkPs.executeQuery();

                if (checkRs.next() && "disabled".equals(checkRs.getString("status"))) {
                    request.setAttribute("error", "Your account has been disabled. Please contact admin.");
                } else {
                    request.setAttribute("error", "Invalid email or password.");
                }

                checkRs.close();
                checkPs.close();

                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error. Please try again.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
