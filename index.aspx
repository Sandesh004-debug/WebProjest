<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="WebApplication3.index" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>LearnEase – Modern Digital Learning Platform</title>
    <meta name="description" content="LearnEase empowers students with high-quality online courses and expert-led digital learning." />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Outfit:wght@700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="Styles/Main.css" rel="stylesheet" />

    <style>
        :root {
            --brand-primary: #0d6efd;
            --brand-dark: #0f172a;
            --glass-bg: rgba(255, 255, 255, 0.8);
        }

        body {
            font-family: 'Inter', sans-serif;
            color: #334155;
            overflow-x: hidden;
        }

        h1, h2, h3, .navbar-brand {
            font-family: 'Outfit', sans-serif;
        }

        .text-gradient {
            background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-section {
            padding: 100px 0;
            background: radial-gradient(circle at top right, rgba(13, 110, 253, 0.05), transparent), radial-gradient(circle at bottom left, rgba(102, 16, 242, 0.05), transparent);
        }

        .hero-img-wrapper {
            position: relative;
            padding: 20px;
        }

            .hero-img-wrapper::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
                background: linear-gradient(135deg, #0d6efd, #6610f2);
                border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
                filter: blur(80px);
                opacity: 0.1;
                z-index: -1;
            }

        .feature-card {
            border: 1px solid rgba(0,0,0,0.05);
            border-radius: 24px;
            padding: 2.5rem;
            background: #fff;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            height: 100%;
        }

            .feature-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 30px 60px rgba(15, 23, 42, 0.1);
            }

        .icon-circle {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
        }

        .stats-bar {
            background: var(--brand-dark);
            border-radius: 30px;
            padding: 40px;
            margin-top: -50px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }

        .btn-premium {
            padding: 12px 32px;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }

        .course-card {
            border: none;
            border-radius: 20px;
            overflow: hidden;
            transition: 0.3s;
            background: #fff;
            border: 1px solid #f1f5f9;
        }

            .course-card:hover {
                transform: scale(1.02);
                box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
            }

        .step-number {
            width: 40px;
            height: 40px;
            background: var(--brand-primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 15px;
        }

        /* Ensure images load predictably */
        .course-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
            background-color: #f1f5f9;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">

        <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top border-bottom py-3">
            <div class="container">
                <asp:HyperLink runat="server" NavigateUrl="~/index.aspx" CssClass="navbar-brand d-flex align-items-center">
            <asp:Image runat="server" ImageUrl="~/images/logo.png" CssClass="me-2" Height="45" />
            <span class="fw-bold fs-3 text-gradient">LearnEase</span>
                </asp:HyperLink>
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="bi bi-list fs-1"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto me-4 gap-2">
                        <li class="nav-item">
                            <asp:HyperLink runat="server" NavigateUrl="~/index.aspx" CssClass="nav-link active fw-semibold">Home</asp:HyperLink></li>
                        <li class="nav-item">
                            <asp:HyperLink runat="server" NavigateUrl="~/about.aspx" CssClass="nav-link fw-semibold">About</asp:HyperLink></li>
                        <li class="nav-item">
                            <asp:HyperLink runat="server" NavigateUrl="~/courses.aspx" CssClass="nav-link fw-semibold">Courses</asp:HyperLink></li>
                        <li class="nav-item">
                            <asp:HyperLink runat="server" NavigateUrl="~/ContactUS.aspx" CssClass="nav-link fw-semibold">Contact Us</asp:HyperLink></li>
                    </ul>
                    <div class="d-flex gap-2">
                        <asp:HyperLink runat="server" NavigateUrl="~/Login.aspx" CssClass="btn btn-outline-primary btn-premium">Login</asp:HyperLink>
                        <asp:HyperLink runat="server" NavigateUrl="~/Register.aspx" CssClass="btn btn-warning btn-premium text-white shadow-sm">Get Started</asp:HyperLink>
                    </div>
                </div>
            </div>
        </nav>

        <section class="hero-section">
            <div class="container">
                <div class="row align-items-center g-5">
                    <div class="col-lg-6">
                        <div class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill mb-4 fw-bold">
                            <i class="bi bi-rocket-takeoff-fill me-2"></i>THE FUTURE OF EDUCATION
                        </div>
                        <h1 class="display-3 fw-800 mb-4 lh-sm">Empower Your Future Through
                            <br />
                            <span class="text-gradient">Digital Mastery</span></h1>
                        <p class="lead text-muted mb-5 fs-5">Experience a revolutionary way of learning. Access world-class courses, real-time mentorship, and industry-standard projects.</p>
                        <div class="d-flex flex-column flex-sm-row gap-3">
                            <asp:HyperLink runat="server" NavigateUrl="~/register.aspx" CssClass="btn btn-warning btn-lg text-white btn-premium px-5 shadow">Start Learning Now</asp:HyperLink>
                            <asp:HyperLink runat="server" NavigateUrl="~/courses.aspx" CssClass="btn btn-outline-dark btn-lg btn-premium px-5">Explore Catalog</asp:HyperLink>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="hero-img-wrapper text-center">
                            <asp:Image runat="server" ImageUrl="https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=800&auto=format&fit=crop" CssClass="img-fluid rounded-4 shadow-2xl position-relative" />
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="container mb-5">
            <div class="stats-bar text-white">
                <div class="row text-center g-4">
                    <div class="col-6 col-md-3">
                        <h2 class="display-6 fw-bold text-gradient mb-0">10k+</h2>
                        <small class="text-white-50 text-uppercase tracking-wider">Learners</small>
                    </div>
                    <div class="col-6 col-md-3">
                        <h2 class="display-6 fw-bold text-gradient mb-0">500+</h2>
                        <small class="text-white-50 text-uppercase tracking-wider">Courses</small>
                    </div>
                    <div class="col-6 col-md-3">
                        <h2 class="display-6 fw-bold text-gradient mb-0">100+</h2>
                        <small class="text-white-50 text-uppercase tracking-wider">Instructors</small>
                    </div>
                    <div class="col-6 col-md-3">
                        <h2 class="display-6 fw-bold text-gradient mb-0">95%</h2>
                        <small class="text-white-50 text-uppercase tracking-wider">Success Rate</small>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-5">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="fw-bold display-5">Explore Popular <span class="text-primary">Programs</span></h2>
                    <p class="text-muted">High-demand skills taught by industry leaders.</p>
                </div>
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="course-card shadow-sm h-100 p-3">
                            <img src="https://images.unsplash.com/photo-1587620962725-abab7fe55159?q=80&w=800&auto=format&fit=crop" class="img-fluid rounded-3 mb-3" alt="Dev" />
                            <span class="badge bg-primary-subtle text-primary mb-2">Development</span>
                            <h5 class="fw-bold">Full-Stack Web Development</h5>
                            <p class="text-muted small">Master React, Node.js, and SQL by building real applications.</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="fw-bold text-dark">$49.99</span>
                                <asp:HyperLink runat="server" NavigateUrl="~/courses.aspx" CssClass="btn btn-sm btn-primary">Enroll</asp:HyperLink>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="course-card shadow-sm h-100 p-3">
                            <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?q=80&w=800&auto=format&fit=crop" class="img-fluid rounded-3 mb-3" alt="Data" />
                            <span class="badge bg-success-subtle text-success mb-2">Data Science</span>
                            <h5 class="fw-bold">AI & Machine Learning</h5>
                            <p class="text-muted small">Neural networks, Python automation, and predictive modeling.</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="fw-bold text-dark">$59.99</span>
                                <asp:HyperLink runat="server" NavigateUrl="~/courses.aspx" CssClass="btn btn-sm btn-primary">Enroll</asp:HyperLink>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="course-card shadow-sm h-100 p-3">
                            <img src="https://images.unsplash.com/photo-1561070791-2526d30994b5?q=80&w=800&auto=format&fit=crop" class="img-fluid rounded-3 mb-3" alt="Design" />
                            <span class="badge bg-info-subtle text-info mb-2">Design</span>
                            <h5 class="fw-bold">Advanced UI/UX Design</h5>
                            <p class="text-muted small">Modern design systems, accessibility, and high-fidelity prototyping.</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="fw-bold text-dark">$39.99</span>
                                <asp:HyperLink runat="server" NavigateUrl="~/courses.aspx" CssClass="btn btn-sm btn-primary">Enroll</asp:HyperLink>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-5 bg-light">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-5">
                        <h2 class="fw-bold display-6 mb-4">How it <span class="text-primary">Works</span></h2>
                        <p class="text-muted mb-5">Our four-step process is designed to take you from a curious learner to a certified expert.</p>
                        <div class="mb-4">
                            <div class="step-number">1</div>
                            <h5 class="fw-bold">Choose your Track</h5>
                            <p class="text-muted small">Pick a career-focused path based on your goals.</p>
                        </div>
                        <div class="mb-4">
                            <div class="step-number">2</div>
                            <h5 class="fw-bold">Interactive Learning</h5>
                            <p class="text-muted small">Watch videos and complete quizzes at your own pace.</p>
                        </div>
                        <div>
                            <div class="step-number">3</div>
                            <h5 class="fw-bold">Get Certified</h5>
                            <p class="text-muted small">Earn an industry-recognized credential upon completion.</p>
                        </div>
                    </div>
                    <div class="col-lg-7 text-center">
                        <img src="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=600&fit=crop" class="img-fluid rounded-5 shadow-lg" alt="Workflow" />
                    </div>
                </div>
            </div>
        </section>

        <section class="py-5 pb-5">
            <div class="container">
                <div class="row g-4">
                    <div class="col-lg-4">
                        <div class="feature-card">
                            <div class="icon-circle bg-primary bg-opacity-10 text-primary"><i class="bi bi-laptop"></i></div>
                            <h4 class="fw-bold">Interactive Lessons</h4>
                            <p class="text-muted">Engage with high-quality video content and real-time coding playgrounds.</p>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="feature-card">
                            <div class="icon-circle bg-success bg-opacity-10 text-success"><i class="bi bi-person-badge"></i></div>
                            <h4 class="fw-bold">Expert Mentors</h4>
                            <p class="text-muted">Get direct guidance from industry veterans from top global tech companies.</p>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="feature-card">
                            <div class="icon-circle bg-info bg-opacity-10 text-info"><i class="bi bi-patch-check"></i></div>
                            <h4 class="fw-bold">Verified Certificates</h4>
                            <p class="text-muted">Earn credentials recognized globally and shareable on professional profiles.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <footer class="bg-dark text-light pt-5 pb-4 mt-5" style="border-radius: 40px 40px 0 0;">
            <div class="container pt-3">
                <div class="row g-5 justify-content-between">
                    <div class="col-lg-4">
                        <div class="d-flex align-items-center mb-4">
                            <asp:Image runat="server" ImageUrl="~/images/logo.png" Height="45" CssClass="me-2" />
                            <span class="fw-bold fs-3">LearnEase</span>
                        </div>
                        <p class="text-white-50 mb-4">Empowering the next generation of digital leaders with high-quality resources.</p>
                        <div class="d-flex gap-3">
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-twitter-x"></i></a>
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-linkedin"></i></a>
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle"><i class="bi bi-instagram"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-4">
                        <h6 class="fw-bold mb-4">Quick Links</h6>
                        <ul class="list-unstyled">
                            <li><a href="index.aspx" class="text-white-50 text-decoration-none d-block mb-3">Home</a></li>
                            <li><a href="about.aspx" class="text-white-50 text-decoration-none d-block mb-3">About Us</a></li>
                            <li><a href="courses.aspx" class="text-white-50 text-decoration-none d-block mb-3">Courses</a></li>
                            <li><a href="ContactUs.aspx" class="text-white-50 text-decoration-none d-block mb-3">Contact Us</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3">
                        <h6 class="fw-bold mb-4">Contact</h6>
                        <p class="text-white-50 small mb-2"><i class="bi bi-envelope me-2 text-primary"></i>info@learnease.com</p>
                        <p class="text-white-50 small mb-2"><i class="bi bi-phone me-2 text-primary"></i>+977 9700000000</p>
                        <p class="text-white-50 small"><i class="bi bi-geo-alt me-2 text-primary"></i>Maitidevi, Kathmandu</p>
                    </div>
                </div>
                <hr class="my-5 border-secondary opacity-25" />
                <div class="text-center text-white-50 small">
                    <p class="m-0">&copy;
                        <asp:Literal ID="litYear" runat="server" />
                        LearnEase Global. Developed by APU Students.</p>
                </div>
            </div>
        </footer>

    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
