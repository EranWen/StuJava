<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@	page import="org.apache.http.util.EntityUtils"%>  
<%@	page import="org.apache.http.HttpEntity"%>  
<%@ page import="org.apache.http.Header"%>
<%@ page import="org.apache.http.entity.StringEntity"%>
<%@ page import="org.apache.http.HttpResponse"%>
<%@ page import="org.apache.http.client.HttpClient"%>
<%@ page import="org.apache.http.client.methods.HttpGet"%>
<%@ page import="org.apache.http.client.methods.HttpPost"%>
<%@ page import="org.apache.http.client.methods.HttpDelete"%>
<%@ page import="org.apache.http.client.methods.HttpPut"%>
<%@ page import="org.apache.http.impl.client.HttpClientBuilder"%>
<%@ page import="Allegion.Hadoop.*"%>
<%@ page import="org.json.*"%>
<%@ page import="java.util.Calendar"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
String Username = request.getParameter("username");
String Password = request.getParameter("password");
if(session.getAttribute("username")==null)
{

	try
	{
		if(Username==null)
		{
			response.sendRedirect("index.html");
		}
		if(Password==null)
		{
			response.sendRedirect("index.html");
		}
		if(Username.equals("admin")==false)
		{
			response.sendRedirect("index.html");
		}
		if(Password.equals("admin")==false)
		{
			response.sendRedirect("index.html");
		}
		session.setAttribute("username", Username);	
	}
	catch(Exception e)
	{
		out.print(e.toString());
		//response.sendRedirect("Index.html");
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
              <li class="active"><a href="index.jsp">存储</a></li>
              <li><a href="job.jsp">任务</a></li>
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
 <%
String RootPath="/";
String DefaultAction="LISTSTATUS";
String CurrentPath= request.getParameter("path");
String CurrentAction= request.getParameter("op");
String HDFSRestServerPath="http://10.192.165.170:8001/webhdfs/v1";
try
{
if(CurrentPath==null)
{
	CurrentPath=RootPath;
}
if(CurrentAction==null)
{
	CurrentAction=DefaultAction;
}
int cl = CurrentPath.length();
int al = CurrentAction.length();
if(cl==0)
{
	CurrentPath=RootPath;
}
if(al==0)
{
	CurrentAction = DefaultAction;
}
}catch(Exception e)
{
	out.print(e.toString());
}
if(CurrentAction.equals("LISTSTATUS"))
{
	//do nothing
}
HttpClient httpclient = HttpClientBuilder.create().build();
String ParentPath = CurrentPath;
int Pos = CurrentPath.lastIndexOf("/");
if(Pos==0)
{
	ParentPath = "/";
}
else
{
	ParentPath = CurrentPath.substring(0, Pos);
}
if(CurrentAction.equals("DELETE"))
{
	String PathUrl = HDFSRestServerPath+CurrentPath+"?user.name=hadoop&op=DELETE";
	HttpDelete httpdel = new HttpDelete(PathUrl);
	HttpResponse res = httpclient.execute(httpdel);  
 	HttpEntity entity = res.getEntity();
 	String resjson = EntityUtils.toString(entity);
 	CurrentPath = ParentPath;
 	out.print(resjson);
 	response.sendRedirect("index.jsp?path="+CurrentPath);
	
}
if(CurrentAction.equals("CREATE"))
{
	
	String FileName=request.getParameter("files[]");
	//String PathUrl = "http://10.192.165.170:8001/webhdfs/v1"+CurrentPath+"?user.name=hadoop&op=CREATE";
	//HttpGet httpget = new HttpGet(PathUrl);
	//HttpResponse res = httpclient.execute(httpget);  
 	//HttpEntity entity = res.getEntity();
 	//String resjson = EntityUtils.toString(entity);
 	//out.print(resjson);
 	System.out.println(FileName);
 	response.sendRedirect("index.jsp?path="+CurrentPath);
}
if(CurrentAction.equals("MKDIRS"))
{
	String FolderName=request.getParameter("foldername");
	String NewPath;
	if(FolderName==null)
	{
		response.sendRedirect("index.jsp?path="+CurrentPath);
	}
	else
	{
		if(CurrentPath.equals("/"))
	 	{
			NewPath="/"+FolderName;
	 	}
		else
		{
			NewPath = CurrentPath+"/"+FolderName;
		}
		String PathUrl = HDFSRestServerPath+NewPath+"?user.name=hadoop&op=MKDIRS";
		HttpPut httpput = new HttpPut(PathUrl);
		HttpResponse res = httpclient.execute(httpput);  
	 	HttpEntity entity = res.getEntity();
	 	String resjson = EntityUtils.toString(entity);
	 	response.sendRedirect("index.jsp?path="+CurrentPath);
	 	out.print(resjson);
	}	
}
if(CurrentAction.equals("TRANSCODE"))
{
	//获取一个新的application-id;
	System.out.println("http://localhost:"+request.getLocalPort()+"/TransCodeCloudService/Application.do?app=TransCode&jobName=TC001&input="+CurrentPath+"&output=/SplitVideo&format=h264");
	HttpPut hp = new HttpPut("http://"+request.getLocalAddr()+":"+request.getLocalPort()+"/Application.do?app=TransCode&jobName=TC001&input="+CurrentPath+"&output=/SplitVideo&format=h264");
	HttpResponse res = httpclient.execute(hp);  
	HttpEntity entity = res.getEntity();
	String resjson = EntityUtils.toString(entity);
	System.out.println(resjson);
	/*
	HttpPost hp = new HttpPost("http://10.192.165.170:8003/ws/v1/cluster/apps/new-application");
	HttpResponse res = httpclient.execute(hp);  
	HttpEntity entity = res.getEntity();
	String resjson = EntityUtils.toString(entity);
	System.out.println(resjson);
	JSONObject root = new JSONObject(resjson);
	String ApplicationID = root.getString("application-id");
	String Jobdir = ApplicationID.substring(11);
	Jobdir = "job"+Jobdir;
	String Last="job_1427450902421_0014";
	String PathUrl = HDFSRestServerPath+"/job/hadoop/.staging/"+Last+"?destination=/job/hadoop/.staging/"+Jobdir+"&op=RENAME";
	HttpPut httpput = new HttpPut(PathUrl);
	res = httpclient.execute(httpput);  
 	entity = res.getEntity();
 	resjson = EntityUtils.toString(entity);
	
	String PathUrl = HDFSRestServerPath+"/job/hadoop/.staging/"+Jobdir+"?user.name=hadoop&op=MKDIRS";
	HttpPut httpput = new HttpPut(PathUrl);
	res = httpclient.execute(httpput);  
 	entity = res.getEntity();
 	resjson = EntityUtils.toString(entity);
 	***********************
 	
	hp = new HttpPost("http://10.192.165.170:8003/ws/v1/cluster/apps");
	JSONObject jsonp = new JSONObject();
	jsonp.put("application-id", ApplicationID);
	jsonp.put("application-name","AVTransCode");
	jsonp.put("unmanaged-AM", false);
	jsonp.put("application-type","MAPREDUCE");
	jsonp.put("queue", "default");
	jsonp.put("max-app-attempts",2);//失败后尝试次数
	jsonp.put("keep-containers-across-application-attempts",false);
	JSONObject resource = new JSONObject();
	resource.put("memory", 2048);
	resource.put("vCores", 2);
	jsonp.put("resource",resource);
	JSONObject am_container_spec = new JSONObject();
	JSONObject local_resources = new JSONObject();
	JSONObject enviroment = new JSONObject();
	JSONObject commands = new JSONObject();
	JSONObject services_data = new JSONObject();
	JSONObject credentials = new JSONObject();
	JSONObject application_acls = new JSONObject();
	JSONArray entry_r = new JSONArray();
	for(int i=0;i<1;i++)
	{
		JSONObject keypair = new JSONObject();
		keypair.put("key","TransCodeMapReduce.jar");
		JSONObject value = new JSONObject();
		value.put("resource", "hdfs://10.192.165.170:9000/app/TransCode/TransCodeMapReduce.jar");
		value.put("type","FILE");
		value.put("visibility","APPLICATION");
		value.put("size",60831);
		long time = 142734593;
		time = time*10000;
		time = time+720;
		//time = 142734593*10000+720; //1427345930720;
		System.out.println(time);
		value.put("timestamp",time);
		keypair.put("value", value);
		entry_r.put(i, keypair);
	}
	local_resources.put("entry", entry_r);	
	JSONArray entry_e = new JSONArray();
	for(int i=0;i<1;i++)
	{
		JSONObject kv = new JSONObject();		
		if(i==0)
		{
			kv.put("key","CLASSPATH");
			//kv.put("value","{{CLASSPATH}}<CPS>./*<CPS>{{HADOOP_CONF_DIR}}<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/common/*<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/common/lib/*<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/mapreduce/*<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/mapreduce/lib/*<CPS>./log4j.properties");			
			kv.put("value","{{CLASSPATH}}<CPS>./*<CPS>{{HADOOP_CONF_DIR}}<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/common/*<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/common/lib/*<CPS>{{HADOOP_HDFS_HOME}}/share/hadoop/hdfs/*<CPS>{{HADOOP_HDFS_HOME}}/share/hadoop/hdfs/lib/*<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/mapreduce/*<CPS>{{HADOOP_COMMON_HOME}}/share/hadoop/mapreduce/lib/*<CPS>{{HADOOP_YARN_HOME}}/share/hadoop/yarn/*<CPS>{{HADOOP_YARN_HOME}}/share/hadoop/yarn/lib/*<CPS>./log4j.properties");			
		}
		if(i==1)
		{
			kv.put("key","DISTRIBUTEDSHELLSCRIPTTIMESTAMP");
			kv.put("value","1427345990720");
		}
		if(i==2)
		{
			kv.put("key","DISTRIBUTEDSHELLSCRIPTLEN");
			kv.put("value","6");
		}
		if(i==3)
		{
			kv.put("key","DISTRIBUTEDSHELLSCRIPTLOCATION");
			kv.put("value","hdfs://10.192.165.170:9000/app/TransCode/");			
		}
		entry_e.put(i, kv);
	}
	enviroment.put("entry",entry_e);
	//commands.put("command","{{JAVA_HOME}}/bin/java -Xmx1024m org.apache.hadoop.util.RunJar TransCodeMapReduce.jar hdfs://10.192.165.170:9000"+CurrentPath);
	commands.put("command","{{JAVA_HOME}}/bin/java -Dlog4j.configuration=container-log4j.properties -Dyarn.app.container.log.dir=<LOG_DIR> -Dyarn.app.container.log.filesize=0 -Dhadoop.root.logger=INFO,CLA  -Xmx1024m org.apache.hadoop.mapreduce.v2.app.MRAppMaster "+CurrentPath+" 1><LOG_DIR>/AVTransCode.stdout 2><LOG_DIR>/AVTransCode.stderr");
	//commands.put("command","{{JAVA_HOME}}/bin/java -Xmx1024m Allegion.Hadoop.SplitVideoFile.SplitVideoFileMapReduce hdfs://10.192.165.170:9000"+CurrentPath+"   1><LOG_DIR>/AVTransCode.stdout 2><LOG_DIR>/AVTransCode.stderr");
	am_container_spec.put("local-resources",local_resources);
	am_container_spec.put("environment",enviroment);
	am_container_spec.put("commands",commands);
	jsonp.put("am-container-spec",am_container_spec);
	System.out.println(jsonp.toString());
	StringEntity post_entity = new StringEntity(jsonp.toString(),"utf-8");
	post_entity.setContentEncoding("UTF-8");
	post_entity.setContentType("application/json");
	hp.setEntity(post_entity);
	res = httpclient.execute(hp);
	entity = res.getEntity();
	resjson = EntityUtils.toString(entity);
	System.out.println(resjson);
	response.sendRedirect("job.jsp");
	*/
}
%>   

<div class="jumbotron">
<div class="row">
<div class="col-lg-1">
</div>
<div class="col-lg-6">
<h1>安朗杰云服务文件系统</h1>
</div>
<div class="col-lg-5">
</div>
</div>
</div>

<div id="pad-wrapper" class="users-list">
<div class="row">
<div class="col-lg-1">
</div>
<div class="col-lg-6">
<span class="btn btn-success fileinput-button">
<i class="glyphicon glyphicon-plus"></i>
<span>添加文件</span>
<input id="addfile" type="file" name="addfiles" multiple>
</span>
<button id ="startupload" type="button" class="btn btn-primary start">
<i class="glyphicon glyphicon-upload"></i>
<span>开始上传</span>
</button>
<button type="button" class="btn btn-warning cancel" id="cancleupload">
<i class="glyphicon glyphicon-ban-circle"></i>
<span>取消上传</span>
</button>
<script>
$('#addfile').on('change',function(){
	var fileslist = $('input[name="addfiles"]').prop('files');//
	if(fileslist.length>0)
	{
		//alert(fileslist[0].name);
		//$('#preuploadtable')。width(500);
		//alert($("#addfile").val());
		for(var i=0;i<fileslist.length;i++)
		{			
			$('#preuploadtable').append("<a href=\"#\" class=\"list-group-item\"><img src=\"images/file32.png \" />&nbsp;&nbsp;&nbsp;&nbsp;"+fileslist[i].name+" </a>")
		}
	}
});
$('#startupload').on('click',function(){
	var fileslist = $('input[name="addfiles"]').prop('files');//
	if(fileslist.length>0)
	{
		//var xhr = new XMLHttpRequest();
		for(var i=0;i<fileslist.length;i++)
		{			
			//在这里循环上传文件
			var current_path = '<%=HDFSRestServerPath%><%=CurrentPath%>';
			var param= '?user.name=hadoop&op=CREATE';
			var first_step_url=current_path+fileslist[0].name+param;
			alert(first_step_url);
			$.ajax({
				type:'PUT',
				data:{},
				url:'http://10.192.165.170:8001/webhdfs/v1/tmp/001.txt?user.name=hadoop&op=CREATE',
			 	success:function(data){
			 		alert(data);
			 	},
				error:function(xhr,msg,err)
				{
					alert(xhr.status);
                    alert(xhr.readyState);
                    alert(msg);

				}
			})			
		}
	}
});
$('#cancleupload').on('click',function(){
	$('#preuploadtable').empty();
	$('#addfiles').reset();
});
</script>
<button id="addfolder" type="button" class="btn btn-success start" data-toggle="modal" data-target="#AddFolder">
<i class="glyphicon glyphicon-plus"></i>
<span>新建文件夹</span>
</button>
<p>
</div>
<div class="col-lg-5">
</div>
</div>
<div class="row">
<div class="col-lg-1">
</div>
<div class="col-lg-7">
     <div class="list-group" id="preuploadtable"></div>
</div>
<div class="col-lg-4">
</div>
</div>
<div class="row-fluid table">
<div class="col-lg-1">
</div>
<div class="col-lg-10">
       <table class="table table-hover">
           <thead>
               <tr>
                   <th class="span4 sortable">
                       <span class="line"></span>名称
                   </th>
                   <th class="span3 sortable">
                       <span class="line"></span>块大小
                   </th>
                   <th class="span2 sortable">
                       <span class="line"></span>文件大小
                   </th>
                   <th class="span3 sortable">
                       <span class="line"></span>所有者
                   </th>
                   <th class="span3 sortable">
                       <span class="line"></span>操作
                   </th>
               </tr>
           </thead>
           <tbody>

<%
 try
 {
	
	String PathUrl = HDFSRestServerPath+CurrentPath+"?user.name=hadoop&op=LISTSTATUS";
 	HttpGet httpget = new HttpGet(PathUrl);
 	HttpResponse res = httpclient.execute(httpget);  
 	HttpEntity entity = res.getEntity();
 	String resjson = EntityUtils.toString(entity);
 	//out.print(resjson);
 	JSONObject	 root = new JSONObject(resjson);
 	JSONObject fss = root.getJSONObject("FileStatuses");
 	JSONArray fs = fss.getJSONArray("FileStatus");
 	
	//out.print("当前目录"+CurrentPath);
	//out.print("当前父目录"+ParentPath);
 	if(CurrentPath.equals("/"))
 	{
 	}
 	else
 	{
 		out.print("<tr><td><a href=\"index.jsp?path="+ParentPath+"\"><img src=\"images/folder32.png \" />&nbsp;&nbsp;&nbsp;&nbsp;..</a></td><td>--</td><td>--</td><td>--</td><td>--</td></tr>");
 	}
 	
 	for(int i=0;i<fs.length();i++)
 	{
 		out.print(" <tr><td>");
 		if(fs.getJSONObject(i).getString("type").equals("DIRECTORY"))
 		{
 			out.print("<img src=\"images/folder32.png \" />&nbsp;&nbsp;&nbsp;&nbsp;");
 			if(CurrentPath.equals("/"))
 			{
 				out.print("<a href=\"index.jsp?path=/"+fs.getJSONObject(i).getString("pathSuffix")+"\">");
 			}
 			else
 			{
 				out.print("<a href=\"index.jsp?path="+CurrentPath+"/"+fs.getJSONObject(i).getString("pathSuffix")+"\">");
 			} 			
 			out.print(fs.getJSONObject(i).getString("pathSuffix"));
 			out.print("</a>");
 		}
 		else
 		{	
 			out.print("<img src=\"images/file32.png \" />&nbsp;&nbsp;&nbsp;&nbsp;");
 			out.print(fs.getJSONObject(i).getString("pathSuffix"));
 		}
 		out.print("</td><td>");
 		out.print(fs.getJSONObject(i).getInt("blockSize"));
 		out.print("</td><td>");
 		out.print(fs.getJSONObject(i).getInt("length")/1024/1024+" MB");
 		out.print("</td><td>");
 		out.print(fs.getJSONObject(i).getString("owner"));
 	 	out.print("</td><td>");
 	 	if(CurrentPath.equals("/"))
 	 	{
 	 		out.print("<a href=\"index.jsp?op=RENAME&path=/"+fs.getJSONObject(i).getString("pathSuffix")+"\">重命名</a>&nbsp;&nbsp;");
 	 		if(fs.getJSONObject(i).getString("type").equals("DIRECTORY"))
 	 		{
 	 			
 	 		}
 	 		else
 	 		{
 	 			out.print("<a href=\"index.jsp?op=OPEN&path=/"+fs.getJSONObject(i).getString("pathSuffix")+"\">下载</a>&nbsp;&nbsp;");
 	 			out.print("<a href=\"index.jsp?op=TRANSCODE&path=/"+fs.getJSONObject(i).getString("pathSuffix")+"\">转码</a>&nbsp;&nbsp;");
 	 		}
 	 		out.print("<a href=\"index.jsp?op=DELETE&path=/"+fs.getJSONObject(i).getString("pathSuffix")+"\">删除</a>&nbsp;&nbsp;");
 	 		
 	 	}
 	 	else
 	 	{
 	 		out.print("<a href=\"index.jsp?op=RENAME&path="+CurrentPath+"/"+fs.getJSONObject(i).getString("pathSuffix")+"\">重命名</a>&nbsp;&nbsp;");
 	 		if(fs.getJSONObject(i).getString("type").equals("DIRECTORY"))
 	 		{
 	 			
 	 		}
 	 		else
 	 		{
 	 			out.print("<a href=\"index.jsp?op=OPEN&path="+CurrentPath+"/"+fs.getJSONObject(i).getString("pathSuffix")+"\">下载</a>&nbsp;&nbsp;");
 	 			out.print("<a href=\"index.jsp?op=TRANSCODE&path="+CurrentPath+"/"+fs.getJSONObject(i).getString("pathSuffix")+"\">转码</a>&nbsp;&nbsp;");
 	 		}
 			out.print("<a href=\"index.jsp?op=DELETE&path="+CurrentPath+"/"+fs.getJSONObject(i).getString("pathSuffix")+"\">删除</a>&nbsp;&nbsp;");
 			
 	 	}
 	 	out.print("</td></tr>");
 	}
 }catch(Exception e)
 {
 	out.print(e.toString());
 }
 %>          
          
   	 		 </tbody>
		</table>
		</div>
		<div class="col-lg-1">
		</div>
	</div>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="AddFolder" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
   <div class="modal-dialog">
      <div class="modal-content">
         <div class="modal-header">
            <button type="button" class="close"     data-dismiss="modal" aria-hidden="true">
                  &times;
            </button>
            <h4 class="modal-title" id="myModalLabel">请填写新建文件夹名称     </h4>
         </div>
         <form  action="index.jsp?op=MKDIRS&path=<%=CurrentPath%>" method="post">
         <div class="modal-body">
            <input type="text" name="foldername" class="form-control" placeholder="新建文件夹名称" required autofocus>
         </div>
         <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">关闭   </button>
            <button type=submit class="btn btn-primary">新建 </button>
         </div>
         </form>
      </div><!-- /.modal-content -->
</div><!-- /.modal --> 
</div>
</body>
</html>