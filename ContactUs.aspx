<%@ Page Title="Contact Us – LearnEase" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="WebApplication3.ContactUs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root { --brand-primary: #0d6efd; }
        .hero-section {
            background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
            color: white;
            padding: 80px 0 120px 0;
            border-radius: 0 0 50px 50px;
            text-align: center;
        }
        .contact-wrapper { margin-top: -80px; position: relative; z-index: 10; }
        .contact-card {
            background: #ffffff;
            border: none;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 40px;
            height: 100%;
        }
        .info-box {
            background: #f8fafc;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 20px;
            transition: 0.3s;
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
        }
        .info-box i { font-size: 1.5rem; color: var(--brand-primary); margin-right: 15px; }
        .error-text { color: #dc3545; font-size: 0.85rem; margin-top: 5px; display: none; font-weight: 500; }
        .map-container { border-radius: 24px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.1); height: 100%; min-height: 400px; }
        iframe { width: 100%; height: 100%; border: none; min-height: 400px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="hero-section">
        <div class="container">
            <h1 class="fw-bold display-4">Get in Touch</h1>
            <p class="lead opacity-75">Our team in Kathmandu is here to support your learning journey.</p>
        </div>
    </section>

    <section class="container contact-wrapper mb-5">
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="contact-card">
                    <h3 class="fw-bold mb-4">Send Us a Message</h3>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Full Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control bg-light border-0 py-2" placeholder="Your Name" />
                            <span id="errName" class="error-text">Please enter your name</span>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-light border-0 py-2" placeholder="email@example.com" />
                            <span id="errEmail" class="error-text">Valid email is required</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Subject</label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control bg-light border-0 py-2" placeholder="Subject" />
                        <span id="errSubject" class="error-text">Subject is required</span>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Message</label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control bg-light border-0" placeholder="How can we help?" />
                        <span id="errMessage" class="error-text">Message cannot be empty</span>
                    </div>
                    <asp:Button ID="btnSubmit" runat="server" Text="Send Message" 
                        CssClass="btn btn-primary px-5 py-3 rounded-pill fw-bold shadow-sm" 
                        OnClientClick="return validateContactForm();" OnClick="btnSubmit_Click" />
                    <asp:Label ID="lblMessage" runat="server" CssClass="d-block mt-3 fw-bold" />
                </div>
            </div>

            <div class="col-lg-5">
                <div class="d-flex flex-column h-100 g-4">
                    <div class="info-box">
                        <i class="bi bi-geo-alt-fill"></i>
                        <div>
                            <h6 class="fw-bold mb-0">Our Location</h6>
                            <small class="text-muted">Maitidevi, Kathmandu 44600, Nepal</small>
                        </div>
                    </div>
                    <div class="info-box">
                        <i class="bi bi-envelope-at-fill"></i>
                        <div>
                            <h6 class="fw-bold mb-0">Email Us</h6>
                            <small class="text-muted">contact@learnease.com.np</small>
                        </div>
                    </div>
                    <div class="map-container">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3532.4132474443914!2d85.33120617531984!3d27.704533925590924!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39eb199efe9d7c6b%3A0x91b99a6b3001a0bc!2sMaitidevi%2C%20Kathmandu%2044600!5e0!3m2!1sen!2snp!4v1700000000000!5m2!1sen!2snp" 
                            allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe> 

                    </div>
                </div>
            </div>
        </div>
    </section>

    <script>
        function validateContactForm() {
            let isValid = true;
            const name = document.getElementById('<%= txtName.ClientID %>').value.trim();
            const email = document.getElementById('<%= txtEmail.ClientID %>').value.trim();
            const subject = document.getElementById('<%= txtSubject.ClientID %>').value.trim();
            const message = document.getElementById('<%= txtMessage.ClientID %>').value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            document.querySelectorAll('.error-text').forEach(el => el.style.display = 'none');

            if (name === "") { document.getElementById('errName').style.display = 'block'; isValid = false; }
            if (!emailRegex.test(email)) { document.getElementById('errEmail').style.display = 'block'; isValid = false; }
            if (subject === "") { document.getElementById('errSubject').style.display = 'block'; isValid = false; }
            if (message === "") { document.getElementById('errMessage').style.display = 'block'; isValid = false; }

            return isValid;
        }
    </script>
</asp:Content>