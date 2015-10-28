import cn.edu.hfut.dmic.webcollector.net.*;
import cn.edu.hfut.dmic.webcollector.crawler.DeepCrawler;
import cn.edu.hfut.dmic.webcollector.model.Links;
import cn.edu.hfut.dmic.webcollector.model.Page;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import com.gargoylesoftware.htmlunit.BrowserVersion;
import java.net.URLEncoder;
import java.util.List;
import weka.classifiers.*;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.mongodb.util.JSON;




public class Main   {
	public Main() {
        super();
        
    }
	
	  
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			DemoJSCrawler	crawler = new DemoJSCrawler("D:\\temp");
			crawler.addSeed("http://stockhtm.finance.qq.com/sstock/ggcx/600660.shtml");
			crawler.start(5);
			
			HttpRequest request = new HttpRequest("http://www.aigaogao.com/tools/history.html?s=600660");
			HttpResponse response = request.getResponse();
	        String html = response.getHtmlByCharsetDetect();
	        System.out.println(html.length());
	        Document doc = Jsoup.parse(html);
	        Elements  trs = doc.getElementById("ctl16_contentdiv").select("tr");
	        for(int i = 0;i<100;i++){
	            Elements tds = trs.get(i).select("td");
	            for(int j = 0;j<tds.size();j++){
	                String text = tds.get(j).text();
	                System.out.println(text);
	            }
	        }
		}
		catch(Exception e)
		{
			System.out.println(e.toString());
		}
		System.out.println("hello");
	}



}