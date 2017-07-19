/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package util;



import java.io.*;
import java.net.*;
import java.util.AbstractMap.SimpleEntry;
import java.util.ArrayList;
import java.util.List;
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
        while ((l = br.readLine()) != null) {
            or.write(l + "\n");
        }
        br.close();
        JSONObject o = new JSONObject(or.toString());
        return o;
    }

    private static String getQuery(List<SimpleEntry> params) throws UnsupportedEncodingException {
        StringBuilder result = new StringBuilder();
        boolean first = true;

        for (SimpleEntry pair : params) {
            if (first) {
                first = false;
            } else {
                result.append("&");
            }

            result.append(URLEncoder.encode((String) pair.getKey(), "UTF-8"));
            result.append("=");
            result.append(URLEncoder.encode((String) pair.getValue(), "UTF-8"));
        }

        return result.toString();
    }
    
    public static JSONObject getJSONObjectFromURL_POST(String address, List<SimpleEntry> params) throws MalformedURLException, IOException, JSONException {
        String type = "application/x-www-form-urlencoded";
        
        String encodedData = getQuery(params);
        URL u = new URL(address);
        HttpURLConnection conn = (HttpURLConnection) u.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty( "Content-Type", type );
        conn.setRequestProperty( "Content-Length", String.valueOf(encodedData.length()));
        OutputStream os = conn.getOutputStream();
        os.write(encodedData.getBytes());
        
        Reader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

        StringBuilder sb = new StringBuilder();
        for (int c; (c = in.read()) >= 0;)
            sb.append((char)c);
        String response = sb.toString();
        
        JSONObject o = new JSONObject(response);
        return o;
        
        
    }
    
    public static void main(String[] args) throws IOException, JSONException {
//        String url = "http://150.65.242.122:8081/api/f=search&query=A_demand_for_payment_shall_not_have_the_effect";
//        System.out.println (Rest.getJSONObjectFromURL(url).toString());
        String q = "滅失 当時 の 本件 商品 の 価額 が 六 〇 万 円 で ある こと は すで に 述べ た とおり （ 原判決 七 枚 目 裏 四 行 目 から 同 八 枚 目 表 三行 目 まで ） で ある が 、 もし 被控訴人 が   れ 以下 で ある と 主張 する もの で ある なら ば 、 被控訴人 の 方 で これ を 立証 す べき 責任 が ある 。";
        String url = "http://uv.jaist.ac.jp:8765/api/search/";        
        List<SimpleEntry> params = new ArrayList<>();
        params.add(new SimpleEntry("query_string", q));
        JSONObject o = Rest.getJSONObjectFromURL_POST(url, params);
        System.out.println(o.toString(4));
    }
    
   
}