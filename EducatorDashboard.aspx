<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EducatorDashboard.aspx.cs" Inherits="WebApplication3.EducatorDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Educator Dashboard | LearnEase</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #7c3aed;
            --success-color: #10b981;
            --info-color: #3b82f6;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --light-bg: #f8fafc;
            --dark-text: #1e293b;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            color: var(--dark-text);
            min-height: 100vh;
        }
        
        .sidebar {
            background: linear-gradient(180deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            color: white;
            position: fixed;
            width: 260px;
            padding-top: 20px;
            transition: all 0.3s;
            z-index: 1000;
        }
        
        .main-content {
            margin-left: 260px;
            transition: all 0.3s;
        }
        
        .navbar-top {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 1rem 20px;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .content-area {
            padding: 20px;
            min-height: calc(100vh - 80px);
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
            border: 1px solid #e2e8f0;
            height: 100%;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            margin: 4px 0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            transition: all 0.3s;
            text-decoration: none;
            cursor: pointer;
        }
        
        .nav-link:hover, .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .nav-link i {
            margin-right: 10px;
            font-size: 18px;
        }
        
        .table th {
            font-weight: 600;
            color: #475569;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .table td {
            vertical-align: middle;
        }
        
        .badge-custom {
            padding: 5px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-active {
            background-color: #dcfce7;
            color: #166534;
        }
        
        .badge-inactive {
            background-color: #f3f4f6;
            color: #6b7280;
        }
        
        .btn-gradient {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-gradient:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }
        
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border-radius: 12px 12px 0 0;
        }
        
        .form-label {
            font-weight: 600;
            color: #475569;
            margin-bottom: 5px;
        }
        
        .form-control, .form-select {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 10px;
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }
        
        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            color: var(--primary-color);
            font-size: 24px;
        }
        
        .course-image {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: bold;
        }
        
        /* Enrollment specific styles */
        .avatar-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 14px;
        }
        
        .badge-enrollment-active { background-color: #dcfce7; color: #166534; }
        .badge-enrollment-completed { background-color: #dbeafe; color: #1d4ed8; }
        .badge-enrollment-dropped { background-color: #fee2e2; color: #991b1b; }
        .badge-enrollment-pending { background-color: #fef3c7; color: #92400e; }
        
        .enrollments-content {
            display: none;
        }
        
        @media (max-width: 768px) {
            .sidebar {
                margin-left: -260px;
            }
            
            .sidebar.show {
                margin-left: 0;
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .mobile-menu-btn {
                display: block;
            }
        }
        /* Add to existing CSS */
.steps {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
    position: relative;
}

.steps::before {
    content: '';
    position: absolute;
    top: 20px;
    left: 50px;
    right: 50px;
    height: 2px;
    background: #e2e8f0;
    z-index: 1;
}

.step {
    display: flex;
    flex-direction: column;
    align-items: center;
    position: relative;
    z-index: 2;
    flex: 1;
}

.step-circle {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #e2e8f0;
    color: #64748b;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    margin-bottom: 8px;
    border: 3px solid white;
    transition: all 0.3s;
}

.step.active .step-circle {
    background: var(--primary-color);
    color: white;
    border-color: var(--primary-color);
}

.step-label {
    font-size: 12px;
    font-weight: 600;
    color: #64748b;
    text-align: center;
}

.step.active .step-label {
    color: var(--primary-color);
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="px-3 mb-4">
                <h3 class="fw-bold mb-0">LearnEase</h3>
                <small class="text-white-50">Educator Portal</small>
            </div>
            
            <div class="px-3 mb-4">
                <div class="d-flex align-items-center">
                    <div class="bg-white rounded-circle p-2 me-3">
                        <i class="bi bi-person-fill text-primary fs-4"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fw-semibold"><asp:Literal ID="litEducatorName" runat="server" /></h6>
                        <small class="text-white-50">Educator</small>
                    </div>
                </div>
            </div>
            
            <div class="px-3">
                <a href="#" class="nav-link active" onclick="showDashboard()">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a href="#" class="nav-link" onclick="showAddCourse()">
                    <i class="bi bi-plus-circle"></i> Add Course
                </a>
                <a href="#" class="nav-link" onclick="showMyCourses()">
                    <i class="bi bi-book"></i> My Courses
                </a>
                <a href="#" class="nav-link" onclick="showEnrollments()">
                    <i class="bi bi-people"></i> Enrollments
                </a>
            </div>
            
            <div class="px-3 mt-auto py-4">
                <asp:Button ID="btnLogout" runat="server" Text="Logout" 
                    CssClass="btn btn-outline-light w-100" OnClick="btnLogout_Click" />
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content" id="mainContent">
            <!-- Top Navigation -->
            <nav class="navbar-top">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <button class="mobile-menu-btn" onclick="toggleSidebar()">
                            <i class="bi bi-list"></i>
                        </button>
                        <h4 class="mb-0 fw-semibold d-inline ms-3">
                            <span id="pageTitle">Dashboard</span>
                        </h4>
                    </div>
                    <div class="d-flex align-items-center">
                        <div class="dropdown">
                            <button class="btn btn-light" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-bell"></i>
                                <span class="badge bg-danger rounded-pill">0</span>
                            </button>
                        </div>
                    </div>
                </div>
            </nav>
            
            <!-- Content Area -->
            <div class="content-area">
                <!-- Error/Success Messages -->
                <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger alert-dismissible fade show" Visible="false" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <asp:Literal ID="litErrorMessage" runat="server" />
                    <button type="button" class="btn-close" onclick="closeAlert(this)"></button>
                </asp:Panel>
                
                <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success alert-dismissible fade show" Visible="false" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <asp:Literal ID="litSuccessMessage" runat="server" />
                    <button type="button" class="btn-close" onclick="closeAlert(this)"></button>
                </asp:Panel>
                
                <!-- Dashboard Content (Default View) -->
                <div id="dashboardContent">
                    <!-- Welcome Message -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="stat-card">
                                <h5 class="fw-semibold">Welcome, <asp:Literal ID="litWelcomeName" runat="server" />!</h5>
                                <p class="text-muted mb-0">Here's an overview of your teaching activities</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Statistics Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="text-muted mb-2">Total Courses</h6>
                                        <h2 class="fw-bold mb-0"><asp:Literal ID="litTotalCourses" runat="server" Text="0" /></h2>
                                    </div>
                                    <div class="stat-icon" style="background-color: #e0e7ff; color: var(--primary-color);">
                                        <i class="bi bi-book"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="text-muted mb-2">Active Courses</h6>
                                        <h2 class="fw-bold mb-0"><asp:Literal ID="litActiveCourses" runat="server" Text="0" /></h2>
                                    </div>
                                    <div class="stat-icon" style="background-color: #dcfce7; color: var(--success-color);">
                                        <i class="bi bi-check-circle"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="stat-card">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="text-muted mb-2">Total Students</h6>
                                        <h2 class="fw-bold mb-0"><asp:Literal ID="litTotalStudents" runat="server" Text="0" /></h2>
                                    </div>
                                    <div class="stat-icon" style="background-color: #fef3c7; color: var(--warning-color);">
                                        <i class="bi bi-people"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="row">
                        <div class="col-12">
                            <div class="stat-card">
                                <h6 class="fw-semibold mb-3">Quick Actions</h6>
                                <div class="d-flex flex-wrap gap-3">
                                    <button class="btn btn-gradient" onclick="showAddCourse()">
                                        <i class="bi bi-plus-lg me-1"></i> Add New Course
                                    </button>
                                    <button class="btn btn-outline-primary" onclick="showMyCourses()">
                                        <i class="bi bi-book me-1"></i> View All Courses
                                    </button>
                                    <button class="btn btn-outline-secondary" onclick="showEnrollments()">
                                        <i class="bi bi-people me-1"></i> View Enrollments
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Add Course Content -->
                <!-- Add Course Content -->
<div id="addCourseContent" style="display: none;">
    <div class="row">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-semibold mb-0">Add New Course</h5>
                <button class="btn btn-outline-secondary" onclick="showDashboard()">
                    <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
                </button>
            </div>
            
            <!-- Progress Steps -->
            <div class="card border-0 shadow mb-4">
                <div class="card-body">
                    <div class="steps">
                        <div class="step active" id="step1">
                            <div class="step-circle">1</div>
                            <div class="step-label">Basic Info</div>
                        </div>
                        <div class="step" id="step2">
                            <div class="step-circle">2</div>
                            <div class="step-label">Course Details</div>
                        </div>
                        <div class="step" id="step3">
                            <div class="step-circle">3</div>
                            <div class="step-label">Review</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Step 1: Basic Information -->
            <div class="card border-0 shadow mb-4" id="step1Content">
                <div class="card-header bg-light">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-info-circle me-2"></i>Basic Course Information</h6>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Course Code *</label>
                            <asp:TextBox ID="txtCourseCode" runat="server" CssClass="form-control" 
                                placeholder="e.g., CS101" MaxLength="20" />
                            <asp:RequiredFieldValidator ID="rfvCourseCode" runat="server" 
                                ControlToValidate="txtCourseCode" ErrorMessage="Course code is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Course Name *</label>
                            <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control" 
                                placeholder="e.g., Introduction to Programming" MaxLength="100" />
                            <asp:RequiredFieldValidator ID="rfvCourseName" runat="server" 
                                ControlToValidate="txtCourseName" ErrorMessage="Course name is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-12">
                            <label class="form-label">Brief Description *</label>
                            <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="3" placeholder="Brief course overview..." />
                            <asp:RequiredFieldValidator ID="rfvDescription" runat="server" 
                                ControlToValidate="txtDescription" ErrorMessage="Description is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Category *</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                <asp:ListItem Value="">Select Category</asp:ListItem>
                                <asp:ListItem Value="Computer Science">Computer Science</asp:ListItem>
                                <asp:ListItem Value="Mathematics">Mathematics</asp:ListItem>
                                <asp:ListItem Value="Science">Science</asp:ListItem>
                                <asp:ListItem Value="Engineering">Engineering</asp:ListItem>
                                <asp:ListItem Value="Business">Business</asp:ListItem>
                                <asp:ListItem Value="Humanities">Humanities</asp:ListItem>
                                <asp:ListItem Value="Arts">Arts</asp:ListItem>
                                <asp:ListItem Value="Language">Language</asp:ListItem>
                                <asp:ListItem Value="Other">Other</asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCategory" runat="server" 
                                ControlToValidate="ddlCategory" InitialValue="" ErrorMessage="Category is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Credits *</label>
                            <asp:TextBox ID="txtCredits" runat="server" CssClass="form-control" 
                                Text="3" TextMode="Number" min="1" max="10" />
                            <asp:RequiredFieldValidator ID="rfvCredits" runat="server" 
                                ControlToValidate="txtCredits" ErrorMessage="Credits are required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Max Students *</label>
                            <asp:TextBox ID="txtMaxStudents" runat="server" CssClass="form-control" 
                                Text="30" TextMode="Number" min="1" max="500" />
                            <asp:RequiredFieldValidator ID="rfvMaxStudents" runat="server" 
                                ControlToValidate="txtMaxStudents" ErrorMessage="Max students is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Start Date *</label>
                            <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" 
                                TextMode="Date" />
                            <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" 
                                ControlToValidate="txtStartDate" ErrorMessage="Start date is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">End Date *</label>
                            <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" 
                                TextMode="Date" />
                            <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" 
                                ControlToValidate="txtEndDate" ErrorMessage="End date is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        <div class="col-12">
                            <div class="form-check">
                                <asp:CheckBox ID="chkIsActive" runat="server" CssClass="form-check-input" Checked="true" />
                                <label class="form-check-label" for="<%= chkIsActive.ClientID %>">Active Course</label>
                            </div>
                        </div>
                        <div class="col-12 mt-4">
                            <button type="button" class="btn btn-gradient" onclick="nextStep()">
                                Next: Course Details <i class="bi bi-arrow-right ms-1"></i>
                            </button>
                            <button type="button" class="btn btn-secondary ms-2" onclick="showDashboard()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Step 2: Course Details -->
            <div class="card border-0 shadow mb-4" id="step2Content" style="display: none;">
                <div class="card-header bg-light">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-journal-text me-2"></i>Course Details & Syllabus</h6>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Detailed Description *</label>
                            <asp:TextBox ID="txtFullDescription" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="4" placeholder="Provide a comprehensive course description..." />
                            <small class="text-muted">This will appear on the course details page</small>
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label">Learning Objectives *</label>
                            <asp:TextBox ID="txtLearningObjectives" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="5" placeholder="Enter learning objectives (one per line)..." />
                            <small class="text-muted">Enter each objective on a new line. Example: 
                                <br/>1. Understand basic programming concepts
                                <br/>2. Write simple Python programs
                            </small>
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label">Prerequisites</label>
                            <asp:TextBox ID="txtPrerequisites" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="3" placeholder="e.g., Basic algebra knowledge, No prior programming experience required..." />
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label">Course Syllabus *</label>
                            <asp:TextBox ID="txtSyllabus" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="8" placeholder="Enter weekly schedule (one week per line)...&#10;Example:&#10;Week 1: Introduction to Programming&#10;Week 2: Variables and Data Types&#10;Week 3: Control Structures" />
                            <small class="text-muted">Format: "Week X: Topic" on separate lines</small>
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label">Required Materials</label>
                            <asp:TextBox ID="txtMaterialsRequired" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="3" placeholder="e.g., Laptop with Python installed, Text editor, Internet connection..." />
                        </div>
                        
                        <div class="col-12 mt-4">
                            <button type="button" class="btn btn-outline-secondary" onclick="prevStep()">
                                <i class="bi bi-arrow-left me-1"></i> Back
                            </button>
                            <button type="button" class="btn btn-gradient ms-2" onclick="nextStep()">
                                Next: Review & Submit <i class="bi bi-arrow-right ms-1"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Step 3: Assessment & Review -->
            <div class="card border-0 shadow mb-4" id="step3Content" style="display: none;">
                <div class="card-header bg-light">
                    <h6 class="mb-0 fw-semibold"><i class="bi bi-clipboard-check me-2"></i>Assessment & Review</h6>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Assessment Methods *</label>
                            <asp:TextBox ID="txtAssessmentMethods" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="4" placeholder="e.g., Weekly assignments (40%), Mid-term exam (20%), Final project (30%), Class participation (10%)..." />
                            <small class="text-muted">Describe how students will be evaluated</small>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Grading Policy *</label>
                            <asp:TextBox ID="txtGradingPolicy" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="4" placeholder="e.g., A: 90-100%, B: 80-89%, C: 70-79%, D: 60-69%, F: Below 60%..." />
                            <small class="text-muted">Define the grading scale</small>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Office Hours</label>
                            <asp:TextBox ID="txtOfficeHours" runat="server" CssClass="form-control" 
                                placeholder="e.g., Monday & Wednesday: 2-4 PM, Friday: 10 AM-12 PM" />
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label">Contact Email *</label>
                            <asp:TextBox ID="txtContactEmail" runat="server" CssClass="form-control" 
                                TextMode="Email" placeholder="professor@learnease.com" />
                            <asp:RequiredFieldValidator ID="rfvContactEmail" runat="server" 
                                ControlToValidate="txtContactEmail" ErrorMessage="Contact email is required" 
                                Display="Dynamic" CssClass="text-danger small" ValidationGroup="AddCourse" />
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label">Course Website (Optional)</label>
                            <asp:TextBox ID="txtWebsiteURL" runat="server" CssClass="form-control" 
                                placeholder="https://courses.learnease.com/cs101" />
                        </div>
                        
                        <!-- Course Preview -->
                        <div class="col-12 mt-4">
                            <div class="card border">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0 fw-semibold"><i class="bi bi-eye me-2"></i>Course Preview</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h5 id="previewCourseName">[Course Name]</h5>
                                            <p id="previewCourseCode" class="text-muted mb-2">[Course Code]</p>
                                            <p id="previewDescription" class="mb-3">[Course Description]</p>
                                            <div class="d-flex gap-2 mb-3">
                                                <span class="badge bg-primary" id="previewCategory">[Category]</span>
                                                <span class="badge bg-secondary" id="previewCredits">[Credits] credits</span>
                                                <span class="badge bg-info" id="previewStudents">Max: [Max Students]</span>
                                            </div>
                                            <p class="mb-1"><strong>Duration:</strong> <span id="previewDuration">[Start Date] to [End Date]</span></p>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="text-muted small">Enrollment opens soon</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-12 mt-4">
                            <button type="button" class="btn btn-outline-secondary" onclick="prevStep()">
                                <i class="bi bi-arrow-left me-1"></i> Back
                            </button>
                            <asp:Button ID="btnAddCourse" runat="server" Text="Create Course" 
                                CssClass="btn btn-gradient ms-2 px-4" OnClick="btnAddCourse_Click" 
                                ValidationGroup="AddCourse" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
                
                <!-- My Courses Content -->
                <div id="myCoursesContent" style="display: none;">
                    <div class="row">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-semibold mb-0">My Courses</h5>
                                <div>
                                    <button class="btn btn-outline-secondary me-2" onclick="showDashboard()">
                                        <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
                                    </button>
                                    <button class="btn btn-gradient" onclick="showAddCourse()">
                                        <i class="bi bi-plus-lg me-1"></i> Add New Course
                                    </button>
                                </div>
                            </div>
                            
                            <asp:Panel ID="pnlNoCourses" runat="server" CssClass="text-center py-5" Visible="false">
                                <i class="bi bi-book display-1 text-muted"></i>
                                <h5 class="mt-3">No courses yet</h5>
                                <p class="text-muted">Create your first course to get started</p>
                                <button class="btn btn-gradient mt-3" onclick="showAddCourse()">
                                    <i class="bi bi-plus-lg me-1"></i> Create Your First Course
                                </button>
                            </asp:Panel>
                            
                            <asp:Panel ID="pnlCourses" runat="server">
                                <div class="table-responsive">
                                    <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="false" 
                                        CssClass="table table-hover" GridLines="None" 
                                        OnRowCommand="gvCourses_RowCommand" AllowPaging="true" PageSize="10"
                                        OnPageIndexChanging="gvCourses_PageIndexChanging">
                                        <Columns>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <div class="course-image">
                                                        <%# Eval("CourseCode").ToString().Substring(0, 1) %>
                                                    </div>
                                                </ItemTemplate>
                                                <ItemStyle Width="70px" />
                                            </asp:TemplateField>
                                            
                                            <asp:TemplateField HeaderText="Course Details">
                                                <ItemTemplate>
                                                    <h6 class="fw-semibold mb-1"><%# Eval("CourseCode") %> - <%# Eval("CourseName") %></h6>
                                                    <p class="text-muted small mb-2"><%# Eval("Description") %></p>
                                                    <div class="d-flex gap-2">
                                                        <span class="badge bg-light text-dark">
                                                            <i class="bi bi-tag me-1"></i><%# Eval("Category") %>
                                                        </span>
                                                        <span class="badge bg-light text-dark">
                                                            <i class="bi bi-credit-card me-1"></i><%# Eval("Credits") %> credits
                                                        </span>
                                                        <span class="badge bg-light text-dark">
                                                            <i class="bi bi-people me-1"></i><%# Eval("MaxStudents") %> max
                                                        </span>
                                                        <span class="badge bg-light text-dark">
                                                            <i class="bi bi-person-fill me-1"></i><%# Eval("EnrolledCount") %> enrolled
                                                        </span>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            
                                            <asp:TemplateField HeaderText="Status">
                                                <ItemTemplate>
                                                    <span class='badge-custom <%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>'>
                                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                                    </span>
                                                </ItemTemplate>
                                                <ItemStyle Width="100px" />
                                            </asp:TemplateField>
                                            
                                            <asp:TemplateField HeaderText="Dates">
                                                <ItemTemplate>
                                                    <div class="small">
                                                        <div><i class="bi bi-calendar-event me-1"></i> <%# Convert.ToDateTime(Eval("StartDate")).ToString("MMM dd, yyyy") %></div>
                                                        <div><i class="bi bi-calendar-check me-1"></i> <%# Convert.ToDateTime(Eval("EndDate")).ToString("MMM dd, yyyy") %></div>
                                                    </div>
                                                </ItemTemplate>
                                                <ItemStyle Width="150px" />
                                            </asp:TemplateField>
                                            
                                            <asp:TemplateField HeaderText="Actions">
                                                <ItemTemplate>
                                                    <div class="btn-group btn-group-sm">
                                                        <asp:LinkButton runat="server" CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>'
                                                            CssClass="btn btn-outline-primary" ToolTip="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </asp:LinkButton>
                                                        <asp:LinkButton runat="server" CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>'
                                                            CssClass="btn btn-outline-danger" ToolTip="Delete">
                 
                                                            <i class="bi bi-trash"></i>
                                                        </asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                                <ItemStyle Width="100px" />
                                            </asp:TemplateField>
                                        </Columns>
                                        <PagerStyle CssClass="pagination justify-content-center mt-3" />
                                        <EmptyDataTemplate>
                                            <div class="text-center py-5">
                                                <i class="bi bi-book display-1 text-muted"></i>
                                                <h5 class="mt-3">No courses found</h5>
                                                <p class="text-muted">Create your first course to get started</p>
                                                <button class="btn btn-gradient mt-3" onclick="showAddCourse()">
                                                    <i class="bi bi-plus-lg me-1"></i> Create Your First Course
                                                </button>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
                
                <!-- Enrollments Content -->
                <div id="enrollmentsContent" class="enrollments-content" style="display: none;">
                    <div class="row">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-semibold mb-0">Student Enrollments</h5>
                                <div>
                                    <button class="btn btn-outline-secondary me-2" onclick="showDashboard()">
                                        <i class="bi bi-arrow-left me-1"></i> Back to Dashboard
                                    </button>
                                    <asp:Button ID="btnExportEnrollments" runat="server" Text="Export to Excel" 
                                        CssClass="btn btn-outline-primary" OnClick="btnExportEnrollments_Click" />
                                </div>
                            </div>
                            
                            <!-- Filters -->
                            <div class="card border-0 shadow mb-4">
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Filter by Course</label>
                                            <asp:DropDownList ID="ddlFilterCourse" runat="server" CssClass="form-select" 
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlFilterCourse_SelectedIndexChanged">
                                                <asp:ListItem Value="0">All Courses</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Filter by Status</label>
                                            <asp:DropDownList ID="ddlFilterStatus" runat="server" CssClass="form-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                                                <asp:ListItem Value="">All Status</asp:ListItem>
                                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                                <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                                <asp:ListItem Value="Dropped">Dropped</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                        <div class="col-md-2 d-flex align-items-end">
                                            <button class="btn btn-outline-secondary w-100" onclick="refreshEnrollments()">
                                                <i class="bi bi-arrow-clockwise me-1"></i> Refresh
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Enrollment Statistics -->
                            <div class="row mb-4">
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex align-items-center">
                                            <div class="stat-icon me-3" style="background-color: #dcfce7; color: #166534;">
                                                <i class="bi bi-people-fill"></i>
                                            </div>
                                            <div>
                                                <h6 class="text-muted mb-1">Total Students</h6>
                                                <h3 class="fw-bold mb-0"><asp:Literal ID="litTotalStudentsEnrollments" runat="server" Text="0" /></h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex align-items-center">
                                            <div class="stat-icon me-3" style="background-color: #dbeafe; color: #1d4ed8;">
                                                <i class="bi bi-check-circle-fill"></i>
                                            </div>
                                            <div>
                                                <h6 class="text-muted mb-1">Active</h6>
                                                <h3 class="fw-bold mb-0"><asp:Literal ID="litActiveEnrollments" runat="server" Text="0" /></h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex align-items-center">
                                            <div class="stat-icon me-3" style="background-color: #fef3c7; color: #92400e;">
                                                <i class="bi bi-award-fill"></i>
                                            </div>
                                            <div>
                                                <h6 class="text-muted mb-1">Completed</h6>
                                                <h3 class="fw-bold mb-0"><asp:Literal ID="litCompletedEnrollments" runat="server" Text="0" /></h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="d-flex align-items-center">
                                            <div class="stat-icon me-3" style="background-color: #fee2e2; color: #991b1b;">
                                                <i class="bi bi-x-circle-fill"></i>
                                            </div>
                                            <div>
                                                <h6 class="text-muted mb-1">Dropped</h6>
                                                <h3 class="fw-bold mb-0"><asp:Literal ID="litDroppedEnrollments" runat="server" Text="0" /></h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Enrollments GridView -->
                            <div class="card border-0 shadow">
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <asp:GridView ID="gvEnrollments" runat="server" AutoGenerateColumns="false" 
                                            CssClass="table table-hover" GridLines="None" AllowPaging="true" PageSize="10"
                                            OnPageIndexChanging="gvEnrollments_PageIndexChanging" OnRowCommand="gvEnrollments_RowCommand">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Student">
                                                    <ItemTemplate>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-circle me-3">
                                                                <span class="avatar-text">
                                                                    <%# GetInitials(Eval("FullName").ToString()) %>
                                                                </span>
                                                            </div>
                                                            <div>
                                                                <h6 class="fw-bold mb-0"><%# Eval("FullName") %></h6>
                                                                <small class="text-muted"><%# Eval("Email") %></small>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                
                                                <asp:TemplateField HeaderText="Course">
                                                    <ItemTemplate>
                                                        <h6 class="fw-bold mb-1"><%# Eval("CourseCode") %> - <%# Eval("CourseName") %></h6>
                                                        <small class="text-muted"><%# Eval("Category") %></small>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                
                                                <asp:BoundField DataField="EnrollmentDate" HeaderText="Enrollment Date" 
                                                    DataFormatString="{0:MMM dd, yyyy}" />
                                                
                                                <asp:TemplateField HeaderText="Status">
                                                    <ItemTemplate>
                                                        <span class='badge <%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                                            <%# Eval("Status") %>
                                                        </span>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                
                                                <asp:TemplateField HeaderText="Actions">
                                                    <ItemTemplate>
                                                        <div class="btn-group btn-group-sm">
                                                            <asp:LinkButton runat="server" CommandName="UpdateStatus" CommandArgument='<%# Eval("EnrollmentID") %>'
                                                                CssClass="btn btn-outline-primary" ToolTip="Update Status">
                                                                <i class="bi bi-pencil"></i>
                                                            </asp:LinkButton>
                                                        </div>
                                                    </ItemTemplate>
                                                    <ItemStyle Width="80px" />
                                                </asp:TemplateField>
                                            </Columns>
                                            <EmptyDataTemplate>
                                                <div class="text-center py-5">
                                                    <i class="bi bi-people display-1 text-muted"></i>
                                                    <h5 class="mt-3">No Enrollments Found</h5>
                                                    <p class="text-muted">No students have enrolled in your courses yet.</p>
                                                </div>
                                            </EmptyDataTemplate>
                                            <PagerStyle CssClass="pagination justify-content-center" />
                                        </asp:GridView>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Hidden fields -->
        <asp:HiddenField ID="hfEditCourseId" runat="server" />
        <asp:HiddenField ID="hfDeleteCourseId" runat="server" />
        <asp:HiddenField ID="hfUpdateEnrollmentId" runat="server" />
        
        <!-- Edit Course Modal -->
        <div class="modal fade" id="editCourseModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Course</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Course Code *</label>
                                <asp:TextBox ID="txtEditCourseCode" runat="server" CssClass="form-control" 
                                    MaxLength="20" ReadOnly="true" />
                                <small class="text-muted">Course code cannot be changed</small>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Course Name *</label>
                                <asp:TextBox ID="txtEditCourseName" runat="server" CssClass="form-control" 
                                    MaxLength="100" />
                                <asp:RequiredFieldValidator ID="rfvEditCourseName" runat="server" 
                                    ControlToValidate="txtEditCourseName" ErrorMessage="Course name is required" 
                                    Display="Dynamic" CssClass="text-danger small" ValidationGroup="EditCourse" />
                            </div>
                            <div class="col-12">
                                <label class="form-label">Description</label>
                                <asp:TextBox ID="txtEditDescription" runat="server" CssClass="form-control" 
                                    TextMode="MultiLine" Rows="3" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Category *</label>
                                <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="Computer Science">Computer Science</asp:ListItem>
                                    <asp:ListItem Value="Mathematics">Mathematics</asp:ListItem>
                                    <asp:ListItem Value="Science">Science</asp:ListItem>
                                    <asp:ListItem Value="Engineering">Engineering</asp:ListItem>
                                    <asp:ListItem Value="Business">Business</asp:ListItem>
                                    <asp:ListItem Value="Humanities">Humanities</asp:ListItem>
                                    <asp:ListItem Value="Arts">Arts</asp:ListItem>
                                    <asp:ListItem Value="Language">Language</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvEditCategory" runat="server" 
                                    ControlToValidate="ddlEditCategory" ErrorMessage="Category is required" 
                                    Display="Dynamic" CssClass="text-danger small" ValidationGroup="EditCourse" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Credits *</label>
                                <asp:TextBox ID="txtEditCredits" runat="server" CssClass="form-control" 
                                    TextMode="Number" min="1" max="10" />
                                <asp:RequiredFieldValidator ID="rfvEditCredits" runat="server" 
                                    ControlToValidate="txtEditCredits" ErrorMessage="Credits are required" 
                                    Display="Dynamic" CssClass="text-danger small" ValidationGroup="EditCourse" />
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Max Students *</label>
                                <asp:TextBox ID="txtEditMaxStudents" runat="server" CssClass="form-control" 
                                    TextMode="Number" min="1" max="500" />
                                <asp:RequiredFieldValidator ID="rfvEditMaxStudents" runat="server" 
                                    ControlToValidate="txtEditMaxStudents" ErrorMessage="Max students is required" 
                                    Display="Dynamic" CssClass="text-danger small" ValidationGroup="EditCourse" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Start Date *</label>
                                <asp:TextBox ID="txtEditStartDate" runat="server" CssClass="form-control" 
                                    TextMode="Date" />
                                <asp:RequiredFieldValidator ID="rfvEditStartDate" runat="server" 
                                    ControlToValidate="txtEditStartDate" ErrorMessage="Start date is required" 
                                    Display="Dynamic" CssClass="text-danger small" ValidationGroup="EditCourse" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">End Date *</label>
                                <asp:TextBox ID="txtEditEndDate" runat="server" CssClass="form-control" 
                                    TextMode="Date" />
                                <asp:RequiredFieldValidator ID="rfvEditEndDate" runat="server" 
                                    ControlToValidate="txtEditEndDate" ErrorMessage="End date is required" 
                                    Display="Dynamic" CssClass="text-danger small" ValidationGroup="EditCourse" />
                            </div>
                            <div class="col-12">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkEditIsActive" runat="server" CssClass="form-check-input" />
                                    <label class="form-check-label" for="<%= chkEditIsActive.ClientID %>">Active Course</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnUpdateCourse" runat="server" Text="Update Course" 
                            CssClass="btn btn-gradient" OnClick="btnUpdateCourse_Click" 
                            ValidationGroup="EditCourse" />
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Delete Course Modal -->
        <div class="modal fade" id="deleteCourseModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Confirm Delete</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="text-center">
                            <i class="bi bi-exclamation-triangle text-danger display-4"></i>
                            <h4 class="mt-3">Are you sure?</h4>
                            <p>You are about to delete the course: <strong id="deleteCourseName"></strong></p>
                            <p class="text-muted small">This action cannot be undone.</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnConfirmDelete" runat="server" Text="Delete Course" 
                            CssClass="btn btn-danger" OnClick="btnConfirmDelete_Click" />
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Update Status Modal -->
        <div class="modal fade" id="updateStatusModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Update Enrollment Status</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Student</label>
                            <div class="form-control bg-light" id="studentNameDisplay"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Course</label>
                            <div class="form-control bg-light" id="courseNameDisplay"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Current Status</label>
                            <div class="form-control bg-light" id="currentStatusDisplay"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Status *</label>
                            <asp:DropDownList ID="ddlNewStatus" runat="server" CssClass="form-select">
                                <asp:ListItem Value="Active">Active</asp:ListItem>
                                <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                <asp:ListItem Value="Dropped">Dropped</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Remarks (Optional)</label>
                            <asp:TextBox ID="txtStatusRemarks" runat="server" CssClass="form-control" 
                                TextMode="MultiLine" Rows="3" placeholder="Add any remarks..." />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <asp:Button ID="btnUpdateStatus" runat="server" Text="Update Status" 
                            CssClass="btn btn-gradient" OnClick="btnUpdateStatus_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Function to toggle sidebar on mobile
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            
            if (window.innerWidth <= 768) {
                sidebar.classList.toggle('show');
            }
        }
        
        // Function to show dashboard
        function showDashboard() {
            document.getElementById('dashboardContent').style.display = 'block';
            document.getElementById('addCourseContent').style.display = 'none';
            document.getElementById('myCoursesContent').style.display = 'none';
            document.getElementById('enrollmentsContent').style.display = 'none';
            document.getElementById('pageTitle').textContent = 'Dashboard';
            updateActiveNav('dashboard');
        }
        
        // Function to show add course
        function showAddCourse() {
            document.getElementById('dashboardContent').style.display = 'none';
            document.getElementById('addCourseContent').style.display = 'block';
            document.getElementById('myCoursesContent').style.display = 'none';
            document.getElementById('enrollmentsContent').style.display = 'none';
            document.getElementById('pageTitle').textContent = 'Add Course';
            updateActiveNav('addCourse');
            
            // Set default dates
            const today = new Date();
            const nextMonth = new Date();
            nextMonth.setMonth(today.getMonth() + 3);
            
            const formatDate = (date) => {
                const d = new Date(date);
                const month = (d.getMonth() + 1).toString().padStart(2, '0');
                const day = d.getDate().toString().padStart(2, '0');
                const year = d.getFullYear();
                return `${year}-${month}-${day}`;
            };
            
            const startDateInput = document.getElementById('<%= txtStartDate.ClientID %>');
            const endDateInput = document.getElementById('<%= txtEndDate.ClientID %>');

            if (startDateInput && !startDateInput.value) {
                startDateInput.value = formatDate(today);
            }
            if (endDateInput && !endDateInput.value) {
                endDateInput.value = formatDate(nextMonth);
            }
        }

        // Function to show my courses
        function showMyCourses() {
            document.getElementById('dashboardContent').style.display = 'none';
            document.getElementById('addCourseContent').style.display = 'none';
            document.getElementById('myCoursesContent').style.display = 'block';
            document.getElementById('enrollmentsContent').style.display = 'none';
            document.getElementById('pageTitle').textContent = 'My Courses';
            updateActiveNav('myCourses');
        }

        // Function to show enrollments
        function showEnrollments() {
            document.getElementById('dashboardContent').style.display = 'none';
            document.getElementById('addCourseContent').style.display = 'none';
            document.getElementById('myCoursesContent').style.display = 'none';
            document.getElementById('enrollmentsContent').style.display = 'block';
            document.getElementById('pageTitle').textContent = 'Enrollments';
            updateActiveNav('enrollments');
        }

        // Function to update active navigation
        function updateActiveNav(activePage) {
            const navLinks = document.querySelectorAll('.nav-link');
            navLinks.forEach(link => {
                link.classList.remove('active');
            });

            if (activePage === 'dashboard') {
                navLinks[0].classList.add('active');
            } else if (activePage === 'addCourse') {
                navLinks[1].classList.add('active');
            } else if (activePage === 'myCourses') {
                navLinks[2].classList.add('active');
            } else if (activePage === 'enrollments') {
                navLinks[3].classList.add('active');
            }
        }

        // Function to close alert
        function closeAlert(button) {
            const alert = button.closest('.alert');
            if (alert) {
                alert.style.display = 'none';
            }
        }

        // Function to refresh enrollments
        function refreshEnrollments() {
            location.reload();
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            showDashboard();

            // Close sidebar when clicking outside on mobile
            document.addEventListener('click', function (event) {
                const sidebar = document.getElementById('sidebar');
                const mainContent = document.getElementById('mainContent');

                if (window.innerWidth <= 768 &&
                    !sidebar.contains(event.target) &&
                    !event.target.closest('.mobile-menu-btn') &&
                    sidebar.classList.contains('show')) {
                    sidebar.classList.remove('show');
                }
            });
        });

        // Handle window resize
        window.addEventListener('resize', function () {
            const sidebar = document.getElementById('sidebar');
            if (window.innerWidth > 768) {
                sidebar.classList.remove('show');
            }
        });
        // Multi-step form functionality
        let currentStep = 1;

        function nextStep() {
            if (currentStep === 1) {
                // Validate step 1
                if (!validateStep1()) {
                    return;
                }
                document.getElementById('step1Content').style.display = 'none';
                document.getElementById('step2Content').style.display = 'block';
                document.getElementById('step1').classList.remove('active');
                document.getElementById('step2').classList.add('active');
                currentStep = 2;
                updatePreview();
            } else if (currentStep === 2) {
                // Validate step 2
                if (!validateStep2()) {
                    return;
                }
                document.getElementById('step2Content').style.display = 'none';
                document.getElementById('step3Content').style.display = 'block';
                document.getElementById('step2').classList.remove('active');
                document.getElementById('step3').classList.add('active');
                currentStep = 3;
                updatePreview();
            }
        }

        function prevStep() {
            if (currentStep === 2) {
                document.getElementById('step2Content').style.display = 'none';
                document.getElementById('step1Content').style.display = 'block';
                document.getElementById('step2').classList.remove('active');
                document.getElementById('step1').classList.add('active');
                currentStep = 1;
            } else if (currentStep === 3) {
                document.getElementById('step3Content').style.display = 'none';
                document.getElementById('step2Content').style.display = 'block';
                document.getElementById('step3').classList.remove('active');
                document.getElementById('step2').classList.add('active');
                currentStep = 2;
            }
        }

        function validateStep1() {
            const courseCode = document.getElementById('<%= txtCourseCode.ClientID %>').value.trim();
    const courseName = document.getElementById('<%= txtCourseName.ClientID %>').value.trim();
    const description = document.getElementById('<%= txtDescription.ClientID %>').value.trim();
    const category = document.getElementById('<%= ddlCategory.ClientID %>').value;
    const credits = document.getElementById('<%= txtCredits.ClientID %>').value.trim();
    const maxStudents = document.getElementById('<%= txtMaxStudents.ClientID %>').value.trim();
    const startDate = document.getElementById('<%= txtStartDate.ClientID %>').value;
    const endDate = document.getElementById('<%= txtEndDate.ClientID %>').value;

            let isValid = true;

            if (!courseCode) {
                showStepError('Course code is required');
                isValid = false;
            }
            if (!courseName) {
                showStepError('Course name is required');
                isValid = false;
            }
            if (!description) {
                showStepError('Description is required');
                isValid = false;
            }
            if (!category) {
                showStepError('Category is required');
                isValid = false;
            }
            if (!credits || isNaN(credits) || credits < 1 || credits > 10) {
                showStepError('Please enter valid credits (1-10)');
                isValid = false;
            }
            if (!maxStudents || isNaN(maxStudents) || maxStudents < 1 || maxStudents > 500) {
                showStepError('Please enter valid max students (1-500)');
                isValid = false;
            }
            if (!startDate) {
                showStepError('Start date is required');
                isValid = false;
            }
            if (!endDate) {
                showStepError('End date is required');
                isValid = false;
            }
            if (startDate && endDate && new Date(startDate) >= new Date(endDate)) {
                showStepError('End date must be after start date');
                isValid = false;
            }

            return isValid;
        }

        function validateStep2() {
            const fullDescription = document.getElementById('<%= txtFullDescription.ClientID %>').value.trim();
    const learningObjectives = document.getElementById('<%= txtLearningObjectives.ClientID %>').value.trim();
    const syllabus = document.getElementById('<%= txtSyllabus.ClientID %>').value.trim();
    
    let isValid = true;
    
    if (!fullDescription) {
        showStepError('Detailed description is required');
        isValid = false;
    }
    if (!learningObjectives) {
        showStepError('Learning objectives are required');
        isValid = false;
    }
    if (!syllabus) {
        showStepError('Course syllabus is required');
        isValid = false;
    }
    
    return isValid;
}

function showStepError(message) {
    Swal.fire({
        icon: 'error',
        title: 'Validation Error',
        text: message,
        confirmButtonColor: '#4f46e5'
    });
}

function updatePreview() {
    // Update preview with entered values
    const courseName = document.getElementById('<%= txtCourseName.ClientID %>').value || '[Course Name]';
    const courseCode = document.getElementById('<%= txtCourseCode.ClientID %>').value || '[Course Code]';
    const description = document.getElementById('<%= txtDescription.ClientID %>').value || '[Course Description]';
    const category = document.getElementById('<%= ddlCategory.ClientID %>').value || '[Category]';
    const credits = document.getElementById('<%= txtCredits.ClientID %>').value || '[Credits]';
    const maxStudents = document.getElementById('<%= txtMaxStudents.ClientID %>').value || '[Max Students]';
    const startDate = document.getElementById('<%= txtStartDate.ClientID %>').value;
    const endDate = document.getElementById('<%= txtEndDate.ClientID %>').value;
    
    document.getElementById('previewCourseName').textContent = courseName;
    document.getElementById('previewCourseCode').textContent = courseCode;
    document.getElementById('previewDescription').textContent = description;
    document.getElementById('previewCategory').textContent = category || 'No category';
    document.getElementById('previewCredits').textContent = credits + ' credits';
    document.getElementById('previewStudents').textContent = 'Max: ' + maxStudents;
    
    if (startDate && endDate) {
        const start = new Date(startDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        const end = new Date(endDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        document.getElementById('previewDuration').textContent = `${start} to ${end}`;
    } else {
        document.getElementById('previewDuration').textContent = '[Start Date] to [End Date]';
    }
}

// Reset form when showing add course
function showAddCourse() {
    document.getElementById('dashboardContent').style.display = 'none';
    document.getElementById('addCourseContent').style.display = 'block';
    document.getElementById('myCoursesContent').style.display = 'none';
    document.getElementById('enrollmentsContent').style.display = 'none';
    document.getElementById('pageTitle').textContent = 'Add Course';
    updateActiveNav('addCourse');
    
    // Reset steps
    currentStep = 1;
    document.getElementById('step1Content').style.display = 'block';
    document.getElementById('step2Content').style.display = 'none';
    document.getElementById('step3Content').style.display = 'none';
    document.getElementById('step1').classList.add('active');
    document.getElementById('step2').classList.remove('active');
    document.getElementById('step3').classList.remove('active');
    
    // Set default dates
    const today = new Date();
    const nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 3);
    
    const formatDate = (date) => {
        const d = new Date(date);
        const month = (d.getMonth() + 1).toString().padStart(2, '0');
        const day = d.getDate().toString().padStart(2, '0');
        const year = d.getFullYear();
        return `${year}-${month}-${day}`;
    };
    
    const startDateInput = document.getElementById('<%= txtStartDate.ClientID %>');
    const endDateInput = document.getElementById('<%= txtEndDate.ClientID %>');

    if (startDateInput && !startDateInput.value) {
        startDateInput.value = formatDate(today);
    }
    if (endDateInput && !endDateInput.value) {
        endDateInput.value = formatDate(nextMonth);
    }

    // Clear preview
    updatePreview();
}
    </script>
</body>
</html>