<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic — Your Smile, Our Mission</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

<!-- ══ NAVBAR ══════════════════════════════════════════════ -->
<%@ include file="navbar.jsp" %>

<!-- ══ HERO ════════════════════════════════════════════════ -->
<section class="hero">
    <div class="container hero-inner">
        <div class="hero-content">
            <h1 class="hero-title">
                Your Perfect Smile<br>Starts <em>Right Here</em>
            </h1>
            <p class="hero-desc">
                World-class dental care with cutting-edge technology and a compassionate team dedicated to keeping your smile healthy and beautiful for life.
            </p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-white btn-lg">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    Book Appointment
                </a>
                <a href="${pageContext.request.contextPath}/about" class="btn btn-outline" style="border-color:rgba(255,255,255,0.5);color:white;">
                    Learn About Us
                </a>
            </div>
            <div class="hero-stats">
                <div class="hero-stat">
                    <strong>15+</strong>
                    <span>Years Experience</span>
                </div>
                <div class="hero-stat">
                    <strong>5,000+</strong>
                    <span>Happy Patients</span>
                </div>
                <div class="hero-stat">
                    <strong>8</strong>
                    <span>Expert Dentists</span>
                </div>
                <div class="hero-stat">
                    <strong>98%</strong>
                    <span>Satisfaction Rate</span>
                </div>
            </div>
        </div>
        <div class="hero-image-wrap">
            <img src="${pageContext.request.contextPath}/images/1.jpg" alt="Dental Treatment" class="hero-image-main">
        </div>
    </div>
</section>

<!-- ══ SERVICES ════════════════════════════════════════════ -->
<section class="section services" id="services">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">What We Offer</span>
            <h2 class="section-title">Comprehensive Dental Services</h2>
            <p class="section-subtitle">
                From routine check-ups to advanced cosmetic procedures, we offer everything your smile needs under one roof.
            </p>
        </div>
        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                </div>
                <h3>General Dentistry</h3>
                <p>Regular cleanings, fillings, extractions and preventive care to maintain your oral health and catch problems early.</p>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                </div>
                <h3>Cosmetic Dentistry</h3>
                <p>Teeth whitening, veneers, bonding and smile makeovers to give you the confident, radiant smile you deserve.</p>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><polyline points="9 12 11 14 15 10"/></svg>
                </div>
                <h3>Dental Implants</h3>
                <p>Permanent tooth replacement solutions with titanium implants that look, feel and function just like natural teeth.</p>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="4" y1="21" x2="4" y2="14"/><line x1="4" y1="10" x2="4" y2="3"/><line x1="12" y1="21" x2="12" y2="12"/><line x1="12" y1="8" x2="12" y2="3"/><line x1="20" y1="21" x2="20" y2="16"/><line x1="20" y1="12" x2="20" y2="3"/><line x1="1" y1="14" x2="7" y2="14"/><line x1="9" y1="8" x2="15" y2="8"/><line x1="17" y1="16" x2="23" y2="16"/></svg>
                </div>
                <h3>Orthodontics</h3>
                <p>Braces, clear aligners and retainers to straighten teeth and correct bite issues for patients of all ages.</p>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                </div>
                <h3>Root Canal Therapy</h3>
                <p>Pain-free root canal treatments using modern rotary techniques to save infected teeth and relieve discomfort.</p>
            </div>
            <div class="service-card">
                <div class="service-icon">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
                </div>
                <h3>Paediatric Dentistry</h3>
                <p>Child-friendly dental care in a warm, welcoming environment to build healthy dental habits from an early age.</p>
            </div>
        </div>
    </div>
</section>

<!-- ══ WHY US ═══════════════════════════════════════════════ -->
<section class="section">
    <div class="container">
        <div class="why-us-inner">
            <div class="why-image-stack">
                <img src="${pageContext.request.contextPath}/images/3.jpg" alt="Our Clinic" class="why-img-main">
                <img src="${pageContext.request.contextPath}/images/4.jpg" alt="Our Team" class="why-img-float">
            </div>
            <div>
                <span class="section-tag">Why Choose Us</span>
                <h2 class="section-title">A Clinic Built Around Your Comfort</h2>
                <p class="section-subtitle">
                    We combine medical excellence with a patient-first approach to make every visit comfortable, transparent and effective.
                </p>
                <div class="why-points">
                    <div class="why-point">
                        <div class="why-point-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg>
                        </div>
                        <div>
                            <h4>Award-Winning Care</h4>
                            <p>Recognised by the Sri Lanka Dental Association for clinical excellence and patient safety standards.</p>
                        </div>
                    </div>
                    <div class="why-point">
                        <div class="why-point-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                        </div>
                        <div>
                            <h4>Latest Technology</h4>
                            <p>Digital X-rays, 3D scanning and painless laser treatments ensure accurate diagnosis and faster healing.</p>
                        </div>
                    </div>
                    <div class="why-point">
                        <div class="why-point-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                        </div>
                        <div>
                            <h4>Sterilised &amp; Safe</h4>
                            <p>Strict sterilisation protocols and single-use instruments guarantee your safety at every appointment.</p>
                        </div>
                    </div>
                    <div class="why-point">
                        <div class="why-point-icon">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/><path d="M6 15h4M16 15h2"/></svg>
                        </div>
                        <div>
                            <h4>Transparent Pricing</h4>
                            <p>No hidden fees. We provide full cost estimates before any procedure so you can plan with confidence.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══ TEAM ═════════════════════════════════════════════════ -->
<section class="section team" id="doctors">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">Our Experts</span>
            <h2 class="section-title">Meet Our Specialist Dentists</h2>
            <p class="section-subtitle">
                Our highly qualified team brings decades of combined experience across all major dental specialisations.
            </p>
        </div>
        <div class="team-grid">
            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/doctor-1.png" alt="Dr. Kamal Perera">
                <div class="team-card-body">
                    <h3>Dr. Kamal Perera</h3>
                    <div class="role">Oral &amp; Maxillofacial Surgeon</div>
                    <p>BDS (Colombo), MDS Oral Surgery. Over 12 years of experience in complex extractions and jaw surgery.</p>
                </div>
            </div>
            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/doctor-2.png" alt="Dr. Nimali Silva">
                <div class="team-card-body">
                    <h3>Dr. Nimali Silva</h3>
                    <div class="role">Cosmetic Dentist</div>
                    <p>BDS (Peradeniya), Dip. Aesthetic Dentistry (UK). Specialist in smile design, veneers and whitening.</p>
                </div>
            </div>
            <div class="team-card">
                <img src="${pageContext.request.contextPath}/images/doctor-3.png" alt="Dr. Ruwan Jayasuriya">
                <div class="team-card-body">
                    <h3>Dr. Ruwan Jayasuriya</h3>
                    <div class="role">Orthodontist</div>
                    <p>BDS, MOrth (Edinburgh). Expert in Invisalign, braces and corrective bite treatments for all ages.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══ TESTIMONIALS ═════════════════════════════════════════ -->
<section class="section">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">Patient Stories</span>
            <h2 class="section-title">What Our Patients Say</h2>
            <p class="section-subtitle">Real experiences from real people who trust Sunrise Dental with their smiles.</p>
        </div>
        <div class="testimonials-grid">
            <div class="testimonial-card">
                <div class="stars" style="color:#0284c7; letter-spacing:2px; font-size:1.1rem;">★★★★★</div>
                <p>"Absolutely amazing experience. The team made me feel so comfortable and my teeth have never looked better after the whitening treatment!"</p>
                <div class="testimonial-author">
                    <div class="author-avatar" style="background:#0284c7; color:white; font-weight:700;">SP</div>
                    <div class="author-info">
                        <strong>Sameera Pathirana</strong>
                        <span>Colombo — Teeth Whitening</span>
                    </div>
                </div>
            </div>
            <div class="testimonial-card">
                <div class="stars" style="color:#0284c7; letter-spacing:2px; font-size:1.1rem;">★★★★★</div>
                <p>"Dr. Ruwan fixed my crowded teeth with Invisalign in just 14 months. The results are incredible — I smile with confidence now!"</p>
                <div class="testimonial-author">
                    <div class="author-avatar" style="background:#0284c7; color:white; font-weight:700;">AK</div>
                    <div class="author-info">
                        <strong>Amali Kumari</strong>
                        <span>Kandy — Invisalign</span>
                    </div>
                </div>
            </div>
            <div class="testimonial-card">
                <div class="stars" style="color:#0284c7; letter-spacing:2px; font-size:1.1rem;">★★★★★</div>
                <p>"I was terrified of dentists but the staff here were so patient and kind. My root canal was painless and I recovered in two days!"</p>
                <div class="testimonial-author">
                    <div class="author-avatar" style="background:#0284c7; color:white; font-weight:700;">RD</div>
                    <div class="author-info">
                        <strong>Roshan De Silva</strong>
                        <span>Galle — Root Canal</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ══ CTA ══════════════════════════════════════════════════ -->
<section class="cta-banner">
    <div class="container">
        <h2>Ready for a Healthier, Brighter Smile?</h2>
        <p>Book your consultation today and take the first step towards the smile you've always wanted.</p>
        <div class="cta-actions">
            <a href="${pageContext.request.contextPath}/contact" class="btn btn-white btn-lg">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                Book an Appointment
            </a>
            <a href="tel:+94112345678" class="btn btn-gold btn-lg" style="background:white; color:#0f172a; border:none; display:inline-flex; align-items:center; gap:8px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.62 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                Call Us Now
            </a>
        </div>
    </div>
</section>

<!-- ══ FOOTER ═══════════════════════════════════════════════ -->
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <img src="${pageContext.request.contextPath}/images/sunrise-logo.png" alt="Sunrise Dental">
                <p>Providing world-class dental care to the people of Sri Lanka since 2009. Your smile is our greatest reward.</p>
                <div class="footer-social" style="display:flex; gap:10px; margin-top:12px;">
                    <a href="#" class="social-btn" title="Facebook" style="display:inline-flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:50%; background:rgba(255,255,255,0.1); color:white;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                    </a>
                    <a href="#" class="social-btn" title="Instagram" style="display:inline-flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:50%; background:rgba(255,255,255,0.1); color:white;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/></svg>
                    </a>
                    <a href="#" class="social-btn" title="WhatsApp" style="display:inline-flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:50%; background:rgba(255,255,255,0.1); color:white;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/></svg>
                    </a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#services">Services</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#doctors">Our Doctors</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Our Services</h4>
                <ul>
                    <li><a href="#">General Dentistry</a></li>
                    <li><a href="#">Cosmetic Dentistry</a></li>
                    <li><a href="#">Dental Implants</a></li>
                    <li><a href="#">Orthodontics</a></li>
                    <li><a href="#">Root Canal Therapy</a></li>
                    <li><a href="#">Paediatric Dentistry</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Contact Us</h4>
                <div class="footer-contact-item">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.6)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    123 Galle Road, Colombo 03, Sri Lanka
                </div>
                <div class="footer-contact-item">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.6)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 13a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.62 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                    +94 11 234 5678
                </div>
                <div class="footer-contact-item">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.6)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                    info@sunrisedental.lk
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <span>© 2025 Sunrise Dental Clinic. All rights reserved.</span>
            <span>Privacy Policy &nbsp;|&nbsp; Terms of Service</span>
        </div>
    </div>
</footer>

<script>
function toggleMobileNav() {
    const links = document.querySelector('.nav-links');
    const cta = document.querySelector('.nav-cta');
    if (links.style.display === 'flex') {
        links.style.display = '';
        cta.style.display = '';
    } else {
        links.style.display = 'flex';
        links.style.flexDirection = 'column';
        links.style.position = 'fixed';
        links.style.top = '70px';
        links.style.left = '0';
        links.style.right = '0';
        links.style.background = '#fff';
        links.style.padding = '20px';
        links.style.boxShadow = '0 8px 24px rgba(0,0,0,0.1)';
        links.style.zIndex = '999';
    }
}
</script>

</body>
</html>
