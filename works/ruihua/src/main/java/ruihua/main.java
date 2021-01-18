package ruihua;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.regex.Pattern;


public class main {

	public static void main(String[] args) throws IOException {
		jiaoyan();
		
	}
	public static void jiaoyan() throws IOException {
		BaoWen bw=new BaoWen();
		String filepath="D:\\workspace\\works\\file\\baowen";
		File[] file=bw.readfile(filepath);
		String[] value=null;
		String filename=null;
		int count = 0;
        int index = 0;
        int onedata=0;
		for(int i=0;i<file.length;i++) {
			filename=file[i].getName();
			if(filename.subSequence(filename.length()-4, filename.length()).equals(".txt")) {
				value=bw.getfilevalue(file[i]);
				
				
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
							 System.out.println(filename);
							 System.out.println(value[j]);
						 }
						//System.out.println(value[j].toString());
//						if(value[0].split("").length!=value[j].split("").length) {
//							System.out.println("123"+value[j].split("").length+"   "+value[0]);
//							System.out.println(filename);
//							System.out.println(value[j].split("").length+"   "+value[j]);
//						}
						

					}
					
				}
				
			}
			
			
//			for(int j=0;j<value.length;j++) {
//				System.out.println(value[i].split("").length);
//			}
		}
		
	}
	
	public static void excel() throws Exception {
		FuJian5 fj=new FuJian5("���ֶ����");
		System.out.println(fj.getexcelrow());
		Map<String, String> map = fj.getcolumnnull();
		Iterator<String> it=map.keySet().iterator();
		while(it.hasNext()) {
			
			System.out.println(it.next());
			System.out.println(map.size());
		}
	}
}
