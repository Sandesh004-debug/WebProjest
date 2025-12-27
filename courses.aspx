<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="courses.aspx.cs" Inherits="WebApplication3.courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        body {
            background-color: #f8fafc;
        }

        .course-card {
            border: none;
            border-radius: 20px;
            transition: all 0.3s ease;
            overflow: hidden;
            background: white;
            border: 1px solid #e2e8f0;
        }

            .course-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            }

        .course-img-wrapper {
            position: relative;
            overflow: hidden;
        }

        .course-price-tag {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background: white;
            padding: 5px 15px;
            border-radius: 10px;
            font-weight: 800;
            color: var(--brand-dark);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .filter-section {
            background: white;
            border-radius: 20px;
            padding: 25px;
            border: 1px solid #e2e8f0;
        }

        .search-bar-wrapper {
            background: white;
            border-radius: 15px;
            padding: 10px 20px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }

        .search-input-clean {
            border: none !important;
            outline: none !important;
            width: 100%;
            font-size: 1rem;
        }

        .category-pill {
            padding: 8px 20px;
            border-radius: 50px;
            background: white;
            border: 1px solid #e2e8f0;
            color: #64748b;
            transition: 0.3s;
            cursor: pointer;
            display: inline-block;
            margin-bottom: 10px;
            text-decoration: none;
        }

            .category-pill.active, .category-pill:hover {
                background: var(--brand-primary);
                color: white;
                border-color: var(--brand-primary);
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfCategory" runat="server" />

    <section class="py-5 bg-white">
        <div class="container py-4">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-800 mb-3">Master New <span class="text-gradient">Skills</span></h1>
                    <p class="text-muted lead mb-4">Access world-class courses designed to help you reach your career milestones.</p>
                    <div class="search-bar-wrapper d-flex align-items-center">
                        <i class="bi bi-search text-muted me-3"></i>
                        <asp:TextBox ID="txtSearch" runat="server" placeholder="What do you want to learn today?" CssClass="search-input-clean flex-grow-1"></asp:TextBox>
                        <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-primary rounded-pill px-4 ms-2" OnClick="btnSearch_Click">Search</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 mb-4">
                    <div class="filter-section sticky-top" style="top: 100px;">
                        <h5 class="fw-bold mb-4">Filters</h5>
                        <div class="mb-4">
                            <label class="fw-semibold small text-uppercase mb-3 d-block text-muted">Categories</label>
                            <div class="d-flex flex-wrap gap-2">
                                <asp:LinkButton ID="lnkAll" runat="server" CssClass="category-pill active" OnClick="Category_Click">All</asp:LinkButton>
                                <asp:LinkButton ID="lnkWeb" runat="server" CssClass="category-pill" OnClick="Category_Click">Web Dev</asp:LinkButton>
                                <asp:LinkButton ID="lnkAI" runat="server" CssClass="category-pill" OnClick="Category_Click">AI/ML</asp:LinkButton>
                                <asp:LinkButton ID="lnkCyber" runat="server" CssClass="category-pill" OnClick="Category_Click">Cyber</asp:LinkButton>
                                <asp:LinkButton ID="lnkDesign" runat="server" CssClass="category-pill" OnClick="Category_Click">Design</asp:LinkButton>
                                <asp:LinkButton ID="lnkBusiness" runat="server" CssClass="category-pill" OnClick="Category_Click">Business</asp:LinkButton>
                                <asp:LinkButton ID="lnkIT" runat="server" CssClass="category-pill" OnClick="Category_Click">IT</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-9">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold mb-0">
                            <asp:Literal ID="litCount" runat="server"></asp:Literal>
                            Courses Found</h4>
                        <asp:DropDownList ID="ddlSort" runat="server" CssClass="form-select w-auto rounded-pill border-0 shadow-sm px-3" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                            <asp:ListItem Text="Most Popular" Value="Popular"></asp:ListItem>
                            <asp:ListItem Text="Newest" Value="Newest"></asp:ListItem>
                            <asp:ListItem Text="Price: Low to High" Value="PriceAsc"></asp:ListItem>
                            <asp:ListItem Text="Price: High to Low" Value="PriceDesc"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="row g-4">
                        <asp:Repeater ID="rptCourses" runat="server">
                            <ItemTemplate>
                                <div class="col-md-6">
                                    <div class="card course-card h-100">
                                        <div class="course-img-wrapper">
                                            <img src='<%# Eval("ImageUrl") %>' class="card-img-top" alt="Course Image">
                                            <span class="course-price-tag"><%# Eval("Price") %></span>
                                        </div>
                                        <div class="card-body p-4">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class='<%# "badge bg-opacity-10 " + Eval("BadgeClass") %>'><%# Eval("Category") %></span>
                                                <span class="text-warning small fw-bold"><i class="bi bi-star-fill me-1"></i><%# Eval("Rating") %></span>
                                            </div>
                                            <h5 class="fw-bold mb-2"><%# Eval("Title") %></h5>
                                            <p class="text-muted small mb-2"><%# Eval("Description") %></p>

                                            <asp:PlaceHolder ID="phProgress" runat="server" Visible='<%# Session["UserID"] != null %>'>
                                                <div class="progress mb-2" style="height: 10px;">
                                                    <div class="progress-bar bg-success" role="progressbar" style='<%# "width: " + Eval("Progress") + "%;" %>' aria-valuenow='<%# Eval("Progress") %>' aria-valuemin="0" aria-valuemax="100"></div>
                                                </div>
                                                <small class="text-muted d-block mb-2">Progress: <%# Eval("Progress") %>%</small>
                                            </asp:PlaceHolder>

                                            <hr class="my-3 opacity-25">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="d-flex align-items-center">
                                                    <img src='<%# Eval("InstructorImg") %>' class="rounded-circle me-2" width="30" height="30" alt="Instructor">
                                                    <small class="text-muted"><%# Eval("InstructorName") %></small>
                                                </div>
                                                <asp:HyperLink runat="server" NavigateUrl='<%# (Session["UserID"] != null) ? "CourseView.aspx?id=" + Eval("CourseID") : "~/login.aspx" %>' CssClass="btn btn-outline-primary btn-sm rounded-pill px-3">View Course</asp:HyperLink>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
