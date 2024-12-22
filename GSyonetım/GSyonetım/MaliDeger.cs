using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GSyonetım
{
    public partial class MaliDeger : Form
    {
        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";


        public MaliDeger()
        {
            InitializeComponent();
            LoadMaliDeger();
        }
        private void LoadMaliDeger()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    string query = @"
                        SELECT bransid, brans_adi, malideger
                        FROM malideger
                        ORDER BY bransid;
                    ";

                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        dataGridView1.DataSource = dataTable; // Verileri DataGridView'e bağla
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Mali değerler yüklenirken bir hata oluştu: " + ex.Message);
            }
        }


        private void button3_Click(object sender, EventArgs e)
        {
            Form1 form1 = new Form1();
            form1.Show();
            this.Close();
        }
    }
}
