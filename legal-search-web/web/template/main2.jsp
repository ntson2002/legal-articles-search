<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
    <head>
        <title>Web site</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
                                <div class="content" style="width:100%"> 
                                    <jsp:include page='<%=request.getParameter("VIEW") %>'/>            
                                </div>                                 
                            </div>  
                            <!-- END MAIN -->  
                            <div class="clear" style="height:60px"></div> 
                        </div> 
                    </div>  
                    <div class="ft"> 
                        <div id="footer"> 
                            <div class="content"> 
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
                                