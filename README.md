# Student Course Management System (SCMS)

A full-featured web-based application that allows admins to manage courses and students to enroll in them. Built using **Java (JSP/Servlets)**, **JDBC**, and **Oracle Database**.

---

## 🚀 Features

### 🛡️ Admin Panel:
- Admin login/logout functionality
- Add, edit, delete courses
- View all enrolled students
- View course enrollment statistics
- Secure session handling

### 🎓 Student Panel:
- Student login/logout
- Enroll in available courses
- View own enrolled courses
- Simple and user-friendly interface

### ✨ Bonus:
- Live toast messages
- Custom chatbot (mini assistant)
- Confirmation modals before delete
- Pagination and search
- Attractive UI with Bootstrap 5

---

## 🛠️ Tech Stack

| Layer          | Technology                  |
|----------------|------------------------------|
| Frontend       | HTML, CSS, JavaScript, Bootstrap |
| Backend        | Java Servlets, JSP           |
| Database       | Oracle SQL (JDBC Connectivity) |
| Server         | Apache Tomcat                |
| Version Control| Git, GitHub                  |

---

## 📁 Project Structure

StudentCourseManagenet/
├── src/
│ └── main/
│ ├── java/
│ │ └── scm.pack/
│ │ ├── AdminBean.java
│ │ ├── AdminLogoutServlet.java
│ │ ├── Dbcon.java
│ │ ├── LoginServlet.java
│ │ └── LogoutServlet.java
│ └── webapp/
│ ├── META-INF/
│ ├── WEB-INF/
│ ├── index.html
│ ├── admin_login.html
│ ├── student_login.html
│ ├── admin_home.jsp
│ ├── student_home.jsp
│ ├── add_course.jsp
│ ├── add_student.jsp
│ ├── delete_course.jsp
│ ├── delete_enrollment.jsp
│ ├── delete_student.jsp
│ ├── edit_course.jsp
│ ├── edit_student.jsp
│ ├── enroll_student.jsp
│ ├── manage_courses.jsp
│ ├── manage_enrollments.jsp
│ ├── manage_students.jsp
│ ├── student_profile.jsp
│ ├── update_student.jsp
│ └── view_my_courses.jsp
