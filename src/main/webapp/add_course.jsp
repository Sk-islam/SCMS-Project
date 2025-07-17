<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("admin_login.html");
        return;
    }

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    String msg = null;

    // Handle course insertion
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    if (title != null && description != null && !title.trim().isEmpty() && !description.trim().isEmpty()) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");

            PreparedStatement pstmt = con.prepareStatement("INSERT INTO courses (id, title, description) VALUES (course_seq.NEXTVAL, ?, ?)");
            pstmt.setString(1, title);
            pstmt.setString(2, description);
            int i = pstmt.executeUpdate();
            if (i > 0) msg = "Course added successfully!";
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4">Courses List</h2>

    <!-- Add New Course Form -->
    <div class="mb-4">
        <form method="post" action="manage_courses.jsp">
            <div class="row g-3">
                <div class="col-md-4">
                    <input type="text" name="title" class="form-control" placeholder="Course Title" required>
                </div>
                <div class="col-md-5">
                    <input type="text" name="description" class="form-control" placeholder="Course Description" required>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-success w-100">Add Course</button>
                </div>
            </div>
        </form>
    </div>

    <!-- Search Box -->
    <div class="mb-3">
        <input type="text" id="searchInput" class="form-control" placeholder="Search by title or description">
    </div>

    <!-- Courses Table -->
    <table class="table table-bordered bg-white shadow-sm" id="coursesTable">
        <thead class="table-success">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");
                stmt = con.createStatement();
                rs = stmt.executeQuery("SELECT * FROM courses ORDER BY id DESC");

                while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("description") %></td>
                <td>
                    <a href="edit_course.jsp?id=<%= rs.getInt("id") %>" class="btn btn-sm btn-warning">Edit</a>
                    <button class="btn btn-sm btn-danger" onclick="confirmDelete(<%= rs.getInt("id") %>)">Delete</button>
                </td>
            </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}
            }
        %>
        </tbody>
    </table>

    <!-- Pagination Buttons -->
    <div class="d-flex justify-content-between">
        <button id="prevBtn" class="btn btn-secondary">Previous</button>
        <button id="nextBtn" class="btn btn-secondary">Next</button>
    </div>

    <a href="admin_home.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
</div>

<!-- Toast Notification -->
<div class="toast-container">
    <div id="toastMsg" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">Action completed successfully!</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Show toast
    function showToast(message) {
        document.querySelector(".toast-body").innerText = message;
        const toast = new bootstrap.Toast(document.getElementById("toastMsg"));
        toast.show();
    }

    // Confirm Delete
    function confirmDelete(courseId) {
        if (confirm("Are you sure you want to delete this course?")) {
            window.location.href = "delete_course.jsp?id=" + courseId;
        }
    }

    // Search functionality
    document.getElementById("searchInput").addEventListener("input", function () {
        const searchValue = this.value.toLowerCase();
        const rows = document.querySelectorAll("#coursesTable tbody tr");
        rows.forEach(row => {
            const title = row.cells[1].textContent.toLowerCase();
            const desc = row.cells[2].textContent.toLowerCase();
            row.style.display = (title.includes(searchValue) || desc.includes(searchValue)) ? "" : "none";
        });
    });

    // Pagination (client-side)
    const rows = document.querySelectorAll("#coursesTable tbody tr");
    const rowsPerPage = 5;
    let currentPage = 1;

    function showPage(page) {
        let start = (page - 1) * rowsPerPage;
        let end = start + rowsPerPage;

        rows.forEach((row, index) => {
            row.style.display = (index >= start && index < end) ? "" : "none";
        });
    }

    document.getElementById("prevBtn").addEventListener("click", function () {
        if (currentPage > 1) {
            currentPage--;
            showPage(currentPage);
        }
    });

    document.getElementById("nextBtn").addEventListener("click", function () {
        if (currentPage * rowsPerPage < rows.length) {
            currentPage++;
            showPage(currentPage);
        }
    });

    showPage(currentPage);

    <% if (msg != null) { %>
        showToast("<%= msg %>");
    <% } %>
</script>
</body>
</html>
