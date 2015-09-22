<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bd.BD"%>
<%@ page import="bd.Formatos"%>
<%@ include file="header_logged.html"%>
<h2>Concursos Existentes</h2>
<div class="cont">
	<% 
		ArrayList<String[]> data = BD.ejecutar_sql_as("fn_get_concursos", session.getAttribute("email").toString(),true);
		if(data==null)out.write("Ha ocurrido un error");
		else{
			String prefijo = " ";
			String [] tmp;
			for(int i =0;i<data.size();i++){
				tmp = data.get(i);
				out.println(String.format(Formatos.FORMATO_CONCURSO, tmp[3].equals("")?"CSS/img/three115.png":prefijo+tmp[3],tmp[2],tmp[0],tmp[0],tmp[0],"concurso.jsp?c="+tmp[4],tmp[5],tmp[6],tmp[7]));
			}
		}
	%>
</div>
<%@ include file="footer.html"%>