<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@	page import="org.apache.http.util.EntityUtils"%>  
<%@	page import="org.apache.http.HttpEntity"%>  
<%@ page import="org.apache.http.Header"%>
<%@ page import="org.apache.http.HttpResponse"%>
<%@ page import="org.apache.http.client.HttpClient"%>
<%@ page import="org.apache.http.client.methods.HttpGet"%>
<%@ page import="org.apache.http.client.methods.HttpDelete"%>
<%@ page import="org.apache.http.client.methods.HttpPut"%>
<%@ page import="org.apache.http.impl.client.HttpClientBuilder"%>
<%@ page import="org.json.*"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Bootstrap -->
<link href="bootstrat/css/bootstrap.min.css" rel="stylesheet">
<link href="bootstrat/css/bootstrap-theme.css" rel="stylesheet">
<link href="css/jquery.fileupload.css" rel="stylesheet">
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="bootstrat/js/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="bootstrat/js/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>安朗杰云服务平台</title>
</head>
<body>
<%
if(session.getAttribute("username")==null)
{
	try
	{
		response.sendRedirect("index.html");
	}
	catch(Exception e)
	{
		out.print(e.toString());
		response.sendRedirect("index.html");
	}
}
%>
    <!-- navbar -->
    
    <nav class="navbar navbar-inverse navbar-static-top navbar-fixed-top">
        <div class="container-fluid">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="index.jsp">安朗杰云服务平台</a>
          </div>            
          <div id="navbar" class="navbar-collapse collapse">
          	<ul class="nav navbar-nav">
              <li><a href="index.jsp">存储</a></li>
              <li class="active"><a href="job.jsp">任务</a></li>
              <li><a href="rm.jsp">详细</a></li>
              </ul>
            <ul class="nav navbar-nav navbar-right">
              <li><a href="#" role="button"><%=session.getAttribute("username")%><b class="caret"></b></a></li>
              <li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
            </ul>
          </div><!--/.nav-collapse -->
        </div><!--/.container-fluid -->
      </nav>
    <!-- end navbar -->
  
<div class="jumbotron">
<div class="row">
<div class="col-lg-1">
</div>
<div class="col-lg-6">
<h1>安朗杰云服务任务系统</h1>
</div>
<div class="col-lg-5">
</div>
</div>
</div>
<div class="container-fluid"> 
<div class="row-fluid table">
<div class="col-lg-1">
</div>
<div class="col-lg-10">
       <table class="table table-hover">
       	<caption><h3>当前任务进度信息</h3></caption>
           <thead>
               <tr>
                   <th class="span2">
                       <span class="line"></span>任务编号</th>
                   <th class="span1 sortable">
                       <span class="line"></span>用户&nbsp;&nbsp;&nbsp; </th>
                   <th class="span1 sortable">
                       <span class="line"></span>任务名称 </th>
                   <th class="span1 sortable">
                       <span class="line"></span>程序类型</th>
                   <th class="span1 sortable">
                       <span class="line"></span>状态&nbsp;&nbsp;&nbsp;</th>
                   <th class="span1 sortable">
                       <span class="line"></span>结束状态</th>
                   <th class="span2 sortable">
                       <span class="line"></span>开始时间</th>
                   <th class="span2 sortable">
                       <span class="line"></span>结束时间</th>
                   <th class="span5 sortable">
                       <span class="line"></span>进度&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>  
               </tr>
           </thead>
           <tbody> 
           <%
HttpClient httpclient = HttpClientBuilder.create().build();
HttpGet hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/apps");
HttpResponse res = httpclient.execute(hg);  
HttpEntity entity = res.getEntity();
String resjson = EntityUtils.toString(entity);
//out.print(resjson);
JSONObject	 root = new JSONObject(resjson);
JSONObject apps = root.getJSONObject("apps");
JSONArray app = apps.getJSONArray("app");

for(int i=0;i<app.length();i++)
{
out.print("<tr><td>");
out.print(app.getJSONObject(i).getString("id"));
out.print("</td><td>");
out.print(app.getJSONObject(i).getString("user"));
out.print("</td><td>");
out.print(app.getJSONObject(i).getString("name"));
out.print("</td><td>");
out.print(app.getJSONObject(i).getString("applicationType"));
out.print("</td><td>");
out.print(app.getJSONObject(i).getString("state"));
out.print("</td><td>");
out.print(app.getJSONObject(i).getString("finalStatus"));
out.print("</td><td>");
Calendar cal = Calendar.getInstance();
cal.setTimeInMillis(app.getJSONObject(i).getLong("startedTime"));
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
out.print(sdf.format(cal.getTime()));
out.print("</td><td>");
cal.setTimeInMillis(app.getJSONObject(i).getLong("finishedTime"));
out.print(sdf.format(cal.getTime()));
out.print("</td><td>");
out.print("<div class=\"progress\">");
out.print("<div class=\"progress-bar progress-bar-striped\" role=\"progressbar\" aria-valuenow=\"60\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: "+app.getJSONObject(i).getInt("progress")+"%\"></div>");
out.print("</div>");
out.print("</td></tr>");
}
           %>          
           </tbody>
      </table>
      </div>
	<div class="col-lg-1">
	</div>
</div>
</div>
</body>
</html>