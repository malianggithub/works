package ruihua;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class FuJian5 {
	Map<String, String> map=null;
	XSSFSheet sheet=null;
	public FuJian5(String sheetname) throws Exception {
		XSSFWorkbook book=new XSSFWorkbook(new FileInputStream(new File("C:\\Users\\16603\\Desktop\\附件5：检查映射.xlsx")));
		sheet=book.getSheet(sheetname);
		
	}
	
	public Map<String, String> getcolumnnull(){
		map=new LinkedHashMap<String, String>();
		int row=sheet.getPhysicalNumberOfRows();
		for(int i=2;i<row;i++) {
			map.put(sheet.getRow(i).getCell(1).toString(), sheet.getRow(i).getCell(4).toString());
		}
		
		return map;
		
	}
	
	public int getexcelrow() {
		return sheet.getPhysicalNumberOfRows()-2;
	}
}
