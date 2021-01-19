package ruihuaInterface;

import java.io.IOException;

public interface JiaoYan {
	public String number(String arg);
	
	public String zhongwen(String arg);
	
	public String isnotempty(String arg);
	
	public void huanhang(String[] value);
	
	public void lsh() throws IOException;
	
	public void files();
}
