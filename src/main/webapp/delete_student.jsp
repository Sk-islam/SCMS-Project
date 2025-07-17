<%@ page import="java.sql.*" %>
<%
String id = request.getParameter("id");

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");
    PreparedStatement ps = con.prepareStatement("DELETE FROM students WHERE id=?");
    ps.setInt(1, Integer.parseInt(id));
    ps.executeUpdate();
    con.close();
    response.sendRedirect("manage_students.jsp");
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
