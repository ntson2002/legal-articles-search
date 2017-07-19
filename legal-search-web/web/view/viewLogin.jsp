<%-- 
    Document   : viewLogin
    Created on : Jun 23, 2017, 11:08:15 AM
    Author     : sonnguyen
--%>

<%@page import="bus.Account"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<h1>Login</h1>
<form method="post">
    <input type="hidden" name="f" value="Login"/>
    <span class="block w100">Username:</span> <input type="text" name="name"/> <br/>
    <span class="block w100">Password:</span> <input type="password" name="password"/>  <br/>
    <input type="submit" value="Login"/>
</form>
