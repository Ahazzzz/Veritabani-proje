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
    public partial class ESpor : Form
    {
        public ESpor()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            esporcu esporcuForm = new esporcu();
            esporcuForm.StartPosition = FormStartPosition.Manual;
            esporcuForm.Location = new Point(100, 100); // Manuel konum ayarı
            esporcuForm.Show();
            this.Hide(); // Mevcut formu gizle
        }

        private void button2_Click(object sender, EventArgs e)
        {
            MaliDeger maliDegerForm = new MaliDeger();
            maliDegerForm.StartPosition = FormStartPosition.Manual;
            maliDegerForm.Location = new Point(100, 100);
            maliDegerForm.Show();
            this.Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Sponsorluklar sponsorluklarForm = new Sponsorluklar();
            sponsorluklarForm.StartPosition = FormStartPosition.Manual;
            sponsorluklarForm.Location = new Point(100, 100);
            sponsorluklarForm.Show();
            this.Hide();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            Tesis tesisForm = new Tesis();
            tesisForm.StartPosition = FormStartPosition.Manual;
            tesisForm.Location = new Point(100, 100);
            tesisForm.Show();
            this.Hide();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            Antrenman antrenmanForm = new Antrenman();
            antrenmanForm.StartPosition = FormStartPosition.Manual;
            antrenmanForm.Location = new Point(100, 100);
            antrenmanForm.Show();
            this.Hide();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            Diger islemlerForm = new Diger();
            islemlerForm.StartPosition = FormStartPosition.Manual;
            islemlerForm.Location = new Point(100, 100);
            islemlerForm.Show();
            this.Hide();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            Form1 form1 = new Form1();
            form1.Show();
            this.Hide();
        }
    }
}
