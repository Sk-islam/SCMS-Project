<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("admin_login.html");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    String title = "", description = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String newTitle = request.getParameter("title");
            String newDesc = request.getParameter("description");

            ps = con.prepareStatement("UPDATE courses SET title=?, description=? WHERE id=?");
            ps.setString(1, newTitle);
            ps.setString(2, newDesc);
            ps.setInt(3, id);
            ps.executeUpdate();

            response.sendRedirect("manage_courses.jsp");
            return;
        }

        ps = con.prepareStatement("SELECT * FROM courses WHERE id=?");
        ps.setInt(1, id);
        rs = ps.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            description = rs.getString("description");
        }

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">Edit Course</h2>
    <form method="post">
        <div class="mb-3">
            <label>Title</label>
            <input type="text" name="title" class="form-control" value="<%= title %>" required>
        </div>
        <div class="mb-3">
            <label>Description</label>
            <textarea name="description" class="form-control" required><%= description %></textarea>
        </div>
        <button type="submit" class="btn btn-warning">Update Course</button>
        <a href="manage_courses.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>
