<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Bill, com.sunrisedental.model.Appointment, java.text.SimpleDateFormat" %>
<%
    Bill bill = (Bill) request.getAttribute("bill");
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    String patientName = (String) request.getAttribute("patientName");
    String patientCode = (String) request.getAttribute("patientCode");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    String formattedDate = (bill != null && bill.getCreatedAt() != null)
            ? sdf.format(bill.getCreatedAt())
            : new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Receipt - Sunrise Dental Clinic</title>
    <style>
        @page { size: A4 portrait; margin: 8mm 10mm; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            background: #f0f4f8;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #1e293b;
            min-height: 100vh;
            padding: 30px 16px;
        }

        /* Portal nav bar */
        .portal-navbar {
            background: #ffffff;
            border-bottom: 1px solid #e2e8f0;
            padding: 12px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: -30px -16px 28px -16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .portal-brand { display: flex; align-items: center; gap: 10px; font-weight: 700; font-size: 1.05rem; color: #0f172a; text-decoration: none; }
        .portal-brand img { height: 32px; }
        .nav-actions { display: flex; align-items: center; gap: 10px; }
        .back-btn { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; font-weight: 600; padding: 7px 14px; border-radius: 6px; text-decoration: none; font-size: 0.85rem; display: flex; align-items: center; gap: 6px; }
        .back-btn:hover { background: #e2e8f0; }
        .print-btn { background: #0284c7; color: #ffffff; border: none; font-weight: 600; padding: 7px 16px; border-radius: 6px; cursor: pointer; font-size: 0.85rem; display: flex; align-items: center; gap: 6px; }
        .print-btn:hover { background: #0369a1; }

        @media print {
            .portal-navbar { display: none; }
            body { background: #fff; padding: 0; }
            .invoice-wrapper { box-shadow: none; border: none; }
        }

        /* Invoice */
        .invoice-wrapper {
            max-width: 780px;
            margin: 0 auto;
            background: #ffffff;
            padding: 32px 38px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #e2e8f0;
        }

        /* Header */
        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            padding-bottom: 16px;
            border-bottom: 2.5px solid #0284c7;
            margin-bottom: 18px;
        }
        .clinic-brand { }
        .clinic-brand img { height: 50px; margin-bottom: 8px; }
        .clinic-brand h1 { font-size: 1.3rem; font-weight: 800; color: #0f172a; margin: 0 0 3px 0; }
        .clinic-brand p { color: #64748b; font-size: 0.82rem; margin: 1px 0; }
        .invoice-meta { text-align: right; }
        .invoice-meta .receipt-label { font-size: 1.5rem; font-weight: 800; color: #0284c7; letter-spacing: -0.5px; }
        .invoice-meta .bill-no { font-size: 1.1rem; font-weight: 700; color: #0f172a; font-family: monospace; margin: 4px 0; }
        .invoice-meta .date-label { font-size: 0.82rem; color: #64748b; }

        /* Patient Portal notice */
        .portal-notice {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 8px;
            padding: 10px 16px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.85rem;
            color: #1e40af;
        }

        /* Two-column info */
        .info-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
            margin-bottom: 20px;
        }
        .info-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 14px 16px;
        }
        .info-box .box-title {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #64748b;
            margin-bottom: 8px;
        }
        .info-box .val { font-size: 0.9rem; color: #334155; margin: 3px 0; }
        .info-box .val strong { color: #0f172a; }
        .pid-badge {
            display: inline-block;
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
            border-radius: 6px;
            padding: 2px 9px;
            font-size: 0.8rem;
            font-weight: 700;
            font-family: monospace;
        }

        /* Billing table */
        .bill-table { width: 100%; border-collapse: collapse; margin-bottom: 18px; font-size: 0.9rem; }
        .bill-table thead tr { background: #1a5276; color: #ffffff; }
        .bill-table thead th { padding: 10px 14px; font-weight: 600; font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .bill-table tbody td { padding: 11px 14px; border-bottom: 1px solid #f1f5f9; color: #334155; }
        .bill-table tbody tr:last-child td { border-bottom: none; }
        .bill-table .amount { text-align: right; font-weight: 600; }

        /* Totals */
        .totals-section { display: flex; justify-content: flex-end; margin-bottom: 22px; }
        .totals-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 14px 20px;
            min-width: 280px;
        }
        .total-row { display: flex; justify-content: space-between; align-items: center; padding: 5px 0; font-size: 0.9rem; color: #475569; }
        .total-row.grand-total {
            border-top: 2px solid #0284c7;
            margin-top: 8px;
            padding-top: 10px;
            font-size: 1.1rem;
            font-weight: 800;
            color: #0f172a;
        }
        .total-row.grand-total .amt { color: #0284c7; }

        /* Footer */
        .receipt-footer {
            text-align: center;
            color: #94a3b8;
            font-size: 0.8rem;
            border-top: 1px solid #f1f5f9;
            padding-top: 14px;
            margin-top: 8px;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.78rem;
            font-weight: 700;
        }
        .status-completed { background: #dcfce7; color: #166534; }
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-confirmed { background: #e0f2fe; color: #0369a1; }
    </style>
</head>
<body>

    <!-- Patient Portal Nav Bar -->
    <nav class="portal-navbar">
        <a href="${pageContext.request.contextPath}/patient-dashboard" class="portal-brand">
            <img src="${pageContext.request.contextPath}/images/sunrise-logo.png" alt="Sunrise Dental">
            <span>Sunrise Dental Patient Portal</span>
        </a>
        <div class="nav-actions">
            <a href="${pageContext.request.contextPath}/patient-dashboard" class="back-btn">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
                Back to Dashboard
            </a>
            <button onclick="window.print()" class="print-btn">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                Print / Save PDF
            </button>
        </div>
    </nav>

    <div class="invoice-wrapper">
        <!-- Invoice Header -->
        <div class="invoice-header">
            <div class="clinic-brand">
                <img src="${pageContext.request.contextPath}/images/sunrise-logo.png" alt="Sunrise Dental">
                <h1>Sunrise Dental Clinic</h1>
                <p>123 Dental Avenue, Colombo 03, Sri Lanka</p>
                <p>Tel: +94 11 234 5678 &nbsp;|&nbsp; info@sunrisedental.lk</p>
            </div>
            <div class="invoice-meta">
                <div class="receipt-label">RECEIPT</div>
                <div class="bill-no">
                    <% if (bill != null) { %><%= bill.getBillNo() %><% } else { %>—<% } %>
                </div>
                <div class="date-label">Issued: <%= formattedDate %></div>
            </div>
        </div>

        <!-- Patient Portal Notice -->
        <div class="portal-notice">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1e40af" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            <span>Viewed from <strong>Patient Portal</strong> &mdash; Patient ID: <span class="pid-badge"><%= patientCode != null ? patientCode : "—" %></span></span>
        </div>

        <!-- Patient & Appointment Info -->
        <div class="info-row">
            <div class="info-box">
                <div class="box-title">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:4px;"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    Patient Details
                </div>
                <div class="val"><strong><%= patientName != null ? patientName : (appointment != null ? appointment.getPatientName() : "—") %></strong></div>
                <% if (appointment != null) { %>
                <div class="val"><%= appointment.getPatientContact() != null ? appointment.getPatientContact() : "" %></div>
                <div class="val"><%= appointment.getPatientEmail() != null ? appointment.getPatientEmail() : "" %></div>
                <% } %>
                <div class="val" style="margin-top:5px;"><span class="pid-badge"><%= patientCode != null ? patientCode : "—" %></span></div>
            </div>
            <div class="info-box">
                <div class="box-title">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle;margin-right:4px;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    Appointment Details
                </div>
                <% if (appointment != null) { %>
                <div class="val"><strong>Appt No:</strong> <%= appointment.getAppointmentNo() %></div>
                <div class="val"><strong>Date:</strong> <%= appointment.getAppointmentDate() %></div>
                <div class="val"><strong>Time:</strong> <%= appointment.getAppointmentTime() %></div>
                <div class="val"><strong>Dentist:</strong> Dr. <%= appointment.getDentistName() != null ? appointment.getDentistName() : "—" %></div>
                <div class="val" style="margin-top:5px;">
                    <span class="status-badge status-<%= appointment.getStatus() != null ? appointment.getStatus().toLowerCase() : "pending" %>">
                        <%= appointment.getStatus() != null ? appointment.getStatus() : "Pending" %>
                    </span>
                </div>
                <% } else { %>
                <div class="val">Appointment information unavailable.</div>
                <% } %>
            </div>
        </div>

        <!-- Billing Table -->
        <table class="bill-table">
            <thead>
                <tr>
                    <th style="width:50%;">Description</th>
                    <th style="text-align:right;">Amount (Rs.)</th>
                </tr>
            </thead>
            <tbody>
                <% if (bill != null) { %>
                <tr>
                    <td>
                        <strong>Treatment Charges</strong>
                        <div style="font-size:0.81rem; color:#64748b; margin-top:2px;">
                            <%= appointment != null && appointment.getTreatmentType() != null ? appointment.getTreatmentType() : "Dental Procedure" %>
                        </div>
                    </td>
                    <td class="amount">Rs. <%= String.format("%,.2f", bill.getTreatmentAmount()) %></td>
                </tr>
                <tr>
                    <td><strong>Consultation Fee</strong></td>
                    <td class="amount">Rs. <%= String.format("%,.2f", bill.getConsultationFee()) %></td>
                </tr>
                <% if (bill.getOtherCharges() != null && bill.getOtherCharges().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                <tr>
                    <td><strong>Other Charges</strong></td>
                    <td class="amount">Rs. <%= String.format("%,.2f", bill.getOtherCharges()) %></td>
                </tr>
                <% } %>
                <% } else { %>
                <tr>
                    <td colspan="2" style="text-align:center; color:#64748b; padding: 24px 14px;">
                        No billing statement has been issued for this appointment yet.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <!-- Totals -->
        <% if (bill != null) { %>
        <div class="totals-section">
            <div class="totals-box">
                <div class="total-row">
                    <span>Treatment Charges</span>
                    <span>Rs. <%= String.format("%,.2f", bill.getTreatmentAmount()) %></span>
                </div>
                <div class="total-row">
                    <span>Consultation Fee</span>
                    <span>Rs. <%= String.format("%,.2f", bill.getConsultationFee()) %></span>
                </div>
                <% if (bill.getOtherCharges() != null && bill.getOtherCharges().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                <div class="total-row">
                    <span>Other Charges</span>
                    <span>Rs. <%= String.format("%,.2f", bill.getOtherCharges()) %></span>
                </div>
                <% } %>
                <div class="total-row grand-total">
                    <span>Total Amount</span>
                    <span class="amt">Rs. <%= String.format("%,.2f", bill.getTotalAmount()) %></span>
                </div>
            </div>
        </div>
        <% } %>

        <!-- Footer -->
        <div class="receipt-footer">
            <p>Thank you for choosing <strong>Sunrise Dental Clinic</strong>. Please retain this receipt for your records.</p>
            <p style="margin-top:4px;">For billing enquiries call +94 11 234 5678 or email billing@sunrisedental.lk</p>
        </div>
    </div>

</body>
</html>
