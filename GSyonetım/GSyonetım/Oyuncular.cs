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
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace GSyonetım
{
    public partial class Oyuncular : Form
    {
        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";
        public Oyuncular()
        {
            InitializeComponent();
            LoadOyuncular();

        }


        private void LoadOyuncular()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT oyuncuid, adi, takimid, paradegeri, bransid FROM oyuncular";

                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        dataGridView1.DataSource = dataTable;

                        // DataGridView'deki sütun isimlerini düzenle
                        dataGridView1.Columns["oyuncuid"].HeaderText = "Oyuncu ID";
                        dataGridView1.Columns["adi"].HeaderText = "Adı";
                        dataGridView1.Columns["takimid"].HeaderText = "Takım ID";
                        dataGridView1.Columns["paradegeri"].HeaderText = "Para Değeri";
                        dataGridView1.Columns["bransid"].HeaderText = "Branş ID";
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Veriler yüklenirken hata oluştu: " + ex.Message);
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }



        private void button3_Click(object sender, EventArgs e)
        {
            Form1 form1 = new Form1();
            form1.Show();
            this.Close();
        }





        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    // Kullanıcıdan alınan veriler
                    if (!int.TryParse(textBox1.Text.Trim(), out int oyuncuId))
                    {
                        MessageBox.Show("Oyuncu ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    string adi = textBox2.Text.Trim(); // Oyuncu adı
                    if (!int.TryParse(textBox3.Text.Trim(), out int takimId))
                    {
                        MessageBox.Show("Takım ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (!decimal.TryParse(textBox4.Text.Trim(), out decimal paraDegeri))
                    {
                        MessageBox.Show("Para Değeri geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (!int.TryParse(textBox5.Text.Trim(), out int bransId))
                    {
                        MessageBox.Show("Branş ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(adi))
                    {
                        MessageBox.Show("Oyuncu adı boş bırakılamaz.");
                        return;
                    }

                    // SQL sorgusu ve parametreler
                    string query = "INSERT INTO oyuncular (oyuncuid, adi, takimid, paradegeri, bransid) VALUES (@oyuncuid, @adi, @takimid, @paradegeri, @bransid)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@oyuncuid", oyuncuId);
                        command.Parameters.AddWithValue("@adi", adi);
                        command.Parameters.AddWithValue("@takimid", takimId);
                        command.Parameters.AddWithValue("@paradegeri", paraDegeri);
                        command.Parameters.AddWithValue("@bransid", bransId);

                        int result = command.ExecuteNonQuery();
                        if (result > 0)
                        {
                            MessageBox.Show("Oyuncu başarıyla eklendi.");
                            LoadOyuncular(); // Oyuncu listesini güncelle
                        }
                        else
                        {
                            MessageBox.Show("Oyuncu eklenirken bir hata oluştu.");
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

                    // DataGridView'den seçili oyuncunun ID'sini al
                    if (dataGridView1.SelectedRows.Count > 0)
                    {
                        int oyuncuId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["oyuncuid"].Value);

                        string query = "DELETE FROM oyuncular WHERE oyuncuid = @oyuncuid";
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@oyuncuid", oyuncuId);

                            int result = command.ExecuteNonQuery();
                            if (result > 0)
                            {
                                MessageBox.Show("Oyuncu başarıyla silindi.");
                                LoadOyuncular(); // Tabloyu güncelle
                            }
                            else
                            {
                                MessageBox.Show("Oyuncu silinirken bir hata oluştu.");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Lütfen silmek için bir oyuncu seçin.");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string searchValue = textBox6.Text.Trim(); // Arama kutusundan değer al

            if (string.IsNullOrWhiteSpace(searchValue))
            {
                MessageBox.Show("Lütfen bir oyuncu adı girin.");
                return;
            }

            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT oyuncuid, adi, takimid, paradegeri, bransid FROM oyuncular WHERE LOWER(adi) LIKE @search";

                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        adapter.SelectCommand.Parameters.AddWithValue("@search", "%" + searchValue.ToLower() + "%");

                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);

                        if (dataTable.Rows.Count > 0)
                        {
                            dataGridView1.DataSource = dataTable;
                        }
                        else
                        {
                            MessageBox.Show("Arama sonucuna göre oyuncu bulunamadı.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Arama sırasında bir hata oluştu: " + ex.Message);
            }
        }
    }
}
