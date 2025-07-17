<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("enrollment_id"));

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");
        PreparedStatement ps = con.prepareStatement("DELETE FROM enrollments WHERE id = ?");
        ps.setInt(1, id);
        ps.executeUpdate();
        con.close();
        response.sendRedirect("manage_enrollments.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
