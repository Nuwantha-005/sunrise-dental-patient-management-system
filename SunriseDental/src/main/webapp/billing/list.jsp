<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Bill, java.text.SimpleDateFormat, java.math.BigDecimal" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    String search = (String) request.getAttribute("search");
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
    int count = (bills != null) ? bills.size() : 0;
%>

<div class="page-header" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
    <div>
        <h1 class="page-title" style="margin:0 0 6px 0;">All Bills & Invoices</h1>
        <p style="color:var(--text-muted); margin:0; font-size:0.9rem;">View, track, and print all patient clinical treatment bills</p>
    </div>
    <div style="display:flex; gap:10px;">
        <a href="${pageContext.request.contextPath}/appointments/history?status=Completed" class="btn btn-secondary" style="display:flex; align-items:center; gap:6px;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <polyline points="12 6 12 12 16 14"></polyline>
            </svg>
            Completed Appointments
        </a>
    </div>
</div>

<!-- Stats Summary Row -->
<div class="stats-grid" style="margin-bottom: 24px;">
    <div class="stat-card">
        <div class="stat-icon blue">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
                <line x1="16" y1="13" x2="8" y2="13"></line>
                <line x1="16" y1="17" x2="8" y2="17"></line>
                <polyline points="10 9 9 9 8 9"></polyline>
            </svg>
        </div>
        <div class="stat-info">
            <h3><%= count %></h3>
            <p><%= (search != null && !search.isBlank()) ? "Filtered Bills" : "Total Generated Bills" %></p>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon green">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="2" y="5" width="20" height="14" rx="2"/>
                <line x1="2" y1="10" x2="22" y2="10"/>
                <path d="M6 15h4M16 15h2"/>
            </svg>
        </div>
        <div class="stat-info">
            <h3>Rs. <%= String.format("%,.2f", totalRevenue) %></h3>
            <p>Total Revenue Settled</p>
        </div>
    </div>
</div>

<!-- Search / Filter Card -->
<div class="card" style="margin-bottom: 24px; padding: 18px 22px;">
    <form method="get" action="${pageContext.request.contextPath}/bills/list" style="display:flex; gap:12px; align-items:center; flex-wrap:wrap;">
        <div style="flex:1; min-width:280px; position:relative;">
            <input type="text" name="search" class="form-control"
                   placeholder="Search by Bill No (e.g. BILL-001), Patient Name, Appointment No, Dentist..."
                   value="<%= search != null ? search : "" %>"
                   style="padding-left:36px; width:100%;">
            <svg style="position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#94a3b8;" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle>
                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
        </div>
        <button type="submit" class="btn btn-primary" style="display:flex; align-items:center; gap:6px;">
            Search
        </button>
        <% if (search != null && !search.isBlank()) { %>
            <a href="${pageContext.request.contextPath}/bills/list" class="btn btn-secondary">Clear</a>
        <% } %>
    </form>
</div>

<!-- Bills Table -->
<div class="card" style="padding:0; overflow:hidden;">
    <div style="padding: 16px 22px; border-bottom: 1px solid var(--border); display:flex; justify-content:space-between; align-items:center; background: #fafbfc;">
        <h3 style="margin:0; font-size:1.05rem; font-weight:700; color:var(--text-main);">Settled Billing Invoices</h3>
        <span style="font-size:0.85rem; color:var(--text-muted);"><%= count %> record<%= count == 1 ? "" : "s" %> found</span>
    </div>

    <% if (bills == null || bills.isEmpty()) { %>
        <div style="text-align:center; padding: 48px 20px;">
            <div style="font-size: 2.5rem; margin-bottom: 12px; color: #94a3b8;">🧾</div>
            <h4 style="margin: 0 0 6px 0; color: var(--text-main);">No bills found</h4>
            <p style="color: var(--text-muted); font-size: 0.9rem; margin: 0;">
                <%= (search != null && !search.isBlank()) ? "No billing records match your search keyword." : "No bills have been generated yet." %>
            </p>
            <% if (search != null && !search.isBlank()) { %>
                <a href="${pageContext.request.contextPath}/bills/list" class="btn btn-secondary" style="margin-top:14px;">View All Bills</a>
            <% } %>
        </div>
    <% } else { %>
        <div class="table-responsive" style="overflow-x:auto;">
            <table class="table" style="margin-bottom:0; width:100%; border-collapse:collapse;">
                <thead>
                    <tr style="background: #f8fafc; border-bottom: 1px solid var(--border);">
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700;">Bill No</th>
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700;">Patient</th>
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700;">Appt Ref</th>
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700;">Dentist</th>
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700;">Treatment(s)</th>
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700; text-align:right;">Amount</th>
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700;">Date Issued</th>
                        <th style="padding:12px 18px; font-size:0.78rem; text-transform:uppercase; color:#64748b; font-weight:700; text-align:center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Bill b : bills) { %>
                    <tr style="border-bottom: 1px solid var(--border);">
                        <td style="padding:14px 18px; font-weight:700; color:#0284c7;">
                            <%= b.getBillNo() %>
                        </td>
                        <td style="padding:14px 18px; font-weight:600; color:var(--text-main);">
                            <%= b.getPatientName() != null ? b.getPatientName() : "—" %>
                        </td>
                        <td style="padding:14px 18px;">
                            <span class="badge" style="background:#f1f5f9; color:#475569; padding:4px 8px; border-radius:4px; font-family:monospace; font-weight:600;">
                                <%= b.getAppointmentNo() != null ? b.getAppointmentNo() : "—" %>
                            </span>
                        </td>
                        <td style="padding:14px 18px; color:var(--text-main);">
                            Dr. <%= b.getDentistName() != null ? b.getDentistName().replace("Dr. ", "") : "Specialist" %>
                        </td>
                        <td style="padding:14px 18px; max-width:240px; color:#475569; font-size:0.88rem;">
                            <%= b.getTreatmentType() != null ? b.getTreatmentType() : "—" %>
                        </td>
                        <td style="padding:14px 18px; text-align:right; font-weight:700; color:#0369a1;">
                            Rs. <%= String.format("%,.2f", b.getTotalAmount()) %>
                        </td>
                        <td style="padding:14px 18px; color:#64748b; font-size:0.83rem;">
                            <%= b.getCreatedAt() != null ? sdf.format(b.getCreatedAt()) : "—" %>
                        </td>
                        <td style="padding:14px 18px; text-align:center;">
                            <a href="${pageContext.request.contextPath}/billing/receipt/<%= b.getAppointmentId() %>"
                               class="btn btn-sm btn-primary"
                               style="display:inline-flex; align-items:center; gap:6px; padding:6px 12px; font-size:0.82rem; text-decoration:none;">
                                🖨️ View & Print
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
