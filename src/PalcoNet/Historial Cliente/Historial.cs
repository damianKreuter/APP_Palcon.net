﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using PalcoNet.Support;

namespace PalcoNet.Historial_Cliente
{
    public partial class Historial : TablaPaginadas
    {
        private int userID;
        private int paginaActual;
        private int ultimaHoja;
        private int totalVistoPorPagina = 10;
        Explorador exx;
        public Historial(int user, Explorador ex)
        {
            exx = ex;
            userID = user;
            paginaActual = 1;
            InitializeComponent();
            
        }

        private void Historial_Load(object sender, EventArgs e)
        {
            DBConsulta.conexionAbrir();
            String res = DBConsulta.obtenerTotalHistorialCompras(userID).Rows[0][0].ToString();
            int cantidad = Convert.ToInt32(res);
            ultimaHoja = (cantidad / totalVistoPorPagina) + 1;
            configuracionGrilla(DBConsulta.obtenerHistorialCompras(userID, 1, totalVistoPorPagina));
            DBConsulta.conexionCerrar();
        }

        private void configuracionGrilla(DataTable dt)
        {
            dataGridView1.DataSource = dt;

            DataGridViewColumn column = dataGridView1.Columns[0];
            column.Width = 50;
            DataGridViewColumn column1 = dataGridView1.Columns[1];
            column1.Width = 80;
            DataGridViewColumn column2 = dataGridView1.Columns[2];
            column2.Width = 210;
            DataGridViewColumn column3 = dataGridView1.Columns[3];
            column3.Width = 80;
            DataGridViewColumn column4 = dataGridView1.Columns[4];
            column4.Width = 100;
            DataGridViewColumn column5 = dataGridView1.Columns[5];
            column4.Width = 90;

            labelPaginas.Text = paginaActual.ToString() + " de " + ultimaHoja.ToString();
            return;
        }

        private void botonAnterior_Click(object sender, EventArgs e)
        {
            if (paginaActual > 1)
            {
                paginaActual -= 1;
                DBConsulta.conexionAbrir();
                configuracionGrilla(DBConsulta.obtenerHistorialCompras(userID, paginaActual, totalVistoPorPagina));
                labelPaginas.Text = paginaActual.ToString() + " de " + ultimaHoja.ToString();
                DBConsulta.conexionCerrar();
            }
        }

        private void botonsiguiente_Click(object sender, EventArgs e)
        {
            if (paginaActual < ultimaHoja)
            {
                paginaActual += 1;
                DBConsulta.conexionAbrir();
                configuracionGrilla(DBConsulta.obtenerHistorialCompras(userID, paginaActual, totalVistoPorPagina));
                labelPaginas.Text = paginaActual.ToString() + " de " + ultimaHoja.ToString();
                DBConsulta.conexionCerrar();
            }
        }

        //Vuelve a la primera hoja
        private void buttonPrimeraHoja_Click(object sender, EventArgs e)
        {
            paginaActual = 1;
            DBConsulta.conexionAbrir();
            configuracionGrilla(DBConsulta.obtenerHistorialCompras(userID, paginaActual, totalVistoPorPagina));
            labelPaginas.Text = paginaActual.ToString() + " de " + ultimaHoja.ToString();
            DBConsulta.conexionCerrar();
        }

        //Va a la última hoja
        private void buttonUltimaHoja_Click(object sender, EventArgs e)
        {
            paginaActual = ultimaHoja;
            DBConsulta.conexionAbrir();
            configuracionGrilla(DBConsulta.obtenerHistorialCompras(userID, paginaActual, totalVistoPorPagina));
            labelPaginas.Text = paginaActual.ToString() + " de " + ultimaHoja.ToString();
            DBConsulta.conexionCerrar();
        }
        //BOTON VOLVER A EXPLORADOR
        private void button3_Click(object sender, EventArgs e)
        {
            exx.Show();
            this.Close();
        }
    }
}
