create table usuarios(
	id_usuario serial primary key,
	nombres varchar(200),
	apellidos varchar(200),
	email varchar(200),
	contrasena varchar(200),
	timestamp timestamp default current_timestamp
);
create table concursos(
	id_concurso serial primary key,
	id_usuario int references usuarios(id_usuario) not null,
	nombre varchar(200) unique not null,
	url_banner varchar(500),
	identificador varchar(200),
	fecha_inicio date,
	fecha_fin date,
	descripcion varchar(1000),
	timestamp timestamp default current_timestamp,
	activo boolean default true
);



create or replace function fn_get_id_usuario(
	_email varchar(200)
)
returns character varying AS
$body$
declare
	ivar int;
begin
	_email := lower(replace(_email, ' ',''));
	select a.id_usuario into ivar from usuarios a where a.email = _email;
	return ivar;
end;
$body$
language plpgsql;

create or replace function fn_get_usuario(
	_email varchar(200),
	_contrasena varchar(200)
)
returns character varying AS
$body$
begin
	_email := lower(replace(_email, ' ',''));
	if (select count(*) from usuarios a where a.email = _email and a.contrasena = _contrasena) > 0 then 
		return 'OK';
	else
		return 'Error - Usuario o contraseña inválidos';
	end if;
end;
$body$
language plpgsql;

create or replace function fn_ins_usuario(
    _nombres varchar(200),
	_apellidos varchar(200),
	_email varchar(200),
	_contrasena varchar(200)
)
returns character varying AS
$body$
declare
	ivar varchar;
begin
	_email := lower(replace(_email, ' ',''));
	select a.email into ivar from usuarios a where a.email = _email;
	if ivar is null then
		insert into usuarios(nombres, apellidos, email, contrasena) 
		values (_nombres, _apellidos, _email, _contrasena) ;
		ivar := 'Se agregó el usuario con éxito';
	else
		ivar := 'Error - El e-mail especificado ya exixte en la base de datos';
	end if;
	return ivar;
end;
$body$
language plpgsql;

create or replace function fn_get_usuario(
	_email varchar(200),
	_contrasena varchar(200)
)
returns character varying AS
$body$
begin
	_email := lower(replace(_email, ' ',''));
	if (select count(*) from usuarios a where a.email = _email and a.contrasena = _contrasena) > 0 then 
		return 'OK';
	else
		return 'Error - Usuario o contraseña inválidos';
	end if;
end;
$body$
language plpgsql;

create or replace function fn_ins_concurso(
	_email varchar(200),
    _nombre varchar(200),
	_url_banner varchar(500),
	_identificador varchar(200),
	_fecha_inicio varchar(12),
	_fecha_fin varchar(12),
	_descripcion varchar(1000)
)
returns character varying AS
$body$
declare
	ivar varchar;
begin
	select a.nombre into ivar from concursos a where a.nombre = _nombre or a.identificador = _identificador;
	if ivar is null then
		insert into concursos(id_usuario, nombre, url_banner, identificador, fecha_inicio, fecha_fin, descripcion) 
		values (fn_get_id_usuario(_email), _nombre, _url_banner, _identificador, to_date(_fecha_inicio,'yyyy-MM-dd'),
			to_date(_fecha_fin,'yyyy-MM-dd'), _descripcion) ;
		ivar := 'Se agregó el concurso con éxito';
	else
		ivar := 'Error - Nomre o identificador ya exixste';
	end if;
	return ivar;
end;
$body$
language plpgsql;


create or replace function fn_get_concursos(
	_email varchar(200)
)
returns setof concurso AS
$body$
	select *
	from concursos
	where fn_get_id_usuario(_email) = id_usuario;
$body$
language plpgsql;

create or replace function fn_get_concurso_id(
	_id_concurso varchar(20)
)
returns setof concursos AS
$body$
begin
	return query select *
	from concursos
	where _id_concurso::int = id_concurso;
end;
$body$
language plpgsql;

create table videos(
	id_video serial primary key,
	id_concurso int references concursos(id_concurso) not null,
	nombre varchar(200) not null,
	email varchar(200) not null,
	url_video_original varchar(500) not null,
	mensaje varchar(1000),
	estado_conversion int default 0 not null,
	fecha_creacion timestamp default current_timestamp,
	fecha_incio_batch timestamp,
	fecha_fin_batch timestamp
	
	
);
create or replace function fn_ins_video(
	_id_concurso varchar(20),
	_nombre varchar(200),
	_email varchar(200),
	_url_video_original varchar(500),
	_mensaje varchar(1000)
)
returns character varying AS
$body$
declare
	ivar varchar;
begin
	select a.nombre into ivar from concursos a where a.id_concurso = _id_concurso::int;
	if ivar is not null then
		insert into videos(id_concurso,nombre,email,url_video_original,mensaje)
		values (_id_concurso::int,_nombre,_email,_url_video_original,_mensaje);
		ivar := 'Se cargó el video con éxito. Se le notifcará via e-mail cuando este disponible';
	else
		ivar := 'Error - El concurso no exixste';
	end if;
	return ivar;
end;
$body$
language plpgsql;

create or replace function fn_get_videos(
	_id_concurso varchar(20)
)
returns setof videos AS
$body$
begin
	return query select *
	from videos
	where _id_concurso::int = id_concurso 
	order by fecha_creacion;
end;
$body$
language plpgsql;

create or replace function fn_get_videos_ok(
	_id_concurso varchar(20)
)
returns setof videos AS
$body$
begin
	return query select *
	from videos
	where _id_concurso::int = id_concurso and estado_conversion = 1
	order by fecha_creacion;
end;
$body$
language plpgsql;

create or replace function fn_get_videos_pendeites()
returns setof videos AS
$body$
begin
	update videos
		set fecha_incio_batch = current_timestamp
	where estado_conversion = 0;
	
	return query select *
	from videos
	where estado_conversion = 0
	order by fecha_creacion;
end;
$body$
language plpgsql;

create or replace function fn_upd_estado_video(
	_id_video varchar(20)
)
returns varchar AS
$body$
begin
	update videos
		set fecha_fin_batch = current_timestamp,
			estado_conversion = 1
	where id_video = _id_video::int;
	return 'OK';
end;
$body$
language plpgsql;

create or replace function fn_upd_concurso(
	_id_concurso varchar(20),
    _nombre varchar(200),
	_url_banner varchar(500),
	_identificador varchar(200),
	_fecha_inicio varchar(12),
	_fecha_fin varchar(12),
	_descripcion varchar(1000)
)
returns character varying AS
$body$
declare
	ivar varchar;
begin
	select a.nombre into ivar 
	from concursos a 
	where (a.nombre = _nombre or a.identificador = _identificador) and _id_concurso::int <> id_concurso;
	if ivar is null then
		update concursos 
			set nombre = _nombre, 
				url_banner = case _url_banner when '' then url_banner else _url_banner end, 
				identificador = _identificador, 
				fecha_inicio = to_date(_fecha_inicio,'yyyy-MM-dd'), 
				fecha_fin = to_date(_fecha_fin,'yyyy-MM-dd'), 
				descripcion =_descripcion 
		where _id_concurso::int = id_concurso;
		ivar := 'Se modificó el concurso con éxito';
	else
		ivar := 'Error - Nomre o identificador ya exixste';
	end if;
	return ivar;
end;
$body$
language plpgsql;

CREATE SEQUENCE id_general
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 11
  CACHE 1;
  
 
 
 create or replace function fn_get_id()
returns character varying AS
$body$
declare
begin
	return nextval('id_general')::varchar;
end;
$body$
language plpgsql;


create or replace function fn_get_video_id(
	_id_video varchar(20)
)
returns setof videos AS
$body$
begin
	return query select *
	from videos
	where _id_video::int = id_video;
end;
$body$
language plpgsql;

create or replace function fn_get_concurso_identificador(
	_identificador varchar(20)
)
returns setof concursos AS
$body$
begin
	return query select *
	from concursos
	where _identificador = identificador;
end;
$body$
language plpgsql;