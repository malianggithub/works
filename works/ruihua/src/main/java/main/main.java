package main;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Pattern;

import ruihuaImpl.BaoWen;
import ruihuaImpl.FuJian5;
import ruihuaInterface.JiaoYan;
import util.PropertiesFactory;


public class main {
	
	
	
	public static void main(String[] args) throws InterruptedException {
		JiaoYan jy=ruihuaImpl.JiaoYan.getJiaoYan();
		jy.files();
		
		Thread td1=new Thread((Runnable) jy);
		
		td1.start();
		
		
		
	}
	
	
	public static void excel() throws Exception {
		FuJian5 fj=new FuJian5("险种定义表");
		System.out.println(fj.getexcelrow());
		Map<String, String> map = fj.getcolumnnull();
		Iterator<String> it=map.keySet().iterator();
		while(it.hasNext()) {
			
			System.out.println(it.next());
			System.out.println(map.size());
		}
	}
	
}
