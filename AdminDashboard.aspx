<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="WebApplication3.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard – LearnEase</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        :root {
            --sidebar-width: 280px;
            --admin-primary: #4f46e5;
            --admin-dark: #1e1b4b;
            --bg-light: #f8fafc;
        }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg-light);
            overflow-x: hidden;
        }

        h1, h2, h3, .brand-font { font-family: 'Outfit', sans-serif; }

        /* Sidebar Layout */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: var(--admin-dark);
            color: white;
            z-index: 1000;
            transition: all 0.3s;
        }

        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            padding: 2rem;
        }

        /* Sidebar Links */
        .nav-link-admin {
            color: rgba(255,255,255,0.7);
            padding: 0.8rem 1.5rem;
            display: flex;
            align-items: center;
            text-decoration: none;
            border-radius: 10px;
            margin: 0.2rem 1rem;
            transition: 0.3s;
        }

        .nav-link-admin:hover, .nav-link-admin.active {
            background: rgba(255,255,255,0.1);
            color: white;
        }

        .nav-link-admin i { margin-right: 1rem; font-size: 1.2rem; }

        /* Cards & Stats */
        .stat-card {
            background: white;
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            padding: 1.5rem;
        }

        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        /* Modern GridView Styling */
        .custom-grid {
            border: none !important;
        }
        .custom-grid th {
            background-color: #f1f5f9 !important;
            color: #64748b;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            padding: 1rem !important;
            border: none !important;
        }
        .custom-grid td {
            padding: 1rem !important;
            border-bottom: 1px solid #f1f5f9 !important;
        }

        .text-gradient {
            background: linear-gradient(135deg, #818cf8 0%, #c084fc 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        @media (max-width: 992px) {
            .sidebar { left: -100%; }
            .main-content { margin-left: 0; }
            .sidebar.active { left: 0; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <div class="sidebar">
        <div class="p-4 mb-4">
            <div class="d-flex align-items-center">
                <asp:Image runat="server" ImageUrl="~/images/logo.png" Height="35" CssClass="me-2" />
                <span class="fw-bold fs-4 brand-font text-gradient">LearnEase</span>
            </div>
            <small class="text-white-50 ms-1">Admin Control Center</small>
        </div>

        <nav>
            <a href="#" class="nav-link-admin active"><i class="bi bi-speedometer2"></i> Dashboard</a>
            <a href="#" class="nav-link-admin"><i class="bi bi-people"></i> Manage Users</a>
            <a href="#" class="nav-link-admin"><i class="bi bi-journal-text"></i> Courses Catalog</a>
            <a href="#" class="nav-link-admin"><i class="bi bi-shield-lock"></i> Security</a>
            <hr class="mx-3 opacity-25">
            <a href="#" class="nav-link-admin"><i class="bi bi-gear"></i> Settings</a>
            <asp:LinkButton ID="btnLogoutSide" runat="server" OnClick="btnLogout_Click" CssClass="nav-link-admin text-danger">
                <i class="bi bi-power"></i> Logout
            </asp:LinkButton>
        </nav>
    </div>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h1 class="h3 fw-bold mb-0">Platform Overview</h1>
                <p class="text-muted small mb-0">Welcome back, Administrator.</p>
            </div>
            <div class="d-flex gap-3">
                <button type="button" class="btn btn-white shadow-sm border rounded-pill px-3 py-2">
                    <i class="bi bi-download me-2"></i> Export Report
                </button>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-lg-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="icon-box bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-people"></i>
                        </div>
                        <span class="badge bg-success bg-opacity-10 text-success">+12%</span>
                    </div>
                    <h6 class="text-muted small fw-semibold">Total Registered</h6>
                    <h2 class="fw-bold mb-0"><asp:Literal ID="litTotalUsers" runat="server" Text="1,284" /></h2>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="icon-box bg-success bg-opacity-10 text-success">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                        <span class="badge bg-success bg-opacity-10 text-success">+5%</span>
                    </div>
                    <h6 class="text-muted small fw-semibold">Revenue (MTD)</h6>
                    <h2 class="fw-bold mb-0">$14,210</h2>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="icon-box bg-info bg-opacity-10 text-info">
                            <i class="bi bi-book"></i>
                        </div>
                        <span class="badge bg-info bg-opacity-10 text-info">Active</span>
                    </div>
                    <h6 class="text-muted small fw-semibold">Active Courses</h6>
                    <h2 class="fw-bold mb-0">86</h2>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="icon-box bg-warning bg-opacity-10 text-warning">
                            <i class="bi bi-activity"></i>
                        </div>
                        <span class="badge bg-danger bg-opacity-10 text-danger">-2%</span>
                    </div>
                    <h6 class="text-muted small fw-semibold">Server Load</h6>
                    <h2 class="fw-bold mb-0">24%</h2>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-bold">Recent Registrations</h5>
                        <div class="input-group input-group-sm" style="max-width: 250px;">
                            <span class="input-group-text bg-light border-0"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control bg-light border-0" placeholder="Search users...">
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <asp:GridView ID="gvUsers" runat="server"
                                CssClass="table custom-grid mb-0"
                                AutoGenerateColumns="False"
                                GridLines="None"
                                EmptyDataText="No users found.">
                                <Columns>
                                    <asp:TemplateField HeaderText="User">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center">
                                                <div class="rounded-circle bg-light d-flex align-items-center justify-content-center me-3" style="width: 35px; height: 35px;">
                                                    <i class="bi bi-person text-muted"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold text-dark"><%# Eval("UserName") %></div>
                                                    <div class="text-muted small"><%# Eval("Email") %></div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Role">
                                        <ItemTemplate>
                                            <span class="badge rounded-pill bg-light text-dark border">Student</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center text-success small fw-bold">
                                                <span class="p-1 bg-success rounded-circle me-2"></span> Active
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <button type="button" class="btn btn-sm btn-light border-0"><i class="bi bi-pencil"></i></button>
                                            <button type="button" class="btn btn-sm btn-light border-0 text-danger"><i class="bi bi-trash"></i></button>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-header bg-white py-3 px-4">
                        <h5 class="fw-bold mb-0">System Control</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="d-flex align-items-center justify-content-between mb-4">
                            <div>
                                <h6 class="mb-0 fw-bold">Maintenance Mode</h6>
                                <p class="text-muted extra-small mb-0">Block public access to the portal.</p>
                            </div>
                            <div class="form-check form-switch p-0">
                                <asp:CheckBox ID="chkMaintenance" runat="server" CssClass="form-check-input ms-0" AutoPostBack="true" 
                                    OnCheckedChanged="chkMaintenance_CheckedChanged" />
                            </div>
                        </div>

                        <div class="d-flex align-items-center justify-content-between mb-4">
                            <div>
                                <h6 class="mb-0 fw-bold">User Registration</h6>
                                <p class="text-muted extra-small mb-0">Allow new users to sign up.</p>
                            </div>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" checked>
                            </div>
                        </div>

                        <asp:Button ID="btnSaveSettings" runat="server" Text="Apply Changes" CssClass="btn btn-primary w-100 py-2 rounded-pill fw-bold shadow-sm" />
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-4 bg-admin-dark text-white p-4" style="background: var(--admin-dark);">
                    <div class="d-flex align-items-center mb-3">
                        <div class="rounded-3 bg-white bg-opacity-10 p-2 me-3">
                            <i class="bi bi-person-badge fs-3 text-gradient"></i>
                        </div>
                        <div>
                            <h6 class="mb-0 fw-bold">Main Admin</h6>
                            <p class="text-white-50 small mb-0">Root Access Granted</p>
                        </div>
                    </div>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="btn btn-sm btn-outline-light w-100 rounded-pill">
                        Sign Out Properly
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>