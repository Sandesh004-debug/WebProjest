using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class CourseDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Get course ID from query string
                if (!string.IsNullOrEmpty(Request.QueryString["CourseID"]))
                {
                    hfCourseId.Value = Request.QueryString["CourseID"];
                    hfStudentId.Value = Session["UserID"].ToString();
                    LoadCourseDetails();
                    CheckEnrollmentStatus();
                }
                else
                {
                    Response.Redirect("StudentDashboard.aspx");
                }
            }
        }

        private void LoadCourseDetails()
        {
            try
            {
                int courseId = Convert.ToInt32(hfCourseId.Value);
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Get basic course info and extended details
                    string query = @"
                        SELECT 
                            c.CourseID, c.CourseCode, c.CourseName, c.Description, 
                            c.Category, c.Credits, c.MaxStudents, c.StartDate, c.EndDate,
                            u.FullName as EducatorName,
                            cd.LearningObjectives, cd.Prerequisites, cd.Syllabus,
                            cd.MaterialsRequired, cd.AssessmentMethods, cd.GradingPolicy,
                            cd.OfficeHours, cd.ContactEmail, cd.WebsiteURL,
                            (SELECT COUNT(*) FROM Enrollments WHERE CourseID = c.CourseID AND Status = 'Active') as EnrolledCount
                        FROM Courses c
                        INNER JOIN Users u ON c.EducatorID = u.UserID
                        LEFT JOIN CourseDetails cd ON c.CourseID = cd.CourseID
                        WHERE c.CourseID = @CourseID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Basic course info
                                litCourseCode.Text = reader["CourseCode"].ToString();
                                litCourseName.Text = reader["CourseName"].ToString();
                                litDescription.Text = reader["Description"].ToString();
                                litCategory.Text = reader["Category"].ToString();
                                litCredits.Text = reader["Credits"].ToString();
                                litMaxStudents.Text = reader["MaxStudents"].ToString();
                                litEnrolledCount.Text = reader["EnrolledCount"].ToString();

                                // Dates
                                DateTime startDate = Convert.ToDateTime(reader["StartDate"]);
                                DateTime endDate = Convert.ToDateTime(reader["EndDate"]);
                                litStartDate.Text = startDate.ToString("MMMM dd, yyyy");
                                litEndDate.Text = endDate.ToString("MMMM dd, yyyy");

                                // Calculate duration in weeks
                                int durationWeeks = (int)((endDate - startDate).TotalDays / 7);
                                litDuration.Text = durationWeeks.ToString();

                                // Educator info
                                string educatorName = reader["EducatorName"].ToString();
                                litEducatorName.Text = educatorName;
                                litEducatorInitials.Text = GetInitials(educatorName);

                                // Extended details (with fallback if not in CourseDetails table)
                                litFullDescription.Text = FormatText(reader["Description"].ToString());
                                litLearningObjectives.Text = FormatList(reader["LearningObjectives"].ToString(), "• ");
                                litPrerequisites.Text = FormatText(reader["Prerequisites"].ToString());
                                litSyllabus.Text = FormatSyllabus(reader["Syllabus"].ToString());
                                litMaterialsRequired.Text = FormatList(reader["MaterialsRequired"].ToString(), "• ");
                                litAssessmentMethods.Text = FormatList(reader["AssessmentMethods"].ToString(), "• ");
                                litGradingPolicy.Text = FormatText(reader["GradingPolicy"].ToString());
                                litOfficeHours.Text = FormatText(reader["OfficeHours"].ToString());
                                litContactEmail.Text = reader["ContactEmail"].ToString();

                                // Store website URL for later use
                                ViewState["WebsiteURL"] = reader["WebsiteURL"].ToString();
                            }
                            else
                            {
                                ShowError("Course not found.");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading course details: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"LoadCourseDetails Error: {ex.Message}\n{ex.StackTrace}");
            }
        }

        private void CheckEnrollmentStatus()
        {
            try
            {
                int courseId = Convert.ToInt32(hfCourseId.Value);
                int studentId = Convert.ToInt32(hfStudentId.Value);
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT EnrollmentID, EnrollmentDate, Status 
                        FROM Enrollments 
                        WHERE StudentID = @StudentID AND CourseID = @CourseID AND Status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Student is enrolled
                                hfIsEnrolled.Value = "true";
                                pnlEnrolled.Visible = true;
                                pnlNotEnrolled.Visible = false;

                                DateTime enrollmentDate = Convert.ToDateTime(reader["EnrollmentDate"]);
                                litEnrollmentDate.Text = enrollmentDate.ToString("MMMM dd, yyyy");
                            }
                            else
                            {
                                // Student is not enrolled
                                hfIsEnrolled.Value = "false";
                                pnlEnrolled.Visible = false;
                                pnlNotEnrolled.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"CheckEnrollmentStatus Error: {ex.Message}");
            }
        }

        protected void btnEnrollCourse_Click(object sender, EventArgs e)
        {
            try
            {
                int courseId = Convert.ToInt32(hfCourseId.Value);
                int studentId = Convert.ToInt32(hfStudentId.Value);
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Check if already enrolled
                    string checkQuery = "SELECT COUNT(*) FROM Enrollments WHERE StudentID = @StudentID AND CourseID = @CourseID AND Status = 'Active'";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@StudentID", studentId);
                        checkCmd.Parameters.AddWithValue("@CourseID", courseId);

                        int existingCount = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (existingCount > 0)
                        {
                            ShowError("You are already enrolled in this course!");
                            return;
                        }
                    }

                    // Check course capacity
                    string capacityQuery = @"
                        SELECT c.MaxStudents, 
                               (SELECT COUNT(*) FROM Enrollments WHERE CourseID = c.CourseID AND Status = 'Active') as CurrentEnrollments
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
                                    ShowError("This course has reached its maximum capacity!");
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
                            // Update enrollment status
                            hfIsEnrolled.Value = "true";
                            pnlEnrolled.Visible = true;
                            pnlNotEnrolled.Visible = false;

                            // Refresh course details to update enrollment count
                            LoadCourseDetails();

                            // Show success message
                            ScriptManager.RegisterStartupScript(this, GetType(), "EnrollSuccess",
                                @"Swal.fire({
                                    icon: 'success',
                                    title: 'Successfully Enrolled!',
                                    text: 'You have been enrolled in the course.',
                                    confirmButtonColor: '#4f46e5'
                                });", true);
                        }
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627) // Unique constraint violation
                {
                    ShowError("You are already enrolled in this course!");
                }
                else
                {
                    ShowError($"Error enrolling in course: {sqlEx.Message}");
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error enrolling in course: {ex.Message}");
            }
        }

        protected void btnDropCourse_Click(object sender, EventArgs e)
        {
            try
            {
                int courseId = Convert.ToInt32(hfCourseId.Value);
                int studentId = Convert.ToInt32(hfStudentId.Value);
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Enrollments 
                                   SET Status = 'Dropped'
                                   WHERE StudentID = @StudentID AND CourseID = @CourseID AND Status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Update enrollment status
                            hfIsEnrolled.Value = "false";
                            pnlEnrolled.Visible = false;
                            pnlNotEnrolled.Visible = true;

                            // Refresh course details to update enrollment count
                            LoadCourseDetails();

                            // Show success message
                            ScriptManager.RegisterStartupScript(this, GetType(), "DropSuccess",
                                @"Swal.fire({
                                    icon: 'success',
                                    title: 'Course Dropped!',
                                    text: 'You have been removed from the course.',
                                    confirmButtonColor: '#4f46e5'
                                });", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error dropping course: {ex.Message}");
            }
        }

        // Helper Methods
        private string GetInitials(string fullName)
        {
            if (string.IsNullOrEmpty(fullName))
                return "??";

            string[] names = fullName.Split(' ');
            if (names.Length >= 2)
                return $"{names[0][0]}{names[1][0]}".ToUpper();
            else if (names.Length == 1)
                return names[0].Substring(0, Math.Min(2, names[0].Length)).ToUpper();
            else
                return "??";
        }

        private string FormatText(string text)
        {
            if (string.IsNullOrEmpty(text))
                return "<p class='text-muted'>Not specified</p>";

            return $"<p>{text.Replace("\n", "<br/>")}</p>";
        }

        private string FormatList(string text, string bullet)
        {
            if (string.IsNullOrEmpty(text))
                return "<p class='text-muted'>Not specified</p>";

            string[] items = text.Split('\n');
            StringBuilder sb = new StringBuilder();

            foreach (string item in items)
            {
                if (!string.IsNullOrWhiteSpace(item))
                {
                    sb.AppendLine($"<div class='material-item'><i class='bi bi-check-circle me-2 text-success'></i>{bullet}{item.Trim()}</div>");
                }
            }

            return sb.ToString();
        }

        private string FormatSyllabus(string syllabus)
        {
            if (string.IsNullOrEmpty(syllabus))
                return "<p class='text-muted'>Syllabus not available</p>";

            string[] weeks = syllabus.Split('\n');
            StringBuilder sb = new StringBuilder();

            foreach (string week in weeks)
            {
                if (!string.IsNullOrWhiteSpace(week))
                {
                    sb.AppendLine($@"
                        <div class='syllabus-item'>
                            <div class='d-flex justify-content-between align-items-center mb-2'>
                                <span class='week-badge'>Week</span>
                            </div>
                            <p class='mb-0'>{week.Trim()}</p>
                        </div>");
                }
            }

            return sb.ToString();
        }

        public int GetEnrollmentProgress()
        {
            try
            {
                int maxStudents = Convert.ToInt32(litMaxStudents.Text);
                int enrolledCount = Convert.ToInt32(litEnrolledCount.Text);

                if (maxStudents == 0) return 0;

                double progress = ((double)enrolledCount / maxStudents) * 100;
                return (int)Math.Min(progress, 100);
            }
            catch
            {
                return 0;
            }
        }

        public string GetCourseWebsite()
        {
            return ViewState["WebsiteURL"]?.ToString() ?? "#";
        }

        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowError",
                $@"Swal.fire({{
                    icon: 'error',
                    title: 'Error',
                    text: '{message.Replace("'", "\\'")}',
                    confirmButtonColor: '#ef4444'
                }});", true);
        }
    }
}