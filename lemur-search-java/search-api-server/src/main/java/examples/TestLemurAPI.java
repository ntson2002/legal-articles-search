package examples;

import java.lang.reflect.Field;
import java.util.Properties;

import org.json.JSONArray;

import lemurproject.indri.QueryEnvironment;
import lemurproject.lemur.Index;
import lemurproject.lemur.IndexManager;

public class TestLemurAPI {

	static {
		try {
			System.setProperty("java.library.path", "lemur-installed/lib");

			Field fieldSysPath = ClassLoader.class
					.getDeclaredField("sys_paths");
			fieldSysPath.setAccessible(true);
			fieldSysPath.set(null, null);

			Properties props = System.getProperties();
			System.out.println("java.library.path="
					+ props.get("java.library.path"));
		} catch (Exception e) {

		}

	}
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		Index ind = IndexManager.openIndex("/Volumes/i1501/s1520203/lemur/civilcode-index");
		
		System.out.print("HELLO!");
	}

}
