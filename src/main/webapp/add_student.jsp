<%@ page import="java.sql.*" %>
<%
String name = request.getParameter("name");
String email = request.getParameter("email");

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");
    PreparedStatement ps = con.prepareStatement("INSERT INTO students (id, name, email) VALUES (students_seq.NEXTVAL, ?, ?)");
    ps.setString(1, name);
    ps.setString(2, email);
    ps.executeUpdate();
    con.close();
    response.sendRedirect("manage_students.jsp");
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
