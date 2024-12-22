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
    public partial class Diger : Form
    {
        private string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=T.ahazz1;Database=GSyonetim";

        public Diger()
        {
            InitializeComponent();
            LoadData();
        }
        private void LoadData()
        {
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            LoadAntrenorler();
            LoadLigler();
            LoadDoktorlar();
            LoadPersoneller();
        }


        private void LoadDoktorlar()
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT doktorid, adi, bransid FROM doktor"; // Doktor tablosu
                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        dataGridView1.DataSource = dataTable; // İlk DataGridView'e bağlama
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Doktor verileri yüklenirken bir hata oluştu: " + ex.Message);
            }
        }

        private void LoadLigler()
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT ligid, adi, bransid, sezon FROM lig"; // Lig tablosu
                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        dataGridView2.DataSource = dataTable; // İkinci DataGridView'e bağlama
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lig verileri yüklenirken bir hata oluştu: " + ex.Message);
            }
        }

        private void LoadPersoneller()
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT * FROM personel"; // Personel tablosundaki tüm veriler
                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        dataGridView4.DataSource = dataTable; // Personel verilerini DataGridView4'e bağla
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Personel verileri yüklenirken bir hata oluştu: " + ex.Message);
            }
        }

        private void LoadAntrenorler()
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();
                    string query = "SELECT antrenorid, adi, takimid, bransid FROM antrenor"; // Antrenör tablosu
                    using (NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);
                        dataGridView3.DataSource = dataTable; // Üçüncü DataGridView'e bağlama
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Antrenör verileri yüklenirken bir hata oluştu: " + ex.Message);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Form1 form1 = new Form1();
            form1.Show();
            this.Close();
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    string query = "INSERT INTO doktor (doktorid, adi, bransid) VALUES (@doktorid, @adi, @bransid)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@doktorid", int.Parse(textBox4.Text.Trim()));
                        command.Parameters.AddWithValue("@adi", textBox1.Text.Trim());
                        command.Parameters.AddWithValue("@bransid", int.Parse(textBox2.Text.Trim()));

                        int result = command.ExecuteNonQuery();
                        if (result > 0)
                        {
                            MessageBox.Show("Doktor başarıyla eklendi.");
                            LoadDoktorlar(); // Doktor tablosunu güncelle
                        }
                        else
                        {
                            MessageBox.Show("Doktor eklenirken bir hata oluştu.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            DeleteRow("doktor", "doktorid", dataGridView1);
        }

        private void button5_Click(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    string query = "INSERT INTO lig (ligid, adi, bransid, sezon) VALUES (@ligid, @adi, @bransid, @sezon)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@ligid", int.Parse(textBox4.Text.Trim()));
                        command.Parameters.AddWithValue("@adi", textBox1.Text.Trim());
                        command.Parameters.AddWithValue("@bransid", int.Parse(textBox2.Text.Trim()));
                        command.Parameters.AddWithValue("@sezon", textBox3.Text.Trim());

                        int result = command.ExecuteNonQuery();
                        if (result > 0)
                        {
                            MessageBox.Show("Lig başarıyla eklendi.");
                            LoadLigler(); // Lig tablosunu güncelle
                        }
                        else
                        {
                            MessageBox.Show("Lig eklenirken bir hata oluştu.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }

        private void button7_Click(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    string query = "INSERT INTO antrenor (antrenorid, adi, takimid, bransid) VALUES (@antrenorid, @adi, @takimid, @bransid)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@antrenorid", int.Parse(textBox4.Text.Trim()));
                        command.Parameters.AddWithValue("@adi", textBox1.Text.Trim());
                        command.Parameters.AddWithValue("@takimid", int.Parse(textBox5.Text.Trim()));
                        command.Parameters.AddWithValue("@bransid", int.Parse(textBox2.Text.Trim()));

                        int result = command.ExecuteNonQuery();
                        if (result > 0)
                        {
                            MessageBox.Show("Antrenör başarıyla eklendi.");
                            LoadAntrenorler(); // Antrenör tablosunu güncelle
                        }
                        else
                        {
                            MessageBox.Show("Antrenör eklenirken bir hata oluştu.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }

        private void button9_Click(object sender, EventArgs e)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    string query = "INSERT INTO personel (personelid, adi, gorev, tesisid) VALUES (@personelid, @adi, @gorev, @tesisid)";
                    using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@personelid", int.Parse(textBox4.Text.Trim()));
                        command.Parameters.AddWithValue("@adi", textBox1.Text.Trim());
                        command.Parameters.AddWithValue("@gorev", textBox6.Text.Trim());
                        command.Parameters.AddWithValue("@tesisid", int.Parse(textBox7.Text.Trim()));

                        int result = command.ExecuteNonQuery();
                        if (result > 0)
                        {
                            MessageBox.Show("Personel başarıyla eklendi.");
                            LoadPersoneller(); // Personel tablosunu güncelle
                        }
                        else
                        {
                            MessageBox.Show("Personel eklenirken bir hata oluştu.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            DeleteRow("lig", "ligid", dataGridView2);
        }

        private void button6_Click(object sender, EventArgs e)
        {
            DeleteRow("antrenor", "antrenorid", dataGridView3);
        }

        private void button8_Click(object sender, EventArgs e)
        {
            DeleteRow("personel", "personelid", dataGridView4);
        }

        private void DeleteRow(string tableName, string idColumn, DataGridView dataGridView)
        {
            try
            {
                using (NpgsqlConnection connection = new NpgsqlConnection(connectionString))
                {
                    connection.Open();

                    if (dataGridView.SelectedRows.Count > 0)
                    {
                        int id = Convert.ToInt32(dataGridView.SelectedRows[0].Cells[idColumn].Value);
                        string query = $"DELETE FROM {tableName} WHERE {idColumn} = @id";
                        using (NpgsqlCommand command = new NpgsqlCommand(query, connection))
                        {
                            command.Parameters.AddWithValue("@id", id);

                            int result = command.ExecuteNonQuery();
                            if (result > 0)
                            {
                                MessageBox.Show($"{tableName} başarıyla silindi.");
                                ReloadData(); // DataGridView'leri güncelle
                            }
                            else
                            {
                                MessageBox.Show("Kayıt silinirken bir hata oluştu.");
                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Lütfen silmek için bir satır seçin.");
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hata: " + ex.Message);
            }
        }

        private void ReloadData()
        {
            LoadDoktorlar();
            LoadLigler();
            LoadAntrenorler();
            LoadPersoneller();
        }

        private void Diger_Load(object sender, EventArgs e)
        {

        }

        private void Diger_Load_1(object sender, EventArgs e)
        {

        }
    }
}
