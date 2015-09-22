<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="bd.BD"%>

<%@ include file="header.html"%>
<script type="text/javascript">
	function poner_accion(accion) {
		var msg = "";
		var lb_error;
		var ctr;
		if(accion == "registrar"){
			lb_error = "lb_error";
			var reg_data = ""
			if((ctr = document.getElementsByName("tb_nombres")[0].value) == "")
				msg = "El campo 'Nombres' es requerido";
			else reg_data+= ctr+";";
			if((ctr = document.getElementsByName("tb_apellidos")[0].value) == "")
				msg = "El campo 'Apellidos' es requerido";
			else reg_data+= ctr+";"; 
			if((ctr = document.getElementsByName("tb_email")[0].value) == "")
				msg = "El campo 'Correo Electrónico' es requerido";
			else reg_data+= ctr+";"; 
			if((ctr = document.getElementsByName("tb_contrasena")[0].value) == "")
				msg = "El campo 'Contraseña' es requerido";
			else reg_data+= ctr;
			if((ctr = document.getElementsByName("tb_contrasena")[0].value) != document.getElementsByName("tb_conf_contrasena")[0].value)
				msg = "La contraseña y su confirmación no coinciden";
			document.getElementById("datos_reg").value = reg_data; 
		}
		else if(accion == "acceder"){
			
		}
		if(msg==""){
			mostrar_progreso();
			document.getElementById("accion").value = accion; 
			document.getElementById("form1").submit();
		}
		else document.getElementById(lb_error).textContent = msg;
		return false;
	}
</script>
<form id="form1" name = "form1" method="post">
	<input TYPE="HIDDEN" NAME="accion" id ="accion" value=""/>
	<div class="row">
		<div class="large-12 columns">
			<input TYPE="hidden" id="datos_reg" name ="datos_reg" value=""/>
			<div id="myModal" class="reveal-modal tiny" data-reveal	aria-labelledby="modalTitle" aria-hidden="true" role="dialog"
				style="text-align:center;">
				<p class="lead">Reg&iacute;strate</p>
				<input type="text" placeholder="Nombres" name="tb_nombres"  maxlength="200" />
				<input type="text" placeholder="Apellidos" name="tb_apellidos" maxlength="200"/> 
				<input type="text" placeholder="Correo Electr&oacute;nico" name="tb_email" maxlength="200"/> 
				<input type="password" placeholder="Contraseña" name="tb_contrasena" maxlength="200"/> 
				<input type="password" placeholder="Confirmar Contraseña" name="tb_conf_contrasena" maxlength="200"/>
				<button class="tiny button" onclick="return poner_accion('registrar');">Registrar</button>
				<a class="close-reveal-modal" aria-label="Close">&#215;</a>
				<label id="lb_error" style="color:red"></label>
			</div>
			<div class="panel">
				<h3>Bienvenido a Smart Tools !</h3>
				<br />
				<div style="width: 50%; margin: 0px auto; text-align: center;">
					<b>Inicia Sesi&oacute;n</b> o <a href="#" data-reveal-id="myModal">Reg&iacute;strate</a>
					<br /> <input type="text" placeholder="Correo Electr&oacute;nico" name ="tb_acc_email"/>
					<input type="password" placeholder="Contraseña" name = "tb_acc_contrasena"/>
					<button class="tiny button" onclick="return poner_accion('acceder');">Acceder</button>
				</div>
			</div>
		</div>
	</div>
	<% 
    	String accion = request.getParameter("accion"), email = null;
    	if(accion != null && accion.equals("registrar")){
    		String[] vals = request.getParameter("datos_reg").split(";");
    		String resp = BD.ejecutar_sqls("fn_ins_usuario", vals, true);
    		if(resp.startsWith("Error"))
    			out.println("<span style='color:red;'>"+resp+"</span>");
    		else email = vals[2];
    	}else if(accion != null && accion.equals("acceder")){
    		String[] vals = {request.getParameter("tb_acc_email"), request.getParameter("tb_acc_contrasena")};
    		String resp = BD.ejecutar_sqls("fn_get_usuario", vals, true);
    		if(resp.startsWith("Error"))
    			out.println("<span style='color:red;'>"+resp+"</span>");
    		else email = request.getParameter("tb_acc_email");
    	}
    	
    	if(email!=null){
    		session.setAttribute( "email", email.replace("'","") );
    		response.sendRedirect("./home.jsp");
    	}
	%>
</form>
<script src="foundation-5.5.2/js/vendor/jquery.js"></script>
    <script src="foundation-5.5.2/js/foundation.min.js"></script>
    <script>
      $(document).foundation();
    </script>
<%@ include file="footer.html"%>