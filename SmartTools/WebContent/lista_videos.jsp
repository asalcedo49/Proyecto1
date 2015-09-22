<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bd.BD"%>
<%@ page import="bd.Formatos"%>
<%@ include file="header_logged.html"%>
<div class="cont">
	<% 
		String id = request.getParameter("id");
		ArrayList<String[]> data = BD.ejecutar_sql_as("fn_get_videos", id, true);
		out.println("<table class='menvid'>");
		String formato = "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>";
		out.println(String.format(formato.replace('d', 'h'),"Email", "Nombres", "Fecha de Cargue", "Estado",""));
		String [] tmp;
		for(int i =0;i<data.size();i++){
			tmp = data.get(i);
			out.println(String.format(formato, tmp[3], tmp[2],tmp[7],tmp[6].equals("0")?"En Proceso":"Convertido",
					"<a href='ver.jsp?id="+tmp[0]+"' >VER</a>"));
		}
		out.println("</table>");
	%>
		
</div>
<%@ include file="footer.html"%>