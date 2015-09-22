	<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bd.BD"%>
<%@ page import="bd.Formatos"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page import="org.apache.commons.io.output.*"%>
<!doctype html>
<html class="no-js" lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>SmartTools</title>

<link rel="stylesheet" href="CSS/progress_ie7.css" />
<link rel="stylesheet" href="CSS/gral.css" />

<script type="text/javascript">
	function mostrar_progreso() {
		document.getElementById("div_process").style.display = "block";
		return false;
	}
	function ocultar_progreso() {
		document.getElementById("div_process").style.display = "none";
		return false;
	}
</script>
<script type="text/javascript">
	function poner_accion() {
		var msg = "";
		var lb_error = "lb_error";
		var ctr;
		if((ctr = document.getElementsByName("tb_nombre")[0].value) == "")
			msg = "El campo 'Nombre Completo' es requerido";
		else if((ctr = document.getElementsByName("tb_email")[0].value) == "")
			msg = "El campo 'Email' es requerido";
		else if((ctr = document.getElementsByName("fl_video")[0].value) == "")
			msg = "Debe seleccionar un video.";
		else if((ctr = document.getElementsByName("tb_mensaje")[0].value) == "")
			msg = "El campo 'Mensaje' es requerido"; 
		
		if(msg==""){
			mostrar_progreso();
			document.getElementById("form1").submit();
		}
		else document.getElementById(lb_error).textContent = msg;
		return false;
	}
</script>
</head>
<body>
	<div class="progressBackgroundFilter" id="div_process"
		style="display: none;">
		<div class="processMessage">
			<br /> Un momento por favor...<br /> <br /> <img
				src="CSS/img/Loading9.gif" alt="- - -" /> <br /> <br />
		</div>
	</div>
	<div class="progressBackgroundFilter" id="div_bc"
		style="display: none;"></div>
	<div class="processMessage" style="display: none" id="div_msg">
		<br /> <label id="lb_message">text</label><br /> <br />
		<button onclick="return ocultar_mensaje();" id="bt_aceptar_mensaje"
			class="tiny button">Aceptar</button>
		<br /> <br />
	</div>
	<%
		String id = request.getParameter("id");
		String[] data = BD.ejecutar_sql_as("fn_get_concurso_id", id, true)
				.get(0);
	%>
	<div
		style="background-color: white; min-height: 500px; padding: 0px 10px 10px 10px; width: 1000px; margin: 0px auto;">
		<div>
			<img src="<%=data[3]%>" height="64px"/>
			<h1 style="display: inline"><%=data[2]%></h1>
		</div>
		<div class="clear hideSkiplink">
			<ul id="menu2" class="menu3">
				<li><a id="A1" href="/SmartTools/concurso.jsp?id=<%=id%>">
						Inicio</a></li>
				<li><a id="A1" href="/SmartTools/nuevo_video.jsp?id=<%=id%>">
						Nuevo Video</a></li>
			</ul>

		</div>
		<form id="form1" name="form1" method="post"
			enctype="multipart/form-data">
			<h3>Nuevo Video</h3>
			<br />
			<div class="cont">
				<table class="tabla" style="width: 80%">
					<tr>
						<td>Nombre Completo</td>
						<td><input type="text" maxlength="200"
							placeholder="Nombre Completo" name="tb_nombre" /></td>
					</tr>
					<tr>
						<td>Email</td>
						<td><input type="email" maxlength="200"
							placeholder="Email" name="tb_email" /></td>
					</tr>
					<tr>
						<td>Video</td>
						<td><input type="file" name="fl_video" /></td>
					</tr>
					<tr>
						<td>Mensaje</td>
						<td><textarea maxlength="200"
								placeholder="Descripci&oacute;n" rows="4" maxlength="1000"
								name="tb_mensaje"></textarea></td>
					</tr>
					<tr>
						<td colspan="2">
							<center>
								<button  onclick="return poner_accion();">Crear</button>
							</center>
						</td>
					</tr>
				</table>
			</div>
			<label id="lb_error" style="color: red"></label>
			<%
				File file;
				int maxFileSize = 5000000 * 1024;
				int maxMemSize = 5000000 * 1024;
				ServletContext context = pageContext.getServletContext();
				String filePath = context.getInitParameter("root")+ context.getInitParameter("video-upload");
				String[] par = new String[5];
				int pos = 0;
				// Verify the content type
				String contentType = request.getContentType();
				if (contentType != null
						&& (contentType.indexOf("multipart/form-data") >= 0)) {
					par[pos++] = id;
					DiskFileItemFactory factory = new DiskFileItemFactory();
					// maximum size that will be stored in memory
					factory.setSizeThreshold(maxMemSize);
					// Location to save data that is larger than maxMemSize.
					factory.setRepository(new File("c:\\temp"));

					// Create a new file upload handler
					ServletFileUpload upload = new ServletFileUpload(factory);
					// maximum file size to be uploaded.
					upload.setSizeMax(maxFileSize);
					try {
						// Parse the request to get file items.
						List fileItems = upload.parseRequest(request);

						// Process the uploaded file items
						Iterator i = fileItems.iterator();

						while (i.hasNext()) {
							FileItem fi = (FileItem) i.next();
							if (!fi.isFormField()) {
								// Get the uploaded file parameters
								String fieldName = fi.getFieldName();
								String fileName = BD.get_name(fi.getName());
								boolean isInMemory = fi.isInMemory();
								long sizeInBytes = fi.getSize();
								// Write the file
								if (!fileName.equals("")) {
									if (fileName.lastIndexOf("\\") >= 0) {
										file = new File(filePath
												+ fileName.substring(fileName
														.lastIndexOf("\\")));
									} else {
										file = new File(filePath
												+ fileName.substring(fileName
														.lastIndexOf("\\") + 1));
									}
									fi.write(file);
									par[pos++] = context.getInitParameter("video-upload")+ file.getName();
								} else
									par[pos++] = "";
							} else {
								par[pos++] = fi.getString();
							}
						}
						String res = BD.ejecutar_sqls("fn_ins_video", par, true), cor;
						cor = res.startsWith("Error") ? "red" : "green";
						out.println("<b style='color:" + cor + "'>" + res + "</b>");
					} catch (Exception ex) {
						ex.printStackTrace();
						out.println("<b style='color:red'>" + ex.getMessage()
								+ "</b>");
					}
				}
			%>
		</form>
	</div>
</body>
</html>