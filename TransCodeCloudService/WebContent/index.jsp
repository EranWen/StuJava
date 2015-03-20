<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Cloud TransCode</title>
</head>
<body>
<%

String Username = request.getParameter("username");
String Password = request.getParameter("password");
Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;
request.setCharacterEncoding("GBK");
try{
Class.forName("oracle.jdbc.driver.OracleDriver");
}
catch(ClassNotFoundException ce){
out.println(ce.getMessage());
}
try{
	    String url="jdbc:oracle:thin:@10.192.165.180:1521:vrs";
	    conn=DriverManager.getConnection(url,"kkyw","kkyw$");
	    if(session.getAttribute("username")==null)
	    {
		    String SearchUser="SELECT YHMM FROM KKYW.T_YHXX where YHZH='"+Username+"'";
		    stmt=conn.prepareStatement(SearchUser);
		    rs=stmt.executeQuery();
			if(rs.next()==false)
			{
				response.sendRedirect("Index.html");
			}
			if(rs.getString(1).equals(Password)==false)
			{
				response.sendRedirect("Index.html");
			}
			session.setAttribute("username", Username);
	    }
		
		stmt=conn.prepareStatement("SELECT * FROM KKYW.T_YHXX");    
		rs=stmt.executeQuery();
		out.print("Hello "+session.getAttribute("username").toString());
		out.print("<TABLE BORDER='1' width='55%' cellpadding='3' align=center>");
		out.print("<TR><TD>"+"<b>Empno</b>"+"</TD>");
		out.print("<TD>"+"<b>Ename</b>"+"</TD>");
		out.print("<TD>"+"<b>Job</b>"+"</TD>");
		out.print("<TD>"+"<b>Mgr</b>"+"</TD>");
		out.print("<TD>"+"<b>hiredate</b>"+"</TD>");
		out.print("<TD align=center>"+"<b>Sal</b>"+"</TD>");
		out.print("<TD>"+"<b>Comm</b>"+"</TD>");
		out.print("<TD>"+"<b>Deptno</b>"+"</TD></TR>");
		
		
		while(rs.next()){
		out.print("<TR><TD>"+rs.getString(1)+"</TD>");
		out.print("<TD>"+rs.getString(2)+"</TD>");
		out.print("<TD >"+rs.getString(3)+"</TD>");
		out.print("<TD>"+rs.getString(4)+"</TD>");
		out.print("<TD>"+rs.getString(1)+"</TD>");
		out.print("<TD>"+rs.getString(2)+"</TD>");
		out.print("<TD>"+rs.getString(3)+"</TD>");
		out.print("<TD>"+rs.getString(4)+"</TD></TR>");
		}
		out.print("</TABLE>");
		    
		rs.close();
		stmt.close();
		conn.close();
	}
	catch(Exception e){
	System.out.println(e.getMessage());
	}


%>
</body>
</html>