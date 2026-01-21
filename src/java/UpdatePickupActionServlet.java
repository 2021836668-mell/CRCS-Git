import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.DBConnection;

@WebServlet("/UpdatePickupActionServlet")
public class UpdatePickupActionServlet extends HttpServlet {

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
            String action = request.getParameter("action");

            // Allow only valid actions
            if (!("In Progress".equals(action)
               || "On Hold".equals(action)
               || "Escalated".equals(action))) {

                response.sendRedirect("pickupList.jsp");
                return;
            }

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE pickups SET action=? WHERE pickup_id=?");

            ps.setString(1, action);
            ps.setInt(2, pickupId);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("pickupList.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pickupList.jsp");
        }
    }
}
