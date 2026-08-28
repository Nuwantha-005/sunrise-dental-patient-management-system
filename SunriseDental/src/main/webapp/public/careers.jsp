<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Careers — Sunrise Dental Clinic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

<!-- ══ NAVBAR ══════════════════════════════════════════════ -->
<%@ include file="navbar.jsp" %>

<!-- ══ PAGE HERO ════════════════════════════════════════════ -->
<div class="page-hero">
    <div class="container">
        <h1>Join Our Team</h1>
        <p>Be part of a passionate team dedicated to transforming smiles and changing lives every single day.</p>
        <div class="breadcrumb-nav">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span>›</span>
            <span style="color:white;">Careers</span>
        </div>
    </div>
</div>

<!-- ══ INTRO ════════════════════════════════════════════════ -->
<section class="section">
    <div class="container">
        <div class="careers-intro">
            <div>
                <span class="section-tag">Life at Sunrise Dental</span>
                <h2 class="section-title">Grow Your Career Where It Matters</h2>
                <p style="color:var(--text-muted); font-size:0.97rem; line-height:1.8; margin-bottom:18px;">
                    At Sunrise Dental, we believe our people are our greatest asset. We're not just a clinic — we're a family of dedicated professionals who genuinely care about each other and the patients we serve.
                </p>
                <p style="color:var(--text-muted); font-size:0.97rem; line-height:1.8; margin-bottom:28px;">
                    Whether you're a newly qualified dentist or a seasoned specialist, we offer the mentorship, state-of-the-art facilities and collaborative culture you need to thrive and reach your full potential.
                </p>
                <div style="display:flex; gap:14px; flex-wrap:wrap;">
                    <a href="#open-positions" class="btn btn-primary">View Open Positions</a>
                    <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline">Send Speculative CV</a>
                </div>
            </div>
            <div>
                <img src="${pageContext.request.contextPath}/images/4.jpg" alt="Our Team at Work"
                     style="width:100%; height:400px; object-fit:cover; border-radius:var(--radius-lg); box-shadow:var(--shadow-md);">
            </div>
        </div>
    </div>
</section>

<!-- ══ PERKS ═════════════════════════════════════════════════ -->
<section class="section-sm" style="background:var(--off-white);">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">Employee Benefits</span>
            <h2 class="section-title">Why Work With Us?</h2>
            <p class="section-subtitle">We invest in our team with competitive benefits and a culture of continuous learning.</p>
        </div>
        <div class="perks-grid">
            <div class="perk-card">
                <div class="perk-icon">💰</div>
                <h4>Competitive Salary</h4>
                <p>Market-leading pay with performance bonuses and annual increments.</p>
            </div>
            <div class="perk-card">
                <div class="perk-icon">📚</div>
                <h4>CPD &amp; Training</h4>
                <p>Fully funded Continuing Professional Development, conferences and overseas workshops.</p>
            </div>
            <div class="perk-card">
                <div class="perk-icon">🏥</div>
                <h4>Health Insurance</h4>
                <p>Comprehensive medical and dental coverage for you and your immediate family.</p>
            </div>
            <div class="perk-card">
                <div class="perk-icon">⏰</div>
                <h4>Flexible Hours</h4>
                <p>Shift flexibility and part-time options to support a healthy work-life balance.</p>
            </div>
            <div class="perk-card">
                <div class="perk-icon">🚀</div>
                <h4>Career Growth</h4>
                <p>Structured career pathways, mentorship programmes and promotion from within.</p>
            </div>
            <div class="perk-card">
                <div class="perk-icon">🎉</div>
                <h4>Team Culture</h4>
                <p>Regular team events, staff appreciation days and a genuinely supportive environment.</p>
            </div>
        </div>
    </div>
</section>

<!-- ══ OPEN POSITIONS ═══════════════════════════════════════ -->
<section class="section" id="open-positions">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">Now Hiring</span>
            <h2 class="section-title">Current Open Positions</h2>
            <p class="section-subtitle">Explore our current vacancies and find the role that's right for you.</p>
        </div>

        <% if ("applied".equals(request.getParameter("status"))) { %>
        <div style="background:#d1fae5; border:1px solid #6ee7b7; border-radius:8px; padding:14px 18px; margin:20px 0; color:#065f46; font-size:0.92rem; max-width:600px; margin:20px auto;">
            ✅ Thank you! Your application has been received. We'll be in touch shortly.
        </div>
        <% } %>

        <div class="jobs-list" style="margin-top:24px;">

            <div class="job-card">
                <div>
                    <div class="job-badge">Clinical</div>
                    <h3>General Dentist (BDS)</h3>
                    <div class="job-meta">
                        <span>📍 Colombo 03</span>
                        <span>⏱ Full-Time</span>
                        <span>💰 Rs. 150,000 – 220,000/month</span>
                        <span>📅 Posted: Aug 2025</span>
                    </div>
                    <p>We are looking for a passionate BDS-qualified General Dentist to join our expanding clinical team. You will handle routine and complex restorative work, preventive care and patient education in a modern, well-equipped environment.</p>
                </div>
                <div class="job-actions">
                    <a href="#apply-modal" class="btn btn-primary" onclick="openApply('General Dentist (BDS)')">Apply Now</a>
                </div>
            </div>

            <div class="job-card">
                <div>
                    <div class="job-badge">Clinical</div>
                    <h3>Dental Hygienist</h3>
                    <div class="job-meta">
                        <span>📍 Colombo 03</span>
                        <span>⏱ Full-Time / Part-Time</span>
                        <span>💰 Rs. 80,000 – 110,000/month</span>
                        <span>📅 Posted: Aug 2025</span>
                    </div>
                    <p>Certified Dental Hygienist needed to perform professional cleanings, periodontal assessments and patient education. Must hold a recognised Dental Hygiene diploma or equivalent qualification.</p>
                </div>
                <div class="job-actions">
                    <a href="#apply-modal" class="btn btn-primary" onclick="openApply('Dental Hygienist')">Apply Now</a>
                </div>
            </div>

            <div class="job-card">
                <div>
                    <div class="job-badge">Support</div>
                    <h3>Dental Receptionist</h3>
                    <div class="job-meta">
                        <span>📍 Colombo 03</span>
                        <span>⏱ Full-Time</span>
                        <span>💰 Rs. 55,000 – 75,000/month</span>
                        <span>📅 Posted: Jul 2025</span>
                    </div>
                    <p>Cheerful and organised Receptionist to manage appointments, greet patients and handle front-desk operations. Proficiency in English and Sinhala required. Prior healthcare experience is a plus.</p>
                </div>
                <div class="job-actions">
                    <a href="#apply-modal" class="btn btn-primary" onclick="openApply('Dental Receptionist')">Apply Now</a>
                </div>
            </div>

            <div class="job-card">
                <div>
                    <div class="job-badge">Technical</div>
                    <h3>Dental Laboratory Technician</h3>
                    <div class="job-meta">
                        <span>📍 Colombo 03</span>
                        <span>⏱ Full-Time</span>
                        <span>💰 Rs. 90,000 – 130,000/month</span>
                        <span>📅 Posted: Jul 2025</span>
                    </div>
                    <p>Experienced Lab Technician to fabricate crowns, bridges, dentures and other prosthetic devices. CAD/CAM knowledge is a distinct advantage. Minimum 3 years' experience required.</p>
                </div>
                <div class="job-actions">
                    <a href="#apply-modal" class="btn btn-primary" onclick="openApply('Dental Laboratory Technician')">Apply Now</a>
                </div>
            </div>

            <div class="job-card">
                <div>
                    <div class="job-badge">Specialist</div>
                    <h3>Consultant Orthodontist</h3>
                    <div class="job-meta">
                        <span>📍 Colombo 03</span>
                        <span>⏱ Part-Time / Sessional</span>
                        <span>💰 Negotiable</span>
                        <span>📅 Posted: Jun 2025</span>
                    </div>
                    <p>Seeking a qualified Orthodontist (MOrth or equivalent) for sessional clinics (2–3 days/week). Invisalign certification is preferred. Excellent opportunity for an experienced specialist seeking a prestigious private practice.</p>
                </div>
                <div class="job-actions">
                    <a href="#apply-modal" class="btn btn-primary" onclick="openApply('Consultant Orthodontist')">Apply Now</a>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- ══ APPLICATION MODAL ═════════════════════════════════════ -->
<div id="apply-modal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:2000; align-items:center; justify-content:center; padding:20px;">
    <div style="background:white; border-radius:var(--radius-lg); padding:40px; max-width:560px; width:100%; position:relative; max-height:90vh; overflow-y:auto; box-shadow:var(--shadow-lg);">
        <button onclick="closeApply()" style="position:absolute; top:16px; right:16px; background:none; border:none; font-size:1.5rem; cursor:pointer; color:var(--text-muted);">✕</button>
        <h3 style="font-size:1.3rem; font-weight:700; color:var(--primary-dark); margin-bottom:6px;">Apply for Position</h3>
        <p id="apply-role" style="color:var(--primary-light); font-weight:600; font-size:0.92rem; margin-bottom:24px;"></p>
        <form action="${pageContext.request.contextPath}/careers" method="post" enctype="multipart/form-data">
            <input type="hidden" id="apply-role-field" name="position">
            <div class="form-row">
                <div class="form-group">
                    <label>First Name *</label>
                    <input type="text" name="firstName" required placeholder="Sameera">
                </div>
                <div class="form-group">
                    <label>Last Name *</label>
                    <input type="text" name="lastName" required placeholder="Pathirana">
                </div>
            </div>
            <div class="form-group">
                <label>Email Address *</label>
                <input type="email" name="email" required placeholder="you@example.com">
            </div>
            <div class="form-group">
                <label>Phone Number *</label>
                <input type="tel" name="phone" required placeholder="+94 77 000 0000">
            </div>
            <div class="form-group">
                <label>Upload CV (PDF/DOC) *</label>
                <input type="file" name="cv" accept=".pdf,.doc,.docx" required style="padding:10px; background:var(--off-white);">
            </div>
            <div class="form-group">
                <label>Cover Letter / Message</label>
                <textarea name="coverLetter" placeholder="Tell us why you'd be a great fit at Sunrise Dental…" style="min-height:110px;"></textarea>
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%; justify-content:center;">
                Submit Application →
            </button>
        </form>
    </div>
</div>

<!-- ══ CTA ══════════════════════════════════════════════════ -->
<section class="cta-banner">
    <div class="container">
        <h2>Don't See a Role That Fits?</h2>
        <p>Send us your CV anyway — we're always looking for exceptional talent to join our growing team.</p>
        <div class="cta-actions">
            <a href="${pageContext.request.contextPath}/contact" class="btn btn-white btn-lg">Get in Touch</a>
            <a href="mailto:careers@sunrisedental.lk" class="btn btn-gold btn-lg">📧 Email Your CV</a>
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

<script>
function openApply(role) {
    document.getElementById('apply-role').textContent = role;
    document.getElementById('apply-role-field').value = role;
    const modal = document.getElementById('apply-modal');
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}
function closeApply() {
    document.getElementById('apply-modal').style.display = 'none';
    document.body.style.overflow = '';
}
document.getElementById('apply-modal').addEventListener('click', function(e) {
    if (e.target === this) closeApply();
});
</script>
</body>
</html>
