<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.sunrisedental.model.Appointment" %>
<%@ page import="com.sunrisedental.model.Bill" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Sunrise Dental Clinic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #f8fafc; margin: 0; font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; color: #1e293b; }
        .portal-navbar { background: #ffffff; border-bottom: 1px solid #e2e8f0; padding: 14px 28px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .portal-brand { display: flex; align-items: center; gap: 12px; font-weight: 700; font-size: 1.15rem; color: #0f172a; text-decoration: none; }
        .portal-brand img { height: 36px; width: auto; }
        .portal-user-info { display: flex; align-items: center; gap: 16px; }
        .portal-user-badge { display: flex; align-items: center; gap: 8px; background: #f1f5f9; padding: 6px 14px; border-radius: 20px; font-size: 0.88rem; font-weight: 600; color: #334155; }
        .logout-btn { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; font-weight: 600; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-size: 0.85rem; transition: all 0.2s; }
        .logout-btn:hover { background: #fee2e2; color: #b91c1c; }
        
        .portal-container { max-width: 1100px; margin: 32px auto; padding: 0 20px; }
        
        .welcome-hero { background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%); color: #ffffff; border-radius: 16px; padding: 30px; margin-bottom: 28px; box-shadow: 0 10px 25px -5px rgba(2, 132, 199, 0.25); position: relative; overflow: hidden; }
        .welcome-hero h1 { margin: 0 0 8px 0; font-size: 1.75rem; font-weight: 700; }
        .welcome-hero p { margin: 0; opacity: 0.9; font-size: 0.95rem; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 18px; margin-bottom: 32px; }
        .stat-card { background: #ffffff; border-radius: 12px; padding: 20px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .stat-card .label { font-size: 0.82rem; font-weight: 600; text-transform: uppercase; color: #64748b; margin-bottom: 6px; letter-spacing: 0.5px; }
        .stat-card .val { font-size: 1.8rem; font-weight: 800; color: #0f172a; }
        
        .section-card { background: #ffffff; border-radius: 14px; border: 1px solid #e2e8f0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin-bottom: 32px; overflow: hidden; }
        .section-header { padding: 18px 24px; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; justify-content: space-between; }
        .section-header h2 { margin: 0; font-size: 1.15rem; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
        
        .table-responsive { overflow-x: auto; }
        .portal-table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.9rem; }
        .portal-table th { background: #f8fafc; padding: 12px 18px; font-weight: 600; color: #475569; border-bottom: 1px solid #e2e8f0; }
        .portal-table td { padding: 14px 18px; border-bottom: 1px solid #f1f5f9; color: #334155; }
        .portal-table tr:last-child td { border-bottom: none; }
        .portal-table tr:hover { background: #f8fafc; }
        
        .badge { display: inline-block; padding: 4px 10px; border-radius: 12px; font-size: 0.78rem; font-weight: 600; }
        .badge-pending { background: #fef3c7; color: #92400e; }
        .badge-confirmed { background: #e0f2fe; color: #0369a1; }
        .badge-completed { background: #dcfce7; color: #166534; }
        .badge-cancelled { background: #fee2e2; color: #991b1b; }
        
        .view-btn { display: inline-flex; align-items: center; gap: 4px; color: #0284c7; font-weight: 600; text-decoration: none; font-size: 0.85rem; }
        .view-btn:hover { text-decoration: underline; }
        
        .empty-state { padding: 40px 20px; text-align: center; color: #64748b; font-size: 0.9rem; }
    </style>
</head>
<body>
    <nav class="portal-navbar">
        <a href="#" class="portal-brand">
            <img src="${pageContext.request.contextPath}/images/sunrise-logo.png" alt="Sunrise Dental">
            <span>Sunrise Dental Patient Portal</span>
        </a>
        <div class="portal-user-info">
            <div class="portal-user-badge">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                <span>${patientName}</span>
            </div>
            <a href="${pageContext.request.contextPath}/patient-logout" class="logout-btn">Log Out</a>
        </div>
    </nav>

    <div class="portal-container">
        <div class="welcome-hero">
            <div style="display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:12px;">
                <div>
                    <h1>Welcome, ${patientName}!</h1>
                    <p>Here is your dental care overview, upcoming schedule, and complete billing records.</p>
                </div>
                <div style="background:rgba(255,255,255,0.2); border:1.5px solid rgba(255,255,255,0.4); padding:10px 18px; border-radius:12px; backdrop-filter:blur(4px); text-align:right;">
                    <div style="font-size:0.75rem; text-transform:uppercase; letter-spacing:1px; opacity:0.85;">Your Patient ID</div>
                    <div style="font-size:1.35rem; font-weight:800; font-family:monospace; letter-spacing:1px;">${patientCode}</div>
                </div>
            </div>
        </div>

        <!-- Patient Details Profile Card -->
        <% com.sunrisedental.model.Patient patientObj = (com.sunrisedental.model.Patient) request.getAttribute("patient"); %>
        <div class="section-card" style="margin-bottom:24px;">
            <div class="section-header" style="background:#f8fafc;">
                <h2>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    Patient Profile &amp; Contact Information
                </h2>
                <span class="badge" style="background:#e0f2fe; color:#0369a1; border:1px solid #bae6fd; font-size:0.85rem; font-family:monospace;">ID: ${patientCode}</span>
            </div>
            <div style="padding:20px 24px; display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:18px; font-size:0.9rem;">
                <div>
                    <div style="font-size:0.78rem; font-weight:600; text-transform:uppercase; color:#64748b; margin-bottom:4px;">Unique Patient Code</div>
                    <div style="font-weight:700; color:#0284c7; font-family:monospace; font-size:1.05rem;">${patientCode}</div>
                </div>
                <div>
                    <div style="font-size:0.78rem; font-weight:600; text-transform:uppercase; color:#64748b; margin-bottom:4px;">Full Name</div>
                    <div style="font-weight:600; color:#0f172a;"><%= patientObj != null ? patientObj.getName() : request.getAttribute("patientName") %></div>
                </div>
                <div>
                    <div style="font-size:0.78rem; font-weight:600; text-transform:uppercase; color:#64748b; margin-bottom:4px;">Contact Number</div>
                    <div style="font-weight:600; color:#0f172a;"><%= (patientObj != null && patientObj.getContact() != null) ? patientObj.getContact() : "N/A" %></div>
                </div>
                <div>
                    <div style="font-size:0.78rem; font-weight:600; text-transform:uppercase; color:#64748b; margin-bottom:4px;">Email Address</div>
                    <div style="font-weight:600; color:#0f172a;"><%= (patientObj != null && patientObj.getEmail() != null) ? patientObj.getEmail() : request.getAttribute("patientEmail") %></div>
                </div>
                <div style="grid-column: span 2;">
                    <div style="font-size:0.78rem; font-weight:600; text-transform:uppercase; color:#64748b; margin-bottom:4px;">Registered Address</div>
                    <div style="font-weight:500; color:#334155;"><%= (patientObj != null && patientObj.getAddress() != null && !patientObj.getAddress().isBlank()) ? patientObj.getAddress() : "No address specified" %></div>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="label">Total Appointments</div>
                <div class="val">${totalCount}</div>
            </div>
            <div class="stat-card">
                <div class="label">Pending / Confirmed</div>
                <div class="val" style="color: #0284c7;">${pendingCount}</div>
            </div>
            <div class="stat-card">
                <div class="label">Completed Visits</div>
                <div class="val" style="color: #16a34a;">${completedCount}</div>
            </div>
        </div>

        <!-- Appointment History Section -->
        <div class="section-card">
            <div class="section-header">
                <h2>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    My Appointments
                </h2>
            </div>
            <div class="table-responsive">
                <% 
                    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
                    if (appointments != null && !appointments.isEmpty()) {
                %>
                <table class="portal-table">
                    <thead>
                        <tr>
                            <th>Appt No</th>
                            <th>Date &amp; Time</th>
                            <th>Assigned Doctor</th>
                            <th>Treatment / Service</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Appointment apt : appointments) { 
                            String statusClass = "badge-pending";
                            if ("Confirmed".equalsIgnoreCase(apt.getStatus())) statusClass = "badge-confirmed";
                            else if ("Completed".equalsIgnoreCase(apt.getStatus())) statusClass = "badge-completed";
                            else if ("Cancelled".equalsIgnoreCase(apt.getStatus())) statusClass = "badge-cancelled";
                        %>
                        <tr>
                            <td><strong style="color:#0f172a;"><%= apt.getAppointmentNo() %></strong></td>
                            <td>
                                <div><strong><%= apt.getAppointmentDate() %></strong></div>
                                <div style="font-size:0.8rem; color:#64748b;"><%= apt.getAppointmentTime() %></div>
                            </td>
                            <td>Dr. <%= apt.getDentistName() %></td>
                            <td><%= apt.getTreatmentType() %></td>
                            <td><span class="badge <%= statusClass %>"><%= apt.getStatus() %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="empty-state">
                    No appointment records found for your account.
                </div>
                <% } %>
            </div>
        </div>

        <!-- Billing Records Section -->
        <div class="section-card">
            <div class="section-header">
                <h2>
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    Bills &amp; Invoices
                </h2>
            </div>
            <div class="table-responsive">
                <% 
                    Map<Integer, Bill> billsMap = (Map<Integer, Bill>) request.getAttribute("billsMap");
                    if (billsMap != null && !billsMap.isEmpty()) {
                %>
                <table class="portal-table">
                    <thead>
                        <tr>
                            <th>Invoice No</th>
                            <th>Appt No</th>
                            <th>Treatment</th>
                            <th>Total Amount</th>
                            <th>Date Issued</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map.Entry<Integer, Bill> entry : billsMap.entrySet()) {
                            Bill bill = entry.getValue();
                        %>
                        <tr>
                            <td><strong style="color:#0f172a;"><%= bill.getBillNo() %></strong></td>
                            <td><%= bill.getAppointmentNo() %></td>
                            <td><%= bill.getTreatmentType() %></td>
                            <td><strong style="color:#0284c7;">Rs. <%= String.format("%,.2f", bill.getTotalAmount()) %></strong></td>
                            <td><%= bill.getCreatedAt() != null ? bill.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/patient-receipt/<%= bill.getAppointmentId() %>" target="_blank" class="view-btn">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                    View Receipt
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="empty-state">
                    No billing statements or receipts issued yet.
                </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
