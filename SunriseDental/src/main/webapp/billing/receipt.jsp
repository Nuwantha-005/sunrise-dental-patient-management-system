<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Bill, com.sunrisedental.model.Appointment, java.text.SimpleDateFormat" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String formattedDate = (bill != null && bill.getCreatedAt() != null)
            ? sdf.format(bill.getCreatedAt())
            : new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date());
%>

<style>
/* Professional Compact Dental Invoice (Strictly 1 Page Fit) */
@page {
    size: A4 portrait;
    margin: 8mm 10mm;
}

.invoice-wrapper {
    max-width: 780px;
    margin: 0 auto;
    background: #ffffff;
    padding: 28px 34px;
    border-radius: 10px;
    box-shadow: 0 4px 18px rgba(0,0,0,0.06);
    border: 1px solid #e2e8f0;
    color: #1e293b;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.35;
}

.invoice-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding-bottom: 12px;
    border-bottom: 2px solid #0284c7;
    margin-bottom: 14px;
}

.clinic-branding h2 {
    font-size: 1.45rem;
    font-weight: 800;
    color: #0369a1;
    margin: 0 0 2px 0;
    letter-spacing: -0.3px;
    display: flex;
    align-items: center;
    gap: 6px;
}

.clinic-branding p {
    margin: 0;
    font-size: 0.82rem;
    color: #64748b;
}

.clinic-contact-info {
    text-align: right;
    font-size: 0.78rem;
    color: #475569;
    line-height: 1.4;
}

.invoice-title-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}

.invoice-title-bar h3 {
    margin: 0;
    font-size: 1.15rem;
    font-weight: 700;
    color: #0f172a;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.paid-badge-stamp {
    display: inline-block;
    padding: 4px 12px;
    font-size: 0.78rem;
    font-weight: 800;
    color: #16a34a;
    background: #f0fdf4;
    border: 1.5px solid #86efac;
    border-radius: 5px;
    letter-spacing: 0.5px;
}

.invoice-meta-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 16px;
    background: #f8fafc;
    padding: 12px 16px;
    border-radius: 6px;
    border: 1px solid #e2e8f0;
    margin-bottom: 14px;
}

.meta-block h4 {
    margin: 0 0 4px 0;
    font-size: 0.72rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #0284c7;
}

.meta-block .name {
    font-size: 0.95rem;
    font-weight: 700;
    color: #0f172a;
    margin-bottom: 2px;
}

.meta-block p {
    margin: 1px 0;
    font-size: 0.8rem;
    color: #475569;
}

.invoice-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 14px;
}

.invoice-table th {
    background: #0f172a;
    color: #ffffff;
    padding: 8px 10px;
    font-size: 0.76rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.invoice-table td {
    padding: 8px 10px;
    font-size: 0.83rem;
    border-bottom: 1px solid #e2e8f0;
}

.invoice-table tbody tr:nth-child(even) {
    background: #f8fafc;
}

.invoice-table .text-right {
    text-align: right;
}

.invoice-summary-section {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 16px;
    gap: 15px;
}

.invoice-notes {
    flex: 1;
    font-size: 0.74rem;
    color: #64748b;
    line-height: 1.45;
    background: #fdfdfd;
    padding: 8px 12px;
    border-left: 3px solid #0284c7;
    border-radius: 4px;
}

.invoice-totals-box {
    width: 250px;
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    padding: 8px 12px;
}

.totals-row {
    display: flex;
    justify-content: space-between;
    padding: 3px 0;
    font-size: 0.8rem;
    color: #475569;
}

.totals-row.grand-total {
    border-top: 1.5px solid #cbd5e1;
    margin-top: 3px;
    padding-top: 6px;
    font-size: 1rem;
    font-weight: 800;
    color: #0369a1;
}

.invoice-signatures {
    display: flex;
    justify-content: space-between;
    margin-top: 22px;
    padding-top: 10px;
}

.sig-box {
    text-align: center;
    width: 180px;
}

.sig-line {
    border-top: 1px solid #94a3b8;
    margin-bottom: 3px;
}

.sig-label {
    font-size: 0.72rem;
    font-weight: 600;
    color: #64748b;
    text-transform: uppercase;
}

.invoice-barcode-footer {
    margin-top: 14px;
    padding-top: 8px;
    border-top: 1px dashed #cbd5e1;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 0.7rem;
    color: #94a3b8;
}

.barcode-mockup {
    font-family: 'Courier New', Courier, monospace;
    font-size: 1.1rem;
    letter-spacing: 3px;
    color: #1e293b;
    font-weight: bold;
}

/* Print Optimization - Guaranteed 1 Page */
@media print {
    html, body {
        height: auto !important;
        margin: 0 !important;
        padding: 0 !important;
        font-size: 11px !important;
        background: #ffffff !important;
        color: #000000 !important;
    }
    .sidebar, .top-header, .page-title, .btn-group, .no-print, nav, aside {
        display: none !important;
    }
    .main-content, .page-body {
        margin: 0 !important;
        padding: 0 !important;
    }
    .card {
        border: none !important;
        box-shadow: none !important;
        padding: 0 !important;
        margin: 0 !important;
    }
    .invoice-wrapper {
        border: none !important;
        box-shadow: none !important;
        padding: 0 !important;
        margin: 0 auto !important;
        max-width: 100% !important;
        width: 100% !important;
        page-break-after: avoid !important;
        page-break-inside: avoid !important;
    }
    .invoice-header {
        border-bottom: 2px solid #000000 !important;
        padding-bottom: 8px !important;
        margin-bottom: 10px !important;
    }
    .invoice-table th {
        background: #1e293b !important;
        color: #ffffff !important;
        -webkit-print-color-adjust: exact !important;
        print-color-adjust: exact !important;
    }
    .paid-badge-stamp {
        border: 1.5px solid #16a34a !important;
        color: #16a34a !important;
        -webkit-print-color-adjust: exact !important;
        print-color-adjust: exact !important;
    }
}
</style>

<div class="no-print" style="margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;">
    <h1 class="page-title" style="margin:0;">Dental Bill and Payment Receipt</h1>
    <div style="display:flex; gap:10px;">
        <button class="btn btn-primary" onclick="window.print()" style="display:flex; align-items:center; gap:6px;">
            🖨️ Print Official Receipt
        </button>
        <a href="${pageContext.request.contextPath}/billing" class="btn btn-secondary">
            ← Billing List
        </a>
    </div>
</div>

<% if (bill != null) { %>
<div class="invoice-wrapper">
    <!-- Top Branding & Clinic Header -->
    <div class="invoice-header">
        <div class="clinic-branding">
            <h2>&#129463; Sunrise Dental Clinic</h2>
            <p>Advanced Oral Care and Cosmetic Dental Center</p>
            <p style="font-size:0.75rem; color:#0284c7; margin-top:2px;">Reg No: SLMC/DENT/2024-889 &bull; Ministry of Health Certified</p>
        </div>
        <div class="clinic-contact-info">
            <strong>Sunrise Dental Clinic (Pvt) Ltd</strong><br>
            No. 123, Galle Road, Colombo 03, Sri Lanka<br>
            📞 Tel: +94 11 234 5678 | Hotline: +94 77 123 4567<br>
            ✉️ Email: billing@sunrisedental.com<br>
            🌐 Web: www.sunrisedental.lk
        </div>
    </div>

    <!-- Title Bar -->
    <div class="invoice-title-bar">
        <div>
            <h3>Official Patient Invoice</h3>
            <span style="font-size:0.78rem; color:#64748b;">Tax Invoice / Payment Receipt</span>
        </div>
        <div class="paid-badge-stamp">
            ✓ PAID IN FULL
        </div>
    </div>

    <!-- Patient & Invoice Metadata -->
    <div class="invoice-meta-grid">
        <div class="meta-block">
            <h4>Billed To (Patient Information)</h4>
            <div class="name"><%= bill.getPatientName() != null ? bill.getPatientName() : (appointment != null ? appointment.getPatientName() : "Valued Patient") %></div>
            <p><strong>Contact:</strong> <%= appointment != null && appointment.getPatientContact() != null ? appointment.getPatientContact() : "—" %></p>
            <% if (appointment != null && appointment.getPatientEmail() != null && !appointment.getPatientEmail().isBlank()) { %>
                <p><strong>Email:</strong> <%= appointment.getPatientEmail() %></p>
            <% } %>
            <p><strong>Address:</strong> <%= appointment != null && appointment.getPatientAddress() != null && !appointment.getPatientAddress().isBlank() ? appointment.getPatientAddress() : "Colombo, Sri Lanka" %></p>
        </div>
        <div class="meta-block">
            <h4>Invoice and Appointment Details</h4>
            <p><strong>Invoice Number:</strong> <span style="color:#0369a1; font-weight:700;"><%= bill.getBillNo() %></span></p>
            <p><strong>Appointment Ref:</strong> <%= bill.getAppointmentNo() != null ? bill.getAppointmentNo() : (appointment != null ? appointment.getAppointmentNo() : "—") %></p>
            <p><strong>Issued Date:</strong> <%= formattedDate %></p>
            <p><strong>Attending Dentist:</strong> Dr. <%= bill.getDentistName() != null ? bill.getDentistName().replace("Dr. ", "") : (appointment != null ? appointment.getDentistName().replace("Dr. ", "") : "Specialist") %></p>
            <p><strong>Payment Method:</strong> Cash / Counter Settlement</p>
        </div>
    </div>

    <!-- Itemized Services Table -->
    <table class="invoice-table">
        <thead>
            <tr>
                <th style="width: 8%;">#</th>
                <th style="width: 52%;">Clinical Procedure / Description</th>
                <th style="width: 20%;" class="text-right">Category</th>
                <th style="width: 20%;" class="text-right">Amount (Rs.)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>01</td>
                <td>
                    <strong><%= bill.getTreatmentType() != null ? bill.getTreatmentType() : (appointment != null ? appointment.getTreatmentType() : "Dental Procedure") %></strong><br>
                    <small style="color:#64748b;">Primary clinical procedure performed by dental specialist</small>
                </td>
                <td class="text-right" style="color:#64748b;">Treatment</td>
                <td class="text-right" style="font-weight:600;"><%= String.format("%,.2f", bill.getTreatmentAmount()) %></td>
            </tr>
            <tr>
                <td>02</td>
                <td>
                    <strong>Specialist Dental Consultation and Clinical Diagnostics</strong><br>
                    <small style="color:#64748b;">Oral examination, treatment planning and doctor fee</small>
                </td>
                <td class="text-right" style="color:#64748b;">Consultation</td>
                <td class="text-right" style="font-weight:600;"><%= String.format("%,.2f", bill.getConsultationFee()) %></td>
            </tr>
            <tr>
                <td>03</td>
                <td>
                    <strong>Sterilization, Medical Sundries and Consumables</strong><br>
                    <small style="color:#64748b;">Hygienic disposables, clinical supplies and facility charges</small>
                </td>
                <td class="text-right" style="color:#64748b;">Clinical Sundries</td>
                <td class="text-right" style="font-weight:600;"><%= String.format("%,.2f", bill.getOtherCharges()) %></td>
            </tr>
        </tbody>
    </table>

    <!-- Financial Breakdown & Notes -->
    <div class="invoice-summary-section">
        <div class="invoice-notes">
            <strong>📌 Patient Care and Billing Notes:</strong><br>
            • Please retain this receipt for insurance claims and follow-up visits.<br>
            • Follow prescribed post-procedure medication and oral hygiene instructions.<br>
            • For emergency dental queries, contact our 24/7 hotline: <strong>+94 77 123 4567</strong>.
        </div>

        <div class="invoice-totals-box">
            <div class="totals-row">
                <span>Subtotal</span>
                <span>Rs. <%= String.format("%,.2f", bill.getTotalAmount()) %></span>
            </div>
            <div class="totals-row">
                <span>Discount (0%)</span>
                <span style="color:#16a34a;">Rs. 0.00</span>
            </div>
            <div class="totals-row grand-total">
                <span>Net Total</span>
                <span>Rs. <%= String.format("%,.2f", bill.getTotalAmount()) %></span>
            </div>
            <div class="totals-row" style="font-size:0.76rem; color:#16a34a; margin-top:2px;">
                <span>Amount Paid</span>
                <span>Rs. <%= String.format("%,.2f", bill.getTotalAmount()) %></span>
            </div>
            <div class="totals-row" style="font-size:0.76rem; color:#64748b;">
                <span>Balance Due</span>
                <span>Rs. 0.00</span>
            </div>
        </div>
    </div>

    <!-- Signatures Section -->
    <div class="invoice-signatures">
        <div class="sig-box">
            <div class="sig-line"></div>
            <div class="sig-label">Authorized Cashier / Reception</div>
            <small style="color:#94a3b8; font-size:0.7rem;">Sunrise Dental Clinic</small>
        </div>
        <div class="sig-box">
            <div class="sig-line"></div>
            <div class="sig-label">Attending Dental Surgeon</div>
            <small style="color:#94a3b8; font-size:0.7rem;">Dr. <%= bill.getDentistName() != null ? bill.getDentistName().replace("Dr. ", "") : "Specialist" %></small>
        </div>
    </div>

    <!-- Footer with Barcode -->
    <div class="invoice-barcode-footer">
        <div>
            <span>Verified Computer Generated Receipt &bull; <%= formattedDate %></span>
        </div>
        <div style="text-align:right;">
            <div class="barcode-mockup">||| | |||| || ||| |||| |</div>
            <span><%= bill.getBillNo() %></span>
        </div>
    </div>
</div>

<div class="no-print" style="margin-top: 20px; text-align: center;">
    <button class="btn btn-primary" onclick="window.print()" style="padding: 10px 28px; font-size: 1rem;">
        🖨️ Print Receipt / Save as PDF
    </button>
    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary" style="margin-left: 10px;">
        Dashboard
    </a>
</div>

<% } else { %>
<div class="card" style="text-align:center; padding:40px;">
    <h3>No bill record found for this appointment.</h3>
    <p style="color:var(--text-muted);">Please generate a bill first from the appointments or billing page.</p>
    <a href="${pageContext.request.contextPath}/billing" class="btn btn-primary" style="margin-top:15px;">Go to Billing</a>
</div>
<% } %>

<%@ include file="/includes/layout-bottom.jsp" %>
