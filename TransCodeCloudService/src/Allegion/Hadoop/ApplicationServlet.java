package Allegion.Hadoop;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.RunningJob;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.yarn.client.api.YarnClient;
import org.apache.http.util.EntityUtils;
import org.apache.http.HttpEntity;
import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.client.methods.HttpPut;
import Allegion.Hadoop.SplitVideoFile.*;
/**
 * Servlet implementation class Application
 */
@WebServlet("/Application")
public class ApplicationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private HttpClient httpclient ;
    private String 	HdfsRootUrl;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApplicationServlet() {
        super();
        // TODO Auto-generated constructor stub
        httpclient = HttpClientBuilder.create().build();
        HdfsRootUrl = "http://10.192.165.170:8001/webhdfs/v1";
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("Have a Get Request");
		String app = request.getParameter("app");
		if(app.equals("TransCode"))
		{
			String hdfsUrl = "hdfs://10.192.165.170:9000";//request.getParameter("hdfsUrl");
			String jobName = request.getParameter("jobName");
			String input = request.getParameter("input");
			String output = request.getParameter("output");
			String format = request.getParameter("format");
			SubAppTransCode(hdfsUrl,jobName,input,output,format);
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
	/**
	 * @see HttpServlet#doPut(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("Have a Put Request");
		String app = request.getParameter("app");
		if(app.equals("TransCode"))
		{
			String hdfsUrl = request.getParameter("hdfsUrl");
			String jobName = request.getParameter("jobName");
			String input = request.getParameter("input");
			String output = request.getParameter("output");
			String format = request.getParameter("format");
			SubAppTransCode(hdfsUrl,jobName,input,output,format);
		}
	}
	
	 protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {  
         response.setContentType("text/html;charset=UTF-8");  
         PrintWriter out = response.getWriter();  
         try {  
             response.setContentType("text/html");  
             response.setHeader("Cache-Control", "no-store");  
             response.setHeader("Pragma", "no-cache");  
             response.setDateHeader("Expires", 0);  
             String name = request.getParameter("op");  
             if(name.equals("CREATE")) {  
                 out.write("OK");  
             }  
             else {  
                 out.write("NO");  
             }  
         } finally {   
             out.close();  
         } 
     } 
	 protected String SubAppTransCode(String hdfsUrl,String jobName,String input,String output,String format)throws IOException
	 {
		 Configuration hdfsconf = new Configuration();
		 hdfsconf.set("fs.defaultFS", hdfsUrl);
		 FileSystem hdfs = FileSystem.get(hdfsconf);
		 Path outpath = new Path(output);
		 //清空，并删除输入目录
		 if(hdfs.exists(outpath))
		 {
			 hdfs.delete(outpath,true);
			 System.out.println("删除目录"+outpath);
		 }
		 JobConf job = new JobConf();
		 job.setJobName(jobName);
		 job.setJarByClass(SplitVideoFileMapReduce.class);
		 job.setInputFormat(SplitVideoFileInputFormat.class);
		 job.setOutputFormat(SplitVideoFileOutputFormat.class);
		 job.setOutputKeyClass(LongWritable.class);
		 job.setOutputValueClass(Text.class);
		 job.setMapperClass(SplitVideoFileMapReduce.SplitTransMap.class);
		 job.setReducerClass(SplitVideoFileMapReduce.SplitTransReduce.class);
		//job.setCombinerClass(LocalTaskReduce.class); // 本质是一个本地reducer 设计初衷是本地将需要reduce操作的数据进行合并
		 job.set("mapred.jar", "/home/hadoop/tools/TransCode/TransCodeMapReduce.jar");
		 job.set("mapreduce.splitvideofile.input", input);
		 job.set("mapreduce.splitvideofile.midPath",output);
		 job.set("yarn.resourcemanager.address", "10.192.165.170:8030");
		 job.set("yarn.resourcemanager.scheduler.address","10.192.165.170:8031");
		 job.set("yarn.resourcemanager.resource-tracker.address","10.192.165.170:8032");
		 job.set("yarn.rescourcemanger.admin.address", "10.192.165.170.8033");
		 job.set("mapreduce.framework.name", "yarn");
		 job.set("fs.default.name",hdfsUrl);
		 /*
		 job.set("yarn.application.classpath", "$HADOOP_CONF_DIR,"  
				+"$HADOOP_COMMON_HOME/share/hadoop/common/*,$HADOOP_COMMON_HOME/share/hadoop/common/lib/*,"  
				+"$HADOOP_HDFS_HOME/share/hadoop/hdfs/*,$HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/*,"  
				+"$HADOOP_MAPARED_HOME/share/hadoop/mapreduce/*,$HADOOP_MAPARED_HOME/share/hadoop/mapreduce/lib/*,"  
				+"$YARN_HOME/share/hadoop/yarn/*,$YARN_HOME/share/hadoop/yarn/lib/*");
		*/
		 job.set("yarn.application.classpath", "./*,/cloud/conf/hadoop/etc/hadoop,"  
					+"/cloud/service/hadoop/share/hadoop/common/*,/cloud/service/hadoop/share/hadoop/common/lib/*,"  
					+"/cloud/service/hadoop/share/hadoop/hdfs/*,/cloud/service/hadoop/share/hadoop/hdfs/lib/*,"  
					+"/cloud/service/hadoop/share/hadoop/mapreduce/*,/cloud/service/hadoop/share/hadoop/mapreduce/lib/*,"  
					+"/cloud/service/hadoop/share/hadoop/yarn/*,/cloud/service/hadoop/share/hadoop/yarn/lib/*");
				
		 FileOutputFormat.setOutputPath(job,new Path(output));		
		 JobClient jc = new JobClient(job); 
		 RunningJob rj = jc.submitJob(job);
		 //out.print(rj.getID().toString());
		 //JobClient.runJob(job);
		 return rj.getID().toString();
		 
	 }
	 protected void SubByYarnClient()
	 {
		 //YarnClient yarn = new YarnClient()
	 }
	 
	 


}
