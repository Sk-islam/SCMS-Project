<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String studentName = (String) session.getAttribute("studentName");
    Integer studentId = (Integer) session.getAttribute("studentId");

    if (studentId == null) {
        response.sendRedirect("student_login.html");
        return;
    }

    List<String[]> courseList = new ArrayList<>();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");

        String query = "SELECT c.TITLE, c.DESCRIPTION FROM COURSES c " +
                       "JOIN ENROLLMENTS e ON c.ID = e.COURSE_ID " +
                       "WHERE e.STUDENT_ID = ?";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setInt(1, studentId);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            courseList.add(new String[]{rs.getString("TITLE"), rs.getString("DESCRIPTION")});
        }

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Courses - SCMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h3 class="mb-4">My Enrolled Courses</h3>

        <% if (courseList.isEmpty()) { %>
            <div class="alert alert-warning">You are not enrolled in any courses yet.</div>
        <% } else { %>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Course Title</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (String[] course : courseList) { %>
                        <tr>
                            <td><%= course[0] %></td>
                            <td><%= course[1] %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
