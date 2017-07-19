/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author sonnguyen
 */
public class MyIO {
    public static JSONObject parseJSONFile(String filename) throws JSONException, IOException {
        String content = new String(Files.readAllBytes(Paths.get(filename)));
        return new JSONObject(content);
    }
    
    public static void main(String[] args) throws JSONException, IOException
    {
//        
        System.out.println(System.getProperty("user.dir"));
        JSONObject o = parseJSONFile("data/data.json");
        System.out.print(o.toString(4));
    }
}
