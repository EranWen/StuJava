import cn.edu.hfut.dmic.webcollector.crawler.DeepCrawler;
import cn.edu.hfut.dmic.webcollector.model.Links;
import cn.edu.hfut.dmic.webcollector.model.Page;
import com.gargoylesoftware.htmlunit.BrowserVersion;
import java.net.URLEncoder;
import java.util.List;
import org.openqa.selenium.WebElement;
import java.io.File;  
import java.io.FileOutputStream;
import java.io.PrintWriter;
import org.jsoup.*;
import org.jsoup.nodes.Document;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

public class DemoJSCrawler extends DeepCrawler{

	public DemoJSCrawler(String crawlPath) {
        super(crawlPath);
    }
	@Override
    public Links visitAndGetNextLinks(Page page) {
        /*HtmlUnitDriver可以抽取JS生成的数据*/
		System.out.println("获取页面");
        HtmlUnitDriver driver=PageUtils.getDriver(page,BrowserVersion.getDefault());
        System.out.println("执行页面");
        /*HtmlUnitDriver也可以像Jsoup一样用CSS SELECTOR抽取数据
                       关于HtmlUnitDriver的文档请查阅selenium相关文档*/
        //System.out.println(driver.getPageSource());
        Document doc = Jsoup.parse(driver.getPageSource());
        System.out.println("分析页面");
        System.out.println("市盈率:"+doc.getElementById("main-15").text());
        System.out.println("振幅:"+doc.getElementById("main-14").text());
        System.out.println("市净率:"+doc.getElementById("main-13").text());
        System.out.println("换手率:"+doc.getElementById("main-12").text());
        System.out.println("流通市值:"+doc.getElementById("main-11").text());
        System.out.println("总市值:"+doc.getElementById("main-10").text());
        System.out.println("成交额:"+doc.getElementById("main-9").text());
        System.out.println("成交量:"+doc.getElementById("main-8").text());
        System.out.println("最低:"+doc.getElementById("main-7").text());
        System.out.println("最高:"+doc.getElementById("main-6").text());
        System.out.println("今开:"+doc.getElementById("main-5").text());
        System.out.println("昨收:"+doc.getElementById("main-4").text());
        
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-1").get(0).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-2").get(0).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-3").get(0).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-4").get(0).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-5").get(0).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-6").get(0).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-1").get(1).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-2").get(1).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-3").get(1).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-4").get(1).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-5").get(1).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-6").get(1).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-1").get(2).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-2").get(2).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-3").get(2).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-4").get(2).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-5").get(2).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-6").get(2).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-1").get(3).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-2").get(3).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-3").get(3).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-4").get(3).html());
        System.out.println(doc.getElementById("mod-gsgk").getElementsByClass("col-5").get(3).html()+doc.getElementById("mod-gsgk").getElementsByClass("col-6").get(3).html());

        
        /*
        List<WebElement> divInfos=driver.findElementsByCssSelector("h3>a[id^=uigs]");
        for(WebElement divInfo:divInfos){
            System.out.println(divInfo.getText());
        }
        */
        return null;
    }
}
