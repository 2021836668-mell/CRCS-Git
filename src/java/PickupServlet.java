import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import util.DBConnection;

@WebServlet("/PickupServlet")
public class PickupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            res.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String role = (String) session.getAttribute("role");
        String action = req.getParameter("action");

        try {
            double weight = Double.parseDouble(req.getParameter("weight"));

            // ❌ Block invalid weight
            if (weight <= 0) {
                req.setAttribute("error", "Weight must be greater than 0.");

                if ("create".equals(action)) {
                    req.getRequestDispatcher("pickupForm.jsp").forward(req, res);
                } else {
                    req.getRequestDispatcher(
                        "editPickup.jsp?id=" + req.getParameter("pickup_id"))
                        .forward(req, res);
                }
                return;
            }

            Connection con = DBConnection.getConnection();

            // 🔒 Server-side lock: user cannot edit completed pickup
            if ("update".equals(action)) {

                PreparedStatement checkPs = con.prepareStatement(
                    "SELECT status FROM pickups WHERE pickup_id=?");
                checkPs.setInt(1, Integer.parseInt(req.getParameter("pickup_id")));
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()
                        && "Completed".equals(rs.getString("status"))
                        && !"admin".equals(role)) {

                    rs.close();
                    checkPs.close();
                    con.close();

                    res.sendRedirect("pickupList.jsp");
                    return;
                }

                rs.close();
                checkPs.close();
            }

            // ✅ CREATE PICKUP
            if ("create".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO pickups (user_id, recycling_type, weight, pickup_date, status) " +
                    "VALUES (?,?,?,?,?)");

                ps.setInt(1, userId);
                ps.setString(2, req.getParameter("recycling_type"));
                ps.setDouble(3, weight);
                ps.setDate(4, java.sql.Date.valueOf(req.getParameter("pickup_date")));
                ps.setString(5, "Pending");

                ps.executeUpdate();
                ps.close();
            }

            // ✅ UPDATE PICKUP (USER ONLY – NO STATUS)
            if ("update".equals(action)) {
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE pickups SET recycling_type=?, weight=?, pickup_date=? WHERE pickup_id=?");

                ps.setString(1, req.getParameter("recycling_type"));
                ps.setDouble(2, weight);
                ps.setDate(3, java.sql.Date.valueOf(req.getParameter("pickup_date")));
                ps.setInt(4, Integer.parseInt(req.getParameter("pickup_id")));

                ps.executeUpdate();
                ps.close();
            }

            con.close();
            res.sendRedirect("pickupList.jsp");

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid weight value.");
            req.getRequestDispatcher("pickupForm.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("pickupList.jsp");
        }
    }

    @Override
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
