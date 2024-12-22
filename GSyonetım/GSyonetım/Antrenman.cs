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
    public partial class Antrenman : Form
    {


        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";
        public Antrenman()
        {
            InitializeComponent();
            LoadAntrenman();
        }

        private void LoadAntrenman()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT * FROM antrenman"; // Antrenman tablosundaki tüm verileri çek

                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable); // Verileri DataTable'e doldur
                        dataGridView1.DataSource = dataTable; // DataGridView'e bağla
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Veriler yüklenirken bir hata oluştu: " + ex.Message);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Form1 form1 = new Form1();
            form1.Show();
            this.Close();
        }

      

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    if (!int.TryParse(textBox1.Text.Trim(), out int antrenmanId))
                    {
                        MessageBox.Show("Antrenman ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (!int.TryParse(textBox2.Text.Trim(), out int bransId))
                    {
                        MessageBox.Show("Branş ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (!int.TryParse(textBox3.Text.Trim(), out int tesisId))
                    {
                        MessageBox.Show("Tesis ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (!DateTime.TryParse(textBox4.Text.Trim(), out DateTime tarih))
                    {
                        MessageBox.Show("Tarih geçerli bir tarih formatında olmalıdır (ör. YYYY-MM-DD).");
                        return;
                    }

                    string query = "INSERT INTO antrenman (antrenmanid, bransid, tesisid, tarih) VALUES (@antrenmanid, @bransid, @tesisid, @tarih)";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@antrenmanid", antrenmanId);
                        command.Parameters.AddWithValue("@bransid", bransId);
                        command.Parameters.AddWithValue("@tesisid", tesisId);
                        command.Parameters.AddWithValue("@tarih", tarih);

                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Antrenman başarıyla eklendi.");
                            LoadAntrenman(); // Antrenman listesini güncelle
                        }
                        else
                        {
                            MessageBox.Show("Antrenman eklenirken bir hata oluştu.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Bir hata oluştu: " + ex.Message);
            }
        }

        private void button1_Click_1(object sender, EventArgs e)
        {

            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    if (dataGridView1.SelectedRows.Count > 0)
                    {
                        int antrenmanId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["antrenmanid"].Value);

                        string query = "DELETE FROM antrenman WHERE antrenmanid = @antrenmanid";
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@antrenmanid", antrenmanId);

                            int result = command.ExecuteNonQuery();
                            if (result > 0)
                            {
                                MessageBox.Show("Antrenman başarıyla silindi.");
                                LoadAntrenman(); // Tabloyu güncelle
                            }
                            else
                            {
                                MessageBox.Show("Antrenman silinirken bir hata oluştu.");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Lütfen silmek için bir antrenman seçin.");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }
    }
}
