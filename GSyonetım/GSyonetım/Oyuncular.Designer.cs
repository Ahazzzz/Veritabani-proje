namespace GSyonetım
{
    partial class Oyuncular
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Oyuncular));
            panel1 = new Panel();
            label1 = new Label();
            pictureBox1 = new PictureBox();
            dataGridView1 = new DataGridView();
            button3 = new Button();
            button4 = new Button();
            button1 = new Button();
            textBox3 = new TextBox();
            textBox1 = new TextBox();
            textBox2 = new TextBox();
            textBox4 = new TextBox();
            textBox5 = new TextBox();
            button2 = new Button();
            textBox6 = new TextBox();
            panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
            ((System.ComponentModel.ISupportInitialize)dataGridView1).BeginInit();
            SuspendLayout();
            // 
            // panel1
            // 
            panel1.Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right;
            panel1.BackColor = Color.FromArgb(192, 0, 0);
            panel1.Controls.Add(label1);
            panel1.Controls.Add(pictureBox1);
            panel1.Location = new Point(0, 0);
            panel1.Name = "panel1";
            panel1.Size = new Size(839, 93);
            panel1.TabIndex = 1;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 27F);
            label1.ForeColor = Color.White;
            label1.Location = new Point(196, 17);
            label1.Name = "label1";
            label1.Size = new Size(566, 61);
            label1.TabIndex = 2;
            label1.Text = "Galatasaray Takım Yönetimi";
            // 
            // pictureBox1
            // 
            pictureBox1.Image = (Image)resources.GetObject("pictureBox1.Image");
            pictureBox1.Location = new Point(3, 0);
            pictureBox1.Name = "pictureBox1";
            pictureBox1.Size = new Size(124, 93);
            pictureBox1.SizeMode = PictureBoxSizeMode.Zoom;
            pictureBox1.TabIndex = 1;
            pictureBox1.TabStop = false;
            // 
            // dataGridView1
            // 
            dataGridView1.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridView1.Location = new Point(3, 135);
            dataGridView1.Name = "dataGridView1";
            dataGridView1.RowHeadersWidth = 51;
            dataGridView1.Size = new Size(836, 253);
            dataGridView1.TabIndex = 2;
            dataGridView1.CellContentClick += dataGridView1_CellContentClick;
            // 
            // button3
            // 
            button3.Location = new Point(692, 443);
            button3.Name = "button3";
            button3.Size = new Size(137, 34);
            button3.TabIndex = 5;
            button3.Text = "Geri Dön";
            button3.UseVisualStyleBackColor = true;
            button3.Click += button3_Click;
            // 
            // button4
            // 
            button4.Location = new Point(12, 446);
            button4.Name = "button4";
            button4.Size = new Size(128, 29);
            button4.TabIndex = 8;
            button4.Text = "Oyuncu Ekle";
            button4.UseVisualStyleBackColor = true;
            button4.Click += button4_Click;
            // 
            // button1
            // 
            button1.Location = new Point(146, 446);
            button1.Name = "button1";
            button1.Size = new Size(94, 29);
            button1.TabIndex = 9;
            button1.Text = "Oyuncu Sil";
            button1.UseVisualStyleBackColor = true;
            button1.Click += button1_Click;
            // 
            // textBox3
            // 
            textBox3.Location = new Point(372, 394);
            textBox3.Name = "textBox3";
            textBox3.PlaceholderText = "takimID";
            textBox3.Size = new Size(128, 27);
            textBox3.TabIndex = 12;
            // 
            // textBox1
            // 
            textBox1.Location = new Point(12, 394);
            textBox1.Name = "textBox1";
            textBox1.PlaceholderText = "OyuncuID";
            textBox1.Size = new Size(128, 27);
            textBox1.TabIndex = 13;
            // 
            // textBox2
            // 
            textBox2.Location = new Point(196, 394);
            textBox2.Name = "textBox2";
            textBox2.PlaceholderText = "adi";
            textBox2.Size = new Size(128, 27);
            textBox2.TabIndex = 14;
            // 
            // textBox4
            // 
            textBox4.Location = new Point(531, 394);
            textBox4.Name = "textBox4";
            textBox4.PlaceholderText = "paradegeri";
            textBox4.Size = new Size(128, 27);
            textBox4.TabIndex = 15;
            // 
            // textBox5
            // 
            textBox5.Location = new Point(701, 394);
            textBox5.Name = "textBox5";
            textBox5.PlaceholderText = "bransID";
            textBox5.Size = new Size(128, 27);
            textBox5.TabIndex = 16;
            // 
            // button2
            // 
            button2.Location = new Point(232, 99);
            button2.Name = "button2";
            button2.Size = new Size(84, 29);
            button2.TabIndex = 17;
            button2.Text = " Ara";
            button2.UseVisualStyleBackColor = true;
            button2.Click += button2_Click;
            // 
            // textBox6
            // 
            textBox6.Location = new Point(12, 99);
            textBox6.Name = "textBox6";
            textBox6.PlaceholderText = "Aranilacak Oyuncu Adi";
            textBox6.Size = new Size(214, 27);
            textBox6.TabIndex = 18;
            // 
            // Oyuncular
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(841, 489);
            Controls.Add(textBox6);
            Controls.Add(button2);
            Controls.Add(textBox5);
            Controls.Add(textBox4);
            Controls.Add(textBox2);
            Controls.Add(textBox1);
            Controls.Add(textBox3);
            Controls.Add(button1);
            Controls.Add(button4);
            Controls.Add(button3);
            Controls.Add(dataGridView1);
            Controls.Add(panel1);
            Name = "Oyuncular";
            Text = "Oyuncular";
            panel1.ResumeLayout(false);
            panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)pictureBox1).EndInit();
            ((System.ComponentModel.ISupportInitialize)dataGridView1).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Panel panel1;
        private Label label1;
        private PictureBox pictureBox1;
        private DataGridView dataGridView1;
        private Button button3;
        private Button button4;
        private Button button1;
        private TextBox textBox3;
        private TextBox textBox1;
        private TextBox textBox2;
        private TextBox textBox4;
        private TextBox textBox5;
        private Button button2;
        private TextBox textBox6;
    }
}