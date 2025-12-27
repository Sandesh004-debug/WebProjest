using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class StudentDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in and is a student
                if (Session["UserID"] == null || Session["UserType"] == null || Session["UserType"].ToString() != "student")
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Set student ID
                int studentId = Convert.ToInt32(Session["UserID"]);
                hfStudentId.Value = studentId.ToString();

                // Display user name
                if (Session["FullName"] != null)
                {
                    string fullName = Session["FullName"].ToString();
                    litFirstName.Text = fullName.Split(' ')[0]; // First name only
                    lblUserNameNav.Text = fullName;
                }

                LoadStatistics();
                LoadEnrolledCourses();
                LoadAvailableCourses();
            }
        }

        private void LoadStatistics()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int studentId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Check if Enrollments table exists
                    string checkTableQuery = @"
                        IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Enrollments')
                        BEGIN
                            CREATE TABLE Enrollments (
                                EnrollmentID INT IDENTITY(1,1) PRIMARY KEY,
                                StudentID INT NOT NULL,
                                CourseID INT NOT NULL,
                                EnrollmentDate DATETIME DEFAULT GETDATE(),
                                Status NVARCHAR(20) DEFAULT 'Active',
                                CONSTRAINT FK_Enrollments_Users FOREIGN KEY (StudentID) REFERENCES Users(UserID),
                                CONSTRAINT FK_Enrollments_Courses FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
                            )
                        END";

                    using (SqlCommand checkCmd = new SqlCommand(checkTableQuery, con))
                    {
                        checkCmd.ExecuteNonQuery();
                    }

                    // Count enrolled courses
                    string enrolledQuery = "SELECT COUNT(*) FROM Enrollments WHERE StudentID = @StudentID AND Status = 'Active'";
                    using (SqlCommand cmd = new SqlCommand(enrolledQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        object result = cmd.ExecuteScalar();
                        litEnrolledCount.Text = result?.ToString() ?? "0";
                        litEnrolledTabCount.Text = result?.ToString() ?? "0";
                    }

                    // Count active courses (courses that are currently active and student is enrolled)
                    string activeQuery = @"
                        SELECT COUNT(DISTINCT e.CourseID) 
                        FROM Enrollments e
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE e.StudentID = @StudentID 
                        AND e.Status = 'Active'
                        AND c.IsActive = 1
                        AND GETDATE() BETWEEN c.StartDate AND c.EndDate";

                    using (SqlCommand cmd = new SqlCommand(activeQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        object result = cmd.ExecuteScalar();
                        litActiveCount.Text = result?.ToString() ?? "0";
                        litActiveCourses.Text = result?.ToString() + " active";
                    }

                    // Count total available courses (active courses not enrolled in)
                    string availableQuery = @"
                        SELECT COUNT(*) 
                        FROM Courses c
                        WHERE c.IsActive = 1
                        AND GETDATE() BETWEEN c.StartDate AND c.EndDate
                        AND NOT EXISTS (
                            SELECT 1 FROM Enrollments e 
                            WHERE e.CourseID = c.CourseID 
                            AND e.StudentID = @StudentID 
                            AND e.Status = 'Active'
                        )";

                    using (SqlCommand cmd = new SqlCommand(availableQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        object result = cmd.ExecuteScalar();
                        litAvailableTabCount.Text = result?.ToString() ?? "0";
                    }

                    // Count all courses
                    string totalQuery = "SELECT COUNT(*) FROM Courses WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(totalQuery, con))
                    {
                        object result = cmd.ExecuteScalar();
                        litTotalCourses.Text = result?.ToString() ?? "0";
                    }

                    // Count new courses (added in last 7 days)
                    string newQuery = @"
                        SELECT COUNT(*) 
                        FROM Courses 
                        WHERE IsActive = 1 
                        AND CreatedDate >= DATEADD(day, -7, GETDATE())
                        AND NOT EXISTS (
                            SELECT 1 FROM Enrollments 
                            WHERE CourseID = Courses.CourseID 
                            AND StudentID = @StudentID
                        )";

                    using (SqlCommand cmd = new SqlCommand(newQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        object result = cmd.ExecuteScalar();
                        int newCount = Convert.ToInt32(result ?? 0);
                        litNewCourses.Text = newCount > 0 ? $"+{newCount} new" : "0 new";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading statistics: {ex.Message}");
                litEnrolledCount.Text = "0";
                litActiveCount.Text = "0";
                litTotalCourses.Text = "0";
            }
        }

        private void LoadEnrolledCourses()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int studentId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT c.CourseID, c.CourseCode, c.CourseName, c.Description, 
                               c.Category, c.Credits, c.StartDate, c.EndDate, c.EducatorID,
                               e.EnrollmentDate
                        FROM Courses c
                        INNER JOIN Enrollments e ON c.CourseID = e.CourseID
                        WHERE e.StudentID = @StudentID 
                        AND e.Status = 'Active'
                        AND c.IsActive = 1
                        ORDER BY e.EnrollmentDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        con.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptEnrolledCourses.DataSource = dt;
                            rptEnrolledCourses.DataBind();
                            pnlEnrolledCourses.Visible = true;
                            pnlNoEnrollments.Visible = false;
                        }
                        else
                        {
                            pnlEnrolledCourses.Visible = false;
                            pnlNoEnrollments.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading enrolled courses: {ex.Message}");
                pnlEnrolledCourses.Visible = false;
                pnlNoEnrollments.Visible = true;
            }
        }

        private void LoadAvailableCourses()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int studentId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT c.CourseID, c.CourseCode, c.CourseName, c.Description, 
                               c.Category, c.Credits, c.StartDate, c.EndDate, c.EducatorID,
                               c.MaxStudents,
                               (SELECT COUNT(*) FROM Enrollments WHERE CourseID = c.CourseID) as CurrentEnrollments
                        FROM Courses c
                        WHERE c.IsActive = 1
                        AND GETDATE() BETWEEN c.StartDate AND c.EndDate
                        AND NOT EXISTS (
                            SELECT 1 FROM Enrollments e 
                            WHERE e.CourseID = c.CourseID 
                            AND e.StudentID = @StudentID 
                            AND e.Status = 'Active'
                        )
                        ORDER BY c.CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        con.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptAvailableCourses.DataSource = dt;
                            rptAvailableCourses.DataBind();
                            pnlNoCourses.Visible = false;
                        }
                        else
                        {
                            pnlNoCourses.Visible = true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading available courses: {ex.Message}");
                pnlNoCourses.Visible = true;
            }
        }

        protected void rptAvailableCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Enroll")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                int studentId = Convert.ToInt32(Session["UserID"]);

                try
                {
                    string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        // Check if already enrolled
                        string checkQuery = "SELECT COUNT(*) FROM Enrollments WHERE StudentID = @StudentID AND CourseID = @CourseID AND Status = 'Active'";

                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                        {
                            checkCmd.Parameters.AddWithValue("@StudentID", studentId);
                            checkCmd.Parameters.AddWithValue("@CourseID", courseId);
                            con.Open();

                            int existingCount = Convert.ToInt32(checkCmd.ExecuteScalar());

                            if (existingCount > 0)
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "AlreadyEnrolled",
                                    "alert('You are already enrolled in this course!');", true);
                                return;
                            }

                            // Check course capacity
                            string capacityQuery = @"
                                SELECT c.MaxStudents, 
                                       (SELECT COUNT(*) FROM Enrollments WHERE CourseID = c.CourseID) as CurrentEnrollments
                                FROM Courses c
                                WHERE c.CourseID = @CourseID";

                            using (SqlCommand capacityCmd = new SqlCommand(capacityQuery, con))
                            {
                                capacityCmd.Parameters.AddWithValue("@CourseID", courseId);

                                using (SqlDataReader reader = capacityCmd.ExecuteReader())
                                {
                                    if (reader.Read())
                                    {
                                        int maxStudents = Convert.ToInt32(reader["MaxStudents"]);
                                        int currentEnrollments = Convert.ToInt32(reader["CurrentEnrollments"]);

                                        if (currentEnrollments >= maxStudents)
                                        {
                                            ScriptManager.RegisterStartupScript(this, GetType(), "CourseFull",
                                                "alert('This course has reached its maximum capacity!');", true);
                                            return;
                                        }
                                    }
                                }
                            }

                            // Enroll student
                            string enrollQuery = @"INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, Status) 
                                                 VALUES (@StudentID, @CourseID, GETDATE(), 'Active')";

                            using (SqlCommand enrollCmd = new SqlCommand(enrollQuery, con))
                            {
                                enrollCmd.Parameters.AddWithValue("@StudentID", studentId);
                                enrollCmd.Parameters.AddWithValue("@CourseID", courseId);

                                int rowsAffected = enrollCmd.ExecuteNonQuery();

                                if (rowsAffected > 0)
                                {
                                    // Refresh data
                                    LoadStatistics();
                                    LoadEnrolledCourses();
                                    LoadAvailableCourses();

                                    // Show success message
                                    ScriptManager.RegisterStartupScript(this, GetType(), "EnrollSuccess",
                                        @"Swal.fire({
                                            icon: 'success',
                                            title: 'Successfully Enrolled!',
                                            text: 'You have been enrolled in the course.',
                                            confirmButtonColor: '#0d6efd'
                                        });", true);
                                }
                            }
                        }
                    }
                }
                catch (SqlException sqlEx)
                {
                    if (sqlEx.Number == 2627) // Unique constraint violation
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "AlreadyEnrolled",
                            "alert('You are already enrolled in this course!');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "EnrollError",
                            $"alert('Error enrolling in course: {sqlEx.Message.Replace("'", "\\'")}');", true);
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "EnrollError",
                        $"alert('Error enrolling in course: {ex.Message.Replace("'", "\\'")}');", true);
                }
            }
        }

        protected void btnViewCourse_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int courseId = Convert.ToInt32(btn.CommandArgument);

            // Redirect to course details page
            Response.Redirect($"CourseDetails.aspx?CourseID={courseId}");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        // Helper methods for data binding
        public string GetCourseInitial(string courseCode)
        {
            if (!string.IsNullOrEmpty(courseCode))
                return courseCode.Substring(0, 1);
            return "C";
        }

        public string TruncateDescription(string description)
        {
            if (string.IsNullOrEmpty(description))
                return "No description available.";

            if (description.Length > 100)
                return description.Substring(0, 100) + "...";

            return description;
        }

        public string GetEducatorName(string educatorId)
        {
            try
            {
                if (string.IsNullOrEmpty(educatorId))
                    return "Unknown";

                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT FullName FROM Users WHERE UserID = @EducatorID";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        con.Open();
                        object result = cmd.ExecuteScalar();
                        return result?.ToString().Split(' ')[0] ?? "Unknown";
                    }
                }
            }
            catch
            {
                return "Unknown";
            }
        }
    }
}