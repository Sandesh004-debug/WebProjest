using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // SECURITY CHECK: If user is not logged in as Admin, kick them to login page
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadDashboardData();
            }
        }

        private void LoadDashboardData()
        {
            // Update stats
            litTotalUsers.Text = "10,543";

            // Bind dummy data to GridView (In real app, this comes from SQL)
            var users = new List<object> {
                new { UserName = "John Doe", Email = "john@example.com" },
                new { UserName = "Jane Smith", Email = "jane@example.com" }
            };

            gvUsers.DataSource = users;
            gvUsers.DataBind();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void chkMaintenance_CheckedChanged(object sender, EventArgs e)
        {
            bool isUnderMaintenance = chkMaintenance.Checked;
            // Logic to update your database/site status
        }
    }
}