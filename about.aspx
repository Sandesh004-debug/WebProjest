<%-- Change the first line of about.aspx to this: --%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="about.aspx.cs" Inherits="WebApplication3.about" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --brand-primary: #0d6efd;
            --brand-secondary: #6610f2;
        }

        .section-padding {
            padding: 90px 0;
        }

        .text-gradient {
            background: linear-gradient(135deg, var(--brand-primary), var(--brand-secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Value Cards Styling */
        .value-card {
            padding: 40px;
            background: #fff;
            border-radius: 20px;
            transition: all 0.3s ease;
            border: 1px solid #f0f0f0;
        }

            .value-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.08);
                border-color: var(--brand-primary);
            }

        /* Mission Section Styling */
        .mission-box {
            border-left: 5px solid var(--brand-primary);
            padding: 40px;
            background: white;
            border-radius: 0 20px 20px 0;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            height: 100%;
        }

        /* Stats Section */
        .stats-badge {
            background: linear-gradient(135deg, #1e293b, #0f172a);
            color: white;
            padding: 60px 0;
        }

        /* Team Image Styling */
        .img-stack {
            position: relative;
        }

            .img-stack::after {
                content: '';
                position: absolute;
                top: 20px;
                left: 20px;
                width: 100%;
                height: 100%;
                border: 2px solid var(--brand-primary);
                border-radius: 1.5rem;
                z-index: -1;
            }
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <section class="section-padding bg-white">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-lg-6">
                    <h6 class="text-primary fw-bold text-uppercase tracking-wider mb-3">Who We Are</h6>
                    <h1 class="display-4 fw-bold mb-4">Redefining the <span class="text-gradient">Digital Learning</span> Frontier</h1>
                    <p class="lead text-muted mb-4">
                        Founded at the Asia Pacific University innovation lab, LearnEase emerged as a solution to the widening gap between traditional education and industry demands. 
                    </p>
                    <p class="text-muted mb-5">
                        We aren't just an online course provider; we are a global ecosystem that integrates AI-driven analytics, expert mentorship, and hands-on project simulation.
                    </p>
                    <div class="row g-4">
                        <div class="col-sm-6">
                            <div class="d-flex align-items-center">
                                <div class="bg-success bg-opacity-10 p-2 rounded-circle me-3">
                                    <i class="bi bi-check2 text-success fs-4"></i>
                                </div>
                                <span class="fw-bold">Global Accreditation</span>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="d-flex align-items-center">
                                <div class="bg-success bg-opacity-10 p-2 rounded-circle me-3">
                                    <i class="bi bi-check2 text-success fs-4"></i>
                                </div>
                                <span class="fw-bold">24/7 Expert Support</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="img-stack">
                        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&h=600&fit=crop" class="img-fluid rounded-4 shadow-lg" alt="Team collaborating" />
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="stats-badge">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-md-3">
                    <h2 class="display-5 fw-bold">150K+</h2>
                    <p class="text-white-50 mb-0">Active Students</p>
                </div>
                <div class="col-md-3">
                    <h2 class="display-5 fw-bold">450+</h2>
                    <p class="text-white-50 mb-0">Expert Mentors</p>
                </div>
                <div class="col-md-3">
                    <h2 class="display-5 fw-bold">94%</h2>
                    <p class="text-white-50 mb-0">Course Completion</p>
                </div>
                <div class="col-md-3">
                    <h2 class="display-5 fw-bold">12+</h2>
                    <p class="text-white-50 mb-0">Global Offices</p>
                </div>
            </div>
        </div>
    </section>

    <section class="section-padding bg-light">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold">Our Core Values</h2>
                <p class="text-muted">The principles that guide our innovation every day.</p>
            </div>
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="value-card h-100">
                        <i class="bi bi-lightbulb text-primary fs-1 mb-3"></i>
                        <h4 class="fw-bold">Incessant Innovation</h4>
                        <p class="text-muted mb-0">We constantly update our curriculum to match the lightning-fast evolution of tech industries.</p>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="value-card h-100">
                        <i class="bi bi-shield-check text-primary fs-1 mb-3"></i>
                        <h4 class="fw-bold">Integrity First</h4>
                        <p class="text-muted mb-0">Transparent pricing and verified certifications that employers actually trust.</p>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="value-card h-100">
                        <i class="bi bi-people text-primary fs-1 mb-3"></i>
                        <h4 class="fw-bold">Community Driven</h4>
                        <p class="text-muted mb-0">Learning is better together. We foster a global network of peers and professionals.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="section-padding bg-white">
        <div class="container">
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="mission-box">
                        <i class="bi bi-bullseye text-primary display-5 mb-3"></i>
                        <h3 class="fw-bold">Our Mission</h3>
                        <p class="text-muted fs-5 mb-0">To democratize elite-level education by making it accessible, affordable, and actionable for learners globally.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mission-box" style="border-left-color: var(--brand-secondary);">
                        <i class="bi bi-eye text-primary display-5 mb-3" style="color: var(--brand-secondary) !important;"></i>
                        <h3 class="fw-bold">Our Vision</h3>
                        <p class="text-muted fs-5 mb-0">To become the world's primary engine for career transformation through digital mastery and AI integration.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
