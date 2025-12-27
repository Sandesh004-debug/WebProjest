<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication3.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | LearnEase Portal</title>

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

        .navbar { background: white; border-bottom: 1px solid #f1f5f9; padding: 1rem 0; }
        .btn-premium { padding: 12px 32px; border-radius: 12px; font-weight: 600; transition: 0.3s; }

        .login-container { flex: 1; display: flex; align-items: center; justify-content: center; padding: 60px 0; }
        
        .login-card {
            background: white;
            border-radius: 30px;
            border: 1px solid #f1f5f9;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 500px;
            overflow: hidden;
        }

        .form-control {
            padding: 0.8rem 1rem;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            background-color: #f8fafc;
            transition: 0.2s;
        }

        .form-control:focus {
            background-color: #fff;
            border-color: var(--brand-primary);
            box-shadow: 0 0 0 4px rgba(13, 110, 253, 0.1);
        }

        .input-group-text {
            border-radius: 0 12px 12px 0;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-left: none;
            color: #94a3b8;
        }

        .user-type-selector {
            display: flex;
            background: #f1f5f9;
            border-radius: 16px;
            padding: 6px;
            margin-bottom: 2rem;
        }

        .user-type-option {
            flex: 1;
            text-align: center;
            padding: 10px;
            border-radius: 12px;
            color: #64748b;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            border: none;
            background: transparent;
            font-size: 0.9rem;
        }

        .user-type-option.active {
            background: white;
            color: var(--brand-primary);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .user-type-option i {
            margin-right: 5px;
        }

        footer { border-radius: 40px 40px 0 0; }
        .footer-link { color: rgba(255,255,255,0.5); text-decoration: none; transition: 0.3s; display: block; margin-bottom: 10px; }
        .footer-link:hover { color: #fff; }
        
        .validation-error {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hfUserType" runat="server" Value="student" />

        <nav class="navbar navbar-expand-lg sticky-top">
            <div class="container">
                <asp:HyperLink runat="server" NavigateUrl="~/index.aspx" CssClass="navbar-brand d-flex align-items-center">
                    <asp:Image runat="server" ImageUrl="~/images/logo.png" CssClass="me-2" Height="45" AlternateText="LearnEase Logo" />
                    <span class="fw-bold fs-3 text-gradient">LearnEase</span>
                </asp:HyperLink>
                <div class="ms-auto">
                    <asp:HyperLink runat="server" NavigateUrl="~/Register.aspx" CssClass="btn btn-outline-primary btn-premium">Register</asp:HyperLink>
                </div>
            </div>
        </nav>

        <div class="login-container container">
            <div class="login-card p-4 p-md-5">
                
                <div class="text-center mb-4">
                    <h2 class="fw-bold display-6">Welcome Back</h2>
                    <p class="text-muted">Select your role and enter credentials</p>
                </div>

                <asp:Panel ID="pnlError" runat="server" CssClass="alert alert-danger border-0 rounded-4 mb-4" Visible="false">
                    <div class="d-flex align-items-center small">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>
                        <asp:Literal ID="litErrorMessage" runat="server" />
                    </div>
                </asp:Panel>

                <!-- Updated User Type Selector with 3 options -->
                <div class="user-type-selector">
                    <button type="button" class="user-type-option active" data-type="student" onclick="selectUserType('student')">
                        <i class="bi bi-mortarboard"></i>Student
                    </button>
                    <button type="button" class="user-type-option" data-type="educator" onclick="selectUserType('educator')">
                        <i class="bi bi-person-badge"></i>Educator
                    </button>
                    
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold text-uppercase text-secondary tracking-wider">
                        <asp:Literal ID="litEmailLabel" runat="server" Text="Email Address" />
                    </label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="student@example.com" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required" CssClass="validation-error" Display="Dynamic" SetFocusOnError="true" />
                </div>
                
                <div class="mb-4">
                    <label class="form-label small fw-bold text-uppercase text-secondary tracking-wider">Password</label>
                    <div class="input-group">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••" style="border-right:none;" />
                        <span class="input-group-text" style="cursor:pointer;" onclick="togglePassword()">
                            <i class="bi bi-eye"></i>
                        </span>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required" CssClass="validation-error" Display="Dynamic" SetFocusOnError="true" />
                </div>

                <div class="mb-3 form-check">
                    <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                    <label class="form-check-label small" for="<%= chkRememberMe.ClientID %>">Remember me</label>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login to Dashboard" 
                    CssClass="btn btn-primary btn-premium w-100 mb-3 shadow" OnClick="btnLogin_Click" />

                <div class="text-center mt-3">
                    <p class="small text-muted mb-0">Don't have an account? 
                        <a href="Register.aspx" class="text-primary fw-bold text-decoration-none">Create one</a>
                    </p>
                    <p class="small text-muted mb-0 mt-2">
                        <a href="ForgotPassword.aspx" class="text-decoration-none">Forgot your password?</a>
                    </p>
                </div>
            </div>
        </div>

        <footer class="bg-dark text-light pt-5 pb-4 mt-auto">
            <div class="container">
                <div class="row g-5 justify-content-between text-start">
                    <div class="col-lg-4">
                        <div class="d-flex align-items-center mb-3">
                            <asp:Image runat="server" ImageUrl="~/images/logo.png" Height="40" CssClass="me-2" />
                            <span class="fw-bold fs-3">LearnEase</span>
                        </div>
                        <p class="text-white-50 small">Providing a world-class digital learning experience for students and educators globally.</p>
                    </div>
                    <div class="col-lg-2">
                        <h6 class="fw-bold mb-4 text-uppercase small tracking-widest">Explore</h6>
                        <ul class="list-unstyled">
                            <li><a href="index.aspx" class="footer-link small">Home</a></li>
                            <li><a href="courses.aspx" class="footer-link small">Courses</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3">
                        <h6 class="fw-bold mb-4 text-uppercase small tracking-widest">Support</h6>
                        <p class="text-white-50 small mb-2"><i class="bi bi-envelope me-2 text-primary"></i> support@learnease.com</p>
                        <p class="text-white-50 small"><i class="bi bi-geo-alt me-2 text-primary"></i> Maitidevi, Kathmandu</p>
                    </div>
                </div>
                <hr class="my-5 border-secondary opacity-25" />
                <p class="text-center text-white-50 small mb-0">&copy; <%= DateTime.Now.Year %> LearnEase Global. Professional Education Platform.</p>
            </div>
        </footer>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectUserType(userType) {
            document.getElementById('<%= hfUserType.ClientID %>').value = userType;

            // Update active button
            document.querySelectorAll('.user-type-option').forEach(btn => {
                btn.classList.remove('active');
                if (btn.getAttribute('data-type') === userType) {
                    btn.classList.add('active');
                }
            });

            // Update placeholder and button text based on user type
            const emailInput = document.getElementById('<%= txtEmail.ClientID %>');
            const emailLabel = document.getElementById('<%= litEmailLabel.ClientID %>');
    const loginButton = document.getElementById('<%= btnLogin.ClientID %>');
    
    switch (userType) {
        case 'student':
            emailInput.placeholder = 'student@example.com';
            emailLabel.innerText = 'Student Email';
            loginButton.innerText = 'Login to Student Dashboard';
            break;
        case 'educator':
            emailInput.placeholder = 'educator@example.com';
            emailLabel.innerText = 'Educator Email';
            loginButton.innerText = 'Login to Educator Dashboard';
            break;
        case 'admin':
            emailInput.placeholder = 'admin@learnease.com';
            emailLabel.innerText = 'Admin Email';
            loginButton.innerText = 'Admin Secure Login';
            
            // Pre-fill admin email for convenience (optional)
            // emailInput.value = 'admin@learnease.com';
            break;
    }
    
    // Clear any previous error messages when switching user types
            document.getElementById('<%= pnlError.ClientID %>').style.display = 'none';
        }

        function togglePassword() {
            const input = document.getElementById('<%= txtPassword.ClientID %>');
            const icon = event.currentTarget.querySelector('i');
            input.type = input.type === "password" ? "text" : "password";
            icon.classList.toggle('bi-eye');
            icon.classList.toggle('bi-eye-slash');
        }
    </script>
</body>
</html>