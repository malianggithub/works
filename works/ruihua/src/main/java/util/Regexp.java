package util;

import java.util.regex.Pattern;

public class Regexp {
	
	public static boolean regexp(String type,String value) {
		return Pattern.matches(PropertiesFactory.getValue(type), value);
	}
}
