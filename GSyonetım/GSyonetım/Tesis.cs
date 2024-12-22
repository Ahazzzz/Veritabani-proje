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
    public partial class Tesis : Form
    {

        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";
        public Tesis()
        {
            InitializeComponent();
            LoadTesisler();
        }
        private void LoadTesisler()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT * FROM tesis"; // Tesis tablosundaki tüm verileri çek

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

        private void button1_Click(object sender, EventArgs e)
        {
            Diger islemlerForm = new Diger();
            islemlerForm.StartPosition = FormStartPosition.Manual;
            islemlerForm.Location = new Point(100, 100);
            islemlerForm.Show();
            this.Hide();
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

                    // Kullanıcıdan alınan veriler
                    if (!int.TryParse(textBox4.Text.Trim(), out int tesisId))
                    {
                        MessageBox.Show("Tesis ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    string tesisAdi = textBox1.Text.Trim(); // Tesis adı
                    string sehir = textBox2.Text.Trim();   // Şehir
                    if (!int.TryParse(textBox3.Text.Trim(), out int takimId))
                    {
                        MessageBox.Show("Takım ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(tesisAdi) || string.IsNullOrWhiteSpace(sehir))
                    {
                        MessageBox.Show("Tesis adı ve şehir boş bırakılamaz.");
                        return;
                    }

                    // SQL sorgusu ve parametreler
                    string query = "INSERT INTO tesis (tesisid, adi, sehir, takimid) VALUES (@tesisid, @adi, @sehir, @takimid)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@tesisid", tesisId);
                        command.Parameters.AddWithValue("@adi", tesisAdi);
                        command.Parameters.AddWithValue("@sehir", sehir);
                        command.Parameters.AddWithValue("@takimid", takimId);

                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Tesis başarıyla eklendi.");
                            LoadTesisler(); // Tesis listesini güncelle
                        }
                        else
                        {
                            MessageBox.Show("Tesis eklenirken bir hata oluştu.");
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

                    // DataGridView'den seçili tesisin ID'sini al
                    if (dataGridView1.SelectedRows.Count > 0)
                    {
                        int tesisId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["tesisid"].Value);

                        string query = "DELETE FROM tesis WHERE tesisid = @tesisid";
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@tesisid", tesisId);

                            int result = command.ExecuteNonQuery();
                            if (result > 0)
                            {
                                MessageBox.Show("Tesis başarıyla silindi.");
                                LoadTesisler(); // Tabloyu güncelle
                            }
                            else
                            {
                                MessageBox.Show("Tesis silinirken bir hata oluştu.");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Lütfen silmek için bir tesis seçin.");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void Tesis_Load(object sender, EventArgs e)
        {

        }
    }
}
