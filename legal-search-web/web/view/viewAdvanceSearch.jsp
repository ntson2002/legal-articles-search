
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


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
//    String IP = "http://150.65.207.57:8081";
//    String IP = "http://150.65.242.122:8081";
        String IP = "http://127.0.0.1:8081";
%>
<%!
    public String topicTabString(JSONObject topics) throws RemoteException, Exception {
        Iterator<?> keys = topics.keys();        
        StringWriter sOut = new StringWriter();
        
        while (keys.hasNext()) {
            String key = (String) keys.next();
            String radioString = String.format("<input type='radio' id='radio-%s' name='topic' value='%s'/>", key, key);
            sOut.write(radioString);
        }
                
        keys = topics.keys();   
        sOut.write("<div id='tabs' style='font-size:smaller'>");
        sOut.write("<ul>");
        while (keys.hasNext()) {
            String key = (String) keys.next();
            sOut.write(String.format("<li><a class='atab' data-value='%s' href='#tabs-%s'>Topic %s</a></li>", key, key, key));
        }
        sOut.write("</ul>");
        keys = topics.keys();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            sOut.write(String.format("<div id='tabs-%s'>", key));        
            JSONArray words = topics.getJSONArray(key);
            for (int i = 0; i < words.length() && i < 20; i++) {
                JSONArray items = words.getJSONArray(i);
                String s = String.format("<span class='topic_word'>%s (%.2f)</span>", items.getString(0), 100 * Double.parseDouble(items.getString(1)));
                sOut.write(s);
            }
            sOut.write("</div>");
        }
        sOut.write("</div>");
        return sOut.toString();
    } 
    
    public JSONObject queryTFIDF_topicBased(String address, String query, int topic) throws Exception
    {
        String url = address + "/api/search2/" + query + "/topic/" + topic;
        JSONObject o = Rest.getJSONObjectFromURL(url);
        return o;
    }
    public JSONObject queryTFIDF(String address, String query) throws Exception
    {
        String url = address + "/api/search/" + query;
        JSONObject o = Rest.getJSONObjectFromURL(url);
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
        keys = topics.keys();
         while (keys.hasNext()) {
            String key = (String) keys.next();
            sOut.write(String.format("<div class='divTopics' id='divTopic-%s' style='display:none; margin-top:10px'>", key));        
            JSONArray words = topics.getJSONArray(key);
            for (int i = 0; i < words.length() && i < 20; i++) {
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
//        out.println(q);
        String temp = " " + q.toLowerCase() + " ";
        for (int i = 0; i < arr.length(); i++) {
            JSONObject doc = arr.getJSONObject(i);
            String text = doc.getString("text");
            String[] words = text.split(" ");

            StringBuffer result = new StringBuffer();
            for (int j = 0; j < words.length; j++) {
                if (temp.contains(" " + words[j].toLowerCase() + " ")) {
                    int count = 1;
                    String temp2 = words[j];
                    while (j + 1 < words.length && temp.contains(" " + words[j + 1].toLowerCase() + " ")) {
                        count++;
                        temp2 = temp2 + " " + words[j + 1];
                        j++;
                    }
                    if (count == 1 && util.Stopwords.STOPWORDS.contains(temp2)) {
                        result.append(temp2 + " ");
                    } else {
                        result.append("<span class='light'>" + temp2 + "</span> ");
                    }
                } else {
                    result.append(words[j] + " ");
                }
                //result.append( optional separator );
            }

            out.println("<div>");
            out.println("<h3>");
            String path = doc.getString("path");
            out.println("<span>" + (i + 1) + ". </span> " + path);
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


<h1>Legal topic-based Search</h1>
<script type="text/javascript">
    $(document).ready(function() {
        $('.expand').find('a[href="#"]').on('click', function(e) {
            e.preventDefault();
            this.expand = !this.expand;
            $(this).text(this.expand ? "Collapse" : "...");
            $(this).closest('.expand').find('.small, .big').toggleClass('small big');
        });
        
        $('#topic').change(function(){            
            var valueSelected = this.value;
            $('.divTopics').hide();
            $('#divTopic-' + valueSelected).show();
        });
        
//        $('#queryType1').change(function()
//        {
//            var s = $('#queryType1').val();
//            $('#queryType2').val(s);
//        });

//        $(function() {
//            $("#tabs").tabs();
//        });       
//        
//        $('.atab').click(function()
//        {
//            var i=$(this).data("value");
//            $("#radio-" + i).prop('checked', true);
//        });
    });
</script>

<hr/>
<%
    
    String _vQuery = "";
    String q = "";
    JSONObject result = null;
    JSONArray arr = null;
    JSONObject map = null;
    int topic = -1;
    if (request.getParameter("topic") != null && !"none".equals(request.getParameter("topic"))) {
        topic = Integer.parseInt(request.getParameter("topic"));        
    }
    
    if (request.getParameter("q") != null) {
        _vQuery = request.getParameter("q");
        q = _vQuery.replaceAll("[^a-zA-Z0-9 ]", " ").replaceAll("  ", " ").replaceAll(" ", "_");
        if (request.getParameter("topic") != null && !"none".equals(request.getParameter("topic"))) {
            
            result = queryTFIDF_topicBased(IP, q, topic);
        }
        else
            result = queryTFIDF(IP, q);
    }
    
    if (result != null)
    {
        arr = result.getJSONArray("result");
        map = result.getJSONObject("map_data");
    }

    String url = IP + "/api/topics";
    JSONObject topics = Rest.getJSONObjectFromURL(url);

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
    <%=selectTopicString(topics, topic)%>
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
        out.println(" " + _vQuery);
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