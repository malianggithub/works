package ruihuaImpl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;

import util.PropertiesFactory;
import util.Regexp;

public class JiaoYan implements ruihuaInterface.JiaoYan,Runnable {
	static Map<Integer, File> map=new HashMap<Integer, File>();
	static  int i=-1;
	static JiaoYan jy=null;
	public static JiaoYan getJiaoYan() {
		
		if(jy==null) {
			jy=new JiaoYan();
		}
		return jy;
	}

	public String number(String arg) {
		if(Regexp.regexp("数字", arg)) {
			return null;
		}
		return arg;
	}

	public String zhongwen(String arg) {
		if(Regexp.regexp("中文", arg)) {
			return null;
		}
		return arg;
	}

	public String isnotempty(String arg) {
		if(!arg.isEmpty()) {
			return null;
		}
		return "注：空值";
	}

	public void huanhang(String[] value) {
		int count = 0;
        int index = 0;
        int onedata=0;
		//有没有换行的情况
		if(value.length!=0) {
			
			for(int j=0;j<value.length;j++) {
				count = 0;
		        index = 0;
				 while ((index = value[j].indexOf("", index)) != -1) {
			            index = index + "".length();

			            count++;
			     }
				 if(j==0) {
					 onedata=count;
				 }
				 if(onedata!=count) {
					 
					 System.out.println(value[j].toString()); 
				 }
				

				

			}
			
		}
		
	}
	public synchronized static int geti() {
		i=i+1;
		return i;
	}
	
	public  void lsh() throws IOException {
		BaoWen bw=new BaoWen();
		String[] value=null;
		String[] value1=null;
		String filename=null;
		int in=geti();
		while(in<map.size()) {
			filename=map.get(in).getName();
			//System.out.println(filename);
			if(filename.substring(filename.length()-3, filename.length()).equals("txt")) {
				value=bw.getfilevalue(map.get(in));
				
				System.out.println(filename);
				for(int j=0;j<value.length;j++) {
					value1=value[j].toString().split("",-1);
					for(int k=0;k<value1.length;k++) {
						if(number(value1[0])!=null) {
							
							System.out.println(number(value1[0]));
						}
						if(zhongwen(value1[2])!=null) {
							System.out.println(zhongwen(value1[2]));
						}
						if(isnotempty(value1[0])!=null) {
							System.out.println(isnotempty(value1[0]));
						}
						
						
						
					}
					
				}
				//格式校验
				//jy.huanhang(value);
				
				
				
				
			}
			
			in=geti();
		}
		
		
		
	}

	public void files() {
		BaoWen bw=new BaoWen();
		String filepath=PropertiesFactory.getValue("报文路径");
		System.out.println(filepath);
		File[] file=null;
		file=bw.readfile(filepath);
		
		
		for(int i=0;i<file.length;i++) {
			map.put(i,file[i]);
		}
	}

	public void run() {
		try {
			jy.getJiaoYan().lsh();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	

}
