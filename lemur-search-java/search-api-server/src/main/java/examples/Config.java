package examples;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Config {
	private JSONObject configJSON = null;
	public Config(String path) throws IOException, JSONException
	{		
		File file = new File(path);
		FileInputStream fis = new FileInputStream(file);
		byte[] data = new byte[(int) file.length()];
		fis.read(data);
		fis.close();
		String str = new String(data, "UTF-8");
		configJSON = new JSONObject(str);
		
	}
	public String getAtribute(String name) throws JSONException
	{
		return configJSON.getString(name);
	}
	public JSONArray getIndexPaths() throws JSONException
	{
		return configJSON.getJSONArray("indexs");		
	}
}
