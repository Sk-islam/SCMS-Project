<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    if (session == null || session.getAttribute("adminName") == null) {
        response.sendRedirect("admin_login.html");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - SCMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            color: white;
        }

        .container {
            margin-top: 80px;
        }

        .card {
            border: none;
            border-radius: 10px;
            transition: transform 0.3s;
        }

        .card:hover {
            transform: scale(1.03);
        }

        .card-title {
            color: #0f2027;
        }

        .header {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 20px 30px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h2 {
            margin: 0;
        }

        .header .welcome {
            font-weight: bold;
            color: #f0f0f0;
        }

        .btn-logout {
            margin-left: 15px;
        }

        a.card-link {
            text-decoration: none;
            color: inherit;
        }
    </style>
</head>
<body>

    <div class="header">
        <h2>Admin Panel - SCMS</h2>
        <div>
            <span class="welcome">Welcome, <%= adminName %></span>
            <a href="<%= request.getContextPath() %>/adminLogout" class="btn btn-sm btn-danger btn-logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <a href="manage_students.jsp" class="card-link">
                    <div class="card bg-light p-4">
                        <h4 class="card-title">Manage Students</h4>
                        <p>Add, view, or remove student records.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="manage_courses.jsp" class="card-link">
                    <div class="card bg-light p-4">
                        <h4 class="card-title">Manage Courses</h4>
                        <p>Create or update course details.</p>
                    </div>
                </a>
            </div>

            <div class="col-md-4">
                <a href="manage_enrollments.jsp" class="card-link">
                    <div class="card bg-light p-4">
                        <h4 class="card-title">Enrollments</h4>
                        <p>View or assign courses to students.</p>
                    </div>
                </a>
            </div>
        </div>
    </div>

</body>
</html>
