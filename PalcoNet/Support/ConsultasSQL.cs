﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Data.SqlTypes;
using System.Data;
using System.Configuration;
using System.Windows.Forms;
using System.Media;
using System.Data;

namespace PalcoNet.Support
{
    class ConsultaGeneral {
        internal static bool esVacio(String n)
        {
            return n == "";
        }

        internal static String fechaToString(DateTime fecha) {
            int anio = fecha.Year;
            int mes = fecha.Month;
            int dia = fecha.Day;
            int hora = fecha.Hour;
            int min = fecha.Minute;
            int seg = fecha.Second;

            return anio.ToString() +"/"+ mes.ToString()+"/" + dia.ToString() +" "+ hora.ToString()+":" + min.ToString() +":"+ seg.ToString();

        }
    }


    class Conexion
    {
        #region Atributos
        //LAPTOP-B6PL6D9G
        //\SQLSERVER2012
 //       private static String configuracionConexion = ConfigurationManager.AppSettings["conexionSQL"];
        private static SqlConnection conexion = new SqlConnection(@"Data source=.\SQLSERVER2012; Initial Catalog=GD2C2018; User id=gdEspectaculos2018; Password= gd2018");
        public static SqlConnection conexionObtener()
        {
            return conexion;
        }

        public static void conexionAbrir()
        {
            conexion.Open();
        }

        public static void conexionCerrar()
        {
            conexion.Close();
        }
        #endregion

        #region ConexionSQL
        /*
        public static SqlConnection conectar()
        {
            String ruta = "";
            return new SqlConnection(@"Data source=LAPTOP-B6PL6D9G\SQLSERVER2012; Initial Catalog=GD2C2018; User id=gdEspectaculos2018; Password= gd2018");
        }

        public void cerrarConeccion(SqlConnection sql)
        {
            sql.Close();
            return;
        }
        */
        

        public static SqlCommand consultaCrear(string consulta)
        {
            return new SqlCommand(consulta, conexionObtener());
        }

        public static int consultaEjecutar(SqlCommand consulta)
        {
            int resultado = 0;
            conexionAbrir();
            try
            {
                resultado = consulta.ExecuteNonQuery();
            }
            catch (Exception excepcion)
            {
                ventanaInformarErrorDatabase(excepcion);
            }
            conexionCerrar();
            return resultado;
        }

        public static DataSet consultaObtenerDatos(SqlCommand consulta)
        {
            DataSet dataSet = new DataSet();
            try
            {
                SqlDataAdapter dataAdapter = new SqlDataAdapter(consulta);
                dataAdapter.Fill(dataSet);
            }
            catch (Exception excepcion)
            {
                ventanaInformarErrorDatabase(excepcion);
            }
            return dataSet;
        }
            
        public static DataTable consultaObtenerTabla(SqlCommand consulta)
        {
            DataSet dataSet = consultaObtenerDatos(consulta);
            DataTable tabla = dataSet.Tables[0];
            return tabla;
        }

        public static List<string> consultaObtenerLista(SqlCommand consulta)
        {
            DataTable tabla = consultaObtenerTabla(consulta);
            List<string> columna = new List<string>();
            if (tabla.Rows.Count > 0)
                foreach (DataRow fila in tabla.Rows)
                    columna.Add(fila[0].ToString());
            return columna;
        }

        public static string consultaObtenerValor(SqlCommand consulta)
        {
            List<string> columna = consultaObtenerLista(consulta);
            if (columna.Count > 0)
                return columna[0];
            else
                return "";
        }

        public static DataRow consultaObtenerFila(SqlCommand consulta)
        {
            DataTable tabla = consultaObtenerTabla(consulta);
            if (tabla.Rows.Count > 0)
                return tabla.Rows[0];
            else
                return null;
        }

        public static bool consultaValorEsIgualA(string valor, int numero)
        {
            int resultado = Convert.ToInt32(valor);
            return resultado == numero;
        }

        public static bool consultaValorEsMayorA(string valor, int numero)
        {
            int resultado = Convert.ToInt32(valor);
            return resultado > numero;
        }

        public static bool consultaValorEsMenorA(string valor, int numero)
        {
            int resultado = Convert.ToInt32(valor);
            return resultado < numero;
        }

        public static bool consultaValorNoExiste(string valor)
        {
            return valor == "";
        }

        public static bool consultaValorExiste(string valor)
        {
            return valor != "";
        }

        #endregion

        #region Ventana

        public static void ventanaInformarErrorDatabase(Exception excepcion)
        {
            SystemSounds.Hand.Play();
            MessageBox.Show("ERROR EN LA BASE DE DATOS:\n" + excepcion.ToString(), "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        public static void ventanaInformarError(string mensaje)
        {
            SystemSounds.Hand.Play();
            MessageBox.Show("ERROR: " + mensaje, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error); 
        }

        public static void ventanaInformarExito(string mensaje)
        {
            SystemSounds.Exclamation.Play();
            MessageBox.Show("AVISO: " + mensaje, "Aviso", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
        #endregion
    
    #region Clase-consultas-general
    class ConsultasSQL {


        internal static void AgregarDomicilio(string calle, int numeroCalle, int piso, string dto, string localidad, string codigoPostal, string razonSocial, string cuit, string tipo_documento, string numeroDocumento)
        {

            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            SqlCommand addDomicilioCommand = new SqlCommand("insert into [GD2C2018].[SQLEADOS].[Domicilio] (domicilio_calle,domicilio_numero,domicilio_piso,domicilio_dto,domicilio_localidad,domicilio_codigo_postal,domicilio_empresa_razon_social,domicilio_empresa_cuit,domicilio_cliente_tipo_documento,domicilio_cliente_numero_documento) values (@calle,@numeroCalle,@piso,@dto,@localidad,@codigoPostal,@razonSocial,@cuit,@tipo_documento,@numeroDocumento)");
            addDomicilioCommand.Parameters.AddWithValue("calle", calle);
            addDomicilioCommand.Parameters.AddWithValue("numeroCalle", numeroCalle);
            addDomicilioCommand.Parameters.AddWithValue("piso", piso);
            addDomicilioCommand.Parameters.AddWithValue("dto", dto);
            addDomicilioCommand.Parameters.AddWithValue("localidad", localidad);
            addDomicilioCommand.Parameters.AddWithValue("codigoPostal", codigoPostal);
            addDomicilioCommand.Parameters.AddWithValue("razonSocial", razonSocial);
            addDomicilioCommand.Parameters.AddWithValue("cuit", cuit);
            addDomicilioCommand.Parameters.AddWithValue("tipo_documento", tipo_documento);
            addDomicilioCommand.Parameters.AddWithValue("numeroDocumento", Convert.ToInt32(numeroDocumento));
            
            

            addDomicilioCommand.Connection = connection;
            connection.Open();
            int registrosModificados = addDomicilioCommand.ExecuteNonQuery();
            connection.Close();
            if (registrosModificados > 0) MessageBox.Show("Domicilio ingresado correctamente", "Estado", MessageBoxButtons.OK, MessageBoxIcon.Information);
            else MessageBox.Show("Error al cargar registro Domicilio", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        internal static bool existeCuit(string cuit, string tipo)
        {
            String RS = null;
            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            SqlCommand tipoHabilitada = new SqlCommand("SELECT " + tipo + "_cuit FROM [GD2C2018].[SQLEADOS].[" + tipo + "] WHERE " + tipo + "_cuit = @cuit and " + tipo + "_estado = 1");
            tipoHabilitada.Parameters.AddWithValue("cuit", cuit);
            tipoHabilitada.Connection = connection;
            connection.Open();
            SqlDataReader reader = tipoHabilitada.ExecuteReader();
            while (reader.Read())
            {
                RS = reader[tipo+"_cuit"].ToString();
            }
            connection.Close();
            return RS != null;

        }

        internal static void darDeBaja(DataGridView dgv, string usuario)
        {
            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            connection.Open();
            try
            {
                String query = "UPDATE [GD2C2018].[SQLEADOS].[Usuario] SET usuario_estado = 0 WHERE usuario_username LIKE " + usuario;
            }
            catch (Exception)
            {
                MessageBox.Show("No se pudo dar de baja al usuario: "+ usuario);
            }
            connection.Close();
            return;
        }

        internal static bool nombreUserDisponible(String nombre)
        {
            String query = String.Format("SELECT usuario_nombre FROM GD2C2018.SQLEADOS.Usuario where usuario_nombre like '" + nombre + "'");
            DataSet usersEncontrados = DBConsulta.ConectarConsulta(query);
            if (DBConsulta.dataSetVacio(usersEncontrados))
            {
                MessageBox.Show("Usuario Disponible");
                return true; // NO ENCONTRO NADA, NO HACE NADA
            }
            return false;
        }

        /*Crea un usuario y devuelve su ID si todo va bien*/
        internal static int crearUser(String nombre, String apellido, bool caso, String contra, String tipo, String codigoRol)
        {
            string nombreUserCreado ="";
            bool creado = false;
            int i = 0, iniciado = 0;
            

            while (!creado)
            {
                /* CREA USUARIOS NUEVOS EN FORMATO <nombre>_<apellido>, SI EXISTEN, EMPIEZA A PONERLES UN NUMERO EL CUAL SE VA INCREMENTANDO
                 SI CONTINUAN LAS CONCIDENCIAS*/
                if (iniciado == 0)
                {
                    nombreUserCreado = nombre.ToLower().Replace(" ", "_") + "_" + apellido.ToLower().Replace(" ", "_");
                    iniciado++;
                }
                else {
                    nombreUserCreado = nombre.ToLower().Replace(" ", "_") + "_" + apellido.ToLower().Replace(" ", "_") + i.ToString();
                    i++;
                }
                /*El caso especial es por si ocurre un error en la conexión. Si hay se aborta todo*/
                creado = true;
            }
            if (caso == false) {
                if (tipo == "Cliente") {
                    return crearUnNuevoUserConNombre(nombreUserCreado, contra, "3", tipo, DateTime.Today);
                }
                // porque es empresa
                if (tipo == "Empresa") {
                    return crearUnNuevoUserConNombre(nombreUserCreado, contra, "2", tipo, DateTime.Today);
                }
                return crearUnNuevoUserConNombre(nombreUserCreado, contra, codigoRol, tipo, DateTime.Today);
            }
            return 0;
        }

        internal static int crearUnNuevoUserConNombre(String nombre, String contra, String rol, String tipo, DateTime fecha) {

            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            SqlCommand addUserCommand = new SqlCommand("insert into [GD2C2018].[SQLEADOS].[Usuario] (usuario_username,usuario_password,usuario_rol,usuario_tipo, usuario_fecha_creacion) values (@nombre,@contra,@rol,@tipo,@fecha)");
            addUserCommand.Parameters.AddWithValue("nombre", nombre);
            addUserCommand.Parameters.AddWithValue("rol", rol);
            addUserCommand.Parameters.AddWithValue("tipo", tipo);
            addUserCommand.Parameters.AddWithValue("fecha", ConsultaGeneral.fechaToString(fecha));

            Random random = new Random();
            int contraAPoner = random.Next(0, 10000000);

            /*
            SqlCommand contracmd = new SqlCommand("SELECT TOP 1 HASHBYTES('SHA2_256', (select top 1 STR(10000000*RAND(convert(varbinary, newid()))) magic_number))");
           contracmd.Connection = connection;
            
            if (contra == "")
            {
     //           int resultado = Conexion.consultaEjecutar(contracmd);
                SqlDataReader sqlreader = contracmd.ExecuteReader();
                contra = Conexion.consultaObtenerValor(contracmd);
     //           DataTable tabla = Conexion.consultaObtenerTabla(contracmd);
      //          DataRow datarowBuscado = tabla.Rows[0];
     //           contra = tabla.Rows[0].ToString();
      //          sqlreader.Close();
            }*/
            addUserCommand.Parameters.AddWithValue("contra", LoginSQL.loginEncriptarContraseña(contraAPoner.ToString()));

            connection.Open();
            addUserCommand.Connection = connection;
            int registrosModificados = addUserCommand.ExecuteNonQuery();
            connection.Close();
            if (registrosModificados > 0)
            {
                
       //         try
     //           {
                    String RS = null;
                    SqlCommand query = new SqlCommand("SELECT usuario_Id FROM [GD2C2018].[SQLEADOS].[Usuario] where usuario_username LIKE " + nombre + " AND SQLEADOS.func_coincide_fecha_creacion(usuario_fecha_creacion, " + ConsultaGeneral.fechaToString(fecha) + ")");
                    query.Connection = connection;

                    connection.Open();
                    RS = Conexion.consultaObtenerValor(query);
             /*   
                    SqlDataAdapter da = new SqlDataAdapter(query, connection);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    
                    
                    RS = dt.Rows[0][0].ToString();
            */
             



                    connection.Close();
                    MessageBox.Show("El usuario fue ingresado correctamente", "Estado", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return Convert.ToInt32(RS);
      //          }
    /*            catch (Exception ex)
                {
                    MessageBox.Show("Error al cargar registro Usuario", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    connection.Close();
                    return -1;
                }
           */     
                //         MessageBox.Show("Cliente fue ingresado correctamente", "Estado", MessageBoxButtons.OK, MessageBoxIcon.Information);
    //            SqlConnection connection1 = PalcoNet.Support.Conexion.conexionObtener();
    //            SqlCommand buscarID = new SqlCommand("SELECT usuario_Id FROM [GD2C2018].[SQLEADOS].[Usuario] where usuario_username LIKE " + nombre + " AND SQLEADOS.func_coincide_fecha_creacion(usuario_fecha_creacion, " + ConsultaGeneral.fechaToString(fecha) + ")");
      //          String buscarCMD = "SELECT usuario_Id FROM [GD2C2018].[SQLEADOS].[Usuario] where usuario_username LIKE " + nombre + " AND SQLEADOS.func_coincide_fecha_creacion(usuario_fecha_creacion, " + fecha.ToString() + ")";
      //          buscarID.Connection = connection1;
     //           connection1.Open();
        //        String RSS = Conexion.consultaObtenerValor(buscarID);
     //          SqlDataReader reader = buscarID.ExecuteReader();
    /*          String RS = null;
                while (reader.Read())
                {
                    RS = reader[0].ToString();
                }
      */  
       //         connection1.Close();
        
                
            }
            else
                MessageBox.Show("Error al cargar registro Usuario", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return -1;
            }           
    }
    #endregion

    #region ConsultaEmpresa
    class ConsultasSQLEmpresa : ConsultasSQL
    {
      /*  
       * internal bool existeCuit(string cuit)
        {
            String empresaRS = null;
            SqlConnection connection = new SqlConnection(@"Data source=.\SQLSERVER2012; Initial Catalog=GD2C2018; User id=gdEspectaculos2018; Password= gd2018");            
            SqlCommand empresaHabilitada = new SqlCommand("SELECT empresa_razon_social FROM [GD2C2018].[SQLEADOS].[Empresa] WHERE empresa_cuit = @cuit and empresa_estado = 1");
            empresaHabilitada.Parameters.AddWithValue("cuit", cuit);
            empresaHabilitada.Connection = connection;
            connection.Open();
            SqlDataReader reader = empresaHabilitada.ExecuteReader();
            while (reader.Read())
            {
                empresaRS = reader["empresa_razon_social"].ToString();
            }
            connection.Close();
            return empresaRS != null;
        }
        */
        internal static void AgregarEmpresa(string razonSocial, string cuit, string ciudad, string mail, string telefono, int usuario, DateTime fecha)
        {

            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            SqlCommand addEmpresaCommand = new SqlCommand("insert into [GD2C2018].[SQLEADOS].[Empresa] (empresa_razon_social,empresa_cuit,empresa_ciudad,empresa_email,empresa_telefono,empresa_usuario,empresa_fecha_creacion) values (@razonSocial,@cuit,@ciudad,@mail,@telefono,@usuario,@fecha)");
            addEmpresaCommand.Parameters.AddWithValue("razonSocial", razonSocial);
            addEmpresaCommand.Parameters.AddWithValue("cuit", cuit);
            addEmpresaCommand.Parameters.AddWithValue("ciudad", ciudad);
            addEmpresaCommand.Parameters.AddWithValue("mail", mail);
            addEmpresaCommand.Parameters.AddWithValue("telefono", telefono);
            addEmpresaCommand.Parameters.AddWithValue("usuario", usuario);
            addEmpresaCommand.Parameters.AddWithValue("fecha", fecha);

            addEmpresaCommand.Connection = connection;
            connection.Open();
            int registrosModificados = addEmpresaCommand.ExecuteNonQuery();
            connection.Close();
            if (registrosModificados > 0) MessageBox.Show("Empresa ingresada correctamente", "Estado", MessageBoxButtons.OK, MessageBoxIcon.Information);
            else MessageBox.Show("Error al cargar registro", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);


        }

        internal static void cargarGriddEmpresa(DataGridView dgv, string razonSocial, string cuit, string mail)
        {
            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            connection.Open();
            try
            {
                String query = "SELECT [empresa_razon_social],[empresa_cuit],[empresa_email],[empresa_ciudad],[empresa_telefono],[empresa_usuario] FROM [GD2C2018].[SQLEADOS].[Empresa] where [empresa_razon_social] like '" + razonSocial + "%' and [empresa_cuit] like '" + cuit + "%' and [empresa_email] like '" + mail + "%' ";
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgv.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("No se pudo llenar el DataGridView: " + ex.ToString());
            }
            connection.Close();
        }



    }
    #endregion

    #region consultaCliente
    class consultasSQLCliente : ConsultasSQL
    {
        internal static void llenarDGVCliente(DataGridView dgv, string nombre, string apellido, string numeroDNI, string mail)
        {
            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            connection.Open();
            try
            {
                String query = "SELECT [usuario_username],[cliente_nombre],[cliente_apellido],[cliente_tipo_documento],[cliente_numero_documento] FROM [GD2C2018].[SQLEADOS].[Cliente] where [cliente_nombre] like '%" + nombre + "%' or [cliente_apellido] like '%" + apellido + "%' or [cliente_email] like '" + mail + "%' or [cliente_numero_documento] = " + numeroDNI;
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgv.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("No se pudo llenar el DataGridView: " + ex.ToString());
            }
            connection.Close();
            return;
        }

        public static void cargarGriddCliente(DataGridView dgv, string nombre, string apellido, string numeroDNI, string mail)
        {
            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            connection.Open();
            try
            {
                String query = "SELECT [usuario_username],[cliente_nombre],[cliente_apellido],[cliente_tipo_documento],[cliente_numero_documento] FROM [GD2C2018].[SQLEADOS].[cliente] c JOIN [GD2C2018].[SQLEADOS].[usuario] u on u.usuario_Id = c.cliente_usuario and u.usuario_estado = 1  where ([cliente_nombre] like '%" + nombre + "%' and [cliente_apellido] like '%" + apellido + "%' and [cliente_email] like '" + mail + "%') or [cliente_numero_documento] = " + numeroDNI;
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgv.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("No se pudo llenar el DataGridView: " + ex.ToString());
            }
            connection.Close();
        }
        #region ocultar
        /*
        internal bool existeCUILCliente(string cuit) { 
            String clienteRS = null;
            SqlConnection connection = new SqlConnection(@"Data source=.\SQLSERVER2012; Initial Catalog=GD2C2018; User id=gdEspectaculos2018; Password= gd2018");
            SqlCommand clienteHabilitada = new SqlCommand("SELECT cliente_cuit FROM [GD2C2018].[SQLEADOS].[Cliente] WHERE cliente_cuit = @cuit and cliente_estado = 1");
            clienteHabilitada.Parameters.AddWithValue("cuit", cuit);
            clienteHabilitada.Connection = connection;
            connection.Open();
            SqlDataReader reader = clienteHabilitada.ExecuteReader();
            while (reader.Read())
            {
                clienteRS = reader["cliente_cuit"].ToString();
            }
            connection.Close();
            return clienteRS != null;
        }
         */
        /* ESTO NO ES USADO
        internal static void cargarGriddCliente(DataGridView dgv, string nombre, string apellido, string nroDNI, string mail)
        {
            SqlConnection connection = new SqlConnection(@"Data source=.\SQLSERVER2012; Initial Catalog=GD2C2018; User id=gdEspectaculos2018; Password= gd2018");
            connection.Open();
            try
            {
                String query = "SELECT [cliente_nombre],[cliente_apellido],[cliente_numero_documento],[cliente_email],[usuario_username] FROM [GD2C2018].[SQLEADOS].[Cliente] where [cliente_nombre] like '%" + nombre + "%' and [cliente_apellido] like '%" + apellido + "%' and [cliente_email] like '%" + mail + "%' and [cliente_numero_documento] = " + Int32.Parse(nroDNI);
                SqlDataAdapter da = new SqlDataAdapter(query, connection);
                DataTable dt = new DataTable();
                da.Fill(dt);
                dgv.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("No se pudo llenar el DataGridView: " + ex.ToString());
            }
            connection.Close();
        }
        */
        #endregion

        internal static void AgregarCliente(string nombre, string apellido, string tipo_documento, string nro_documento,
            int usuario, string mail, string datos_tarjeta, int puntaje, int estado, string cuit, string telefono, String fecha_nacimiento,
            DateTime fecha_creacion)
        {

            SqlConnection connection = PalcoNet.Support.Conexion.conexionObtener();
            SqlCommand addClienteCommand = new SqlCommand("insert into [GD2C2018].[SQLEADOS].[Cliente] (cliente_nombre,cliente_apellido,cliente_usuario,cliente_tipo_documento,cliente_numero_documento,cliente_fecha_nacimiento,cliente_fecha_creacion,cliente_datos_tarjeta,cliente_puntaje,cliente_email,cliente_telefono,cliente_estado,cliente_cuit) values (@nombre,@apellido,@user,@tipo_documento,@nro_documento,@fecha_nacimiento,@fecha_creacion, @datos_tarjeta, @puntaje, @mail, @telefono, @estado, @cuit)");            
            addClienteCommand.Parameters.AddWithValue("nombre", nombre);
            addClienteCommand.Parameters.AddWithValue("apellido", apellido);
            addClienteCommand.Parameters.AddWithValue("user", usuario);
            addClienteCommand.Parameters.AddWithValue("tipo_documento", tipo_documento);
            addClienteCommand.Parameters.AddWithValue("nro_documento", Convert.ToInt32(nro_documento));
            addClienteCommand.Parameters.AddWithValue("mail", mail);
            addClienteCommand.Parameters.AddWithValue("datos_tarjeta", datos_tarjeta);
            addClienteCommand.Parameters.AddWithValue("puntaje", puntaje);
            addClienteCommand.Parameters.AddWithValue("estado", estado);
            addClienteCommand.Parameters.AddWithValue("cuit", cuit);
            addClienteCommand.Parameters.AddWithValue("telefono", telefono);
            addClienteCommand.Parameters.AddWithValue("fecha_nacimiento", fecha_nacimiento);
            addClienteCommand.Parameters.AddWithValue("fecha_creacion", ConsultaGeneral.fechaToString(fecha_creacion));


            addClienteCommand.Connection = connection;
            connection.Open();
            int registrosModificados = addClienteCommand.ExecuteNonQuery();
            connection.Close();
            if (registrosModificados > 0) MessageBox.Show("Cliente ingresada correctamente", "Estado", MessageBoxButtons.OK, MessageBoxIcon.Information);
            else MessageBox.Show("Error al cargar registro", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

        }
    }
    #endregion

    #region LOGIN
    class LoginSQL : ConsultasSQL
    {
        public static int corroborarDatos(String user, String contra) {
            String query = String.Format("SELECT usuario_nombre, usuario_password, usuario_logins_fallidos, usuario_estado FROM GD2C2018.SQLEADOS.Usuario where usuario_nombre like '" + user + "'");
            DataSet usersEncontrados = DBConsulta.ConectarConsulta(query);
            if(DBConsulta.dataSetVacio(usersEncontrados)) {
              MessageBox.Show("No existe el usuario");
              return -1; // NO ENCONTRO NADA, NO HACE NADA
            }
            String nombreUser = usersEncontrados.Tables[0].Rows[0][0].ToString();
            byte[] pass = (byte[])usersEncontrados.Tables[0].Rows[0][1];
            String intentos_fallidos = usersEncontrados.Tables[0].Rows[0][2].ToString();
            String estadoUser = usersEncontrados.Tables[0].Rows[0][3].ToString();

            int nrointentos = Convert.ToInt32(intentos_fallidos);
            if (estadoUser == "0")
            {
                MessageBox.Show("Su usuario está bloqueado \nComuniquese con un administrador");
                //USER BLOQUEADO, NO SE HACE NADA PERO SE IMPOSIBILITA SU ENTRADA
                return -2;
            }
            else {
                if (!coincidenContrasenias(pass, contra))
                {
                    MessageBox.Show("Usuario o contraseña incorrecto\n\nLimite de tolerancia de intentos fallidos hasta ser bloqueado: 3 \nLogins fallidos cometidos por usted: " + (nrointentos++).ToString());
                    if (nrointentos < 3)
                    {
                        String subirIntentosFallidos = String.Format("UPDATE GD2C2018.SQLEADOS.Usuario SET usuario_logins_fallidos = usuario_logins_fallidos + 1 where usuario_nombre like  '" + user + "'");
                        DBConsulta.ModificarDB(subirIntentosFallidos);
                    }
                    else {
                        String subirIntentosFallidos = String.Format("UPDATE GD2C2018.SQLEADOS.Usuario SET usuario_estado = 0 where usuario_nombre like  '" + user + "'");
                        DBConsulta.ModificarDB(subirIntentosFallidos);
                    }
                    return 0; // DEBE SALTAR UNA VENTANA QUE MLA LA CONTRA Y EN CORRESPONDENCIA SUBE EL CONTADOR
                    // DE LOGIN
                }
                MessageBox.Show("Bienvenido: " + nombreUser);
                //Borrar todos los contadores de Logins fallidos para el usuario que ingresó
                String resetearCampoLoginsFallidos = String.Format("UPDATE GD2C2018.SQLEADOS.Usuario SET usuario_logins_fallidos = 0 where usuario_nombre like  '" + user + "'");
                DBConsulta.ModificarDB(resetearCampoLoginsFallidos);
                if (userTieneMasDe1Rol(ObtenerRoles(user)))
                {
                    // SIGNIFICA QUE EL USUARIO TIENE MAS DE 1 ROL, ABRE VENTANA DE SELECCION DE USER
                    return 2;
                }
                return 1; 
            }
        }

        public static byte[] loginEncriptarContraseña(String contrasenia)
        {
            using (SHA256 hash = SHA256Managed.Create())
            {
                Encoding encoder = Encoding.UTF8;
                return hash.ComputeHash(encoder.GetBytes(contrasenia));
            }
        }

        private static byte[] obtenerContraRealEncriptada(String contraReal) {
            return Encoding.ASCII.GetBytes(contraReal);
        }

        public static bool coincidenContrasenias(byte[] contraseniaReal, String contrasenia)
        {
            byte[] contraseniaEncriptada = loginEncriptarContraseña(contrasenia);
            return contraseniaEncriptada.SequenceEqual(contraseniaReal);
        }

        public static bool userTieneMasDe1Rol(DataSet DS) {
            return DS.Tables[0].Rows.Count > 1;
        }

        public static DataSet ObtenerRolesSinAdmin()
        {
            String query = String.Format("Select distinct r.rol_nombre from SQLEADOS.Rol r where rol_Id > 0");
            return DBConsulta.ConectarConsulta(query);
        }

        public static DataSet ObtenerRoles(String user) {
            String query;
            if (user == "")
            {
                query = String.Format("Select distinct r.rol_nombre from SQLEADOS.Rol r");
            }
            else {
                query = String.Format("Select r.rol_nombre from SQLEADOS.Rol r JOIN SQLEADOS.UserXRol ux on ux.userXRol_rol = r.rol_Id JOIN SQLEADOS.Usuario u ON u.usuario_Id = ux.userXRol_usuario where u.usuario_nombre LIKE '" + user + "'");

            }
            return DBConsulta.ConectarConsulta(query);
        }
        
    }
    #endregion

    #region Registro
    class RegistroSQL : ConsultasSQL {
        
    }

    #endregion
}