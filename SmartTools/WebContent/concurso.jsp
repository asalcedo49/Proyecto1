<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bd.BD"%>
<%@ page import="bd.Formatos"%>
<!doctype html>
<html class="no-js" lang="en">
<head>
<meta charset="utf-8" />
<title>SmartTools</title>
<link rel="stylesheet" href="CSS/progress_ie7.css" />
<link rel="stylesheet" href="CSS/gral.css" />

</head>
<body>

	<% 
		String id = request.getParameter("id");
		String [] data = null;
		if(id==null)
		 	id = BD.ejecutar_sql_as("fn_get_concurso_identificador", request.getParameter("c"),true).get(0)[0];
		data = BD.ejecutar_sql_as("fn_get_concurso_id", id,true).get(0);
	%>
	<div style="background-color: white; min-height: 500px; padding: 0px 10px 10px 10px; width: 1000px; margin: 0px auto;">
		<div>
			<img src="<%= data[3] %>" height="64px"/>
			<h1 style="display: inline"><%= data[2] %></h1>
		</div>
		<div class="clear hideSkiplink">
			<ul id="menu2" class="menu3">
				<li><a id="A1" href="/SmartTools/concurso.jsp?id=<%= id %>"> Inicio</a></li>
				<li><a id="A1" href="/SmartTools/nuevo_video.jsp?id=<%= id %>"> Nuevo Video</a></li>
			</ul>

		</div>
		<div class="cont">
		<% 
			ArrayList<String[]> videos = BD.ejecutar_sql_as("fn_get_videos_ok", id, true);
			String []tmp;
			for(int i = 0; i<videos.size(); i++){
				tmp = videos.get(i);
				out.println(String.format(Formatos.FORMATO_VIDEO, 
						/*URL*/"/Videos/"+ tmp[0]+".mp4",
						/*Mensaje*/tmp[5],
						/*Nombres*/tmp[2],
						/*Fecha*/tmp[7]));
				
			}
		%>
		
		</div>
	</div>
</body>
</html>
