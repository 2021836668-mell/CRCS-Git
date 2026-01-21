import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import util.DBConnection;

@WebServlet("/PickupServlet")
public class PickupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String action = req.getParameter("action");

        try {
            Connection con = DBConnection.getConnection();

            if ("create".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO pickups (user_id, recycling_type, weight, pickup_date, status) VALUES (?,?,?,?,?)");
                ps.setInt(1, userId);
                ps.setString(2, req.getParameter("recycling_type"));
                ps.setDouble(3, Double.parseDouble(req.getParameter("weight")));
                ps.setDate(4, java.sql.Date.valueOf(req.getParameter("pickup_date")));
                ps.setString(5, "Pending");
                ps.executeUpdate();
                ps.close();
            }

            if ("update".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE pickups SET recycling_type=?, weight=?, pickup_date=?, status=? WHERE pickup_id=?");
                ps.setString(1, req.getParameter("recycling_type"));
                ps.setDouble(2, Double.parseDouble(req.getParameter("weight")));
                ps.setDate(3, java.sql.Date.valueOf(req.getParameter("pickup_date")));
                ps.setString(4, req.getParameter("status"));
                ps.setInt(5, Integer.parseInt(req.getParameter("pickup_id")));
                ps.executeUpdate();
                ps.close();
            }

            con.close();
            res.sendRedirect("pickupList.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        if ("delete".equals(req.getParameter("action"))) {
            try {
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM pickups WHERE pickup_id=?");
                ps.setInt(1, Integer.parseInt(req.getParameter("id")));
                ps.executeUpdate();
                ps.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            res.sendRedirect("pickupList.jsp");
        }
    }
}
