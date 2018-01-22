
<%@page import="java.util.AbstractList"%>
<%@page import="java.util.AbstractMap.SimpleEntry"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%@page import="bus.Account"%>
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
<h1>Information retrieval for legal texts</h1>
<script type="text/javascript">    
    $(document).ready(function(){
        
        $('h3').find('a[href="#"]').on('click', function(e) {
            e.preventDefault();   
            
            this.expand = !this.expand;
            var temp = $(this).attr('data').split(";");
            var path = temp[0];
            var divid = temp[1];
                
            if (this.expand)
            {
//                alert($("#" + divid + "_full").attr("data"));                
                $("#" + divid + "_full").show();
                $("#" + divid + "_short").hide();
                if ($("#" + divid + "_full").attr("data") !== "true")
                {
                    
//                    alert($("#" + divid + "_full").attr("data"));
                    jQuery.getJSON( "Ajax?function=get_doc&path=" + path).done(function(data)
                    {   
                        $("#" + divid + "_full").attr("data", "true");
                        
                        $("#" + divid + "_full").html("<pre>" + data.content.replace(" ", "") + "</pre>");    

                    }); 
                }
            }
            else 
            {
                $("#" + divid + "_full").hide();
                $("#" + divid + "_short").show();
            }
            $(this).text(this.expand ? "-" : "+");
            $(this).closest('.expand').find('.small, .big').toggleClass('small big');
        });
    });

</script>
<%!
public JSONArray queryOnOriginalSpace(String q, String type) throws IOException, JSONException 
{       
//    String url = "http://altix-uv.jaist.ac.jp:8765/api/search/";     
    String url = "http://hpcc-057.jaist.ac.jp:8765/api/search/";
    List<SimpleEntry> params = new ArrayList<SimpleEntry>();

    params.add(new SimpleEntry("query_string", q));
    params.add(new SimpleEntry("type", type));
    params.add(new SimpleEntry("map", "n"));
    JSONObject o = Rest.getJSONObjectFromURL_POST(url, params);
    return o.getJSONArray("result");
//    return null;
}

%>
<hr/>
<%       
    String type = request.getParameter("type");
    if (type == null) 
        type = "tfidf";
        
    String _vQuery = "";   
    
    JSONArray arr = null; 
    if (request.getParameter("q") != null) 
    {               
        _vQuery = request.getParameter("q");
        
        arr = queryOnOriginalSpace(_vQuery, type);        
  
    }
%>
<form method="get">
    <input type="hidden" name="f" value="Search"/>
    Query: <input type="text" class="search-box w600" name="q" value="<%=_vQuery%>" />
     <input class='search-button' type="submit" value="Search"/> 
     <br/>
     Sample query (must be tokenized): <span style="font-style: italic; font-size: smaller">滅失 当時 の 本件 商品 の 価額 が 六 〇 万 円 で ある こと は すで に 述べ た とおり （ 原判決 七 枚 目 裏 四 行 目 から 同 八 枚 目 表 三行 目 まで ） で ある が 、 もし 被控訴人 が   れ 以下 で ある と 主張 する もの で ある なら ば 、 被控訴人 の 方 で これ を 立証 す べき 責任 が ある 。</span>
     <p>
     Weighting model:
     <div style="display: block; width: 400px; margin-left: 40px"><input name='type'  type="radio" value="tfidf" <% if(type.equals("tfidf")) out.print("checked='checked'"); %>/> TF-IDF weighting model </div>
     <div style="display: block; width: 400px; margin-left: 40px"><input name='type' type="radio" value="bm25" <% if(type.equals("bm25")) out.print("checked='checked'"); %>/> BM25F weighting model</div>
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
            String temp = " " + _vQuery + " ";
            for(int i = 0; i<arr.length();i++)
            {
                JSONObject doc = arr.getJSONObject(i);               
                String text = doc.getString("text");
                

               
                out.println("<div>");
                out.println("<h3>");
                String path = doc.getString("path");
                Path p = Paths.get(path);                
                out.println("<span>" + (i+1) + ". </span> " + path);
                out.println(" <span class='result-score'>[" + doc.getString("score") + " ]</span>");
                out.println("<a class='link-button' href='#' data='" + path + ";doc" + i + "'>+</a>");
                out.println("</h3>");          
                out.println("<div class='expand'>");                
                out.println("<div id='doc" + i + "_short'>");            
                out.println(text.toString().replace("\n", "<br/>"));
                out.println("</div>");
                out.println("<div id='doc" + i + "_full' style='display:None' data='false'>");            
                out.println(text.toString().replace("\n", "<br/>"));
                out.println("</div>");
                
            

                out.println("</div>");
                out.println("</div>");
            }            
        }                 
    %>
    <%--<%=request.getContextPath()%>--%> 
</div>