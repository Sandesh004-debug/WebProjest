<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="WebApplication3.StudentDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - LearnEase</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --sidebar-width: 260px;
            --brand-primary: #0d6efd;
            --brand-bg: #f8fafc;
            --success-color: #10b981;
            --warning-color: #f59e0b;
        }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--brand-bg);
            color: #1e293b;
        }

        h1, h2, h3, .brand-font { font-family: 'Outfit', sans-serif; }

        /* Sidebar Styling */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: #ffffff;
            border-right: 1px solid #e2e8f0;
            z-index: 1000;
            padding: 1.5rem;
            transition: all 0.3s ease;
        }

        .main-content {
            margin-left: var(--sidebar-width);
            padding: 2rem;
            min-height: 100vh;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            padding: 0.8rem 1rem;
            color: #64748b;
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 0.5rem;
            transition: 0.3s;
            font-weight: 500;
        }

        .nav-link-custom:hover, .nav-link-custom.active {
            background: #eff6ff;
            color: var(--brand-primary);
        }

        .nav-link-custom i { font-size: 1.25rem; margin-right: 1rem; }

        /* Card Enhancements */
        .glass-card {
            background: white;
            border: 1px solid #f1f5f9;
            border-radius: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
        }

        .text-gradient {
            background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .course-progress { height: 8px; border-radius: 10px; }

        /* Header Avatar */
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* Course Cards */
        .course-card {
            border-radius: 16px;
            overflow: hidden;
            height: 100%;
            position: relative;
        }

        .course-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 1;
        }

        .course-image {
            height: 180px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
        }

        .course-category {
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .enroll-btn {
            width: 100%;
            padding: 10px;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .enroll-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .badge-enrolled {
            background-color: #dcfce7;
            color: #166534;
        }

        .badge-available {
            background-color: #dbeafe;
            color: #1d4ed8;
        }

        /* Tab Navigation */
        .nav-tabs-custom {
            border-bottom: 2px solid #e2e8f0;
        }

        .nav-tabs-custom .nav-link {
            border: none;
            color: #64748b;
            font-weight: 500;
            padding: 12px 24px;
            border-radius: 12px 12px 0 0;
            margin-right: 5px;
        }

        .nav-tabs-custom .nav-link.active {
            color: var(--brand-primary);
            background-color: #eff6ff;
            border-bottom: 3px solid var(--brand-primary);
        }

        .nav-tabs-custom .nav-link:hover {
            color: var(--brand-primary);
            background-color: #f8fafc;
        }

        @media (max-width: 991.98px) {
            .sidebar { left: -100%; }
            .main-content { margin-left: 0; }
            .sidebar.show { left: 0; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="sidebar d-none d-lg-block">
            <div class="brand mb-5 px-2">
                <asp:HyperLink runat="server" NavigateUrl="~/index.aspx" CssClass="d-flex align-items-center text-decoration-none">
                    <asp:Image runat="server" ImageUrl="~/images/logo.png" Height="35" CssClass="me-2" />
                    <span class="fw-bold fs-4 text-gradient brand-font">LearnEase</span>
                </asp:HyperLink>
            </div>

            <nav class="nav flex-column">
                <a href="#" class="nav-link-custom active"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
                <a href="#enrolledCourses" class="nav-link-custom" onclick="showEnrolledCourses()"><i class="bi bi-bookmark-check"></i> Enrolled Courses</a>
                <a href="#allCourses" class="nav-link-custom" onclick="showAllCourses()"><i class="bi bi-book"></i> All Courses</a>
                <hr class="my-4 text-muted opacity-25">
                <a href="Profile.aspx" class="nav-link-custom"><i class="bi bi-person"></i> Profile</a>
                <a href="Settings.aspx" class="nav-link-custom"><i class="bi bi-gear"></i> Settings</a>
                <asp:LinkButton ID="btnLogoutSide" runat="server" CssClass="nav-link-custom text-danger mt-5" OnClick="btnLogout_Click">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </asp:LinkButton>
            </nav>
        </div>

        <main class="main-content">
            <header class="d-flex justify-content-between align-items-center mb-5">
                <div>
                    <h2 class="fw-bold mb-1">Hello, <asp:Literal ID="litFirstName" runat="server" Text="Student" /> 👋</h2>
                    <p class="text-muted mb-0">Welcome to your learning dashboard</p>
                </div>
                
                <div class="d-flex align-items-center gap-3">
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center gap-2 text-decoration-none" data-bs-toggle="dropdown">
                            <img src="https://ui-avatars.com/api/?name=<%= Server.UrlEncode(Session["FullName"]?.ToString() ?? "User") %>&background=0D6EFD&color=fff" class="user-avatar" alt="User">
                            <div class="d-none d-md-block">
                                <p class="mb-0 fw-bold small text-dark"><asp:Label ID="lblUserNameNav" runat="server" Text="User" /></p>
                                <p class="mb-0 text-muted" style="font-size: 0.7rem;">Student</p>
                            </div>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-4 p-2 mt-2">
                             <li><asp:LinkButton ID="btnLogout" runat="server" CssClass="dropdown-item rounded-3 py-2 text-danger" OnClick="btnLogout_Click"><i class="bi bi-box-arrow-right me-2"></i>Logout</asp:LinkButton></li>
                        </ul>
                    </div>
                </div>
            </header>

            <!-- Statistics Cards -->
            <div class="row g-4 mb-5">
                <div class="col-lg-4 col-md-6">
                    <div class="glass-card p-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-bookmark-check fs-4"></i>
                            </div>
                            <span class="text-success small fw-bold"><asp:Literal ID="litNewCourses" runat="server" Text="0 new" /></span>
                        </div>
                        <h6 class="text-muted mb-1">Enrolled Courses</h6>
                        <h3 class="fw-bold mb-0"><asp:Literal ID="litEnrolledCount" runat="server" Text="0" /></h3>
                    </div>
                </div>
                <div class="col-lg-4 col-md-6">
                    <div class="glass-card p-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="stat-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-check-circle fs-4"></i>
                            </div>
                            <span class="text-success small fw-bold"><asp:Literal ID="litActiveCourses" runat="server" Text="0 active" /></span>
                        </div>
                        <h6 class="text-muted mb-1">Active Courses</h6>
                        <h3 class="fw-bold mb-0"><asp:Literal ID="litActiveCount" runat="server" Text="0" /></h3>
                    </div>
                </div>
                <div class="col-lg-4 col-md-12">
                    <div class="glass-card p-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-clock-history fs-4"></i>
                            </div>
                            <span class="text-muted small fw-bold">This semester</span>
                        </div>
                        <h6 class="text-muted mb-1">Total Courses Available</h6>
                        <h3 class="fw-bold mb-0"><asp:Literal ID="litTotalCourses" runat="server" Text="0" /></h3>
                    </div>
                </div>
            </div>

            <!-- Course Tabs -->
            <div class="glass-card p-4">
                <ul class="nav nav-tabs-custom mb-4" id="courseTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="enrolled-tab" data-bs-toggle="tab" data-bs-target="#enrolled" type="button" role="tab">
                            <i class="bi bi-bookmark-check me-2"></i>Enrolled Courses (<asp:Literal ID="litEnrolledTabCount" runat="server" Text="0" />)
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="available-tab" data-bs-toggle="tab" data-bs-target="#available" type="button" role="tab">
                            <i class="bi bi-book me-2"></i>All Available Courses (<asp:Literal ID="litAvailableTabCount" runat="server" Text="0" />)
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="courseTabsContent">
                    <!-- Enrolled Courses Tab -->
                    <div class="tab-pane fade show active" id="enrolled" role="tabpanel">
                        <asp:Panel ID="pnlNoEnrollments" runat="server" CssClass="text-center py-5" Visible="false">
                            <i class="bi bi-book display-1 text-muted mb-3"></i>
                            <h4 class="mb-3">No Enrolled Courses Yet</h4>
                            <p class="text-muted mb-4">Browse available courses and enroll to get started</p>
                            <button class="btn btn-primary" type="button" data-bs-target="#available-tab" data-bs-toggle="tab">
                                <i class="bi bi-eye me-1"></i>Browse Courses
                            </button>
                        </asp:Panel>

                        <asp:Panel ID="pnlEnrolledCourses" runat="server">
                            <div class="row g-4">
                                <asp:Repeater ID="rptEnrolledCourses" runat="server">
                                    <ItemTemplate>
                                        <div class="col-lg-4 col-md-6">
                                            <div class="course-card glass-card">
                                                <div class="course-badge">
                                                    <span class="badge badge-enrolled py-2 px-3">
                                                        <i class="bi bi-check-circle me-1"></i>Enrolled
                                                    </span>
                                                </div>
                                                <div class="course-image">
                                                    <%# GetCourseInitial(Eval("CourseCode").ToString()) %>
                                                </div>
                                                <div class="p-4">
                                                    <span class="course-category text-primary mb-2">
                                                        <i class="bi bi-tag me-1"></i><%# Eval("Category") %>
                                                    </span>
                                                    <h5 class="fw-bold mb-2"><%# Eval("CourseCode") %>: <%# Eval("CourseName") %></h5>
                                                    <p class="text-muted small mb-3" style="min-height: 60px;">
                                                        <%# TruncateDescription(Eval("Description").ToString()) %>
                                                    </p>
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span class="badge bg-light text-dark">
                                                            <i class="bi bi-credit-card me-1"></i><%# Eval("Credits") %> credits
                                                        </span>
                                                        <span class="badge bg-light text-dark">
                                                            <i class="bi bi-person me-1"></i>Prof. <%# GetEducatorName(Eval("EducatorID").ToString()) %>
                                                        </span>
                                                    </div>
                                                    <div class="d-flex justify-content-between small text-muted mb-3">
                                                        <span><i class="bi bi-calendar me-1"></i><%# Convert.ToDateTime(Eval("StartDate")).ToString("MMM dd") %></span>
                                                        <span><%# Convert.ToDateTime(Eval("EndDate")).ToString("MMM dd, yyyy") %></span>
                                                    </div>
                                                    <asp:Button ID="btnViewCourse" runat="server" Text="View Course" 
                                                        CssClass="btn btn-outline-primary enroll-btn" 
                                                        CommandArgument='<%# Eval("CourseID") %>' 
                                                        OnClick="btnViewCourse_Click" />
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>
                    </div>

                    <!-- Available Courses Tab -->
                    <div class="tab-pane fade" id="available" role="tabpanel">
                        <div class="row g-4">
                            <asp:Repeater ID="rptAvailableCourses" runat="server" OnItemCommand="rptAvailableCourses_ItemCommand">
                                <ItemTemplate>
                                    <div class="col-lg-4 col-md-6">
                                        <div class="course-card glass-card">
                                            <div class="course-badge">
                                                <span class="badge badge-available py-2 px-3">
                                                    <i class="bi bi-clock me-1"></i>Available
                                                </span>
                                            </div>
                                            <div class="course-image">
                                                <%# GetCourseInitial(Eval("CourseCode").ToString()) %>
                                            </div>
                                            <div class="p-4">
                                                <span class="course-category text-primary mb-2">
                                                    <i class="bi bi-tag me-1"></i><%# Eval("Category") %>
                                                </span>
                                                <h5 class="fw-bold mb-2"><%# Eval("CourseCode") %>: <%# Eval("CourseName") %></h5>
                                                <p class="text-muted small mb-3" style="min-height: 60px;">
                                                    <%# TruncateDescription(Eval("Description").ToString()) %>
                                                </p>
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <span class="badge bg-light text-dark">
                                                        <i class="bi bi-credit-card me-1"></i><%# Eval("Credits") %> credits
                                                    </span>
                                                    <span class="badge bg-light text-dark">
                                                        <i class="bi bi-person me-1"></i>Prof. <%# GetEducatorName(Eval("EducatorID").ToString()) %>
                                                    </span>
                                                </div>
                                                <div class="d-flex justify-content-between small text-muted mb-3">
                                                    <span><i class="bi bi-calendar me-1"></i><%# Convert.ToDateTime(Eval("StartDate")).ToString("MMM dd") %></span>
                                                    <span><%# Convert.ToDateTime(Eval("EndDate")).ToString("MMM dd, yyyy") %></span>
                                                </div>
                                                <asp:Button ID="btnEnroll" runat="server" Text="Enroll Now" 
                                                    CssClass="btn btn-primary enroll-btn" 
                                                    CommandName="Enroll" 
                                                    CommandArgument='<%# Eval("CourseID") %>'
                                                    OnClientClick="return confirm('Are you sure you want to enroll in this course?');" />
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        
                        <asp:Panel ID="pnlNoCourses" runat="server" CssClass="text-center py-5" Visible="false">
                            <i class="bi bi-book display-1 text-muted mb-3"></i>
                            <h4 class="mb-3">No Courses Available</h4>
                            <p class="text-muted">Check back later for new course offerings</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </main>

        <!-- Hidden Fields -->
        <asp:HiddenField ID="hfStudentId" runat="server" />
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tab switching functions
        function showEnrolledCourses() {
            const enrolledTab = document.querySelector('#enrolled-tab');
            if (enrolledTab) {
                enrolledTab.click();
            }
        }

        function showAllCourses() {
            const availableTab = document.querySelector('#available-tab');
            if (availableTab) {
                availableTab.click();
            }
        }

        // Initialize tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>