import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

import util.DBConnection;

@WebServlet("/UpdateRoleServlet")
public class UpdateRoleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ---- ADMIN CHECK ----
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        int targetUserId = Integer.parseInt(request.getParameter("user_id"));
        int newRoleId = Integer.parseInt(request.getParameter("role_id"));
        int adminId = (int) session.getAttribute("user_id");

        // Prevent admin from changing own role
        if (targetUserId == adminId) {
            response.sendRedirect("userList.jsp");
            return;
        }

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE users SET role_id = ? WHERE user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, newRoleId);
            ps.setInt(2, targetUserId);

            ps.executeUpdate();

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("userList.jsp");
    }
}
