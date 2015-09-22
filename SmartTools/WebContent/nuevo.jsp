<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bd.BD"%>
<%@ include file="header_logged.html"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page import="org.apache.commons.io.output.*"%>
<script type="text/javascript">
	function poner_accion() {
		var msg = "";
		var lb_error = "lb_error";
		var ctr;
		if ((ctr = document.getElementsByName("tb_nombre")[0].value) == "")
			msg = "El campo 'Nombre Concurso' es requerido";
		else if ((ctr = document.getElementsByName("tb_identificador")[0].value) == "")
			msg = "El campo 'Identificador' es requerido";
		else if ((ctr = document.getElementsByName("tb_fecha_inicio")[0].value) == "")
			msg = "El campo 'Fecha de Incio' es requerido";
		else if ((ctr = document.getElementsByName("tb_fecha_fin")[0].value) == "")
			msg = "El campo 'Fecha de Finalizacion' es requerido";
		else if ((ctr = document.getElementsByName("tb_descripcion")[0].value) == "")
			msg = "El campo 'Descripcion' es requerido";

		if (msg == "") {
			mostrar_progreso();
			document.getElementById("form1").submit();
		} else
			document.getElementById(lb_error).textContent = msg;
		return false;
	}
</script>
<form id="form1" name="form1" method="post"
	enctype="multipart/form-data">
	<h3>Nuevo Concurso</h3>
	<br />
	<%
		String id = request.getParameter("id");
		File file;
		int maxFileSize = 5000 * 1024;
		int maxMemSize = 5000 * 1024;
		ServletContext context = pageContext.getServletContext();
		String filePath = context.getInitParameter("root")+ context.getInitParameter("file-upload");
		String[] par = new String[7];
		int pos = 0;
		// Verify the content type
		String contentType = request.getContentType();
		if (contentType != null
				&& (contentType.indexOf("multipart/form-data") >= 0)) {
			par[pos++] = session.getAttribute("email").toString();
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
							par[pos++] = context.getInitParameter("file-upload")+file.getName();
						} else
							par[pos++] = "";
					} else {
						par[pos++] = fi.getString();
					}
				}
				String res = "", cor;
				if (id != null) {
					par[0] = id;
					res = BD.ejecutar_sqls("fn_upd_concurso", par, true);
				} else
					res = BD.ejecutar_sqls("fn_ins_concurso", par, true);
				cor = res.startsWith("Error") ? "red" : "green";
				out.println("<b style='color:" + cor + "'>" + res + "</b>");
			} catch (Exception ex) {
				ex.printStackTrace();
				out.println("<b style='color:red'>" + ex.getMessage()
						+ "</b>");
			}
		}
	%>
	<%
		String[] data = null;
		if (id != null)
			data = BD.ejecutar_sql_as("fn_get_concurso_id", id, true).get(0);
	%>
	<div class="cont">
		<table class="tabla">
			<tr>
				<td>Nombre del Concurso</td>
				<td><input type="text" maxlength="200"
					placeholder="Nombre del Concurso" name="tb_nombre"
					value="<%=data == null ? "" : data[2]%>" /></td>
			</tr>
			<tr>
				<td>Banner</td>
				<td><input type="file" name="fl_banner" /></td>
			</tr>
			<tr>
				<td>Identificador</td>
				<td><input type="text" maxlength="200"
					placeholder="Identificador" name="tb_identificador"
					value="<%=data == null ? "" : data[4]%>" /></td>
			</tr>
			<tr>
				<td>Fecha de Inicio</td>
				<td><input type="Date" name="tb_fecha_inicio"
					value="<%=data == null ? "" : data[5]%>" /></td>
			</tr>
			<tr>
				<td>Fecha de Finalizaci&oacute;n</td>
				<td><input type="date" name="tb_fecha_fin"
					value="<%=data == null ? "" : data[6]%>" /></td>
			</tr>
			<tr>
				<td>Descripci&oacute;n</td>
				<td><textarea maxlength="200" placeholder="Descripci&oacute;n"
						rows="4" maxlength="1000" name="tb_descripcion"><%=data == null ? "" : data[7]%></textarea></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<button onclick="return poner_accion();" style="margin: 0px auto;"><%=data == null ? "Crear" : "Actualizar"%></button>
				</td>
			</tr>
		</table>
	</div>
	<label id="lb_error" style="color: red"></label>
</form>
<%@ include file="footer.html"%>