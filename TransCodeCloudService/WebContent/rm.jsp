<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@	page import="org.apache.http.util.EntityUtils"%>  
<%@	page import="org.apache.http.HttpEntity"%>  
<%@ page import="org.apache.http.Header"%>
<%@ page import="org.apache.http.HttpResponse"%>
<%@ page import="org.apache.http.client.HttpClient"%>
<%@ page import="org.apache.http.client.methods.HttpGet"%>
<%@ page import="org.apache.http.client.methods.HttpPost"%>
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
    
    <nav class="navbar navbar-inverse navbar-fixed-top">
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
              <li><a href="job.jsp">任务</a></li>
              <li class="active"><a href="rm.jsp">详细</a></li>
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
<h1>安朗杰云服务系统信息</h1>
</div>
<div class="col-lg-5">
</div>
</div>
</div>
<div class="container-fluid">
<div class="row table">
<div class="col-lg-1">
</div>
<div class="col-lg-10">
       <table class="table table-hover">
           <thead>
               <tr>
                   <th class="span4 sortable">
                       <span class="line"></span>属性名称
                   </th>
                   <th class="span3 sortable">
                       <span class="line"></span>属性值
                   </th>
               </tr>
           </thead>
           <tbody>
           <%

HttpClient httpclient = HttpClientBuilder.create().build();
HttpGet	hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/info");
HttpResponse res = httpclient.execute(hg);  
HttpEntity entity = res.getEntity();
String resjson = EntityUtils.toString(entity);
//out.print(resjson);
JSONObject	 root = new JSONObject(resjson);
JSONObject ci = root.getJSONObject("clusterInfo");
out.print("<tr><td>HADOOP版本</td><td>");
out.print(ci.getString("hadoopVersion"));
out.print("</td></tr>");
out.print("<tr><td>HADOOP状态</td><td>");
out.print(ci.getString("state"));
out.print("</td></tr>");
out.print("<tr><td>HADOOP启动时间</td><td>");
Calendar cal = Calendar.getInstance();
cal.setTimeInMillis(ci.getLong("startedOn"));
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
out.print(sdf.format(cal.getTime()));
out.print("</td></tr>");
out.print("<tr><td>RM版本</td><td>");
out.print(ci.getString("resourceManagerVersion"));
out.print("</td></tr>");
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/metrics");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);
JSONObject cm = root.getJSONObject("clusterMetrics");
out.print("</td></tr>");

out.print("<tr><td>内存总数</td><td>");
out.print(cm.getInt("totalMB")+" MB");
out.print("</td></tr>");
out.print("<tr><td>虚拟CPU</td><td>");
out.print(cm.getInt("totalVirtualCores"));
out.print("</td></tr>");
out.print("<tr><td>节点总数</td><td>");
out.print(cm.getInt("totalNodes"));
out.print("</td></tr>");
out.print("<tr><td>节点丢失</td><td>");
out.print(cm.getInt("lostNodes"));
out.print("</td></tr>");
out.print("<tr><td>活动节点</td><td>");
out.print(cm.getInt("activeNodes"));
out.print("</td></tr>");
out.print("<tr><td>已提交任务</td><td>");
out.print(cm.getInt("appsSubmitted"));
out.print("</td></tr>");
out.print("<tr><td>已完成任务</td><td>");
out.print(cm.getInt("appsCompleted"));
out.print("</td></tr>");
out.print("<tr><td>正在运行的任务</td><td>");
out.print(cm.getInt("appsRunning"));
out.print("</td></tr>");
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/scheduler");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);
//JSONObject cm = root.getJSONObject("clusterMetrics");
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/apps");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/appstatistics");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/apps/application_1425610763065_0001");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/apps/application_1425610763065_0001/appattempts");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/nodes");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);
hg = new HttpGet("http://10.192.165.170:8003/ws/v1/cluster/nodes/hadoopdn8:51403");
res = httpclient.execute(hg);  
entity = res.getEntity();
resjson = EntityUtils.toString(entity);
//out.print(resjson);
root = new JSONObject(resjson);

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