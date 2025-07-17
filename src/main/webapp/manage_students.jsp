<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Students</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f4f4;
        }

        .container {
            margin-top: 50px;
        }

        .table thead {
            background-color: #0f2027;
            color: white;
        }

        .btn-sm {
            margin-right: 5px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="text-center mb-4">Manage Students</h2>

    <!-- Add Student Form -->
    <div class="card mb-4">
        <div class="card-header">Add Student</div>
        <div class="card-body">
            <form action="add_student.jsp" method="post" class="row g-3">
                <div class="col-md-4">
                    <input type="text" name="name" class="form-control" placeholder="Name" required />
                </div>
                <div class="col-md-4">
                    <input type="email" name="email" class="form-control" placeholder="Email" required />
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-success">Add Student</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Student Table -->
    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th>ID</th><th>Name</th><th>Email</th><th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            Connection con = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT * FROM students");

                while(rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("email") %></td>
            <td>
                <form action="edit_student.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>" />
                    <input type="hidden" name="name" value="<%= rs.getString("name") %>" />
                    <input type="hidden" name="email" value="<%= rs.getString("email") %>" />
                    <button type="submit" class="btn btn-warning btn-sm">Edit</button>
                </form>
                <form action="delete_student.jsp" method="post" style="display:inline;" onsubmit="return confirm('Are you sure?');">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>" />
                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                </form>
            </td>
        </tr>
        <%
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if(rs != null) try { rs.close(); } catch(Exception ignored) {}
                if(stmt != null) try { stmt.close(); } catch(Exception ignored) {}
                if(con != null) try { con.close(); } catch(Exception ignored) {}
            }
        %>
        </tbody>
    </table>
</div>

</body>
</html>
