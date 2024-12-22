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
    public partial class Sponsorluklar : Form
    {

        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";

        public Sponsorluklar()
        {
            InitializeComponent();
            LoadSponsorluklar();
        }

        private void LoadSponsorluklar()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT * FROM sponsor"; // Sponsor tablosundaki tüm verileri çek

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


        private void button1_Click_1(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    if (dataGridView1.SelectedRows.Count > 0)
                    {
                        int sponsorId = Convert.ToInt32(dataGridView1.SelectedRows[0].Cells["sponsorid"].Value);

                        string query = "DELETE FROM sponsor WHERE sponsorid = @sponsorid";
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@sponsorid", sponsorId);

                            int result = command.ExecuteNonQuery();
                            if (result > 0)
                            {
                                MessageBox.Show("Sponsor başarıyla silindi.");
                                LoadSponsorluklar(); // Tabloyu güncelle
                            }
                            else
                            {
                                MessageBox.Show("Sponsor silinirken bir hata oluştu.");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Lütfen silmek için bir sponsor seçin.");
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
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    if (!int.TryParse(textBox1.Text.Trim(), out int sponsorId))
                    {
                        MessageBox.Show("Sponsor ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    string sponsorAdi = textBox2.Text.Trim(); // Sponsor adı
                    if (!int.TryParse(textBox3.Text.Trim(), out int takimId))
                    {
                        MessageBox.Show("Takım ID geçerli bir sayı olmalıdır.");
                        return;
                    }

                    if (string.IsNullOrWhiteSpace(sponsorAdi))
                    {
                        MessageBox.Show("Sponsor adı boş bırakılamaz.");
                        return;
                    }

                    string query = "INSERT INTO sponsor (sponsorid, adi, takimid) VALUES (@sponsorid, @adi, @takimid)";

                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@sponsorid", sponsorId);
                        command.Parameters.AddWithValue("@adi", sponsorAdi);
                        command.Parameters.AddWithValue("@takimid", takimId);

                        int result = command.ExecuteNonQuery();

                        if (result > 0)
                        {
                            MessageBox.Show("Sponsor başarıyla eklendi.");
                            LoadSponsorluklar(); // Sponsor listesini güncelle
                        }
                        else
                        {
                            MessageBox.Show("Sponsor eklenirken bir hata oluştu.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Bir hata oluştu: " + ex.Message);
            }
        }
    }
}
