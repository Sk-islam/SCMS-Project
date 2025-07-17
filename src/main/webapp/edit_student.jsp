<%
String id = request.getParameter("id");
String name = request.getParameter("name");
String email = request.getParameter("email");
%>

<form action="update_student.jsp" method="post" style="margin: 30px;">
    <input type="hidden" name="id" value="<%= id %>" />
    Name: <input type="text" name="name" value="<%= name %>" required />
    Email: <input type="email" name="email" value="<%= email %>" required />
    <button type="submit">Update</button>
</form>
