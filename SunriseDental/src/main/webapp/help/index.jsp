<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/layout-top.jsp" %>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 24px; flex-wrap:wrap; gap:12px;">
    <div>
        <h1 class="page-title" style="margin:0; display:flex; align-items:center; gap:10px;">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/>
                <line x1="9" y1="7" x2="15" y2="7"/>
                <line x1="9" y1="11" x2="15" y2="11"/>
            </svg>
            Sunrise Dental System User Guide &amp; Help Center
        </h1>
        <p style="color:var(--text-muted); margin-top:4px; font-size:0.94rem;">
            Comprehensive documentation, step-by-step workflow guides, and role permissions for staff members and administrators.
        </p>
    </div>
</div>

<style>
.help-grid-layout {
    display: grid;
    grid-template-columns: 270px 1fr;
    gap: 24px;
    align-items: start;
}

@media (max-width: 992px) {
    .help-grid-layout {
        grid-template-columns: 1fr;
    }
}

.help-sidebar-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.05);
    border: 1px solid #e2e8f0;
    position: sticky;
    top: 20px;
}

.help-nav-list {
    list-style: none;
    padding: 0;
    margin: 12px 0 0 0;
}

.help-nav-list li {
    margin-bottom: 6px;
}

.help-nav-list a {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 14px;
    color: #1e293b;
    text-decoration: none;
    font-size: 0.9rem;
    font-weight: 600;
    border-radius: 8px;
    transition: all 0.2s ease;
}

.help-nav-list a:hover {
    background: #f0f9ff;
    color: #0284c7;
    transform: translateX(3px);
}

.help-section-card {
    background: white;
    border-radius: 12px;
    padding: 28px;
    margin-bottom: 24px;
    box-shadow: 0 4px 16px rgba(0,0,0,0.05);
    border: 1px solid #e2e8f0;
    scroll-margin-top: 20px;
}

.help-section-card h3 {
    margin: 0 0 14px 0;
    color: #0f172a;
    font-size: 1.22rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 10px;
    border-bottom: 2px solid #e0f2fe;
    padding-bottom: 10px;
}

.step-list {
    list-style: none;
    padding: 0;
    margin: 16px 0;
}

.step-list li {
    display: flex;
    gap: 14px;
    margin-bottom: 14px;
    align-items: flex-start;
}

.step-number {
    background: #0284c7;
    color: white;
    font-weight: 700;
    font-size: 0.85rem;
    min-width: 26px;
    height: 26px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 2px;
}

.step-content {
    flex: 1;
    font-size: 0.93rem;
    line-height: 1.5;
    color: #334155;
}

.feature-badge {
    background: #f0f9ff;
    border: 1px solid #0284c7;
    color: #0369a1;
    font-weight: 700;
    font-size: 0.75rem;
    padding: 2px 8px;
    border-radius: 4px;
    text-transform: uppercase;
}

.perm-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 14px;
}

.perm-table th, .perm-table td {
    padding: 11px 14px;
    border: 1px solid #e2e8f0;
    font-size: 0.88rem;
}

.perm-table th {
    background: #f8fafc;
    font-weight: 700;
    color: #0f172a;
}
</style>

<div class="help-grid-layout">
    <!-- Help Topics Quick Nav -->
    <div class="help-sidebar-card">
        <h4 style="margin:0 0 10px 0; font-size:1.02rem; color:#0f172a; font-weight:700; display:flex; align-items:center; gap:8px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
            Help Topics
        </h4>
        <ul class="help-nav-list">
            <li>
                <a href="#getting-started">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                    Getting Started
                </a>
            </li>
            <li>
                <a href="#register-appointment">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    Booking Appointments
                </a>
            </li>
            <li>
                <a href="#treatments-pricing">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                    Treatments &amp; Pricing
                </a>
            </li>
            <li>
                <a href="#billing-receipts">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/><path d="M6 15h4M16 15h2"/></svg>
                    Billing &amp; Receipts
                </a>
            </li>
            <li>
                <a href="#booking-history">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><circle cx="12" cy="12" r="9"/><polyline points="12 7 12 12 15 15"/></svg>
                    History &amp; Rescheduling
                </a>
            </li>
            <li>
                <a href="#staff-receptionists">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    Staff &amp; Receptionists
                </a>
            </li>
            <li>
                <a href="#dentists-management">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="16" y1="11" x2="22" y2="11"/></svg>
                    Dentists &amp; Codes
                </a>
            </li>
            <li>
                <a href="#contact-messages">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                    Patient Messages
                </a>
            </li>
            <li>
                <a href="#patient-portal">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    Patient Portal &amp; Login
                </a>
            </li>
            <li>
                <a href="#role-permissions">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    Role Permissions
                </a>
            </li>
        </ul>
    </div>

    <!-- Main Help Documentation -->
    <div>
        <!-- Getting Started -->
        <div class="help-section-card" id="getting-started">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                1. Getting Started &amp; Dashboard Overview
            </h3>
            <p>The <strong>Sunrise Dental Patient Management System</strong> provides an end-to-end platform for clinic operations, patient registration, multi-procedure scheduling, automated billing, and email notifications.</p>
            
            <div style="background:#f8fafc; border-left:4px solid #0284c7; padding:14px 18px; border-radius:0 8px 8px 0; margin:16px 0;">
                <strong style="color:#0f172a; display:flex; align-items:center; gap:6px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                    Dashboard Features:
                </strong>
                <ul style="margin:8px 0 0 18px; font-size:0.9rem; color:#334155; line-height:1.6;">
                    <li><strong>Key Statistics Cards:</strong> Real-time counters for Today's Appointments, Registered Patients, Active Dentists, and Total Clinic Revenue.</li>
                    <li><strong>Active Appointments List:</strong> Displays today's scheduled consultations with instant action buttons:
                        <br>&bull; <code>Details &amp; Email</code>: View appointment summary and confirmation email log.
                        <br>&bull; <code>Complete &amp; Bill</code>: Marks procedure as completed and opens billing generator.
                        <br>&bull; <code>Edit</code>: Reschedule appointment date, time, dentist, or procedure.
                        <br>&bull; <code>Delete</code>: Permanently remove booking record (Admin only).
                    </li>
                </ul>
            </div>
        </div>

        <!-- Booking Appointments -->
        <div class="help-section-card" id="register-appointment">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                2. Registering New Appointments
            </h3>
            <p>Navigate to <strong>Appointments &gt; Register New Appointment</strong> to schedule consultations or treatments for existing or new patients.</p>

            <ul class="step-list">
                <li>
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <strong>Patient Search &amp; Auto-fill:</strong> Type the patient's contact number or name, or click <strong>Search Patients</strong> to quickly auto-fill details for registered clinic patients.
                    </div>
                </li>
                <li>
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <strong>Select Dentist:</strong> Choose the preferred specialist doctor.
                    </div>
                </li>
                <li>
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <strong>Doctor-Aware Treatment Selection:</strong> The treatments dropdown automatically filters in real-time to show <strong>only the procedures assigned to that specific doctor</strong> along with their configured prices.
                    </div>
                </li>
                <li>
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <strong>Doctor Schedule Availability Validation:</strong> Selecting a date automatically verifies the chosen day of the week (e.g. Monday) against the doctor's configured working days. If the doctor is not available on that day, a live warning is shown and the server blocks invalid bookings.
                    </div>
                </li>
                <li>
                    <div class="step-number">5</div>
                    <div class="step-content">
                        <strong>Multi-Procedure Booking:</strong> Click <strong>+ Add Treatment</strong> to select multiple treatment procedures performed during the same visit (e.g. <em>Root Canal Therapy</em> + <em>Teeth Whitening</em>).
                    </div>
                </li>
                <li>
                    <div class="step-number">6</div>
                    <div class="step-content">
                        <strong>Auto-Generated Credentials &amp; Confirmation Email:</strong> Upon clicking <strong>Save Appointment and Send Email</strong>, an auto-generated 8-character password and unique Patient ID (<code>PAT-001</code>) are created and sent in an HTML confirmation email.
                    </div>
                </li>
            </ul>
        </div>

        <!-- Treatments & Pricing -->
        <div class="help-section-card" id="treatments-pricing">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                3. Managing Treatments &amp; Doctor Working Days
            </h3>
            <p><span class="feature-badge">Admin Feature</span> Navigate to <strong>Treatments</strong> from the sidebar menu to configure service offerings, doctor pricing, and working schedules.</p>

            <div style="background:#ecfdf5; border:1px solid #10b981; padding:14px 18px; border-radius:8px; margin:16px 0; color:#065f46; font-size:0.9rem;">
                <strong style="display:flex; align-items:center; gap:6px; color:#047857;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#047857" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                    Doctor-Specific Treatment Assignment &amp; Available Days:
                </strong>
                <p style="margin:4px 0 0 0;">Each dentist has specific treatments assigned to them along with doctor-specific prices and available schedule days (e.g. Mon, Wed, Fri). The appointment calendar checks these schedule days live to prevent bookings on doctor off-days.</p>
            </div>

            <ol style="margin-left:20px; font-size:0.92rem; line-height:1.7; color:#334155;">
                <li>Click <strong>+ Add New Treatment</strong>.</li>
                <li>Select the assigned doctor, enter procedure name, set standard fee in LKR (Rs.), and check available working days (Mon–Sun).</li>
                <li>Use the <strong>Filter by Dentist</strong> dropdown on the Treatments list page to inspect procedures and schedule days for specific doctors.</li>
            </ol>
        </div>

        <!-- Billing & Receipts -->
        <div class="help-section-card" id="billing-receipts">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/><path d="M6 15h4M16 15h2"/></svg>
                4. Automated Billing &amp; Printable Receipts
            </h3>
            <p>When an appointment is completed, the system seamlessly transitions from appointment management to bill generation.</p>

            <ul class="step-list">
                <li>
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <strong>Initiate Billing:</strong> Click the <strong>Complete (`✔`)</strong> action icon on any appointment in the Dashboard or Booking History.
                    </div>
                </li>
                <li>
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <strong>Auto-Populated Pricing:</strong> The bill breakdown auto-fills each procedure with the exact price configured in the database for that doctor.
                    </div>
                </li>
                <li>
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <strong>Real-time Grand Total Calculation:</strong> Adjust treatment fees, consultation fee, or clinical sundries as needed — the total updates automatically.
                    </div>
                </li>
                <li>
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <strong>Save &amp; Complete:</strong> Click <strong>Save Bill and Open Official Printable Receipt</strong>. The invoice is generated, the appointment status changes to <code>Completed</code>, and the record is archived into <strong>Booking History</strong>.
                    </div>
                </li>
                <li>
                    <div class="step-number">5</div>
                    <div class="step-content">
                        <strong>Print Official Receipt:</strong> Click <strong>Print Official Receipt</strong> on the invoice page for a 1-page A4 dental receipt featuring Ministry of Health certification and clinic branding.
                    </div>
                </li>
            </ul>
        </div>

        <!-- Booking History -->
        <div class="help-section-card" id="booking-history">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><circle cx="12" cy="12" r="9"/><polyline points="12 7 12 12 15 15"/></svg>
                5. Booking History &amp; Rescheduling
            </h3>
            <p>Access <strong>Appointments &gt; Booking History</strong> to review past treatment records, filter appointments, or modify scheduled visits.</p>

            <ul style="margin-left:20px; font-size:0.92rem; line-height:1.7; color:#334155;">
                <li><strong>Search &amp; Filter:</strong> Filter by keyword (Appointment No, Patient Name, Phone, Email, Procedure), Status (<code>Completed</code>, <code>Confirmed</code>, <code>Pending</code>, <code>Cancelled</code>), or Dentist.</li>
                <li><strong>Rescheduling:</strong> Click <strong>Edit</strong> to alter date, time, assigned doctor, or procedures. The system automatically performs overlap checks to prevent doctor double-booking.</li>
                <li><strong>Deletion (Admin Only):</strong> Administrators can click <strong>Delete</strong> to permanently erase booking records and associated invoices.</li>
            </ul>
        </div>

        <!-- Staff & Receptionists -->
        <div class="help-section-card" id="staff-receptionists">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                6. Staff &amp; Receptionist Account Management
            </h3>
            <p><span class="feature-badge">Admin Feature</span> Navigate to <strong>Receptionists</strong> from the sidebar menu.</p>
            <p style="font-size:0.92rem; color:#334155;">Administrators can create login accounts for clinic receptionists with custom usernames, secure SHA-256 hashed passwords, email addresses, and contact numbers. Receptionists can handle appointments, patient lookup, and bill generation while administrative actions (adding dentists/receptionists, deleting records) remain restricted to Admins.</p>
        </div>

        <!-- Dentists Management -->
        <div class="help-section-card" id="dentists-management">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="16" y1="11" x2="22" y2="11"/></svg>
                7. Dentists &amp; Auto-Assigned Dentist IDs
            </h3>
            <p>Navigate to <strong>Dentists</strong> from the sidebar menu to manage doctor profiles.</p>
            <ul style="margin-left:20px; font-size:0.92rem; line-height:1.7; color:#334155;">
                <li><strong>Auto-Assigned Dentist ID:</strong> Every registered dentist is automatically assigned a unique Dentist ID (e.g. <code>DOC-001</code>, <code>DOC-002</code>).</li>
                <li><strong>Specialization &amp; Contact:</strong> Configure medical specialization (e.g. <em>Oral &amp; Maxillofacial</em>, <em>Orthodontics</em>, <em>Cosmetic Dentistry</em>) and contact details.</li>
            </ul>
        </div>

        <!-- Patient Messages -->
        <div class="help-section-card" id="contact-messages">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                8. Patient Inquiries &amp; Contact Messages
            </h3>
            <p>Navigate to <strong>Contact Messages</strong> from the sidebar menu to view patient inquiries sent via the public clinic website.</p>
            <p style="font-size:0.92rem; color:#334155;">Review message sender name, contact phone number, subject, message body, submission timestamp, send direct email replies, and permanently delete messages (Admin only).</p>
        </div>

        <!-- Patient Portal & Login -->
        <div class="help-section-card" id="patient-portal">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                9. Patient Portal, Unique Patient IDs &amp; Cookies
            </h3>
            <p>Patients have access to a dedicated online <strong>Patient Portal (`/patient-login`)</strong> where they can view their appointment history, personal contact profile, and printable billing statements.</p>

            <ul style="margin-left:20px; font-size:0.92rem; line-height:1.7; color:#334155;">
                <li><strong>Auto-Assigned Unique Patient ID:</strong> Every patient is automatically assigned a unique code (e.g. <code>PAT-001</code>, <code>PAT-002</code>) upon registration or booking.</li>
                <li><strong>Auto-Generated Portal Credentials:</strong> An 8-character password is generated for each booking, securely hashed with SHA-256 in the database, and sent in the appointment confirmation email.</li>
                <li><strong>Flexible Portal Login:</strong> Patients can log in using either their <strong>Patient ID</strong> (e.g. <code>PAT-001</code>) or <strong>Appointment ID</strong> (e.g. <code>APT-001</code>) and their generated password.</li>
                <li><strong>"Remember Me" Cookie:</strong> Patients can check <em>"Remember my Patient ID on this browser"</em> to store a 30-day persistent cookie that auto pre-fills their login ID on future visits.</li>
            </ul>
        </div>

        <!-- Role Permissions Matrix -->
        <div class="help-section-card" id="role-permissions">
            <h3>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                10. Role Permissions Matrix
            </h3>
            <p>The system enforces strict role-based access control (RBAC) to safeguard clinic data:</p>

            <table class="perm-table">
                <thead>
                    <tr>
                        <th>System Feature / Action</th>
                        <th style="text-align:center;">
                            <span style="display:inline-flex; align-items:center; gap:6px; color:#0f172a;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0f172a" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                Administrator
                            </span>
                        </th>
                        <th style="text-align:center;">
                            <span style="display:inline-flex; align-items:center; gap:6px; color:#0f172a;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0f172a" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                Receptionist
                            </span>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>View Dashboard &amp; Summary Counters</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Register New Appointments &amp; Multi-Treatments</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Generate Bills &amp; Print Official Receipts</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Manage Patient Records (Add / Edit)</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full Access</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Delete Patient Records</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Allowed</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#64748b; font-weight:600; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Restricted</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Manage Treatments &amp; Doctor Pricing</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full (Add/Edit/Delete)</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#334155; font-weight:600; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#334155" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg> View Only</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Manage Dentist Profiles</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full (Add/Edit/Delete)</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#334155; font-weight:600; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#334155" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg> View Only</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Manage Receptionist User Accounts</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Full (Add/Edit/Delete)</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#64748b; font-weight:600; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Restricted</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Delete Booking History Records</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Allowed</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#64748b; font-weight:600; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Restricted</span>
                        </td>
                    </tr>
                    <tr>
                        <td>Delete Contact Messages</td>
                        <td style="text-align:center;">
                            <span style="color:#0284c7; font-weight:700; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg> Allowed</span>
                        </td>
                        <td style="text-align:center;">
                            <span style="color:#64748b; font-weight:600; display:inline-flex; align-items:center; gap:4px;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg> Restricted</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
