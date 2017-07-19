<%@page contentType="text/html" pageEncoding="UTF-8"%>

    
        
    </meta>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
    <head>
        <title>Web site</title>
        <!--<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />-->
        <meta http-equiv="Content-Type" content="text/html; charset=EUC-JP"/>
        <meta http-equiv="Content-Language" content="ja"/>
        <meta name="title" content="Web site" />
        <meta name="description" content="Site description here" />
        <meta name="keywords" content="keywords here" />
        <meta name="language" content="en" />
        <meta name="subject" content="Site subject here" />
        <meta name="robots" content="All" />
        <meta name="copyright" content="Your company" />
        <meta name="abstract" content="Site description here" />
        <meta name="MSSmartTagsPreventParsing" content="true" />
        <link id="theme" rel="stylesheet" type="text/css" href="style.css" title="theme" />
        
        <script type="text/javascript" language="javascript" src="js/custom.js"></script>
        <script type="text/javascript" language="javascript" src="js/addon.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
    </head>
    <body> 
        <div id="top"> 
            <div class="overlay"></div> 
        </div> 

        <div id="wrapper"> 
            <div class="overlay"></div>  
            <div class="border-top"></div>  
            <div class="content"> 
                <div id="container"> 
<!--                    <div class="hd"> 
                        <div id="container-top"></div>  
                        <div id="banner"></div>  
                         MENU HERE !!!!!   
                    </div>  -->
                    <div class="bd"> 
                        <div id="page"> 
                            <!-- SIDEBAR HERE !!! --> 
                            
                            <!-- MAIN COLUMN -->  
                            <div id="main"> 
                                <div class="content"> 
                                    <jsp:include page='<%=request.getParameter("VIEW") %>'/>            
                                </div> 
                                <div class="sidebar">
                                    <div class="sidebox1"> 
                                        <h2>COLIEE 2015 queries</h2> 
                                        <jsp:include page='queries.html'/> 
                                    </div>
                                </div>
                            </div>  
                            <!-- END MAIN -->  
                            <div class="clear" style="height:60px"></div> 
                        </div> 
                    </div>  
                    <div class="ft"> 
                        <div id="footer"> 
                            <div class="content"> 
                                <a href="index.jsp?f=AdvanceSearch">Advance search: Multi-view search based on topic-modeling</a>
                            </div> 
                        </div>  
                        <div id="container-bottom"></div> 
                    </div> 
                </div> 
            </div> 
        </div>   
        <div class="clear"></div> 
    </body>
</html>                   
                                