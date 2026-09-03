<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us — Sunrise Dental Clinic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

<!-- ══ NAVBAR ══════════════════════════════════════════════ -->
<%@ include file="navbar.jsp" %>


<!-- ══ PAGE HERO ════════════════════════════════════════════ -->
<div class="page-hero">
    <div class="container">
        <h1>Contact Us</h1>
        <p>We'd love to hear from you. Book an appointment, ask a question or just say hello!</p>
        <div class="breadcrumb-nav">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <span>›</span>
            <span style="color:white;">Contact Us</span>
        </div>
    </div>
</div>

<!-- ══ CONTACT MAIN ════════════════════════════════════════ -->
<section class="section">
    <div class="container">
        <div class="contact-grid">

            <!-- Info card -->
            <div class="contact-info-card">
                <h3>Get in Touch</h3>
                <p>Our friendly team is here to help Mon–Sat. Don't hesitate to reach out through any channel below.</p>

                <div class="contact-detail">
                    <div class="contact-detail-icon">📍</div>
                    <div>
                        <strong>Visit Us</strong>
                        <span>123 Galle Road, Colombo 03<br>Sri Lanka</span>
                    </div>
                </div>
                <div class="contact-detail">
                    <div class="contact-detail-icon">📞</div>
                    <div>
                        <strong>Call Us</strong>
                        <span>+94 11 234 5678 (Main)<br>+94 77 890 1234 (WhatsApp)</span>
                    </div>
                </div>
                <div class="contact-detail">
                    <div class="contact-detail-icon">✉️</div>
                    <div>
                        <strong>Email Us</strong>
                        <span>info@sunrisedental.lk<br>appointments@sunrisedental.lk</span>
                    </div>
                </div>

                <div class="contact-hours">
                    <h4>⏰ Opening Hours</h4>
                    <div class="hours-row"><span>Monday – Friday</span><span>8:00 AM – 7:00 PM</span></div>
                    <div class="hours-row"><span>Saturday</span><span>9:00 AM – 5:00 PM</span></div>
                    <div class="hours-row"><span>Sunday</span><span>10:00 AM – 2:00 PM</span></div>
                    <div class="hours-row"><span>Public Holidays</span><span>Emergency only</span></div>
                </div>
            </div>

            <!-- Contact Form -->
            <div class="contact-form-card">
                <h3>Send Us a Message</h3>
                <p>Fill in the form below and we'll respond within one business day.</p>

                <% if ("success".equals(request.getParameter("status"))) { %>
                <div style="background:#d1fae5; border:1px solid #6ee7b7; border-radius:8px; padding:14px 18px; margin-bottom:20px; color:#065f46; font-size:0.92rem;">
                    ✅ Thank you! Your message has been received. We'll be in touch shortly.
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/contact" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="firstName">First Name *</label>
                            <input type="text" id="firstName" name="firstName" placeholder="Sameera" required>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name *</label>
                            <input type="text" id="lastName" name="lastName" placeholder="Pathirana" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email Address *</label>
                            <input type="email" id="email" name="email" placeholder="you@example.com" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" name="phone" placeholder="+94 77 000 0000">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="subject">Subject *</label>
                        <select id="subject" name="subject" required>
                            <option value="" disabled selected>Select a subject…</option>
                            <option>Book an Appointment</option>
                            <option>Treatment Enquiry</option>
                            <option>Pricing &amp; Insurance</option>
                            <option>Emergency Dental Care</option>
                            <option>Feedback &amp; Complaints</option>
                            <option>Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="message">Message *</label>
                        <textarea id="message" name="message" placeholder="Tell us how we can help you…" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg" style="width:100%; justify-content:center;">
                        Send Message &nbsp;→
                    </button>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- ══ MAP SECTION ══════════════════════════════════════════ -->
<section class="section-sm" style="background:var(--off-white);">
    <div class="container">
        <div class="text-center" style="margin-bottom:32px;">
            <span class="section-tag">Find Us</span>
            <h2 class="section-title">We're Easy to Find</h2>
        </div>
        <div class="map-placeholder">
            <div style="font-size:3rem;">🗺️</div>
            <strong style="color:var(--primary-dark);">Sunrise Dental Clinic</strong>
            <span>123 Galle Road, Colombo 03, Sri Lanka</span>
            <a href="https://maps.google.com" target="_blank" class="btn btn-primary btn-sm" style="margin-top:8px;">
                Open in Google Maps →
            </a>
        </div>
    </div>
</section>

<!-- ══ FAQ STRIP ════════════════════════════════════════════ -->
<section class="section">
    <div class="container">
        <div class="text-center">
            <span class="section-tag">Got Questions?</span>
            <h2 class="section-title">Frequently Asked Questions</h2>
        </div>
        <div style="max-width:780px; margin:0 auto; display:flex; flex-direction:column; gap:16px; margin-top:40px;">
            <details style="background:var(--white); border:1px solid var(--border); border-radius:var(--radius); padding:20px 24px; cursor:pointer;">
                <summary style="font-weight:700; color:var(--primary-dark); font-size:0.97rem; list-style:none; display:flex; justify-content:space-between; align-items:center;">
                    Do I need a referral to visit Sunrise Dental? <span>+</span>
                </summary>
                <p style="color:var(--text-muted); font-size:0.9rem; line-height:1.7; margin-top:12px;">No referral is required. You can book directly with any of our dentists through the contact form, by phone or by walk-in during opening hours.</p>
            </details>
            <details style="background:var(--white); border:1px solid var(--border); border-radius:var(--radius); padding:20px 24px; cursor:pointer;">
                <summary style="font-weight:700; color:var(--primary-dark); font-size:0.97rem; list-style:none; display:flex; justify-content:space-between; align-items:center;">
                    Do you accept insurance or offer payment plans? <span>+</span>
                </summary>
                <p style="color:var(--text-muted); font-size:0.9rem; line-height:1.7; margin-top:12px;">We work with most major health insurers in Sri Lanka and also offer interest-free payment plans for treatments over Rs. 20,000. Please call us for details.</p>
            </details>
            <details style="background:var(--white); border:1px solid var(--border); border-radius:var(--radius); padding:20px 24px; cursor:pointer;">
                <summary style="font-weight:700; color:var(--primary-dark); font-size:0.97rem; list-style:none; display:flex; justify-content:space-between; align-items:center;">
                    What should I do in a dental emergency? <span>+</span>
                </summary>
                <p style="color:var(--text-muted); font-size:0.9rem; line-height:1.7; margin-top:12px;">Call our emergency line at <strong>+94 77 890 1234</strong> anytime. We hold daily emergency slots and will see you as soon as possible, including on weekends and public holidays.</p>
            </details>
            <details style="background:var(--white); border:1px solid var(--border); border-radius:var(--radius); padding:20px 24px; cursor:pointer;">
                <summary style="font-weight:700; color:var(--primary-dark); font-size:0.97rem; list-style:none; display:flex; justify-content:space-between; align-items:center;">
                    How early should I arrive for my appointment? <span>+</span>
                </summary>
                <p style="color:var(--text-muted); font-size:0.9rem; line-height:1.7; margin-top:12px;">We recommend arriving 10 minutes early for first-time visits to complete your patient registration. For follow-ups, arriving at your scheduled time is perfectly fine.</p>
            </details>
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
