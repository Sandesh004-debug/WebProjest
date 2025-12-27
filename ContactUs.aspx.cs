using System;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace WebApplication3
{
    public partial class ContactUs : Page
    {
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtName.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                !Regex.IsMatch(txtEmail.Text, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Please provide valid contact information.";
                return;
            }

            // Logic to save to database or send email would go here

            lblMessage.ForeColor = System.Drawing.Color.MediumSeaGreen;
            lblMessage.Text = "Thank you! Your message has been sent successfully.";

            // Reset form
            txtName.Text = txtEmail.Text = txtSubject.Text = txtMessage.Text = "";
        }
    }
}