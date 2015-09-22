package bd;

public class Formatos {
	public final static String FORMATO_VIDEO = 
			"<table class='menvid'><tr><td><video  controls preload='metadata' width='400' height='267' data-setup='{}'><source src='%s' type='video/mp4' /></video></td><th>Mensaje</th><td style='width:100%%'>%s</td></tr><tr><th>Nombres</th><td colspan='2'>%s</td></tr><tr><th>Fecha</th><td colspan='2'>%s</td></tr></table>";
	public final static String FORMATO_CONCURSO =
			"<table class='menvid'><tr><td rowspan='5' ><img src='%s' width='64px' height='64px'/></td><th style='width:25%%;'>Nombre</th><td style='width:75%%;'>%s</td><td rowspan='5'><a class='mmenu' href='lista_videos.jsp?id=%s' style='width:70px;'><img src='CSS/img/movie43.png' alt='' /><br />Videos</a></td><td rowspan='5'><a class='mmenu' href='nuevo.jsp?id=%s' style='width:70px;'><img src='CSS/img/edit26.png' alt='' /><br />Editar</a></td></tr><tr><th>URL</th><td><a href='concurso.jsp?id=%s'>%s</a></td></tr><tr><th>Fecha Inicio</th><td>%s</td></tr><tr><th>Fecha Fin</th><td>%s</td></tr><tr><th>Descripci&oacute;n</th><td>%s</td></tr></table>";
}
