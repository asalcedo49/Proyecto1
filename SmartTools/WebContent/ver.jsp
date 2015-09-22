<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bd.BD"%>
<%@ page import="bd.Formatos"%>
<%@ include file="header_logged.html"%>
<div class="cont">

		<% 
			String id = request.getParameter("id");
			String[] data = null;
			data = BD.ejecutar_sql_as("fn_get_video_id", id, true).get(0);
			String url = data[6].equals("0")? data[4]: data[0]+".mp4";
			String tipo = url.substring(url.indexOf('.')+1);
		%>
		<video  controls preload='metadata' width='800' height='560' data-setup='{}' style="display: block;margin:0px auto;">
			<source src='<%= url %>' type='video/<%= tipo %>' />
		</video>
</div>
<%@ include file="footer.html"%>