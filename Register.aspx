<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="WebApplication3.Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | LearnEase</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Outfit:wght@700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --brand-primary: #0d6efd;
            --brand-dark: #0f172a;
        }

        body { 
            font-family: 'Inter', sans-serif; 
            color: #334155; 
            background-color: #fcfcfd;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        h1, h2, h3, .navbar-brand { font-family: 'Outfit', sans-serif; }

        .text-gradient {
            background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Navbar Styling */
        .navbar { background: white; border-bottom: 1px solid #f1f5f9; padding: 1rem 0; }
        .btn-premium { padding: 12px 32px; border-radius: 12px; font-weight: 600; transition: 0.3s; }

        /* Auth Layout */
        .auth-wrapper { flex: 1; display: flex; align-items: center; justify-content: center; padding: 60px 0; }
        
        .register-card {
            background: white;
            border-radius: 30px;
            border: 1px solid #f1f5f9;
            box-shadow: 0 20px 40px rgba(15, 23, 42, 0.05);
            overflow: hidden;
            width: 100%;
            max-width: 500px;
        }

        .form-control, .form-select {
            padding: 0.8rem 1rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            background-color: #f8fafc;
        }

        .form-control:focus {
            background-color: #fff;
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 4px rgba(13, 110, 253, 0.1);
        }

        /* Footer Styling */
        footer { border-radius: 40px 40px 0 0; }
        .footer-link { color: rgba(255,255,255,0.5); text-decoration: none; transition: 0.3s; margin-bottom: 12px; display: block; }
        .footer-link:hover { color: #fff; transform: translateX(5px); }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <asp:HyperLink runat="server" NavigateUrl="~/index.aspx" CssClass="navbar-brand d-flex align-items-center">
                    <asp:Image runat="server" ImageUrl="~/images/logo.png" CssClass="me-2" Height="45" AlternateText="LearnEase Logo" />
                    <span class="fw-bold fs-3 text-gradient">LearnEase</span>
                </asp:HyperLink>
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="bi bi-list fs-1"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto me-4 gap-2">
                        <li class="nav-item"><asp:HyperLink runat="server" NavigateUrl="~/index.aspx" CssClass="nav-link fw-semibold">Home</asp:HyperLink></li>
                        <li class="nav-item"><asp:HyperLink runat="server" NavigateUrl="~/about.aspx" CssClass="nav-link fw-semibold">About</asp:HyperLink></li>
                        <li class="nav-item"><asp:HyperLink runat="server" NavigateUrl="~/courses.aspx" CssClass="nav-link fw-semibold">Courses</asp:HyperLink></li>
                    </ul>
                    <div class="d-flex gap-2">
                        <asp:HyperLink runat="server" NavigateUrl="~/Login.aspx" CssClass="btn btn-outline-primary btn-premium">Login</asp:HyperLink>
                    </div>
                </div>
            </div>
        </nav>

        <div class="auth-wrapper container">
            <div class="register-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <h2 class="fw-bold display-6">Join Us</h2>
                    <p class="text-muted">Create an account to start learning</p>
                </div>

                <asp:Panel ID="pnlMsg" runat="server" Visible="false" CssClass="alert border-0 shadow-sm rounded-4 mb-4">
                    <asp:Literal ID="litMsg" runat="server" />
                </asp:Panel>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase text-secondary">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter your name" />
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase text-secondary">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="name@example.com" />
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase text-secondary">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••" />
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase text-secondary">I am a...</label>
                    <asp:DropDownList ID="ddlUserType" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Select User Type" Value="" />
                        <asp:ListItem Text="Student" Value="Student" />
                        <asp:ListItem Text="Educator" Value="Educator" />
                    </asp:DropDownList>
                </div>

                <div class="mb-4">
                    <div class="form-check">
                        <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label small text-muted">Agree to Terms & Privacy Policy</label>
                    </div>
                </div>

                <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-warning btn-premium text-white w-100 mb-3 shadow" OnClick="btnRegister_Click" />
                
                <p class="text-center small mb-0">
                    Already registered? <a href="Login.aspx" class="text-primary text-decoration-none fw-bold">Login here</a>
                </p>
            </div>
        </div>

        <footer class="bg-dark text-light pt-5 pb-4 mt-auto">
            <div class="container">
                <div class="row g-5 justify-content-between">
                    <div class="col-lg-4">
                        <div class="d-flex align-items-center mb-4">
                            <asp:Image runat="server" ImageUrl="~/images/logo.png" Height="40" CssClass="me-2" />
                            <span class="fw-bold fs-3">LearnEase</span>
                        </div>
                        <p class="text-white-50 mb-4">Empowering the next generation of digital leaders with high-quality resources.</p>
                        <div class="d-flex gap-3">
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-linkedin"></i></a>
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-instagram"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4">
                        <h6 class="fw-bold mb-4 text-uppercase">Quick Links</h6>
                        <ul class="list-unstyled">
                            <li><asp:HyperLink runat="server" NavigateUrl="~/index.aspx" CssClass="footer-link">Home</asp:HyperLink></li>
                            <li><asp:HyperLink runat="server" NavigateUrl="~/about.aspx" CssClass="footer-link">About Us</asp:HyperLink></li>
                            <li><asp:HyperLink runat="server" NavigateUrl="~/courses.aspx" CssClass="footer-link">Courses</asp:HyperLink></li>
                        </ul>
                    </div>
                    <div class="col-lg-3">
                        <h6 class="fw-bold mb-4 text-uppercase">Contact</h6>
                        <p class="text-white-50 small mb-2"><i class="bi bi-envelope me-2 text-primary"></i> info@learnease.com</p>
                        <p class="text-white-50 small"><i class="bi bi-geo-alt me-2 text-primary"></i> Maitidevi, Kathmandu</p>
                    </div>
                </div>
                <hr class="my-5 border-secondary opacity-25" />
                <div class="text-center text-white-50 small">
                    <p class="m-0">&copy; <%= DateTime.Now.Year %> LearnEase Global. Developed by APU Students.</p>
                </div>
            </div>
        </footer>

    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>