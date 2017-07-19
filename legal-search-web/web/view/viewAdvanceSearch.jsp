<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.AbstractMap.SimpleEntry"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.StringWriter"%>
<%@page import="java.util.Iterator"%>
<%@page import="util.Rest"%>
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


<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
        String IP = "http://altix-uv.jaist.ac.jp:8765";
%>
<%!
    
    public JSONObject queryTFIDF_topicBased(String address, String query, Integer topic) throws Exception
    {
        String url = address + "/api/search_topic/";     
        List<SimpleEntry> params = new ArrayList<SimpleEntry>();

        params.add(new SimpleEntry("function", "search"));
        params.add(new SimpleEntry("query_string", query));
        params.add(new SimpleEntry("topic_index", topic.toString()));
        params.add(new SimpleEntry("type", "tfidf"));
        params.add(new SimpleEntry("map", "y"));
                
        JSONObject o = Rest.getJSONObjectFromURL_POST(url, params);        
        return o;
    }
    
    public JSONObject queryTFIDF(JspWriter out, String address, String query) throws Exception
    {       
        
        String url = address + "/api/search/";     
        List<SimpleEntry> params = new ArrayList<SimpleEntry>();

        params.add(new SimpleEntry("query_string", query));
        params.add(new SimpleEntry("type", "tfidf"));
        params.add(new SimpleEntry("map", "y"));
        JSONObject o = Rest.getJSONObjectFromURL_POST(url, params);        
        return o;
        
    }
    
    public JSONObject getTopics(String address) throws Exception
    {
        String url = address + "/api/search_topic/";     
        List<SimpleEntry> params = new ArrayList<SimpleEntry>();

        params.add(new SimpleEntry("function", "get_topic"));
        params.add(new SimpleEntry("n", "50"));
        JSONObject o = Rest.getJSONObjectFromURL_POST(url, params);        
        return o;
    }
    
    public String selectTopicString(JSONObject topics, Integer selected) throws Exception
    {
        Iterator<?> keys = topics.keys();
        StringWriter sOut = new StringWriter();
        sOut.write("<select name='topic' id='topic'>");
        sOut.write("<option value='none'>None</option>");
        while (keys.hasNext()) {
            String key = (String) keys.next();            
            String optionString = String.format("<option value='%s'>Topic %s</option>", key, key);
            if (key.equals(selected.toString()))
                optionString = String.format("<option value='%s' selected='selected'>Topic %s</option>", key, key);
            sOut.write(optionString);
        }
        
        sOut.write("</select>");
        sOut.write("<input class='search-button' type='submit' value='Search'/>");
        
        sOut.write("<span id='topicDescription'></span>");
        
        
        keys = topics.keys();
         while (keys.hasNext()) {
            String key = (String) keys.next();
            sOut.write(String.format("<div class='divTopics' id='divTopic-%s' style='display:none; margin-top:10px'>", key));        
            JSONArray words = topics.getJSONArray(key);
            for (int i = 0; i < words.length(); i++) {
                JSONArray items = words.getJSONArray(i);
                String s = String.format("<span class='topic_word'>%s (%.2f)</span>", items.getString(0), 100 * Double.parseDouble(items.getString(1)));
                sOut.write(s);
            }
            sOut.write("</div>");
        }
        return sOut.toString();
    }
           
    
    public void printResultString(JSONArray arr, String q, JspWriter out) throws Exception 
    {

        String temp = " " + q.toLowerCase() + " ";
        for (int i = 0; i < arr.length(); i++) {
            JSONObject doc = arr.getJSONObject(i);
            String text = doc.getString("text");

            out.println("<div>");
            out.println("<h3><a name='result" + i + "'></a>");
            String path = doc.getString("path");
            out.println("<span>" + (i + 1) + ". </span> " + path);
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

<h1>Legal topic-based Search <a href="#" id="viewDescription" style="text-decoration: none" title="Show/Hide description">(?)</a></h1>
<div id="divDescription">
    <p><b>Description:</b></p>
    <ol>
        <li>List of topics are learned automatically based on the corpus using the LDA algorithm</li>
        <li>After relevant documents are retrieved, they are ranked based on the similarity with the chosen topic</li>
        <li>The query and returned documents from high dimensional space are mapped into the 2-D space. The distance in this space is distance between query and documents.</li>
    </ol>
</div>
<script type="text/javascript">
    $(document).ready(function() {
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
        
        $('#topic').change(function(){            
            var valueSelected = this.value;            
            if (this.value === "none")
            {
                $("#topicDescription").html("<br/>Top 50 terms of topic: <b>None</b>");
            }
            else
            {
                $("#topicDescription").html("<br/>Top 50 terms of topic <b>" + this.value + "</b>");
            }
            
            $('.divTopics').hide();
            $('#divTopic-' + valueSelected).show();
        });
        
        $("#viewDescription").on('click', function(e) {
            $("#divDescription").toggle();
        });
       
    });
</script>

<hr/>
<%    
    String _vQuery = "";
    JSONObject result = null;
    JSONArray arr = null;
    JSONObject map = null;
    int topic = -1;
    if (request.getParameter("topic") != null && !"none".equals(request.getParameter("topic"))) {
        topic = Integer.parseInt(request.getParameter("topic"));        
    }
    
    if (request.getParameter("q") != null) {
        _vQuery = request.getParameter("q");
        if (request.getParameter("topic") != null && !"none".equals(request.getParameter("topic"))) {
            
//            result = queryTFIDF(out, IP, _vQuery);
            result = queryTFIDF_topicBased(IP, _vQuery, topic);
        }
        else
        {
//            q = "数年前";
            result = queryTFIDF(out, IP, _vQuery);
        }
    }
    
    if (result != null)
    {
        arr = result.getJSONArray("result");
        map = result.getJSONObject("map_data");
    }

    JSONObject topics = getTopics(IP);

%>

<script type="text/javascript">
    <%if(topic >=0 ) { %>
    $(document).ready(function() {
        $('.divTopics').hide();
        $('#divTopic-' + <%=topic%>).show();
    });   
    <%}%>
</script>
<form method="get">
    <input type="hidden" name="f" value="AdvanceSearch"/>
    Query: <input class='search-box' id="queryType1" type="text" name="q" value="<%=_vQuery%>" size="60"/>     

    <%= selectTopicString(topics, topic)%>
    <br/>
    Sample query (must be tokenized): <span style="font-style: italic; font-size: smaller">滅失 当時 の 本件 商品 の 価額 が 六 〇 万 円 で ある こと は すで に 述べ た とおり （ 原判決 七 枚 目 裏 四 行 目 から 同 八 枚 目 表 三行 目 まで ） で ある が 、 もし 被控訴人 が   れ 以下 で ある と 主張 する もの で ある なら ば 、 被控訴人 の 方 で これ を 立証 す べき 責任 が ある 。</span>
</form>
 
    <div>    
<%
    if (_vQuery != "") {
        out.println("<h2>Query: </h2>");
        if (request.getParameter("qid") != null) {

            out.println("<span class='query-id'>");
            out.println(request.getParameter("qid"));
            out.println("</span>");
        }
        out.println("<span class='query'>");
//        String name = new String(_vQuery.getBytes(), "EUC-JP");
//        out.println("XYZ:" + name );
        out.println(_vQuery);
        out.println("</span>");
    }
%>


<%--<%=request.getContextPath()%>--%> 
</div>

<div id="container" style="width: 90%;">
        <canvas id="canvas" style="width: 500px;height: 500px"></canvas>
</div>

<% if (map != null) {%>
<script>    
var view = function(e, item)
{
    console.log(item); //Debug in CHROME will show attibutes of item
    location.hash = "#result" + item[0]._datasetIndex;    
};
var DEFAULT_DATASET_SIZE = 7;
Chart.defaults.global.legend.display = false;

var bubbleChartData = <%=map.toString()%>;
window.onload = function() {
    var ctx = document.getElementById("canvas").getContext("2d");
    window.myChart = new Chart(ctx, {
        type: 'bubble',
        data: bubbleChartData,
        options: {
            responsive: true,
            title:{
                display:false,
                text:'Query-Documents map'
            },
            onClick: view,
            scales: {
                   xAxes: [{
                           display: true
//                           ticks: {
//                               min: -1.5,
//                               max: 1.5
//                           }
                       }],
                   yAxes: [{
                           display: true,
//                           ticks: {
//                               min: -1,
//                               max: 1
//                           }
                       }]
               }
        }
    });
};
</script>

<% }%>    
<%
    if (arr != null) {
        out.println("<h2>Top 20 relevant articles: </h2>");
        printResultString(arr, _vQuery, out);
    }
%>