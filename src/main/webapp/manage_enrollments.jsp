<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("admin_login.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Enrollments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        /* Simple Chatbot Box */
        #chatBot {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 300px;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            display: none;
            z-index: 999;
        }

        #chatBotHeader {
            background-color: #0d6efd;
            color: #fff;
            padding: 10px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }

        #chatBotBody {
            height: 250px;
            overflow-y: auto;
            padding: 10px;
        }

        #chatInput {
            border: none;
            border-top: 1px solid #ddd;
            padding: 10px;
            width: 100%;
        }
    </style>
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">Student Enrollments</h2>

    <!-- 🔍 Search Filter -->
    <div class="mb-3">
        <input type="text" id="searchInput" class="form-control" placeholder="Search student or course...">
    </div>

    <table class="table table-bordered bg-white shadow-sm">
        <thead class="table-warning">
            <tr>
                <th>Enrollment ID</th>
                <th>Student Name</th>
                <th>Course Title</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody id="enrollmentTable">
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");

                    String sql = "SELECT e.id AS eid, s.name AS sname, c.title AS ctitle " +
                                 "FROM enrollments e " +
                                 "JOIN students s ON e.student_id = s.id " +
                                 "JOIN courses c ON e.course_id = c.id";

                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("eid") %></td>
                <td><%= rs.getString("sname") %></td>
                <td><%= rs.getString("ctitle") %></td>
                <td>
                    <form action="delete_enrollment.jsp" method="post" onsubmit="return confirm('Delete this enrollment?')">
                        <input type="hidden" name="enrollment_id" value="<%= rs.getInt("eid") %>">
                        <button class="btn btn-sm btn-danger">Delete</button>
                    </form>
                </td>
            </tr>
            <% 
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                }
            %>
        </tbody>
    </table>

    <!-- ✅ Toast for Load -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="pageToast" class="toast text-white bg-success" role="alert">
            <div class="d-flex">
                <div class="toast-body">Enrollments Loaded Successfully!</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <hr>
    <h4 class="mt-5">Assign Course to Student</h4>
    <form action="enroll_student.jsp" method="post" class="row g-3 bg-white p-4 shadow-sm rounded" onsubmit="return confirmEnroll()">
        <div class="col-md-6">
            <label class="form-label">Select Student</label>
            <select name="student_id" class="form-select" required>
                <%
                    Connection con1 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");
                    Statement stmt1 = con1.createStatement();
                    ResultSet rs1 = stmt1.executeQuery("SELECT id, name FROM students");
                    while (rs1.next()) {
                %>
                <option value="<%= rs1.getInt("id") %>"><%= rs1.getString("name") %></option>
                <% } con1.close(); %>
            </select>
        </div>

        <div class="col-md-6">
            <label class="form-label">Select Course</label>
            <select name="course_id" class="form-select" required>
                <%
                    Connection con2 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "TIGER");
                    Statement stmt2 = con2.createStatement();
                    ResultSet rs2 = stmt2.executeQuery("SELECT id, title FROM courses");
                    while (rs2.next()) {
                %>
                <option value="<%= rs2.getInt("id") %>"><%= rs2.getString("title") %></option>
                <% } con2.close(); %>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Enroll Student</button>
            <a href="admin_home.jsp" class="btn btn-secondary ms-2">Back to Dashboard</a>
        </div>
    </form>
</div>

<!-- ✅ ChatBot -->
<div id="chatBot">
    <div id="chatBotHeader">💬 Help Chat</div>
    <div id="chatBotBody">
        <div><strong>Bot:</strong> Hello! How can I assist you?</div>
    </div>
    <input type="text" id="chatInput" placeholder="Type your message...">
</div>
<button class="btn btn-info position-fixed bottom-0 end-0 m-4" onclick="toggleChat()">💬 Chat</button>

<script>
    document.getElementById("searchInput").addEventListener("keyup", function () {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll("#enrollmentTable tr");

        rows.forEach(row => {
            const student = row.cells[1].textContent.toLowerCase();
            const course = row.cells[2].textContent.toLowerCase();
            row.style.display = (student.includes(filter) || course.includes(filter)) ? "" : "none";
        });
    });

    function confirmEnroll() {
        return confirm("Are you sure you want to enroll this student?");
    }

    window.onload = function () {
        const toast = new bootstrap.Toast(document.getElementById('pageToast'));
        toast.show();
    };

    // ✅ Toggle Chat
    function toggleChat() {
        const chat = document.getElementById('chatBot');
        chat.style.display = chat.style.display === "none" ? "block" : "none";
    }

    // ✅ Basic Chat Handling
    document.getElementById("chatInput").addEventListener("keypress", function(e) {
        if (e.key === "Enter") {
            const input = this.value.trim();
            if (!input) return;

            const chatBody = document.getElementById("chatBotBody");
            chatBody.innerHTML += `<div><strong>You:</strong> ${input}</div>`;

            // Very basic responses
            let reply = "Sorry, I didn't get that.";
            if (input.toLowerCase().includes("enroll")) reply = "You can enroll using the form above.";
            else if (input.toLowerCase().includes("delete")) reply = "Click the delete button next to an enrollment.";
            else if (input.toLowerCase().includes("logout")) reply = "Click the back to dashboard and logout there.";

            chatBody.innerHTML += `<div><strong>Bot:</strong> ${reply}</div>`;
            this.value = "";
            chatBody.scrollTop = chatBody.scrollHeight;
        }
    });
</script>
</body>
</html>
