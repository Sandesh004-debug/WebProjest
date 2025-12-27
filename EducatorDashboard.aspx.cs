using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class EducatorDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in and is an educator
                if (Session["UserID"] == null || Session["UserType"] == null || Session["UserType"].ToString() != "educator")
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Display educator name
                if (Session["FullName"] != null)
                {
                    litEducatorName.Text = Session["FullName"].ToString();
                    litWelcomeName.Text = Session["FullName"].ToString();
                }

                LoadStatistics();
                LoadCourses();
                LoadCoursesForFilter();
                LoadEnrollments();
                LoadEnrollmentStatistics();
            }
        }
        private void ClearCourseForm()
        {
            // Clear basic fields
            txtCourseCode.Text = "";
            txtCourseName.Text = "";
            txtDescription.Text = "";
            ddlCategory.SelectedIndex = 0;
            txtCredits.Text = "3";
            txtMaxStudents.Text = "30";

            // Set default dates
            txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtEndDate.Text = DateTime.Now.AddMonths(3).ToString("yyyy-MM-dd");
            chkIsActive.Checked = true;

            // Clear extended fields
            txtFullDescription.Text = "";
            txtLearningObjectives.Text = "";
            txtPrerequisites.Text = "";
            txtSyllabus.Text = "";
            txtMaterialsRequired.Text = "";
            txtAssessmentMethods.Text = "";
            txtGradingPolicy.Text = "";
            txtOfficeHours.Text = "";
            txtContactEmail.Text = "";
            txtWebsiteURL.Text = "";
        }

        private void LoadStatistics()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int educatorId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Total courses
                    string totalCoursesQuery = "SELECT COUNT(*) FROM Courses WHERE EducatorID = @EducatorID";
                    using (SqlCommand cmd = new SqlCommand(totalCoursesQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        litTotalCourses.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Active courses
                    string activeCoursesQuery = "SELECT COUNT(*) FROM Courses WHERE EducatorID = @EducatorID AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(activeCoursesQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        litActiveCourses.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Total students across all courses
                    string totalStudentsQuery = @"
                        SELECT COUNT(DISTINCT e.StudentID) 
                        FROM Enrollments e
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE c.EducatorID = @EducatorID AND e.Status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(totalStudentsQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        object result = cmd.ExecuteScalar();
                        litTotalStudents.Text = result?.ToString() ?? "0";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading statistics: {ex.Message}");
                litTotalCourses.Text = "0";
                litActiveCourses.Text = "0";
                litTotalStudents.Text = "0";
            }
        }

        private void LoadCourses()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int educatorId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT 
                                        CourseID,
                                        CourseCode,
                                        CourseName,
                                        Description,
                                        Category,
                                        Credits,
                                        MaxStudents,
                                        IsActive,
                                        CreatedDate,
                                        StartDate,
                                        EndDate,
                                        (SELECT COUNT(*) FROM Enrollments WHERE CourseID = Courses.CourseID AND Status = 'Active') as EnrolledCount
                                     FROM Courses 
                                     WHERE EducatorID = @EducatorID
                                     ORDER BY CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        con.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvCourses.DataSource = dt;
                        gvCourses.DataBind();

                        // Show/hide no courses message
                        pnlNoCourses.Visible = dt.Rows.Count == 0;
                        pnlCourses.Visible = dt.Rows.Count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading courses: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"LoadCourses Error: {ex.Message}");
                pnlNoCourses.Visible = true;
                pnlCourses.Visible = false;
            }
        }

        private void LoadCoursesForFilter()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int educatorId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT CourseID, CourseCode + ' - ' + CourseName as CourseDisplay 
                                   FROM Courses 
                                   WHERE EducatorID = @EducatorID AND IsActive = 1
                                   ORDER BY CourseCode";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            ddlFilterCourse.Items.Clear();
                            ddlFilterCourse.Items.Add(new ListItem("All Courses", "0"));

                            while (reader.Read())
                            {
                                ddlFilterCourse.Items.Add(new ListItem(
                                    reader["CourseDisplay"].ToString(),
                                    reader["CourseID"].ToString()
                                ));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading courses for filter: {ex.Message}");
            }
        }

        private void LoadEnrollments()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int educatorId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    StringBuilder query = new StringBuilder(@"
                        SELECT e.EnrollmentID, e.StudentID, e.CourseID, e.EnrollmentDate, e.Status,
                               u.FullName, u.Email,
                               c.CourseCode, c.CourseName, c.Category
                        FROM Enrollments e
                        INNER JOIN Users u ON e.StudentID = u.UserID
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE c.EducatorID = @EducatorID
                    ");

                    SqlCommand cmd = new SqlCommand();
                    cmd.Parameters.AddWithValue("@EducatorID", educatorId);

                    // Apply filters
                    if (ddlFilterCourse.SelectedValue != "0")
                    {
                        query.Append(" AND c.CourseID = @CourseID");
                        cmd.Parameters.AddWithValue("@CourseID", ddlFilterCourse.SelectedValue);
                    }

                    if (!string.IsNullOrEmpty(ddlFilterStatus.SelectedValue))
                    {
                        query.Append(" AND e.Status = @Status");
                        cmd.Parameters.AddWithValue("@Status", ddlFilterStatus.SelectedValue);
                    }

                    query.Append(" ORDER BY e.EnrollmentDate DESC");

                    cmd.CommandText = query.ToString();
                    cmd.Connection = con;

                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvEnrollments.DataSource = dt;
                    gvEnrollments.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading enrollments: {ex.Message}");
                ShowError($"Error loading enrollments: {ex.Message}");
            }
        }

       
        private void LoadEnrollmentStatistics()
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int educatorId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Total unique students
                    string totalStudentsQuery = @"
                        SELECT COUNT(DISTINCT e.StudentID) 
                        FROM Enrollments e
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE c.EducatorID = @EducatorID";

                    using (SqlCommand cmd = new SqlCommand(totalStudentsQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        litTotalStudentsEnrollments.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Active enrollments
                    string activeQuery = @"
                        SELECT COUNT(*) 
                        FROM Enrollments e
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE c.EducatorID = @EducatorID AND e.Status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(activeQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        litActiveEnrollments.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Completed enrollments
                    string completedQuery = @"
                        SELECT COUNT(*) 
                        FROM Enrollments e
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE c.EducatorID = @EducatorID AND e.Status = 'Completed'";

                    using (SqlCommand cmd = new SqlCommand(completedQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        litCompletedEnrollments.Text = cmd.ExecuteScalar().ToString();
                    }

                    // Dropped enrollments
                    string droppedQuery = @"
                        SELECT COUNT(*) 
                        FROM Enrollments e
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE c.EducatorID = @EducatorID AND e.Status = 'Dropped'";

                    using (SqlCommand cmd = new SqlCommand(droppedQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                        litDroppedEnrollments.Text = cmd.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error loading enrollment statistics: {ex.Message}");
            }
        }

        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                int educatorId = Convert.ToInt32(Session["UserID"]);

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Begin transaction to ensure both tables are updated
                    SqlTransaction transaction = con.BeginTransaction();

                    try
                    {
                        // Insert into Courses table
                        string courseQuery = @"INSERT INTO Courses 
                                    (CourseCode, CourseName, Description, EducatorID, Category, 
                                     Credits, MaxStudents, IsActive, StartDate, EndDate, CreatedDate)
                                    VALUES 
                                    (@CourseCode, @CourseName, @Description, @EducatorID, @Category, 
                                     @Credits, @MaxStudents, @IsActive, @StartDate, @EndDate, GETDATE());
                                    SELECT SCOPE_IDENTITY();";

                        int courseId = 0;

                        using (SqlCommand cmd = new SqlCommand(courseQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@CourseCode", txtCourseCode.Text.Trim());
                            cmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                            cmd.Parameters.AddWithValue("@EducatorID", educatorId);
                            cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                            cmd.Parameters.AddWithValue("@Credits", Convert.ToInt32(txtCredits.Text));
                            cmd.Parameters.AddWithValue("@MaxStudents", Convert.ToInt32(txtMaxStudents.Text));
                            cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                            cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(txtStartDate.Text));
                            cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(txtEndDate.Text));

                            courseId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // Insert into CourseDetails table
                        string detailsQuery = @"INSERT INTO CourseDetails 
                                       (CourseID, LearningObjectives, Prerequisites, Syllabus,
                                        MaterialsRequired, AssessmentMethods, GradingPolicy,
                                        OfficeHours, ContactEmail, WebsiteURL)
                                       VALUES 
                                       (@CourseID, @LearningObjectives, @Prerequisites, @Syllabus,
                                        @MaterialsRequired, @AssessmentMethods, @GradingPolicy,
                                        @OfficeHours, @ContactEmail, @WebsiteURL)";

                        using (SqlCommand detailsCmd = new SqlCommand(detailsQuery, con, transaction))
                        {
                            detailsCmd.Parameters.AddWithValue("@CourseID", courseId);
                            detailsCmd.Parameters.AddWithValue("@LearningObjectives", txtLearningObjectives.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@Prerequisites", txtPrerequisites.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@Syllabus", txtSyllabus.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@MaterialsRequired", txtMaterialsRequired.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@AssessmentMethods", txtAssessmentMethods.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@GradingPolicy", txtGradingPolicy.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@OfficeHours", txtOfficeHours.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@ContactEmail", txtContactEmail.Text.Trim());
                            detailsCmd.Parameters.AddWithValue("@WebsiteURL", txtWebsiteURL.Text.Trim());

                            detailsCmd.ExecuteNonQuery();
                        }

                        // Commit transaction
                        transaction.Commit();

                        // Clear form
                        ClearCourseForm();

                        // Refresh data
                        LoadStatistics();
                        LoadCourses();
                        LoadCoursesForFilter();

                        // Show success message
                        ShowSuccess("Course added successfully with complete details!");

                        // Switch to My Courses view
                        ScriptManager.RegisterStartupScript(this, GetType(), "SwitchToMyCourses",
                            "showMyCourses();", true);
                    }
                    catch (Exception ex)
                    {
                        // Rollback transaction on error
                        transaction.Rollback();
                        throw ex;
                    }
                }
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 2627) // Unique constraint violation
                {
                    ShowError("Course code already exists. Please use a different course code.");
                }
                else
                {
                    ShowError($"Error adding course: {sqlEx.Message}");
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error adding course: {ex.Message}");
            }
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                LoadCourseForEdit(courseId);
            }
            else if (e.CommandName == "DeleteCourse")
            {
                int courseId = Convert.ToInt32(e.CommandArgument);
                ShowDeleteConfirmation(courseId);
            }
        }

        private void LoadCourseForEdit(int courseId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT CourseCode, CourseName, Description, Category, Credits, 
                                    MaxStudents, IsActive, StartDate, EndDate 
                                    FROM Courses WHERE CourseID = @CourseID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Populate edit form
                                hfEditCourseId.Value = courseId.ToString();
                                txtEditCourseCode.Text = reader["CourseCode"].ToString();
                                txtEditCourseName.Text = reader["CourseName"].ToString();
                                txtEditDescription.Text = reader["Description"].ToString();

                                // Set category dropdown
                                string category = reader["Category"].ToString();
                                if (ddlEditCategory.Items.FindByValue(category) != null)
                                {
                                    ddlEditCategory.SelectedValue = category;
                                }
                                else
                                {
                                    ddlEditCategory.SelectedValue = "Other";
                                }

                                txtEditCredits.Text = reader["Credits"].ToString();
                                txtEditMaxStudents.Text = reader["MaxStudents"].ToString();
                                chkEditIsActive.Checked = Convert.ToBoolean(reader["IsActive"]);

                                if (reader["StartDate"] != DBNull.Value)
                                {
                                    DateTime startDate = Convert.ToDateTime(reader["StartDate"]);
                                    txtEditStartDate.Text = startDate.ToString("yyyy-MM-dd");
                                }

                                if (reader["EndDate"] != DBNull.Value)
                                {
                                    DateTime endDate = Convert.ToDateTime(reader["EndDate"]);
                                    txtEditEndDate.Text = endDate.ToString("yyyy-MM-dd");
                                }

                                // Show edit modal
                                ScriptManager.RegisterStartupScript(this, GetType(), "ShowEditModal",
                                    @"var editModal = new bootstrap.Modal(document.getElementById('editCourseModal'));
                                    editModal.show();", true);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading course for editing: {ex.Message}");
            }
        }

        protected void btnUpdateCourse_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(hfEditCourseId.Value))
                {
                    ShowError("No course selected for editing.");
                    return;
                }

                int courseId = Convert.ToInt32(hfEditCourseId.Value);
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Courses 
                                    SET CourseName = @CourseName,
                                        Description = @Description,
                                        Category = @Category,
                                        Credits = @Credits,
                                        MaxStudents = @MaxStudents,
                                        IsActive = @IsActive,
                                        StartDate = @StartDate,
                                        EndDate = @EndDate
                                    WHERE CourseID = @CourseID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        cmd.Parameters.AddWithValue("@CourseName", txtEditCourseName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Description", txtEditDescription.Text.Trim());
                        cmd.Parameters.AddWithValue("@Category", ddlEditCategory.SelectedValue);
                        cmd.Parameters.AddWithValue("@Credits", Convert.ToInt32(txtEditCredits.Text));
                        cmd.Parameters.AddWithValue("@MaxStudents", Convert.ToInt32(txtEditMaxStudents.Text));
                        cmd.Parameters.AddWithValue("@IsActive", chkEditIsActive.Checked);
                        cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(txtEditStartDate.Text));
                        cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(txtEditEndDate.Text));

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Refresh data
                            LoadStatistics();
                            LoadCourses();
                            LoadCoursesForFilter();

                            // Show success message
                            ShowSuccess("Course updated successfully!");

                            // Hide edit modal
                            ScriptManager.RegisterStartupScript(this, GetType(), "HideEditModal",
                                @"var editModal = bootstrap.Modal.getInstance(document.getElementById('editCourseModal'));
                                if (editModal) editModal.hide();", true);
                        }
                        else
                        {
                            ShowError("Failed to update course. Course not found.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error updating course: {ex.Message}");
            }
        }

        private void ShowDeleteConfirmation(int courseId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    // Get course name and check for enrollments in a single query
                    string query = @"
                SELECT 
                    c.CourseName,
                    (SELECT COUNT(*) FROM Enrollments WHERE CourseID = @CourseID AND Status = 'Active') as ActiveEnrollments
                FROM Courses c 
                WHERE c.CourseID = @CourseID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", courseId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string courseName = reader["CourseName"].ToString();
                                int activeEnrollments = Convert.ToInt32(reader["ActiveEnrollments"]);

                                hfDeleteCourseId.Value = courseId.ToString();

                                if (activeEnrollments > 0)
                                {
                                    // Show error directly without modal
                                    ShowError($"Cannot delete '{courseName}' because it has {activeEnrollments} active enrollment(s).");
                                    return;
                                }

                                // Pass course name to JavaScript for modal
                                string script = $@"
                            document.getElementById('deleteCourseName').textContent = '{courseName.Replace("'", "\\'")}';
                            var deleteModal = new bootstrap.Modal(document.getElementById('deleteCourseModal'));
                            deleteModal.show();";
                                ScriptManager.RegisterStartupScript(this, GetType(), "ShowDeleteModal", script, true);
                            }
                            else
                            {
                                ShowError("Course not found!");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading course for deletion: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"ShowDeleteConfirmation Error: {ex.Message}");
            }
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(hfDeleteCourseId.Value))
                {
                    ShowError("No course selected for deletion.");
                    return;
                }

                int courseId = Convert.ToInt32(hfDeleteCourseId.Value);
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;
                string courseName = "";

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();

                    // Begin transaction to ensure data consistency
                    SqlTransaction transaction = con.BeginTransaction();

                    try
                    {
                        // 1. Get course name for message
                        string getCourseQuery = "SELECT CourseName FROM Courses WHERE CourseID = @CourseID";
                        using (SqlCommand getCmd = new SqlCommand(getCourseQuery, con, transaction))
                        {
                            getCmd.Parameters.AddWithValue("@CourseID", courseId);
                            object result = getCmd.ExecuteScalar();
                            if (result == null)
                            {
                                transaction.Rollback();
                                ShowError("Course not found!");
                                return;
                            }
                            courseName = result.ToString();
                        }

                        // 2. Check for ANY enrollments (not just active)
                        string checkEnrollmentsQuery = "SELECT COUNT(*) FROM Enrollments WHERE CourseID = @CourseID";
                        using (SqlCommand enrollCmd = new SqlCommand(checkEnrollmentsQuery, con, transaction))
                        {
                            enrollCmd.Parameters.AddWithValue("@CourseID", courseId);
                            int enrollmentCount = Convert.ToInt32(enrollCmd.ExecuteScalar());

                            if (enrollmentCount > 0)
                            {
                                transaction.Rollback();
                                ShowError($"Cannot delete '{courseName}' because it has {enrollmentCount} enrollment(s). Please remove all enrollments first.");
                                return;
                            }
                        }

                        // 3. Delete from CourseDetails first (foreign key constraint)
                        string deleteDetailsQuery = "DELETE FROM CourseDetails WHERE CourseID = @CourseID";
                        using (SqlCommand detailsCmd = new SqlCommand(deleteDetailsQuery, con, transaction))
                        {
                            detailsCmd.Parameters.AddWithValue("@CourseID", courseId);
                            detailsCmd.ExecuteNonQuery();
                        }

                        // 4. Delete from Courses
                        string deleteCourseQuery = "DELETE FROM Courses WHERE CourseID = @CourseID";
                        using (SqlCommand courseCmd = new SqlCommand(deleteCourseQuery, con, transaction))
                        {
                            courseCmd.Parameters.AddWithValue("@CourseID", courseId);
                            int rowsAffected = courseCmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                transaction.Commit();
                                ShowSuccess($"Course '{courseName}' deleted successfully!");
                            }
                            else
                            {
                                transaction.Rollback();
                                ShowError("Failed to delete course.");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        throw ex;
                    }
                }

                // Refresh data
                LoadStatistics();
                LoadCourses();
                LoadCoursesForFilter();

                // Hide delete modal
                string script = @"var deleteModal = bootstrap.Modal.getInstance(document.getElementById('deleteCourseModal'));
                        if (deleteModal) deleteModal.hide();";
                ScriptManager.RegisterStartupScript(this, GetType(), "HideDeleteModal", script, true);
            }
            catch (SqlException sqlEx)
            {
                if (sqlEx.Number == 547) // Foreign key constraint violation
                {
                    ShowError("Cannot delete this course because it has related records in the database.");
                }
                else
                {
                    ShowError($"Database error: {sqlEx.Message}");
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error deleting course: {ex.Message}");
                System.Diagnostics.Debug.WriteLine($"DeleteCourse Error: {ex.Message}");
            }
        }

        // Enrollments Methods
        protected void ddlFilterCourse_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadEnrollments();
            LoadEnrollmentStatistics();
        }

        protected void ddlFilterStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadEnrollments();
            LoadEnrollmentStatistics();
        }

        protected void gvEnrollments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int enrollmentId = Convert.ToInt32(e.CommandArgument);
                LoadEnrollmentForStatusUpdate(enrollmentId);
            }
            else if (e.CommandName == "ViewProfile")
            {
                int studentId = Convert.ToInt32(e.CommandArgument);
                // You can implement student profile viewing here
                ShowSuccess($"Viewing student profile (ID: {studentId}) - Feature to be implemented");
            }
        }

        private void LoadEnrollmentForStatusUpdate(int enrollmentId)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT e.EnrollmentID, e.Status,
                               u.FullName as StudentName,
                               c.CourseCode + ' - ' + c.CourseName as CourseDisplay
                        FROM Enrollments e
                        INNER JOIN Users u ON e.StudentID = u.UserID
                        INNER JOIN Courses c ON e.CourseID = c.CourseID
                        WHERE e.EnrollmentID = @EnrollmentID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@EnrollmentID", enrollmentId);
                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                hfUpdateEnrollmentId.Value = enrollmentId.ToString();
                                string studentName = reader["StudentName"].ToString();
                                string courseDisplay = reader["CourseDisplay"].ToString();
                                string currentStatus = reader["Status"].ToString();

                                // Set dropdown to current status
                                ddlNewStatus.SelectedValue = currentStatus;

                                // Pass data to JavaScript
                                ScriptManager.RegisterStartupScript(this, GetType(), "LoadEnrollmentData",
                                    $@"document.getElementById('studentNameDisplay').textContent = '{studentName}';
                                    document.getElementById('courseNameDisplay').textContent = '{courseDisplay}';
                                    document.getElementById('currentStatusDisplay').textContent = '{currentStatus}';
                                    var modal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
                                    modal.show();", true);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error loading enrollment: {ex.Message}");
            }
        }

        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(hfUpdateEnrollmentId.Value))
                {
                    ShowError("No enrollment selected for update.");
                    return;
                }

                int enrollmentId = Convert.ToInt32(hfUpdateEnrollmentId.Value);
                string newStatus = ddlNewStatus.SelectedValue;
                string remarks = txtStatusRemarks.Text.Trim();

                string connectionString = ConfigurationManager.ConnectionStrings["LMSConn"].ConnectionString;

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"UPDATE Enrollments 
                                   SET Status = @Status
                                   WHERE EnrollmentID = @EnrollmentID";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@EnrollmentID", enrollmentId);
                        cmd.Parameters.AddWithValue("@Status", newStatus);

                        con.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            // Refresh data
                            LoadEnrollments();
                            LoadEnrollmentStatistics();

                            ShowSuccess("Enrollment status updated successfully!");

                            // Hide modal
                            ScriptManager.RegisterStartupScript(this, GetType(), "HideStatusModal",
                                @"var modal = bootstrap.Modal.getInstance(document.getElementById('updateStatusModal'));
                                if (modal) modal.hide();", true);

                            // Clear form
                            txtStatusRemarks.Text = "";
                        }
                        else
                        {
                            ShowError("Failed to update enrollment status.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Error updating enrollment status: {ex.Message}");
            }
        }

        protected void btnExportEnrollments_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment;filename=StudentEnrollments.xls");
                Response.ContentType = "application/vnd.ms-excel";
                Response.Charset = "";

                System.IO.StringWriter sw = new System.IO.StringWriter();
                HtmlTextWriter hw = new HtmlTextWriter(sw);

                gvEnrollments.AllowPaging = false;
                LoadEnrollments();

                gvEnrollments.RenderControl(hw);
                Response.Output.Write(sw.ToString());
                Response.Flush();
                Response.End();
            }
            catch (Exception ex)
            {
                ShowError($"Error exporting enrollments: {ex.Message}");
            }
        }

        public override void VerifyRenderingInServerForm(Control control)
        {
            // Required for GridView export
        }

        protected void gvEnrollments_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvEnrollments.PageIndex = e.NewPageIndex;
            LoadEnrollments();
        }

        // Helper Methods
        public string GetInitials(string fullName)
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

        public string GetStatusBadgeClass(string status)
        {
            switch (status.ToLower())
            {
                case "active": return "badge-active";
                case "completed": return "badge-completed";
                case "dropped": return "badge-dropped";
                default: return "badge-pending";
            }
        }

        // Navigation and UI Methods
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void gvCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCourses.PageIndex = e.NewPageIndex;
            LoadCourses();
        }

       

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            litErrorMessage.Text = message;
            pnlSuccess.Visible = false;

            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollToTop",
                "window.scrollTo(0, 0);", true);
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            litSuccessMessage.Text = message;
            pnlError.Visible = false;

            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollToTop",
                "window.scrollTo(0, 0);", true);
        }
        
    }
}

