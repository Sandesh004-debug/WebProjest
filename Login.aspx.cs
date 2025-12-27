using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace WebApplication3
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlError.Visible = false;
                hfUserType.Value = "student";
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            // Basic validation
            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                ShowError("Please enter email address.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                ShowError("Please enter password.");
                return;
            }

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string userType = hfUserType.Value.ToLower();

            // Hardcoded admin login
            if (userType == "admin" && email == "admin@learnease.com" && password == "Admin@123")
            {
                Session["UserID"] = 0;
                Session["FullName"] = "System Administrator";
                Session["UserEmail"] = email;
                Session["UserType"] = "admin";
                Session["IsAuthenticated"] = true;

                Response.Redirect("AdminDashboard.aspx");
                return;
            }

            // Regular user login
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT UserID, FullName, Email, PasswordHash, UserType FROM Users WHERE Email = @Email";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Email", email);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string storedHash = reader["PasswordHash"].ToString();
                        string dbUserType = reader["UserType"].ToString().ToLower();

                        if (HashPassword(password) == storedHash)
                        {
                            // Check if selected user type matches database user type
                            if ((userType == "student" && dbUserType == "student") ||
                                (userType == "educator" && dbUserType == "educator"))
                            {
                                Session["UserID"] = reader["UserID"];
                                Session["FullName"] = reader["FullName"];
                                Session["UserEmail"] = reader["Email"];
                                Session["UserType"] = dbUserType;
                                Session["IsAuthenticated"] = true;

                                // Redirect based on user type
                                if (dbUserType == "student")
                                    Response.Redirect("StudentDashboard.aspx");
                                else if (dbUserType == "educator")
                                    Response.Redirect("EducatorDashboard.aspx");
                            }
                            else
                            {
                                ShowError($"Please select correct user type: {dbUserType}");
                            }
                        }
                        else
                        {
                            ShowError("Invalid password");
                        }
                    }
                    else
                    {
                        ShowError("User not found");
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowError("Login error. Please try again.");
                // Log the error if needed
                System.Diagnostics.Debug.WriteLine($"Login error: {ex.Message}");
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(bytes);
            }
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litErrorMessage.Text = message;
        }
    }
}