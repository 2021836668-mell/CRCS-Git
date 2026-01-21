import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("user_id") == null ||
            !"admin".equals(request.getSession().getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = Integer.parseInt(request.getParameter("user_id"));
        String password = request.getParameter("password");
        String status = request.getParameter("status");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps;

            if (password != null && !password.trim().isEmpty()) {

                String sql =
                    "UPDATE users SET password=?, status=? WHERE user_id=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, password);
                ps.setString(2, status);
                ps.setInt(3, userId);

            } else {
                String sql =
                    "UPDATE users SET status=? WHERE user_id=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, status);
                ps.setInt(2, userId);
            }

            ps.executeUpdate();
            ps.close();
            con.close();

            response.sendRedirect("userList.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("userList.jsp");
        }
    }
}
