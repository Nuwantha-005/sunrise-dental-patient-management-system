<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us — Sunrise Dental Clinic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

<!-- ══ NAVBAR ══════════════════════════════════════════════ -->
<%@ include file="navbar.jsp" %>

<!-- ══ PAGE HERO ═══════════════════════════════════════════ -->
<div class="page-hero">
    <div class="container">
        <h1>About Sunrise Dental</h1>
        <p>A legacy of trusted care, innovation and compassion — built over 15 years of serving smiles across Sri Lanka.</p>
        <div class="breadcrumb-nav">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span>›</span>
            <span style="color:white;">About Us</span>
        </div>
    </div>
</div>

<!-- ══ MISSION ══════════════════════════════════════════════ -->
<section class="section">
    <div class="container">
        <div class="mission-grid">
            <div class="mission-content">
                <span class="section-tag">Our Story</span>
                <h2 class="section-title">Dedicated to Your Dental Health Since 2009</h2>
                <p class="section-subtitle">
                    Sunrise Dental Clinic was founded with a single vision — to make premium dental care accessible, comfortable and affordable for every Sri Lankan family.
                </p>
                <p style="color:var(--text-muted); font-size:0.95rem; line-height:1.8; margin-bottom:16px;">
                    What began as a small two-chair practice in Colombo has grown into a multi-speciality dental centre trusted by over 5,000 patients. Our team of eight specialist dentists and 20 dedicated staff members work together every day to deliver exceptional outcomes — whether it's a routine cleaning or a complex full-mouth rehabilitation.
                </p>
                <p style="color:var(--text-muted); font-size:0.95rem; line-height:1.8; margin-bottom:32px;">
                    We invest continuously in the latest dental technology — from digital X-rays and intraoral cameras to 3D cone beam CT scanning — because we believe that better tools mean better outcomes for our patients.
                </p>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary">Book a Consultation</a>
            </div>
            <div>
                <img src="${pageContext.request.contextPath}/images/3.jpg" alt="Our Clinic" class="mission-image">
            </div>
        </div>
    </div>
</section>

<!-- ══ MILESTONES ═══════════════════════════════════════════ -->
<section class="section-sm" style="background:var(--off-white);">
    <div class="container">
        <div class="milestones">
            <div class="milestone"><strong>15+</strong><span>Years in Practice</span></div>
            <div class="milestone"><strong>5,000+</strong><span>Patients Treated</span></div>
            <div class="milestone"><strong>8</strong><span>Specialist Dentists</span></div>
            <div class="milestone"><strong>98%</strong><span>Satisfaction Rate</span></div>
        </div>
    </div>
</section>

<!-- ══ VALUES ═══════════════════════════════════════════════ -->
<section class="section">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">What We Stand For</span>
            <h2 class="section-title">Our Core Values</h2>
            <p class="section-subtitle">Every decision we make is guided by these four principles that define who we are.</p>
        </div>
        <div class="values-grid">
            <div class="value-card">
                <div class="value-icon">🎯</div>
                <h3>Excellence</h3>
                <p>We hold ourselves to the highest clinical standards, pursuing continuous education and evidence-based practices.</p>
            </div>
            <div class="value-card">
                <div class="value-icon">❤️</div>
                <h3>Compassion</h3>
                <p>Every patient is treated with warmth and empathy. We listen before we act, because your comfort matters most.</p>
            </div>
            <div class="value-card">
                <div class="value-icon">🔍</div>
                <h3>Integrity</h3>
                <p>Transparent pricing, honest advice and ethical practice. We only recommend what you genuinely need.</p>
            </div>
            <div class="value-card">
                <div class="value-icon">🚀</div>
                <h3>Innovation</h3>
                <p>Adopting the latest dental technologies and techniques to deliver faster, more accurate and more comfortable care.</p>
            </div>
        </div>
    </div>
</section>

<!-- ══ TEAM ═════════════════════════════════════════════════ -->
<section class="section team">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">The People Behind Your Smile</span>
            <h2 class="section-title">Meet Our Expert Team</h2>
            <p class="section-subtitle">Board-certified specialists with international training and a passion for dentistry.</p>
        </div>
        <div class="team-grid">
            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/4.jpg" alt="Dr. Kamal Perera">
                <div class="team-card-body">
                    <h3>Dr. Kamal Perera</h3>
                    <div class="role">Oral &amp; Maxillofacial Surgeon</div>
                    <p>BDS (Colombo), MDS. 12+ years specialising in jaw surgery, complex extractions and oral pathology.</p>
                </div>
            </div>
            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/1.jpg" alt="Dr. Nimali Silva">
                <div class="team-card-body">
                    <h3>Dr. Nimali Silva</h3>
                    <div class="role">Cosmetic &amp; Aesthetic Dentist</div>
                    <p>BDS (Peradeniya), Dip. Aesthetic Dentistry (UK). Expert in smile design, porcelain veneers and whitening.</p>
                </div>
            </div>
            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/2.jpg" alt="Dr. Ruwan Jayasuriya">
                <div class="team-card-body">
                    <h3>Dr. Ruwan Jayasuriya</h3>
                    <div class="role">Consultant Orthodontist</div>
                    <p>BDS, MOrth RCS (Edinburgh). Certified Invisalign provider with 10+ years correcting smiles of all ages.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══ ACCREDITATIONS ══════════════════════════════════════ -->
<section class="section-sm" style="background:var(--off-white);">
    <div class="container text-center">
        <span class="section-tag">Recognised &amp; Accredited</span>
        <h2 class="section-title" style="margin-bottom:40px;">Trusted by Leading Dental Bodies</h2>
        <div style="display:flex; justify-content:center; gap:40px; flex-wrap:wrap; align-items:center;">
            <div style="background:white; border-radius:12px; padding:20px 32px; box-shadow:var(--shadow-sm); font-weight:700; color:var(--primary-dark); border:1px solid var(--border);">🦷 SLDA Member</div>
            <div style="background:white; border-radius:12px; padding:20px 32px; box-shadow:var(--shadow-sm); font-weight:700; color:var(--primary-dark); border:1px solid var(--border);">🏅 ISO 9001:2015</div>
            <div style="background:white; border-radius:12px; padding:20px 32px; box-shadow:var(--shadow-sm); font-weight:700; color:var(--primary-dark); border:1px solid var(--border);">✅ MOHSL Registered</div>
            <div style="background:white; border-radius:12px; padding:20px 32px; box-shadow:var(--shadow-sm); font-weight:700; color:var(--primary-dark); border:1px solid var(--border);">🌟 5-Star Google Rating</div>
        </div>
    </div>
</section>

<!-- ══ CTA ══════════════════════════════════════════════════ -->
<section class="cta-banner">
    <div class="container">
        <h2>Come Experience the Sunrise Difference</h2>
        <p>Join thousands of patients who trust us with their smiles. Your first consultation is just a call away.</p>
        <div class="cta-actions">
            <a href="${pageContext.request.contextPath}/contact" class="btn btn-white btn-lg">Book Appointment</a>
            <a href="${pageContext.request.contextPath}/careers" class="btn btn-gold btn-lg">Join Our Team</a>
        </div>
    </div>
</section>

<!-- ══ FOOTER ═══════════════════════════════════════════════ -->
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <img src="${pageContext.request.contextPath}/images/sunrise-logo.png" alt="Sunrise Dental">
                <p>Providing world-class dental care to the people of Sri Lanka since 2009.</p>
                <div class="footer-social">
                    <a href="#" class="social-btn">f</a>
                    <a href="#" class="social-btn">📷</a>
                    <a href="#" class="social-btn">💬</a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/careers">Careers</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Services</h4>
                <ul>
                    <li><a href="#">General Dentistry</a></li>
                    <li><a href="#">Cosmetic Dentistry</a></li>
                    <li><a href="#">Dental Implants</a></li>
                    <li><a href="#">Orthodontics</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Contact</h4>
                <div class="footer-contact-item">📍 123 Galle Road, Colombo 03</div>
                <div class="footer-contact-item">📞 +94 11 234 5678</div>
                <div class="footer-contact-item">✉️ info@sunrisedental.lk</div>
            </div>
        </div>
        <div class="footer-bottom">
            <span>© 2025 Sunrise Dental Clinic. All rights reserved.</span>
            <span>Privacy Policy &nbsp;|&nbsp; Terms of Service</span>
        </div>
    </div>
</footer>

</body>
</html>
