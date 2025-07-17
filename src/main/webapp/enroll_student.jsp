<%@ page import="java.sql.*" %>
<%
    int studentId = Integer.parseInt(request.getParameter("student_id"));
    int courseId = Integer.parseInt(request.getParameter("course_id"));

    Connection con = null;
    PreparedStatement ps = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");

        String sql = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
        ps = con.prepareStatement(sql);
        ps.setInt(1, studentId);
        ps.setInt(2, courseId);

        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("manage_enrollments.jsp");
        } else {
            out.println("<h3>Enrollment failed!</h3>");
        }

    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
