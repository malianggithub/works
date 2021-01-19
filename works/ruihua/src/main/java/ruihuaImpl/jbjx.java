package ruihuaImpl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParserFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.Map.Entry;

public class jbjx {

	public static void main(String[] args) throws Exception {
		getxmlname();

	}
	public static void getxmlname() throws Exception {
		Properties pro=new Properties();
		pro.load(new BufferedReader(new FileReader(new File("C:\\Users\\16603\\git\\work\\file\\file\\kettle路径.properties"))));
		Iterator<Entry<Object, Object>> it = pro.entrySet().iterator();
		File file=null;
		File[] namelist=null;
		String path=null;
		String folder=null;
		String[] sql=null;
		while(it.hasNext()) {
			
			folder=it.next().getKey().toString();
			path=pro.getProperty(folder);
			System.out.println(folder);
			file=new File(path);
			namelist=file.listFiles();
			String filenamez=null;
			String[] name=null;
			for(int i=0;i<namelist.length;i++) {;
				sql=csql(usql(namelist[i].toString()));
				System.out.println(namelist[i]+"\t:"+sql.length);
				name=namelist[i].toString().split("\\\\");
				filenamez=name[name.length-1].replaceAll(".ktr", "");
				for(int j=0;j<sql.length;j++) {
					
					
					updatefile(sql[j],folder+"\\"+filenamez+j);
				}
			}
		}
		
		
	}
	public static String usql(String filename) throws Exception {
		DocumentBuilderFactory dbf=DocumentBuilderFactory.newInstance();
		DocumentBuilder db=dbf.newDocumentBuilder();
		Document d=db.parse("file:///"+filename);
		NodeList list=d.getElementsByTagName("sql");
		
		
		return list.item(0).getTextContent().toString();
		
	}
	public static String[] csql(String sql) {
		
		return sql.split("union all -- 分割");
		
	}
	public static void updatefile(String sql,String filename) throws IOException {
		BufferedWriter bfw=new BufferedWriter(new FileWriter(new File("C:\\Users\\16603\\git\\work\\file\\"+filename+".sql")));
		bfw.write(sql);
		bfw.close();
		
	}
}
