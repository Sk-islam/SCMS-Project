<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String studentName = (String) session.getAttribute("studentName");
    if (studentName == null) {
        response.sendRedirect("student_login.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Panel - SCMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f1f1f1;
            font-family: 'Segoe UI', sans-serif;
        }
        .header {
            background-color: #007bff;
            color: white;
            padding: 15px;
        }
        .nav-link {
            margin: 10px 0;
            padding: 12px;
            border-radius: 8px;
            background-color: white;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            color: #007bff;
            font-weight: 500;
            text-decoration: none;
            display: block;
            text-align: center;
        }
        .nav-link:hover {
            background-color: #e9f2ff;
        }
    </style>
</head>
<body>

    <div class="header d-flex justify-content-between align-items-center px-4">
        <h4>Student Panel - SCMS</h4>
        <div>
            Hi, <strong><%= studentName %></strong> |
            <a href="LogoutServlet" class="text-light text-decoration-none">Logout</a>
        </div>
    </div>

    <div class="container mt-5">
        <a href="view_my_courses.jsp" class="nav-link">📘 My Courses</a>
        <a href="student_profile.jsp" class="nav-link">👤 Profile</a>
    </div>

</body>
</html>
