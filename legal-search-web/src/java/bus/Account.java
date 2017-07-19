/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bus;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.security.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author sonnguyen
 */
public class Account {

    public static void main(String[] args) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        System.out.println(Account.getMD5String("@admin@2017"));
        System.out.println(Account.getMD5String("@user01@2017"));
        System.out.println(Account.getMD5String("12345"));
    }

    public static Boolean getLoginStatus(HttpSession session) {
        Object isLogin = session.getAttribute("ISLOGIN");
        return (isLogin != null && (Boolean) isLogin == true);
    }

    public static String getLoginName(HttpSession session) {
        Object name = session.getAttribute("USERNAME");
        return (name != null ? (String) name : "");
    }

    public static void checkLoginStatus(HttpSession session, HttpServletResponse response, String redirectURL) throws IOException {
        Object isLogin = session.getAttribute("ISLOGIN");
        if (isLogin == null || !((Boolean) isLogin)) {
//            String redirectURL = "index.php?controller=Home&action=Login";
            response.sendRedirect(redirectURL);

        }
    }

    public static Boolean checkAccount(String path, String name, String password) throws UnsupportedEncodingException, NoSuchAlgorithmException, IOException, JSONException {
//        String path = "./data/data.json";
        JSONArray accounts = util.MyIO.parseJSONFile(path).getJSONArray("account");
        HashMap<String, String> list = new HashMap<>();
        for (int i = 0; i < accounts.length(); i++) {
            JSONObject o = accounts.getJSONObject(i);
            list.put(o.getString("name"), o.getString("password"));
        }
//        HashMap<String, String> list = new HashMap<>();
//        list.put("admin", getMD5String("@admin@2017"));
//        list.put("user01", getMD5String("@user1@2017"));
        System.out.print(password);
        System.out.print(getMD5String(password));
        return list.keySet().contains(name) && list.get(name).equals(getMD5String(password));
    }

    public static String getMD5String(String text) throws UnsupportedEncodingException, NoSuchAlgorithmException {
//        byte[] bytesOfMessage = text.getBytes("UTF-8");
//
//        MessageDigest md = MessageDigest.getInstance("MD5");
//        byte[] thedigest = md.digest(bytesOfMessage);
//        return thedigest.toString();        
        MessageDigest mdAlgorithm = MessageDigest.getInstance("MD5");
        mdAlgorithm.update(text.getBytes());

        byte[] digest = mdAlgorithm.digest();
        StringBuilder hexString = new StringBuilder();

        for (int i = 0; i < digest.length; i++) {
            text = Integer.toHexString(0xFF & digest[i]);

            if (text.length() < 2) {
                text = "0" + text;
            }

            hexString.append(text);
        }

        return hexString.toString();
    }

}
