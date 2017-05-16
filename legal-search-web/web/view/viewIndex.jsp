
<%@page import="org.json.JSONException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.rmi.RemoteException"%>
<%@page import="java.io.PrintStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.nio.file.Path"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONStringer"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.interf.test.TestRemote"%>
<%@page import="java.rmi.registry.Registry"%>
<%@page import="java.rmi.registry.LocateRegistry"%>
<%@page import="com.interf.test.Constant"%>
<%@page import="util.Rest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<h1>Civil code search engine</h1>
<script type="text/javascript">    
    $(document).ready(function(){
        
        $('.expand').find('a[href="#"]').on('click', function (e) {            
            e.preventDefault();
            this.expand = !this.expand;
            $(this).text(this.expand?"Collapse":"...");
            $(this).closest('.expand').find('.small, .big').toggleClass('small big');
        });
    });
//    $(document).ready(function(){
//
//        alert("");
//
//    }); 
</script>
<%!
public JSONArray queryOnOriginalSpace(String q) throws RemoteException, Exception
{       
        //String IP = "127.0.0.1";//args[0];
        //String IP = "150.65.43.47";//args[0];
        //String IP = "150.65.204.15";
        String IP = "150.65.242.122";
//        String IP = "127.0.0.1";
        Registry registry = LocateRegistry.getRegistry(IP, 52366);
        TestRemote remote = (TestRemote) registry.lookup("LEGAL-API");
        
        JSONObject queryJ = new JSONObject();
	queryJ.put("query", q);
	queryJ.put("n", 20);                
        JSONObject o = new JSONObject( remote.query2(queryJ.toString()));
        return o.getJSONArray("result");
        //out.print(o.toString());
}
public JSONArray queryOnMDSSpace_old(JspWriter out, String q) throws IOException, JSONException 
{   
    String pythonPath = "//anaconda/bin/python";    
    String pythonProgram ="/Users/sonnguyen/Bitbucket/nii-projects/MDS/query.py";
    
    String command = pythonPath + " " + pythonProgram + " " + q.replace(" ", "_") + "";
    Process p = Runtime.getRuntime().exec(command);
    //out.print(command);
    //Process p = Runtime.getRuntime().exec("ls");
    BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));		
    String line= in.readLine();
    String ss = "";
    while (line !=null){                
        ss = ss + line;
        line = in.readLine();
    }
    
    JSONObject o2 =  new JSONObject(ss);    
    
    return o2.getJSONArray("result");
}

public JSONArray queryOnMDSSpace(JspWriter out, String q) throws IOException, JSONException 
{   
//    String address = "http://127.0.0.1:8081";
    String address = "http://150.65.242.122:8081";
    String url = address + "/api/search_mds/" + q.replace(" ", "_");
    JSONObject o = Rest.getJSONObjectFromURL(url);    
    return o.getJSONArray("result");
}
%>
<hr/>
<%    
    String space = request.getParameter("space");
    if (space == null) 
        space = "org";
        
    String _vQuery = "";   
    String q = "";   
    JSONArray arr = null; 
    if (request.getParameter("q") != null) 
    {        
        _vQuery = request.getParameter("q");
        q = _vQuery.replaceAll("[^a-zA-Z0-9 ]", " ");
        q = q.replaceAll("  ", " ");      
        
        if (space.endsWith("org"))        
            arr = queryOnOriginalSpace(q);        
        
        if (space.equals("mds"))
        {                       
            arr = queryOnMDSSpace(out, q);
        }
    }
%>
<form method="get">
    <input type="hidden" name="f" value="Home"/>
    Query: <input class='search-box' type="text" name="q" value="<%=_vQuery%>" size="60"/>
     <input class='search-button' type="submit" value="Search"/> 
     <p>
     Query space:
     <div style="display: block; width: 200px; margin-left: 40px"><input name='space'  type="radio" value="org" <% if(space.equals("org")) out.print("checked='checked'"); %>/> Original space (lemur API) </div>
     <div style="display: block; width: 200px; margin-left: 40px"><input name='space' type="radio" value="mds" <% if(space.equals("mds")) out.print("checked='checked'"); %>/> MDS space (python API)</div>
<!--     <div style="display: block; width: 200px; margin-left: 40px"><input name='space'  type="radio" value="merge" <% if(space.equals("merge")) out.print("checked='checked'"); %>/> Merge</div>-->
     </p>
    <hr/>
</form>

<div>    
    <%
        if (_vQuery != "")
        {
            out.println("<h2>Query: </h2>");
            if(request.getParameter("qid") != null)
            {

                out.println("<span class='query-id'>");
                out.println(request.getParameter("qid"));
                out.println("</span>");
            }
            out.println("<span class='query'>");
            out.println(" " + _vQuery);
            out.println("</span>");
        }
        
        
        if (arr != null)
        {
            out.println("<h2>Top 20 relevant articles: </h2>");
            String temp = " " + q.toLowerCase() + " ";
            for(int i = 0; i<arr.length();i++)
            {
                JSONObject doc = arr.getJSONObject(i);               
                String text = doc.getString("text");
                String[] words = text.split(" ");
                
                StringBuffer result = new StringBuffer();
                for (int j = 0; j < words.length; j++) 
                {
                    if (temp.contains(" " + words[j].toLowerCase() + " "))
                    {
                        int count = 1;
                        String temp2 = words[j];                        
                        while(j+1 < words.length && temp.contains(" " + words[j+1].toLowerCase() + " "))
                        {
                            count ++;
                            temp2 = temp2 + " " + words[j+1];
                            j++;
                        }                                    
                        if (count == 1 && util.Stopwords.STOPWORDS.contains(temp2))
                            result.append(temp2 + " ");
                        else 
                            result.append( "<span class='light'>" + temp2 + "</span> ");
                    }
                    else 
                        result.append(words[j] + " ");
                   //result.append( optional separator );
                }
               
                out.println("<div>");
                out.println("<h3>");
                String path = doc.getString("path");
                Path p = Paths.get(path);                
                out.println("<span>" + (i+1) + ". </span> " + p.getFileName().toString());
                out.println(" <span class='result-score'>[" + doc.getString("score") + " ]</span>");
                out.println("</h3>");          
                out.println("<div class='expand'>");
                out.println("<div class='small'>");
                out.println(result.toString());  
                 
                out.println("</div>");
                out.println("<a href='#'>...</a>");
                out.println("</div>");
                out.println("</div>");
            }            
        }                 
    %>
    <%--<%=request.getContextPath()%>--%> 
</div>