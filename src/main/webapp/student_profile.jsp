<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    Integer studentId = (Integer) session.getAttribute("studentId");

    if (studentId == null) {
        response.sendRedirect("student_login.html");
        return;
    }

    String name = "", email = "";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");

        PreparedStatement pst = con.prepareStatement("SELECT NAME, EMAIL FROM STUDENTS WHERE ID = ?");
        pst.setInt(1, studentId);	
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            name = rs.getString("NAME");
            email = rs.getString("EMAIL");
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
    <title>Student Profile - SCMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h3 class="mb-4">My Profile</h3>
        <table class="table table-striped">
            <tr>
                <th>Student ID</th>
                <td><%= studentId %></td>
            </tr>
            <tr>
                <th>Name</th>
                <td><%= name %></td>
            </tr>
            <tr>
                <th>Email</th>
                <td><%= email %></td>
            </tr>
        </table>
    </div>
</body>
</html>
