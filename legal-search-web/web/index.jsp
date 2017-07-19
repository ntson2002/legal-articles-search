<%-- 
    Document   : index
    Created on : Jan 21, 2016, 5:03:11 PM
    Author     : ntson
--%>

<%@page import="bus.Account"%>
<%@page import="util.PageList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
   
    
//    String fullPath = context.getRealPath("/WEB-INF/test/foo.txt");

    String account_path = getServletContext().getRealPath("/data/data.json");
//    request.getContextPath() + 
//    out.println(account_path);
    
    request.setCharacterEncoding("utf-8");
    String f = request.getParameter("f");
    if (f == null)
        f = "Home";
    PageList c = PageList.valueOf(f);

    String VIEW = "../view/viewIndex.jsp";
    String TEMPLATE = "template/template.jsp";
    String loginURL = "index.jsp?f=Login";
    String homeURL = "index.jsp";    
    switch (c)
    {        
        case Search:
            Account.checkLoginStatus(session, response, loginURL);
            VIEW = "../view/viewSearch.jsp";
            break;
        case AdvanceSearch:
            Account.checkLoginStatus(session, response, loginURL);
            VIEW = "../view/viewAdvanceSearch.jsp";
            break;
        case Login:           
            if (request.getParameter("name") != null)
            {
                String name = request.getParameter("name");
                String password = request.getParameter("password");
                if (Account.checkAccount(account_path, name, password))
                {
                    session.setAttribute("ISLOGIN", true);
                    session.setAttribute("USERNAME", name);
                    response.sendRedirect(homeURL);
                    return;
                }
            }

            VIEW = "../view/viewLogin.jsp";
            break;
        case Logout:
            session.removeAttribute("ISLOGIN");
            session.removeAttribute("USERNAME");
            response.sendRedirect(loginURL);
            return;            
        default:                        
            VIEW = "../view/viewIndex.jsp";
            break;
    }
%>

<jsp:include page="<%=TEMPLATE%>">
    <jsp:param name="VIEW" value="<%=VIEW%>"/>
</jsp:include>
