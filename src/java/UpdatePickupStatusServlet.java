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

@WebServlet("/UpdatePickupStatusServlet")
public class UpdatePickupStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔒 Admin-only protection
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            int pickupId = Integer.parseInt(request.getParameter("pickup_id"));
            String status = request.getParameter("status");

            // ✅ Allow ONLY predefined status values
            if (!(
                    "Pending".equals(status)
                 || "In Progress".equals(status)
                 || "On Hold".equals(status)
                 || "Completed".equals(status)
                )) {
                response.sendRedirect("pickupList.jsp");
                return;
            }

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE pickups SET status=? WHERE pickup_id=?");

            ps.setString(1, status);
            ps.setInt(2, pickupId);

            ps.executeUpdate();

            ps.close();
            con.close();

        } catch (NumberFormatException e) {
            // Invalid pickup_id
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("pickupList.jsp");
    }
}
