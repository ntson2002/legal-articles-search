<%-- 
    Document   : newjsp
    Created on : Mar 15, 2017, 2:54:42 PM
    Author     : sonnguyen
--%>

<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <form method="get">
            <input type="text" name="content"/>
            <input type="submit" value="submit"/>
            
        </form>
    </body>
    <%
//        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("utf-8");
        if (request.getParameter("content") != "")
        {
            
//            out.print(URLDecoder.decode(request.getParameter("content"),"utf-8"));
            out.print(request.getParameter("content"));
            out.print("コニチワ");
        }
        %>
        
</html>
