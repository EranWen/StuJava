package Allegion.Hadoop.SplitVideoFile;

import java.io.IOException;
import java.util.Iterator;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reducer;
import org.apache.hadoop.mapred.Reporter;


public class SplitVideoFileMapReduce {

	public static Configuration hdfsconf ;
	public static class SplitTransMap extends MapReduceBase implements Mapper<LongWritable,Text,LongWritable, Text>
	{

		public  void map(LongWritable key,Text  value,OutputCollector<LongWritable,Text> output,Reporter reporter) throws IOException
		{		
				SplitVideoFileTrans svft = new SplitVideoFileTrans();
				System.out.println("开始转码"+value.toString());
				svft.Trans("codec=h264&size=320*240&fps=15", value.toString());
				
				Text  newTxt = new Text(value.toString()+".dst");
				System.out.println("转码完成"+value.toString());
				output.collect(key, newTxt);
		}
	}
	public static class SplitTransReduce extends MapReduceBase implements Reducer<LongWritable,Text,LongWritable,Text>
	{
		public void reduce(LongWritable key,Iterator<Text> values,OutputCollector<LongWritable,Text> output,Reporter reporter) throws IOException
		{
			//同一个key进行合并，这里应该啥也不用做
			Text pa=new Text("Nothing");
			while(values.hasNext())
			{
				 pa = values.next();
			}	
			System.out.println("准备合并"+pa.toString());
			output.collect(key,pa);
		}
	}
}
