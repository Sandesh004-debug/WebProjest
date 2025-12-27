using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace WebApplication3
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMsg.Visible = false;
            }
        }
        
        
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate form inputs
                if (!ValidateForm())
                {
                    return;
                }

                // Get connection string from web.config
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                // Check if email already exists
                if (IsEmailExists(txtEmail.Text.Trim(), connectionString))
                {
                    ShowMessage("Email is already registered. Please use a different email or login.", "danger");
                    return;
                }

                // Hash the password
                string hashedPassword = HashPassword(txtPassword.Text.Trim());

                // Insert user into database
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // First, ensure the Users table exists
                    EnsureUsersTableExists(con);

                    string query = @"INSERT INTO Users (FullName, Email, PasswordHash, UserType, CreatedDate) 
                                     VALUES (@FullName, @Email, @PasswordHash, @UserType, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                        cmd.Parameters.AddWithValue("@UserType", ddlUserType.SelectedValue);

                        OpenConnection(con);
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage("✅ Registration successful! You can now login.", "success");
                            ClearForm();

                            // Auto-redirect to login page after 3 seconds
                            string script = "setTimeout(function(){ window.location.href = 'Login.aspx'; }, 3000);";
                            ScriptManager.RegisterStartupScript(this, GetType(), "redirect", script, true);
                        }
                        else
                        {
                            ShowMessage("Registration failed. Please try again.", "danger");
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                HandleSqlException(sqlEx);
            }
            catch (Exception ex)
            {
                ShowMessage($"Error: {ex.Message}", "danger");
                // Log error for debugging
                System.Diagnostics.Debug.WriteLine($"Error in btnRegister_Click: {ex.Message}\n{ex.StackTrace}");
            }
        }

        private bool ValidateForm()
        {
            // Clear previous messages
            pnlMsg.Visible = false;

            // Validate Full Name
            if (string.IsNullOrWhiteSpace(txtFullName.Text))
            {
                ShowMessage("Please enter your full name.", "danger");
                txtFullName.Focus();
                return false;
            }

            // Validate Email
            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                ShowMessage("Please enter your email address.", "danger");
                txtEmail.Focus();
                return false;
            }

            if (!IsValidEmail(txtEmail.Text))
            {
                ShowMessage("Please enter a valid email address (e.g., name@example.com).", "danger");
                txtEmail.Focus();
                return false;
            }

            // Validate Password
            if (string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                ShowMessage("Please enter a password.", "danger");
                txtPassword.Focus();
                return false;
            }

            if (txtPassword.Text.Length < 6)
            {
                ShowMessage("Password must be at least 6 characters long.", "danger");
                txtPassword.Focus();
                return false;
            }

            // Validate User Type
            if (string.IsNullOrWhiteSpace(ddlUserType.SelectedValue))
            {
                ShowMessage("Please select whether you are a Student or Educator.", "danger");
                ddlUserType.Focus();
                return false;
            }

            // Validate Terms Checkbox
            if (!chkTerms.Checked)
            {
                ShowMessage("You must agree to the Terms & Privacy Policy.", "danger");
                return false;
            }

            return true;
        }

        private bool IsEmailExists(string email, string connectionString)
        {
            SqlConnection con = null;
            try
            {
                con = new SqlConnection(connectionString);
                string query = "SELECT COUNT(1) FROM Users WHERE Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    OpenConnection(con);
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
            catch (SqlException)
            {
                return false; // If table doesn't exist or any SQL error
            }
            finally
            {
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(hashedBytes);
            }
        }

        private void EnsureUsersTableExists(SqlConnection connection)
        {
            try
            {
                OpenConnection(connection);

                // Check if table exists
                string checkQuery = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users'";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, connection))
                {
                    int tableCount = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (tableCount == 0)
                    {
                        // Create the table
                        string createTableQuery = @"
                        CREATE TABLE Users (
                            UserID INT IDENTITY(1,1) PRIMARY KEY,
                            FullName NVARCHAR(100) NOT NULL,
                            Email NVARCHAR(100) NOT NULL UNIQUE,
                            PasswordHash NVARCHAR(255) NOT NULL,
                            UserType NVARCHAR(20) NOT NULL,
                            CreatedDate DATETIME DEFAULT GETDATE(),
                            IsActive BIT DEFAULT 1,
                            CONSTRAINT CHK_UserType CHECK (UserType IN ('Student', 'Educator'))
                        )";

                        using (SqlCommand createCmd = new SqlCommand(createTableQuery, connection))
                        {
                            createCmd.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Failed to ensure Users table exists: {ex.Message}");
            }
        }

        private void OpenConnection(SqlConnection connection)
        {
            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
        }

        private void HandleSqlException(SqlException sqlEx)
        {
            string errorMessage;

            switch (sqlEx.Number)
            {
                case 2627: // Unique constraint violation
                    errorMessage = "Email is already registered. Please use a different email.";
                    break;

                case 18456: // Login failed
                    errorMessage = "Database login failed. Please check your SQL Server credentials.";
                    break;

                case -1: // Connection error
                    errorMessage = "Cannot connect to database. Please check if SQL Server is running.";
                    break;

                case 2: // Network error
                    errorMessage = "Network error. Please check your connection to the database server.";
                    break;

                case 53: // Server not found
                    errorMessage = "Database server not found. Please verify the server name in web.config.";
                    break;

                default:
                    errorMessage = $"Database Error [{sqlEx.Number}]: {sqlEx.Message}";
                    break;
            }

            ShowMessage(errorMessage, "danger");

            // For debugging
            if (Context.IsDebuggingEnabled)
            {
                ShowMessage($"<small>Detailed Error: {sqlEx.Message}</small>", "info");
            }
        }

        private void ShowMessage(string message, string type)
        {
            pnlMsg.Visible = true;
            litMsg.Text = message;

            // Set alert type based on Bootstrap classes
            switch (type.ToLower())
            {
                case "success":
                    pnlMsg.CssClass = "alert alert-success border-0 shadow-sm rounded-4 mb-4";
                    break;
                case "danger":
                    pnlMsg.CssClass = "alert alert-danger border-0 shadow-sm rounded-4 mb-4";
                    break;
                case "warning":
                    pnlMsg.CssClass = "alert alert-warning border-0 shadow-sm rounded-4 mb-4";
                    break;
                default:
                    pnlMsg.CssClass = "alert alert-info border-0 shadow-sm rounded-4 mb-4";
                    break;
            }
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            ddlUserType.SelectedIndex = 0;
            chkTerms.Checked = false;
        }
    }
}