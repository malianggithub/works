package ruihua;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Collection;

public class BaoWen {
	BufferedReader bdr=null;
	
	
	public File[] readfile(String filepath) {
		File allfile=new File(filepath);
		File[] filename=allfile.listFiles();
		
		return filename;
	}
	public String[] getfilevalue(File file) throws IOException {
		bdr=new BufferedReader(new FileReader(file));
		Collection<String> col=new ArrayList<String>();
		String value="";
		while(value!=null) {
			value=bdr.readLine();
			if(value!=null) {
				col.add(value);
			}
			
		}
		Object[] arr= col.toArray();
		String[] arr1=new String[arr.length];
		for(int i=0;i<arr.length;i++) {
			arr1[i]=(String) arr[i];
		}
		return arr1;
	}
	
	
	
	
	
	public void close() throws IOException {
		bdr.close();
	}
}
