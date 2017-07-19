<%-- 
    Document   : template
    Created on : Jun 23, 2017, 2:47:20 PM
    Author     : sonnguyen
--%>

<%@page import="bus.Account"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
    <head>
        <title></title>
        <!--<?php require("include/meta.phtml"); ?>-->     
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link href="css/dropdown_menu.css" rel="stylesheet" type="text/css"/>
<!--        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js">
        </script>-->
        
        <script type="text/javascript" language="javascript" src="js/custom.js"></script>
        <script type="text/javascript" language="javascript" src="js/addon.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/flick/jquery-ui.css">
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
        
<!--        <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>        -->
        <script src="js/dist-chartjs/Chart.bundle.js"></script>
        <style type="text/css">
        canvas{
            -moz-user-select: none;
            -webkit-user-select: none;
            -ms-user-select: none;
        }
        </style>        
    </head>
    <body>
        <div id="header">            
            <div style="float:left">
                <img src="css/images/logo.jpg" style="height:60px"/> 
            </div>
            <div style="margin-left:200px; padding: 10px; height: 100%; vertical-align: middle; font-weight:bold; font-size:28pt; font-family: 'Palatino Linotype', 'Book Antiqua', Palatino, serif;">
                Topic-based information retrieval in legal texts</div>
        </div>
        <div id="topbar"></div>    
        <center>
        <div id="wrapper">   
            <div id="smallbar" style="text-align: left; padding-left: 10px; padding-top: 5px">
                <div style="float:left">
                <jsp:include page="./menu.html"/>
<!--                <?php 
                    include("include/menu.phtml"); 
                ?>-->
                </div>                                                                            
            <div style="float:right; margin-right: 10px">
            <%
//                out.write("XXX:" + Account.getLoginStatus(session).toString());

                if (Account.getLoginStatus(session))
                {
                    String name = Account.getLoginName(session);
                    %>
                    <form method="get">
                        <input type="hidden" name="f" value="Logout"/>
                        [ <strong><%=name%></strong> <input type="submit" value="Logout"/>]
                    </form>
                    <%
//                    String logoutLink = "<a href='./index.jsp?f=Logout'>Logout</a>";                    
//                    out.write("[ " + name + " "  + logoutLink + "]");
                    
                }
                else
                { 
                    %>
                    
                    <form method="post">
                        <input type="hidden" name="f" value="Login"/>
                        <input type="submit" value="Login"/>
                    </form>
                <%
                    }
            %>
            </div>
                
            </div> 
            <div id="content">    
                <!-- ------------------------------------ -->
                <!-- ------------------------------------ -->
                <!-- BEGIN: Nội dung chính của trang web  -->
                <div id="primary">                    
                    <!--<?php require($VIEW); ?>-->
                    <jsp:include page='<%=request.getParameter("VIEW") %>'/>
                </div>
                <!-- END: Nội dung chính của trang web  -->
                <!-- ------------------------------------ -->
                <!-- ------------------------------------ -->
                <!--<div id="secondary">-->                             
                <!--</div>-->
            </div>            
            <div id="footer">                
                Copyright by Japan Advanced Institute of Science and Technology - Nguyen Lab - 2015
            </div>
        </div>   
        </center>
    </body>
</html>
