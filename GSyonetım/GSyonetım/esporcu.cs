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
    public partial class esporcu : Form
    {
        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";
        public esporcu()
        {
            InitializeComponent();
            LoadEsporcular();
        }

        private void LoadEsporcular()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT * FROM esporcu"; // Esporcu tablosundaki tüm verileri getir

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
                MessageBox.Show("Esporcular yüklenirken bir hata oluştu: " + ex.Message);
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
                    if (!int.TryParse(textBox1.Text.Trim(), out int esporcuId) ||
                        !int.TryParse(textBox2.Text.Trim(), out int oyuncuId) ||
                        string.IsNullOrWhiteSpace(textBox3.Text) ||
                        !int.TryParse(textBox4.Text.Trim(), out int takimId))
                    {
                        MessageBox.Show("Lütfen tüm alanları doğru bir şekilde doldurun.");
                        return;
                    }

                    string oyunAdi = textBox3.Text.Trim();

                    // SQL sorgusu ve parametreler
                    string query = "INSERT INTO esporcu (esporcuid, oyuncuid, oyunadi, takimid) VALUES (@esporcuid, @oyuncuid, @oyunadi, @takimid)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@esporcuid", esporcuId);
                        command.Parameters.AddWithValue("@oyuncuid", oyuncuId);
                        command.Parameters.AddWithValue("@oyunadi", oyunAdi);
                        command.Parameters.AddWithValue("@takimid", takimId);

                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Esporcu başarıyla eklendi.");
                            LoadEsporcular(); // Tabloyu güncelle
                        }
                        else
                        {
                            MessageBox.Show("Esporcu eklenirken bir hata oluştu.");
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

                    // DataGridView'den seçili esporcunun ID'sini al
                    if (dataGridView1.SelectedRows.Count > 0)
                    {
                        int esporcuId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["esporcuid"].Value);

                        string query = "DELETE FROM esporcu WHERE esporcuid = @esporcuid";
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@esporcuid", esporcuId);

                            int result = command.ExecuteNonQuery();
                            if (result > 0)
                            {
                                MessageBox.Show("Esporcu başarıyla silindi.");
                                LoadEsporcular(); // Tabloyu güncelle
                            }
                            else
                            {
                                MessageBox.Show("Esporcu silinirken bir hata oluştu.");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Lütfen silmek için bir esporcu seçin.");
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
