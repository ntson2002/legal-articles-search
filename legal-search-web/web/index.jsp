<%-- 
    Document   : index
    Created on : Jan 21, 2016, 5:03:11 PM
    Author     : ntson
--%>


<%@page import="util.PageList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    request.setCharacterEncoding("utf-8");
    String f = request.getParameter("f");
    if (f == null)
        f = "Home";
    PageList c = PageList.valueOf(f);
    
    String VIEW = "../view/viewIndex.jsp";
    String TEMPLATE = "template/main.jsp";
    switch (c)
    {
        case Search:
            VIEW = "../view/viewIndex.jsp";
            break;
        case AdvanceSearch:
            TEMPLATE = "template/main2.jsp";
            VIEW = "../view/viewAdvanceSearch.jsp";
            break;
        default:
            
            VIEW = "../view/viewIndex.jsp";
            break;
    }
%>

<jsp:include page="<%=TEMPLATE%>">
    <jsp:param name="VIEW" value="<%=VIEW%>"/>
</jsp:include>
