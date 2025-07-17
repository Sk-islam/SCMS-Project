package scm.pack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // Update with your DB details
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
    private static final String DB_USER = "system";
    private static final String DB_PASS = "TIGER";

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userType = request.getParameter("userType");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            if ("admin".equals(userType)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                ps = con.prepareStatement("SELECT * FROM APP_ADMIN WHERE USERNAME = ? AND PASSWORD = ?");
                ps.setString(1, username);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("adminName", username);
                    response.sendRedirect("admin_home.jsp");
                } else {
                    request.setAttribute("error", "Invalid admin credentials");
                    request.getRequestDispatcher("admin_login.html").forward(request, response);
                }

            } else if ("student".equals(userType)) {
                int studentId = Integer.parseInt(request.getParameter("studentId"));

                ps = con.prepareStatement("SELECT * FROM students WHERE ID = ?");
                ps.setInt(1, studentId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("studentId", studentId);
                    session.setAttribute("studentName", rs.getString("NAME"));
                    response.sendRedirect("student_home.jsp");
                } else {
                    request.setAttribute("error", "Invalid student ID");
                    request.getRequestDispatcher("student_login.html").forward(request, response);
                }

            } else {
                response.sendRedirect("index.html");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Internal Server Error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
