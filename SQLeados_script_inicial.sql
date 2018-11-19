--Me conecto a la base de datos a usar
USE [GD2C2018]
GO

----------------------------------------------------------------------------------------------
								/** ELIMINACI�N DE CONSTRAINS DE TABLAS ANTERIORES **/
----------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM SYS.SCHEMAS WHERE name = 'SQLEADOS')
BEGIN
	DECLARE @Sql NVARCHAR(MAX) = '';

-------------------------------------
--		ELIMINACION DE CONSTRAINTS
-------------------------------------

	SELECT @Sql = @Sql + 'ALTER TABLE ' + QUOTENAME('SQLEADOS') + '.' + QUOTENAME(t.name) + ' DROP CONSTRAINT ' 
																		+ QUOTENAME(f.name)  + ';' + CHAR(13)
	FROM SYS.TABLES t 
	INNER JOIN SYS.FOREIGN_KEYS f ON f.parent_object_id = t.object_id 
	INNER JOIN SYS.SCHEMAS s ON t.SCHEMA_ID = s.SCHEMA_ID
	WHERE s.name = 'SQLEADOS'
	ORDER BY t.name;
	PRINT @Sql
	EXEC  (@Sql)


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.func_coincide_fecha_creacion'))
    DROP FUNCTION SQLEADOS.func_coincide_fecha_creacion

-------------------------------------
--		ELIMINACION DE TABLAS
-------------------------------------
	DECLARE @SqlStatement NVARCHAR(MAX)
	SELECT @SqlStatement = COALESCE(@SqlStatement, N'') + N'DROP TABLE [SQLEADOS].' + QUOTENAME(TABLE_NAME) + N';' + CHAR(13)
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA = 'SQLEADOS' AND TABLE_TYPE = 'BASE TABLE'
	PRINT @SqlStatement
	EXEC  (@SqlStatement)
	DROP SCHEMA SQLEADOS
END
GO



----------------------------------------------------------------------------------------------
								/** CREACION DE SCHEMA **/
----------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'SQLEADOS')
BEGIN
    EXEC ('CREATE SCHEMA SQLEADOS AUTHORIZATION gdEspectaculos2018')
END
GO

----------------------------------------------------------------------------------------------
								/** VALIDACION TABLAS **/
----------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.FuncionalidadXRol'))
    DROP TABLE SQLEADOS.FuncionalidadXRol

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Compra'))
    DROP TABLE SQLEADOS.Compra

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Domicilio'))
    DROP TABLE SQLEADOS.Domicilio

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.ubicacionXpublicacion'))
    DROP TABLE SQLEADOS.ubicacionXpublicacion

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Publicacion'))
    DROP TABLE SQLEADOS.Publicacion

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Empresa'))
    DROP TABLE SQLEADOS.Empresa

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Cliente'))
    DROP TABLE SQLEADOS.Cliente

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Usuario'))
    DROP TABLE SQLEADOS.Usuario

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Rol'))
    DROP TABLE SQLEADOS.Rol

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Funcionalidad'))
    DROP TABLE SQLEADOS.Funcionalidad

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Ubicacion'))
    DROP TABLE SQLEADOS.Ubicacion

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.GradoPrioridad'))
    DROP TABLE SQLEADOS.GradoPrioridad

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Rubro'))
    DROP TABLE SQLEADOS.Rubro

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Funcionalidad'))
    DROP TABLE SQLEADOS.Funcionalidad

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Factura'))
    DROP TABLE SQLEADOS.Funcionalidad

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.Factura'))
    DROP TABLE SQLEADOS.Factura

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.ItemFactura'))
    DROP TABLE SQLEADOS.ItemFactura

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.puntaje'))
    DROP TABLE SQLEADOS.puntaje
	
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.canjeproducto'))
    DROP TABLE SQLEADOS.canjeproducto

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.UserXRol'))
    DROP TABLE SQLEADOS.UserXRol
	
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SQLEADOS.func_coincide_fecha_creacion'))
    DROP TABLE SQLEADOS.func_coincide_fecha_creacion
	
----------------------------------------------------------------------------------------------
								/** CREACION de tablas **/
----------------------------------------------------------------------------------------------


create table [SQLEADOS].Funcionalidad(
funcionalidad_Id int primary key identity,
funcionalidad_descripcion nvarchar(255) not null)

create table [SQLEADOS].Rol(
rol_Id int primary key identity,
rol_nombre nvarchar(255) not null,
rol_estado bit default 1
)

create table [SQLEADOS].FuncionalidadXRol(
--ELIMINO FUNCIONALIDADXROL_ID
--	MOTIVO: La tabla solo referencia funcionalidad y rol, lo cual el ID deja de tener mucho sentido
funcionalidadXRol_rol int not null references [SQLEADOS].Rol,
funcionalidadXRol_funcionalidad int not null references [SQLEADOS].Funcionalidad,
)

create table [SQLEADOS].Usuario(
usuario_Id int primary key identity,
usuario_nombre varchar(255)  not null, --SACO EL UNIQUE AS� PUEDE ANDAR EL TRIGGER
usuario_password varbinary(100) not null,
usuario_tipo varchar(20) not null,
usuario_estado int default 1, --Indicador para saber si est� habilitado o no
usuario_logins_fallidos int default 0, --Como es un contador de intentos fallidos que cuenta hasta 3, iniciar� en 0
usuario_fecha_creacion datetime
)


create table [SQLEADOS].UserXRol(
userXRol_rol int not null references [SQLEADOS].Rol,
userXRol_usuario int not null references [SQLEADOS].Usuario
)


create table [SQLEADOS].Cliente(
--cliente_id int primary key identity,

cliente_nombre varchar(255) not null,
cliente_apellido varchar(255) not null,
cliente_usuario int references [SQLEADOS].Usuario,
cliente_tipo_documento varchar(5) not null,
cliente_numero_documento numeric(18,0) not null CHECK (cliente_numero_documento >= 0),
cliente_fecha_nacimiento datetime not null CHECK (YEAR(cliente_fecha_nacimiento) >= 1900),
cliente_fecha_creacion datetime not null,
cliente_datos_tarjeta varchar(255),
cliente_puntaje int default 0,
--cliente_compra int references [SQLEADOS].Compra,
cliente_email varchar(255) not null,
cliente_telefono varchar(255),
cliente_estado int default 1,
cliente_cuit varchar(20) unique, 
PRIMARY KEY (cliente_tipo_documento,cliente_numero_documento)
		--EJ: DNI 18563520
)

create table [SQLEADOS].Empresa(
empresa_cuit nvarchar(255),
empresa_razon_social varchar(255) not null unique,
empresa_fecha_creacion datetime,
empresa_email nvarchar(50),
empresa_usuario int references [SQLEADOS].Usuario,
empresa_ciudad varchar(255) ,
empresa_estado int default 1,
empresa_telefono varchar(20),
PRIMARY KEY (empresa_cuit,empresa_razon_social)
)

create table [SQLEADOS].Domicilio(
domicilio_id int primary key identity,
domicilio_calle varchar(255) not null,
domicilio_numero int not null CHECK (domicilio_numero >= 0),
domicilio_piso int CHECK (domicilio_piso >= 0),
domicilio_dto varchar(2),
domicilio_localidad varchar(255),
domicilio_codigo_postal int not null,
domicilio_cliente_tipo_documento varchar(5),
domicilio_cliente_numero_documento numeric(18,0),
domicilio_empresa_razon_social varchar(255),
domicilio_empresa_cuit nvarchar(255),
FOREIGN KEY (domicilio_cliente_tipo_documento, domicilio_cliente_numero_documento) REFERENCES [SQLEADOS].Cliente(cliente_tipo_documento,cliente_numero_documento),
FOREIGN KEY (domicilio_empresa_cuit,domicilio_empresa_razon_social)	REFERENCES [SQLEADOS].Empresa(empresa_cuit,empresa_razon_social)
)

create table [SQLEADOS].Rubro(
rubro_id int primary key identity,
rubro_descripcion varchar(255) not null,
)

create table [SQLEADOS].GradoPrioridad(
grado_id int primary key identity,
grado_nombre varchar(255) not null,
grado_comision numeric(10,2) not null,
)

create table [SQLEADOS].Ubicacion(
ubicacion_id int primary key identity,
ubicacion_fila nvarchar(3) not null,
ubicacion_asiento numeric(18,0) not null,
ubicacion_sin_numerar bit,
ubicacion_Tipo_codigo numeric(18,0),
ubicacion_Tipo_Descripcion nvarchar(255),
)

create table [SQLEADOS].Publicacion(
publicacion_codigo int primary key identity(12353,1),
publicacion_usuario_responsable int references [SQLEADOS].Usuario,
publicacion_rubro int references [SQLEADOS].Rubro not null,
publicacion_grado int references [SQLEADOS].GradoPrioridad not null,
publicacion_descripcion varchar(255),
publicacion_stock int not null,
publicacion_estado varchar(20) not null,
publicacion_puntaje_venta int not null default 100, -- DEFAULT 100 ES ARBITRARIO
pubicacion_putaje_compra int not null default 30, -- DEFAULT 30 ES ARBITRARIO (Cantidad de puntos que necesitas para comprarlo)
publicacion_fecha datetime not null,
publicacion_fecha_venc datetime not null,		--NUEVO CAMPO
publicacion_estado_validacion int default 0		--NUEVO CAMPO
)

create table [SQLEADOS].ubicacionXpublicacion(
ubiXpubli_ID int primary key identity,
ubiXpubli_Ubicacion int references [SQLEADOS].Ubicacion,
ubiXpubli_Publicacion int references [SQLEADOS].Publicacion,
ubiXpubli_precio int 
)

--TABLA NUEVA
create table [SQLEADOS].Factura(
factura_nro int primary key ,
factura_empresa_cuit nvarchar(255),
factura_empresa_razon_social varchar(255),
factura_fecha datetime,
factura_total decimal(14,2) not null CHECK (factura_total>0),
factura_forma_de_pago nvarchar(255),
FOREIGN KEY (factura_empresa_cuit, factura_empresa_razon_social) REFERENCES [SQLEADOS].Empresa(empresa_cuit, empresa_razon_social),
)

create table [SQLEADOS].Compra(
compra_id int primary key identity,
compra_factura int references SQLEADOS.Factura,
compra_cliente_tipo_documento varchar(5),
compra_cliente_numero_documento numeric(18,0),
compra_fecha datetime not null,
compra_cantidad numeric(18,0) not null,
compra_precio int not null,
compra_ubiXpubli int references [SQLEADOS].ubicacionXpublicacion,
FOREIGN KEY (compra_cliente_tipo_documento, compra_cliente_numero_documento) REFERENCES [SQLEADOS].Cliente(cliente_tipo_documento,cliente_numero_documento),

)


--TABLA NUEVA
create table [SQLEADOS].ItemFactura(
item_factura_id int primary key identity,
item_factura_nro int References SQLEADOS.FACTURA,
item_factura_monto decimal(16,2),
item_factura_cantidad numeric(18,0),
item_factura_descripcion nvarchar(60),
)

-- TABLA NUEVA
create table [SQLEADOS].puntaje(
punt_id int primary key identity,
punt_cliente_tipo_documento  varchar(5),
punt_cliente_numero_documento numeric(18,0),
--punt_premio varchar(255),
punt_fecha_vencimiento date,
punt_puntaje int,
punt_vencido int,	
FOREIGN KEY (punt_cliente_tipo_documento, punt_cliente_numero_documento) REFERENCES [SQLEADOS].Cliente(cliente_tipo_documento,cliente_numero_documento),
)

--TABLA CANJE DE PREMIOS
create table [SQLEADOS].canjeproducto(
canj_id int primary key identity,
canj_costo_puntaje int,
canj_producto varchar(50),
)

----------------------------------------------------------------------------------------------
								/** insertar en tablas **/
----------------------------------------------------------------------------------------------

--ROL

go
insert into SQLEADOS.Rol (rol_nombre) values
('Administrativo'), 
('Empresa'),
('Cliente');

---/** FUNCIONALIDAD **/
go
insert into SQLEADOS.Funcionalidad (funcionalidad_descripcion) values
('ABM de Rol'),
('Registro de usuarios'),
('ABM de Clientes'),
('ABM de Empresa de espectaculo'),
('ABM de Rubro'),
('ABM Grado de publicacion'),
('Generar Publicacion'),
('Editar Publicacion'),
('Comprar'),
('Historial de cliente'),
('Canje y Administracion de puntos'),
('Generar rendicion de comisiones'),
('Listado Estadistico');

--FUNCIONALIDAD POR ROL

--FUNCIONALIDADXROL ADMIN
go
insert into SQLEADOS.FuncionalidadXRol (funcionalidadXRol_funcionalidad, funcionalidadXRol_rol) 
select distinct A.funcionalidad_Id, 
	R.rol_Id												-- Referencia a administrativo
	from SQLEADOS.Funcionalidad A, SQLEADOS.Rol R
		where R.rol_nombre like 'Administrativo'
	order by 1

--FUNCIONALIDADXROL de CLIENTES
go
insert into SQLEADOS.FuncionalidadXRol (funcionalidadXRol_funcionalidad, funcionalidadXRol_rol)
select  
	funcionalidad_Id, 
	R.rol_Id												-- REFERENTE DE CLIENTES
	from SQLEADOS.Funcionalidad, SQLEADOS.Rol R
	where 
		(funcionalidad_descripcion LIKE 'Comprar' 
		OR funcionalidad_descripcion LIKE 'Historial de cliente' 
		OR funcionalidad_descripcion LIKE 'ABM de Clientes'
		OR funcionalidad_descripcion LIKE 'Canje y Administracion de puntos'
		OR funcionalidad_descripcion LIKE 'Registro de usuarios')
		AND R.rol_nombre like 'Cliente'
	order by 1


--	FUNCIONALIDADXROL DE EMPRESAS
go
insert into SQLEADOS.FuncionalidadXRol (funcionalidadXRol_funcionalidad, funcionalidadXRol_rol)
select distinct 
	F.funcionalidad_Id, 
	R.rol_Id												-- REFERENTE DE EMPRESAS
	from SQLEADOS.Funcionalidad F, SQLEADOS.Rol R
	where 
		(funcionalidad_descripcion LIKE 'Generar Publicacion' 
		OR funcionalidad_descripcion LIKE 'ABM de Rubro' 
		OR funcionalidad_descripcion LIKE 'Generar rendicion de comisiones'
		OR funcionalidad_descripcion LIKE 'Editar Publicacion'
		OR funcionalidad_descripcion LIKE 'Registro de usuarios'
		OR funcionalidad_descripcion LIKE 'ABM de Empresas de espectaculo')
		AND R.rol_nombre like 'Empresa'
	order by 1


--EMPRESA
go
insert into SQLEADOS.Empresa(empresa_razon_social,empresa_cuit,empresa_fecha_creacion,empresa_email)
select distinct Espec_Empresa_Razon_Social,Espec_Empresa_Cuit,Espec_Empresa_Fecha_Creacion,Espec_Empresa_Mail from gd_esquema.Maestra 
				order by Espec_Empresa_Razon_Social 

--DOMICILIO_EMPRESA
go
insert into SQLEADOS.Domicilio(domicilio_calle,domicilio_numero,domicilio_piso,domicilio_dto,
								domicilio_codigo_postal,domicilio_empresa_razon_social,domicilio_empresa_cuit)
select distinct Espec_Empresa_Dom_Calle,Espec_Empresa_Nro_Calle,Espec_Empresa_Piso,
				Espec_Empresa_Depto,Espec_Empresa_Cod_Postal,Espec_Empresa_Razon_Social,Espec_Empresa_Cuit from gd_esquema.Maestra 
				order by Espec_Empresa_Razon_Social

--CLIENTE
go
 PRINT('POR A CLIENTE') 
insert into SQLEADOS.Cliente(cliente_nombre,cliente_apellido,cliente_tipo_documento,cliente_numero_documento,
							cliente_fecha_nacimiento,cliente_fecha_creacion,cliente_puntaje,cliente_email,cliente_cuit)
select distinct Cli_Nombre,Cli_Apeliido,'DNI',Cli_Dni,Cli_Fecha_Nac,GETDATE(),0,Cli_Mail,CONCAT('20-',Cli_Dni,'-4') 
	from gd_esquema.Maestra where Cli_Dni is not null order by Cli_Nombre
 PRINT('PASA A CLIENTE') 
--DOMICILIO_CLIENTE
PRINT('POR A DOMICILIO') 
go
insert into SQLEADOS.Domicilio(domicilio_calle,domicilio_numero,domicilio_piso,domicilio_dto,
								domicilio_codigo_postal,domicilio_cliente_tipo_documento,domicilio_cliente_numero_documento)
select distinct Cli_Dom_Calle,Cli_Nro_Calle,Cli_Piso,Cli_Depto,Cli_Cod_Postal,'DNI',Cli_Dni from gd_esquema.Maestra where Cli_Dni is not null

PRINT('PASA A DOMICILIO') 
--USUARIO

--Usuarios ADMIN
/************************************************************
 USER ADMIN ->
	NOMBRE: admin
	CONTRA: pass123
***********************************************************/


PRINT('POR A USER') 
go
insert into SQLEADOS.Usuario(usuario_nombre, usuario_password,usuario_tipo, usuario_fecha_creacion) values
('admin',
HASHBYTES('SHA2_256', 'pass123'),
'Administrativo',
GETDATE()
)

--Usuarios clientes
PRINT('POR A CLIENTE') 
go
insert into SQLEADOS.Usuario(usuario_nombre, usuario_password,
	usuario_tipo, usuario_fecha_creacion)
select distinct 
	(LOWER(replace(A.Cli_Nombre, space(1), '_'))+'_'+A.Cli_Apeliido), -- as nombre_user
	(select top 1 HASHBYTES('SHA2_256', (select top 1 STR(10000000*RAND(convert(varbinary, newid()))) magic_number))), 
	--  contrase�as_autogeneradas,
	--CONTRASE�A AUTOGENERADA DE FORMA NUM�RICA DECIMAL, ES POCO PROBABLE QUE SE REPITA, est� entre 1 y 100000
	'Cliente', -- as tipo_user --TIPO USER
	GETDATE()
	from gd_esquema.Maestra A 
	where A.cli_mail is not null order by 1
	
--Usuarios Empresas
PRINT('POR A EMPRESA') 
go
insert into SQLEADOS.Usuario (usuario_nombre, usuario_password,usuario_tipo, usuario_fecha_creacion)
select distinct 
	(LOWER(replace(Espec_Empresa_Razon_Social, space(1), '_'))), --NOMBRE 
	(select top 1 HASHBYTES('SHA2_256', (select top 1 STR(10000000*RAND(convert(varbinary, newid()))) magic_number))), --contrase�as_autogeneradas
	'Empresa',
	GETDATE()
	from gd_esquema.Maestra



-- USERXROL
PRINT('POR A USERXROL ADMIN') 
-- ADMIN

go 
insert into SQLEADOS.UserXRol(userXRol_rol,userXRol_usuario)
select distinct 0, u.usuario_Id from SQLEADOS.Usuario u
	WHERE u.usuario_nombre LIKE 'admin'

 --EMPRESAS
 PRINT('USERXROL EMPRESA') 
go
insert into SQLEADOS.UserXRol(userXRol_rol,userXRol_usuario)
select distinct 1,u.usuario_Id from SQLEADOS.Usuario u
	INNER JOIN SQLEADOS.Empresa e ON (LOWER(replace(empresa_razon_social, space(1), '_'))) = u.usuario_nombre

--CLIENTE
 PRINT('USERXROL CLIENTE') 
go
insert into SQLEADOS.UserXRol(userXRol_rol,userXRol_usuario)
select distinct 2, u.usuario_Id from SQLEADOS.Usuario u
	INNER JOIN SQLEADOS.Cliente c ON (LOWER(replace(c.cliente_nombre, space(1), '_'))+'_'+c.cliente_apellido) = u.usuario_nombre

--RUBRO 


 PRINT('RUBRO') 
go
insert into SQLEADOS.Rubro(rubro_descripcion)
select distinct Espectaculo_Rubro_Descripcion from gd_esquema.Maestra

insert into SQLeados.Rubro(rubro_descripcion) values
('Musical'),
('Infaltil'),
('Comedia');

--Grado Publicacion
go
insert into SQLeados.GradoPrioridad(grado_nombre,grado_comision) values
('Alta',15),
('Media',10),
('Baja',5);




--PUBLICACION

go
insert into SQLEADOS.Publicacion(
			publicacion_rubro,
			publicacion_grado,
			publicacion_descripcion,
			publicacion_estado,
			publicacion_fecha,
			publicacion_fecha_venc,
			publicacion_stock,
			publicacion_usuario_responsable, 
			publicacion_estado_validacion)

select			2,  --Le asigno un rubro y grado por defecto
				2,
				A.Espectaculo_Descripcion,
				A.Espectaculo_Estado,
				A.Espectaculo_Fecha, 
				A.Espectaculo_Fecha_Venc,
				count(*) - count(Cli_Nombre) -(count(Cli_Nombre)/2),  --por cada asiento comprado hay 3 registros uno en null otro con la compra y otro con la facturacion por eso esta cuenta 
				U.usuario_Id,
				CASE							--VALIDACION SI LA FECHA DE VENCIMIENTO DEL ESPECTACULO ES MAYOR QUE LA ANUNCIADA
					WHEN 
						(
						NOT(YEAR(Espectaculo_Fecha) < YEAR(Espectaculo_Fecha_Venc)
						OR (YEAR(Espectaculo_Fecha) = YEAR(Espectaculo_Fecha_Venc) AND MONTH(Espectaculo_Fecha) < MONTH(Espectaculo_Fecha_Venc))
						OR (YEAR(Espectaculo_Fecha) = YEAR(Espectaculo_Fecha_Venc) AND MONTH(Espectaculo_Fecha) = MONTH(Espectaculo_Fecha_Venc) 
							AND DAY(Espectaculo_Fecha) < DAY(Espectaculo_Fecha_Venc)))
						)
						THEN 1
					ELSE 
						0
				END
				from gd_esquema.Maestra A
				JOIN SQLEADOS.Empresa E on E.empresa_cuit = A.Espec_Empresa_Cuit 
				JOIN SQLEADOS.Usuario U on U.usuario_nombre = (LOWER(replace(A.Espec_Empresa_Razon_Social, space(1), '_')))
				group by Espectaculo_Cod,Espectaculo_Descripcion,Espectaculo_Estado,Espectaculo_Fecha,Espectaculo_Fecha_Venc,usuario_Id 
				order by Espectaculo_Cod,usuario_Id
				

--UBICACION

insert into SQLEADOS.Ubicacion(ubicacion_asiento,ubicacion_fila,ubicacion_sin_numerar,
								ubicacion_Tipo_codigo,ubicacion_Tipo_Descripcion)
select distinct Ubicacion_Asiento, Ubicacion_Fila, 
	Ubicacion_Sin_numerar, Ubicacion_Tipo_Codigo, 
	Ubicacion_Tipo_Descripcion from gd_esquema.Maestra 

--UBICACIONXPUBLICACION

insert into SQLEADOS.ubicacionXpublicacion(
			ubiXpubli_Publicacion,
			ubiXpubli_Ubicacion,
			ubiXpubli_precio)
select distinct a.Espectaculo_Cod, u.ubicacion_id,a.Ubicacion_Precio from gd_esquema.Maestra a
	JOIN SQLeados.ubicacion u on u.ubicacion_asiento = a.Ubicacion_Asiento
								AND u.ubicacion_fila = a.Ubicacion_Fila
								AND u.ubicacion_sin_numerar = a.Ubicacion_Sin_numerar
								AND u.ubicacion_Tipo_codigo = a.Ubicacion_Tipo_Codigo
							AND u.ubicacion_Tipo_Descripcion = a.Ubicacion_Tipo_Descripcion
	order by 1

/* ITEM FACTURA Y FACTURA */


--Factura
GO
insert into [SQLEADOS].Factura(factura_nro, factura_empresa_cuit, 
								factura_empresa_razon_social, factura_fecha, 
								factura_total, factura_forma_de_pago)
	select distinct Factura_Nro, Espec_Empresa_Cuit, Espec_Empresa_Razon_Social, Factura_Fecha, Factura_Total, Forma_Pago_Desc
	from gd_esquema.Maestra
	where Factura_Nro is not null
	order by 1


--ItemFactura--
GO
insert into [SQLEADOS].ItemFactura(item_factura_nro, item_factura_monto, item_factura_descripcion, item_factura_cantidad)
select Factura_Nro, Item_Factura_Monto, Item_Factura_Descripcion, Item_Factura_Cantidad from gd_esquema.Maestra where Factura_Nro is not null order by Factura_Nro

--COMPRA--
go
insert into SQLEADOS.Compra(
			compra_factura,
			compra_cliente_tipo_documento,
			compra_cliente_numero_documento,
			compra_fecha,
			compra_cantidad,
			compra_precio,
			compra_ubiXpubli)
select distinct m.Factura_Nro,'DNI',m.Cli_Dni,m.Compra_Fecha, m.Compra_Cantidad,x.ubiXpubli_precio,x.ubiXpubli_ID from gd_esquema.Maestra m
join SQLeados.ubicacionXpublicacion x on m.Espectaculo_Cod = x.ubiXpubli_Publicacion 
join SQLeados.Ubicacion u on u.ubicacion_asiento = m.Ubicacion_Asiento and m.Ubicacion_Fila = u.ubicacion_fila and m.Ubicacion_Sin_numerar = u.Ubicacion_Sin_numerar
and m.Ubicacion_Tipo_Codigo = u.ubicacion_Tipo_codigo and u.ubicacion_Tipo_Descripcion = m.Ubicacion_Tipo_Descripcion 
where (m.Compra_Fecha is not null) and (m.Factura_Fecha is not null) and x.ubiXpubli_Ubicacion = u.ubicacion_id 

--PUNTAJE
go 
insert into SQLEADOS.puntaje(punt_cliente_numero_documento, punt_cliente_tipo_documento, punt_puntaje, punt_fecha_vencimiento, punt_vencido)
select distinct c.cliente_numero_documento, c.cliente_tipo_documento, SUM(p.pubicacion_putaje_compra),
	Convert(varchar(30),CONVERT(varchar(4), YEAR(com.compra_fecha+1))
			 + '-'+ 
			 CONVERT(varchar(2), MONTH(com.compra_fecha))
			  +'-'+ 
			   CONVERT(varchar(2),  DAY(com.compra_fecha)) + ' 00:00:00'
			  ,102),
		CASE
			WHEN YEAR(com.compra_fecha)+1 < YEAR(GETDATE())
					OR (YEAR(com.compra_fecha)+1 = YEAR(GETDATE()) AND MONTH(com.compra_fecha) < MONTH(GETDATE()))
					OR (YEAR(com.compra_fecha)+1 = YEAR(GETDATE()) AND MONTH(com.compra_fecha) = MONTH(GETDATE()) AND DAY(com.compra_fecha) < DAY(GETDATE()))
				THEN 0
			ELSE 1 END 
	from SQLEADOS.Cliente c
	join SQLEADOS.Compra com ON com.compra_cliente_numero_documento = c.cliente_numero_documento
								AND c.cliente_tipo_documento = com.compra_cliente_tipo_documento
	join SQLEADOS.ubicacionXpublicacion ubxp ON ubxp.ubiXpubli_ID = com.compra_ubiXpubli
	join SQLEADOS.Publicacion p on p.publicacion_codigo = ubxp.ubiXpubli_Publicacion
	GROUP BY c.cliente_numero_documento, c.cliente_tipo_documento, com.compra_fecha

--CANJE DE PREMIOS
go
insert into SQLEADOS.canjeproducto (canj_costo_puntaje, canj_producto) values
(1000, 'Taza PALCONET'), 
(2000, 'Gorra PALCONET'),
(3000, 'Remera PALCONET'),
(4000, 'Campera PALCONET'),
(5000, 'Viaje a Orlando Resort');

----------------------------------------------------------------------------------------------
								/** FUNCIONES, PROCEDURES Y TRIGGERS **/
----------------------------------------------------------------------------------------------
PRINT('Comienza UPDATE CLIENTE') 

UPDATE SQLEADOS.Cliente
SET cliente_usuario = usuario_Id 
FROM SQLEADOS.Cliente
INNER JOIN SQLEADOS.Usuario
       ON (LOWER(replace(cliente_nombre, space(1), '_'))+'_'+cliente_apellido) = usuario_nombre

PRINT('Comienza UPDATE EMPRESA') 

UPDATE SQLEADOS.Empresa
SET empresa_usuario = usuario_Id 
FROM SQLEADOS.Empresa
INNER JOIN SQLEADOS.Usuario
       ON (LOWER(replace(empresa_razon_social, space(1), '_'))) = usuario_nombre






GO
CREATE FUNCTION SQLEADOS.func_coincide_fecha_creacion (@fechaUser datetime, @fechaBuscada datetime) 
RETURNS bit 
AS 
BEGIN
	IF (@fechaUser = @fechaBuscada) 
	BEGIN
		RETURN 1
	END
	RETURN 0
END



GO
CREATE TRIGGER 
	TRIG_fecha_publicada_es_menor_a_vencimiento on [SQLEADOS].[Publicacion]
for insert as
	begin 
		declare @fecha1 datetime
		declare @fecha2 datetime
		declare @indice int
			select 
				@fecha1 = publicacion_fecha,
				@fecha2 = publicacion_fecha_venc,
				@indice = publicacion_codigo
				from SQLEADOS.Publicacion
				
				IF( 
					NOT(YEAR(@fecha1) < YEAR(@fecha2)
					OR (YEAR(@fecha1) = YEAR(@fecha2) AND MONTH(@fecha1) < MONTH(@fecha2))
					OR (YEAR(@fecha1) = YEAR(@fecha2) AND MONTH(@fecha1) = MONTH(@fecha2) AND DAY(@fecha1) < DAY(@fecha2)))
				) 
					update SQLEADOS.Publicacion
					set publicacion_estado_validacion = 1
					where 
				--		(NOT(YEAR(@fecha1) < YEAR(@fecha2)
				--		OR (YEAR(@fecha1) = YEAR(@fecha2) AND MONTH(@fecha1) < MONTH(@fecha2))
				--		OR (YEAR(@fecha1) = YEAR(@fecha2) AND MONTH(@fecha1) = MONTH(@fecha2) AND DAY(@fecha1) < DAY(@fecha2))))
				--		AND 
						publicacion_codigo=@indice;
		END

GO
CREATE TRIGGER 
	TRIG_poner_nombre_bien_al_user on [SQLEADOS].[Usuario]
for insert as
	begin 
		declare @UsuarioNombre varchar(255)
		declare @nombreOriginal varchar(255)
		declare @contaseniaOriginal varchar(255)
		declare @numero int = 0
		declare @userID int
		
			Select 
				@UsuarioNombre = usuario_nombre,
				@nombreOriginal = @UsuarioNombre,
				@contaseniaOriginal = usuario_password,
				@userID = usuario_Id
				from [SQLEADOS].Usuario u
							
				WHILE((select count(*) from [SQLEADOS].Usuario u1 
							WHERE @UsuarioNombre LIKE u1.usuario_nombre)							
								) > 0 
					 
					select 
						@UsuarioNombre = @nombreOriginal + CONVERT(varchar(10),@numero),
						@numero = @numero +1
						from [SQLEADOS].Usuario
							where @UsuarioNombre LIKE usuario_nombre
							order by usuario_Id DESC
				update [SQLEADOS].Usuario
					set usuario_password = HASHBYTES('SHA2_256', @contaseniaOriginal)
					Where usuario_nombre=@nombreOriginal AND usuario_Id = @userID;
				if(@numero>0) 
					update [SQLEADOS].Usuario
						set usuario_nombre = @UsuarioNombre
						where 
							usuario_nombre=@nombreOriginal AND usuario_Id = @userID;
		END


 
/*
	DE PRUEBA
*/
insert into SQLEADOS.Usuario(usuario_nombre, usuario_password,usuario_tipo, usuario_fecha_creacion) values
('prueba',
HASHBYTES('SHA2_256', '123'),
'Administrativo',
GETDATE()
)

insert into SQLEADOS.UserXRol(userXRol_rol, userXRol_usuario)
select 
	rol_Id,
	usuario_Id
	from SQLEADOS.Rol, SQLEADOS.Usuario
		where usuario_nombre LIKE 'prueba'
