<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@page import="java.sql.*"%>
<%
    Connection conn = null;
    try{
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        conn = DriverManager.getConnection("jdbc:mysql://localhost/yabe","yabe","yabe");
    }

    catch(Exception e){
        out.print("<p>Could not connect to SQL server.</p>");
        e.printStackTrace();
    }
  
    String name = request.getParameter("name");
    int age;
    if (request.getParameter("age") != null) {
        age = Integer.parseInt(request.getParameter("age").trim());
    } else {
        age = 0;
    }
    String address = request.getParameter("address");
    String password = request.getParameter("password");
    String username = request.getParameter("username");
    String password_hash = BCrypt.hashpw(password,BCrypt.gensalt());
    if(name != null && age >= 13 && address != null && password != null){
        Statement stmt = conn.createStatement();
        String ins_query = "UPDATE users (username, password_hash, age, name, address) VALUES (\'" + username + "\', \'" + password_hash + "\', \'" + age + "\', \'" + name + "\', \'" + address + "\')";
        int res = stmt.executeUpdate(ins_query);
    
        if (res < 1) {
            session.setAttribute("alert","Update failed.");
            session.setAttribute("alert_type","danger");
            %><%@ include file="register.jsp" %><%
        } else {
            session.setAttribute("alert","Update successful.");
            session.setAttribute("alert_type","success");
            %><%@ include file="login.jsp" %><%
        }
    } else {
            session.setAttribute("alert","Invalid user information fields. Please review your information and try again.");
            session.setAttribute("alert_type","danger");
            %><%@ include file="register.jsp" %><%
    }
%>