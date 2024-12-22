using static System.Runtime.InteropServices.JavaScript.JSType;

namespace GSyonetım
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.StartPosition = FormStartPosition.Manual;
            this.Location = new Point(100, 100);
        }


        private void button5_Click(object sender, EventArgs e)
        {
            Futbol futbolForm = new Futbol();
            futbolForm.StartPosition = FormStartPosition.Manual;
            futbolForm.Location = new Point(100, 100);
            futbolForm.Show();
            this.Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {

            Voleybol voleybolForm = new Voleybol();
            voleybolForm.StartPosition = FormStartPosition.Manual;
            voleybolForm.Location = new Point(100, 100);
            voleybolForm.Show();
            this.Hide();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Basketbol basketbolForm = new Basketbol();
            basketbolForm.StartPosition = FormStartPosition.Manual;
            basketbolForm.Location = new Point(100, 100);
            basketbolForm.Show();
            this.Hide();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            ESpor esporForm = new ESpor();
            esporForm.Show();
            this.Hide();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Oyuncular oyuncularForm = new Oyuncular();
            oyuncularForm.StartPosition = FormStartPosition.Manual;
            oyuncularForm.Location = new Point(100, 100);
            oyuncularForm.Show();
            this.Hide();

        }
    }
}
