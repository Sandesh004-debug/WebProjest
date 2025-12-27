<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseDetails.aspx.cs" Inherits="WebApplication3.CourseDetails" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Details - LearnEase</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-color: #4f46e5;
            --secondary-color: #7c3aed;
            --success-color: #10b981;
            --info-color: #3b82f6;
            --warning-color: #f59e0b;
            --light-bg: #f8fafc;
            --dark-text: #1e293b;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            color: var(--dark-text);
        }
        
        .course-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 30px 30px;
        }
        
        .course-badge {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .info-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
            border: 1px solid #e2e8f0;
        }
        
        .info-card h5 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
            font-size: 20px;
        }
        
        .syllabus-item {
            padding: 1rem;
            border-left: 3px solid var(--primary-color);
            margin-bottom: 1rem;
            background: #f8fafc;
            border-radius: 0 8px 8px 0;
        }
        
        .week-badge {
            background: var(--primary-color);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .stats-card {
            text-align: center;
            padding: 1.5rem;
            border-radius: 12px;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .stats-label {
            color: #64748b;
            font-size: 14px;
        }
        
        .btn-enroll {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s;
        }
        
        .btn-enroll:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
        }
        
        .progress-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: conic-gradient(var(--primary-color) 0% var(--progress), #e2e8f0 var(--progress) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            position: relative;
        }
        
        .progress-circle::before {
            content: '';
            position: absolute;
            width: 100px;
            height: 100px;
            background: white;
            border-radius: 50%;
        }
        
        .progress-text {
            position: relative;
            z-index: 1;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
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
        
        .material-item {
            display: flex;
            align-items: center;
            padding: 0.5rem;
            background: #f8fafc;
            border-radius: 8px;
            margin-bottom: 0.5rem;
        }
        
        @media (max-width: 768px) {
            .course-header {
                padding: 2rem 0;
                border-radius: 0 0 20px 20px;
            }
            
            .progress-circle {
                width: 100px;
                height: 100px;
            }
            
            .progress-circle::before {
                width: 80px;
                height: 80px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom">
            <div class="container">
                <a class="navbar-brand fw-bold text-primary" href="StudentDashboard.aspx">
                    <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                </a>
                <div class="d-flex align-items-center">
                    <asp:Button ID="btnEnrollCourse" runat="server" Text="Enroll Now" 
                        CssClass="btn btn-enroll" OnClick="btnEnrollCourse_Click" />
                </div>
            </div>
        </nav>
        
        <!-- Course Header -->
        <div class="course-header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <div class="d-flex align-items-center mb-3">
                            <span class="course-badge me-2">
                                <asp:Literal ID="litCourseCode" runat="server" />
                            </span>
                            <span class="course-badge">
                                <asp:Literal ID="litCategory" runat="server" />
                            </span>
                        </div>
                        <h1 class="display-5 fw-bold mb-3"><asp:Literal ID="litCourseName" runat="server" /></h1>
                        <p class="lead mb-4" style="opacity: 0.9;"><asp:Literal ID="litDescription" runat="server" /></p>
                        <div class="d-flex align-items-center">
                            <div class="avatar-circle me-2">
                                <asp:Literal ID="litEducatorInitials" runat="server" />
                            </div>
                            <div>
                                <h6 class="mb-0 fw-semibold">Prof. <asp:Literal ID="litEducatorName" runat="server" /></h6>
                                <small style="opacity: 0.8;">Course Instructor</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 mt-4 mt-lg-0">
                        <div class="row text-center">
                            <div class="col-4">
                                <div class="stats-card">
                                    <div class="stats-number"><asp:Literal ID="litCredits" runat="server" /></div>
                                    <div class="stats-label">Credits</div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="stats-card">
                                    <div class="stats-number"><asp:Literal ID="litDuration" runat="server" /></div>
                                    <div class="stats-label">Weeks</div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="stats-card">
                                    <div class="stats-number"><asp:Literal ID="litEnrolledCount" runat="server" Text="0" /></div>
                                    <div class="stats-label">Enrolled</div>
                                </div>
                            </div>
                        </div>
                        <div class="mt-3 text-center">
                            <div class="progress-circle" style="--progress: <%= GetEnrollmentProgress() %>%">
                                <div class="progress-text"><%= GetEnrollmentProgress() %>%</div>
                            </div>
                            <div class="stats-label">Course Capacity Filled</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="container">
            <div class="row">
                <!-- Left Column - Course Details -->
                <div class="col-lg-8">
                    <!-- About Course -->
                    <div class="info-card">
                        <h5><i class="bi bi-info-circle me-2"></i>About This Course</h5>
                        <p><asp:Literal ID="litFullDescription" runat="server" /></p>
                    </div>
                    
                    <!-- Learning Objectives -->
                    <div class="info-card">
                        <h5><i class="bi bi-bullseye me-2"></i>Learning Objectives</h5>
                        <asp:Literal ID="litLearningObjectives" runat="server" />
                    </div>
                    
                    <!-- Syllabus -->
                    <div class="info-card">
                        <h5><i class="bi bi-journal-text me-2"></i>Course Syllabus</h5>
                        <asp:Literal ID="litSyllabus" runat="server" />
                    </div>
                    
                    <!-- Assessment & Grading -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-card h-100">
                                <h5><i class="bi bi-clipboard-check me-2"></i>Assessment Methods</h5>
                                <asp:Literal ID="litAssessmentMethods" runat="server" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-card h-100">
                                <h5><i class="bi bi-graph-up me-2"></i>Grading Policy</h5>
                                <asp:Literal ID="litGradingPolicy" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Right Column - Course Info & Actions -->
                <div class="col-lg-4">
                    <!-- Quick Info -->
                    <div class="info-card">
                        <h5><i class="bi bi-calendar-event me-2"></i>Course Schedule</h5>
                        <div class="d-flex align-items-center mb-3">
                            <div class="info-icon" style="background-color: #e0e7ff; color: var(--primary-color);">
                                <i class="bi bi-calendar-plus"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Start Date</h6>
                                <p class="text-muted mb-0"><asp:Literal ID="litStartDate" runat="server" /></p>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="info-icon" style="background-color: #dcfce7; color: var(--success-color);">
                                <i class="bi bi-calendar-check"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">End Date</h6>
                                <p class="text-muted mb-0"><asp:Literal ID="litEndDate" runat="server" /></p>
                            </div>
                        </div>
                        <div class="d-flex align-items-center">
                            <div class="info-icon" style="background-color: #fef3c7; color: var(--warning-color);">
                                <i class="bi bi-people"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Class Size</h6>
                                <p class="text-muted mb-0"><asp:Literal ID="litMaxStudents" runat="server" /> students maximum</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Prerequisites -->
                    <div class="info-card">
                        <h5><i class="bi bi-clipboard-data me-2"></i>Prerequisites</h5>
                        <asp:Literal ID="litPrerequisites" runat="server" />
                    </div>
                    
                    <!-- Required Materials -->
                    <div class="info-card">
                        <h5><i class="bi bi-bag-check me-2"></i>Required Materials</h5>
                        <asp:Literal ID="litMaterialsRequired" runat="server" />
                    </div>
                    
                    <!-- Instructor Contact -->
                    <div class="info-card">
                        <h5><i class="bi bi-person-lines-fill me-2"></i>Instructor Contact</h5>
                        <div class="mb-3">
                            <h6 class="mb-1">Office Hours</h6>
                            <p class="text-muted mb-0"><asp:Literal ID="litOfficeHours" runat="server" /></p>
                        </div>
                        <div class="mb-3">
                            <h6 class="mb-1">Email</h6>
                            <p class="text-muted mb-0"><asp:Literal ID="litContactEmail" runat="server" /></p>
                        </div>
                        <div>
                            <h6 class="mb-1">Course Website</h6>
                            <a href="<%= GetCourseWebsite() %>" target="_blank" class="text-primary text-decoration-none">
                                <i class="bi bi-link-45deg me-1"></i>Visit Course Site
                            </a>
                        </div>
                    </div>
                    
                    <!-- Enrollment Status -->
                    <div class="info-card">
                        <h5><i class="bi bi-info-square me-2"></i>Your Enrollment Status</h5>
                        <asp:Panel ID="pnlNotEnrolled" runat="server">
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle me-2"></i>
                                You are not enrolled in this course
                            </div>
                            <asp:Button ID="btnEnrollBottom" runat="server" Text="Enroll Now" 
                                CssClass="btn btn-enroll w-100" OnClick="btnEnrollCourse_Click" />
                        </asp:Panel>
                        <asp:Panel ID="pnlEnrolled" runat="server" Visible="false">
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle me-2"></i>
                                You are enrolled in this course
                                <div class="small mt-1">Enrolled on: <asp:Literal ID="litEnrollmentDate" runat="server" /></div>
                            </div>
                            <div class="d-grid gap-2">
                                <asp:Button ID="btnGoToCourse" runat="server" Text="Go to Course" 
                                    CssClass="btn btn-outline-primary" />
                                <asp:Button ID="btnDropCourse" runat="server" Text="Drop Course" 
                                    CssClass="btn btn-outline-danger" OnClick="btnDropCourse_Click" 
                                    OnClientClick="return confirm('Are you sure you want to drop this course?');" />
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Hidden Fields -->
        <asp:HiddenField ID="hfCourseId" runat="server" />
        <asp:HiddenField ID="hfStudentId" runat="server" />
        <asp:HiddenField ID="hfIsEnrolled" runat="server" Value="false" />
        
        <!-- Footer -->
        <footer class="mt-5 py-4 bg-dark text-white">
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
                        <h5>LearnEase Learning Platform</h5>
                        <p class="text-white-50">Providing quality education for everyone</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <p class="text-white-50 mb-0">&copy; 2024 LearnEase. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>
    </form>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Format syllabus items
        document.addEventListener('DOMContentLoaded', function() {
            // Add week badges to syllabus items
            const syllabusItems = document.querySelectorAll('.syllabus-item');
            syllabusItems.forEach((item, index) => {
                const weekNumber = index + 1;
                item.querySelector('.week-badge').textContent = `Week ${weekNumber}`;
            });
        });
        
        // Smooth scroll for syllabus items
        function scrollToSyllabus() {
            document.querySelector('#syllabus').scrollIntoView({
                behavior: 'smooth'
            });
        }
    </script>
</body>
</html>