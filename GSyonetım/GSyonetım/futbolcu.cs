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
    public partial class futbolcu : Form
    {
        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";
        public futbolcu()
        {
            InitializeComponent();
            LoadFutbolcular();
        }

        private void LoadFutbolcular()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT * FROM futbolcu"; // Futbolcu tablosundaki tüm verileri getir

                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        dataGridView1.DataSource = dataTable;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Futbolcular yüklenirken bir hata oluştu: " + ex.Message);
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {

            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    // TextBox'lardan veri alma
                    if (!int.TryParse(textBox1.Text.Trim(), out int futbolcuId) ||
                        !int.TryParse(textBox2.Text.Trim(), out int oyuncuId) ||
                        string.IsNullOrWhiteSpace(textBox3.Text) ||
                        !int.TryParse(textBox4.Text.Trim(), out int takimId))
                    {
                        MessageBox.Show("Lütfen tüm alanları doğru bir şekilde doldurun.");
                        return;
                    }

                    string pozisyon = textBox3.Text.Trim();

                    // SQL sorgusu ve parametreler
                    string query = "INSERT INTO futbolcu (futbolcuid, oyuncuid, pozisyon, takimid) VALUES (@futbolcuid, @oyuncuid, @pozisyon, @takimid)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@futbolcuid", futbolcuId);
                        command.Parameters.AddWithValue("@oyuncuid", oyuncuId);
                        command.Parameters.AddWithValue("@pozisyon", pozisyon);
                        command.Parameters.AddWithValue("@takimid", takimId);

                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Futbolcu başarıyla eklendi.");
                            LoadFutbolcular(); // Tabloyu güncelle
                        }
                        else
                        {
                            MessageBox.Show("Futbolcu eklenirken bir hata oluştu.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Bir hata oluştu: " + ex.Message);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    // DataGridView'den seçili futbolcunun ID'sini al
                    if (dataGridView1.SelectedRows.Count > 0)
                    {
                        int futbolcuId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["futbolcuid"].Value);

                        string query = "DELETE FROM futbolcu WHERE futbolcuid = @futbolcuid";
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@futbolcuid", futbolcuId);

                            int result = command.ExecuteNonQuery();
                            if (result > 0)
                            {
                                MessageBox.Show("Futbolcu başarıyla silindi.");
                                LoadFutbolcular(); // Tabloyu güncelle
                            }
                            else
                            {
                                MessageBox.Show("Futbolcu silinirken bir hata oluştu.");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Lütfen silmek için bir futbolcu seçin.");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
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
