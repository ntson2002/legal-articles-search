/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package util;

import java.io.*;
import java.net.*;
import org.json.JSONException;
import org.json.JSONObject;

public class Rest {

    public static JSONObject getJSONObjectFromURL(String url) throws IOException, JSONException
    {
        URLConnection urlc = (new URL(url)).openConnection();

        InputStream response = urlc.getInputStream();
        //get result
        BufferedReader br = new BufferedReader(new InputStreamReader(response));
        StringWriter or = new StringWriter();
        
        String l = null;
        while ((l=br.readLine())!=null) {
            or.write(l + "\n");
        }
        br.close();
        JSONObject o = new JSONObject(or.toString());
        return o;
    }
    public static void main(String[] args) throws IOException, JSONException {
        String url = "http://150.65.242.122:8081/api/f=search&query=A_demand_for_payment_shall_not_have_the_effect";
        System.out.println (Rest.getJSONObjectFromURL(url).toString());
    }

   
}