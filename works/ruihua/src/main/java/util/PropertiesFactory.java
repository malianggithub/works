package util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

public class PropertiesFactory {
	private static Properties pf=new Properties();
	private static String value=null;
	
	public static String getValue(String key) {
		try {
			pf.load(new  FileReader(new File("C:\\Users\\16603\\git\\works\\works\\ruihua\\file\\file\\jiaoyanconfig.properties")));
			value=(String) pf.get(key);
		} catch (FileNotFoundException e) {
			
			e.printStackTrace();
		} catch (IOException e) {
			
			e.printStackTrace();
		}
		
		return value;
	}
}
