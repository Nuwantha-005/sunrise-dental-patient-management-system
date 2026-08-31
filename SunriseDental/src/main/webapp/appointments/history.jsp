<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Appointment, com.sunrisedental.model.Dentist" %>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Booking and Treatment History</h1>

<% if ("registered".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success" style="display:flex; align-items:center; gap:8px; margin-bottom:20px; background:#ecfdf5; border:1px solid #10b981; color:#065f46; border-radius:8px; padding:12px 16px;">
        <span style="font-size:1.3rem;">✅</span>
        <div>
            <strong>Appointment Registered!</strong> Appointment <strong><%= request.getParameter("appointmentNo") != null ? request.getParameter("appointmentNo") : "" %></strong> has been booked successfully and recorded in Booking History.
            <% if ("1".equals(request.getParameter("emailSent"))) { %>
            <div style="font-size:0.85rem; color:#047857; margin-top:2px;">📧 Confirmation email has been sent to the patient.</div>
            <% } %>
        </div>
    </div>
<% } else if ("completed".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px; margin-bottom:20px; background:#ecfdf5; border:1px solid #10b981; color:#065f46; border-radius:8px; padding:14px 18px;">
        <div style="display:flex; align-items:center; gap:10px;">
            <span style="font-size:1.4rem;">✅</span>
            <div>
                <strong>Appointment Completed &amp; Billed!</strong> 
                Appointment <strong><%= request.getParameter("appointmentNo") != null ? request.getParameter("appointmentNo") : "" %></strong> 
                <% if (request.getParameter("billNo") != null && !request.getParameter("billNo").isBlank()) { %>
                    (Invoice No: <strong><%= request.getParameter("billNo") %></strong>)
                <% } %>
                has been marked as <strong>Completed</strong> and archived into Booking History.
            </div>
        </div>
        <% if (request.getParameter("receiptId") != null && !request.getParameter("receiptId").isBlank()) { %>
        <div>
            <a href="${pageContext.request.contextPath}/billing/receipt/<%= request.getParameter("receiptId") %>" 
               class="btn btn-primary btn-sm" style="display:inline-flex; align-items:center; gap:6px; font-weight:600; padding:6px 14px;">
                🧾 View / Print Official Receipt
            </a>
        </div>
        <% } %>
    </div>
<% } else if ("deleted".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success" style="display:flex; align-items:center; gap:8px; margin-bottom:20px; background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:12px 16px;">
        <span style="font-size:1.3rem;">🗑️</span>
        <span><strong>Appointment Deleted:</strong> The selected appointment booking and associated records have been removed from the system.</span>
    </div>
<% } else if ("unauthorized".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger" style="display:flex; align-items:center; gap:8px; margin-bottom:20px; background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:12px 16px;">
        <span style="font-size:1.3rem;">🚫</span>
        <span><strong>Access Denied:</strong> Only Administrators are permitted to delete appointment bookings.</span>
    </div>
<% } %>

<div class="card" style="margin-bottom:20px;">
    <form action="${pageContext.request.contextPath}/appointments/history" method="get" class="form-grid" style="grid-template-columns: 2fr 1.2fr 1.2fr auto; gap: 12px; align-items: end;">
        <div class="form-group" style="margin:0;">
            <label for="search" style="font-size:0.85rem; font-weight:600; color:var(--text-muted);">Search Keyword</label>
            <input type="text" id="search" name="search" class="form-control"
                   placeholder="Appointment No, Patient, Contact, Email, Treatment..."
                   value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
        </div>
        <div class="form-group" style="margin:0;">
            <label for="status" style="font-size:0.85rem; font-weight:600; color:var(--text-muted);">Status Filter</label>
            <select id="status" name="status" class="form-control">
                <%
                    String selectedStatus = (String) request.getAttribute("selectedStatus");
                    if (selectedStatus == null) selectedStatus = "ALL";
                %>
                <option value="ALL" <%= "ALL".equals(selectedStatus) ? "selected" : "" %>>All Statuses</option>
                <option value="Completed" <%= "Completed".equals(selectedStatus) ? "selected" : "" %>>Completed</option>
                <option value="Confirmed" <%= "Confirmed".equals(selectedStatus) ? "selected" : "" %>>Confirmed</option>
                <option value="Pending" <%= "Pending".equals(selectedStatus) ? "selected" : "" %>>Pending</option>
                <option value="Cancelled" <%= "Cancelled".equals(selectedStatus) ? "selected" : "" %>>Cancelled</option>
            </select>
        </div>
        <div class="form-group" style="margin:0;">
            <label for="dentistId" style="font-size:0.85rem; font-weight:600; color:var(--text-muted);">Dentist</label>
            <select id="dentistId" name="dentistId" class="form-control">
                <option value="0">All Dentists</option>
                <%
                    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
                    String selectedDentist = (String) request.getAttribute("selectedDentist");
                    if (dentists != null) {
                        for (Dentist d : dentists) {
                            boolean isSel = selectedDentist != null && String.valueOf(d.getId()).equals(selectedDentist);
                %>
                <option value="<%= d.getId() %>" <%= isSel ? "selected" : "" %>><%= d.getName() %></option>
                <%      }
                    }
                %>
            </select>
        </div>
        <div style="display:flex; gap:8px;">
            <button type="submit" class="btn btn-primary" style="padding:10px 18px; display:flex; align-items:center; gap:6px;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                Filter
            </button>
            <a href="${pageContext.request.contextPath}/appointments/history" class="btn btn-secondary" style="padding:10px 14px; display:flex; align-items:center; gap:6px;">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>
                Reset
            </a>
        </div>
    </form>
</div>

<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
        <div>
            <h3 style="margin:0;">Archived Bookings and Past Appointments</h3>
            <small style="color:var(--text-muted);">View completed dental treatments and previous patient appointments</small>
        </div>
        <a href="${pageContext.request.contextPath}/appointments/register" class="btn btn-primary btn-sm" style="display:flex; align-items:center; gap:6px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            New Appointment
        </a>
    </div>

    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Appointment No</th>
                <th>Patient Details</th>
                <th>Dentist</th>
                <th>Treatment</th>
                <th>Date and Time</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            List<Appointment> historyList = (List<Appointment>) request.getAttribute("historyList");
            if (historyList != null && !historyList.isEmpty()) {
                int i = 1;
                for (Appointment a : historyList) {
                    String badgeClass = "badge-pending";
                    if ("Confirmed".equals(a.getStatus())) badgeClass = "badge-confirmed";
                    else if ("Completed".equals(a.getStatus())) badgeClass = "badge-completed";
                    else if ("Cancelled".equals(a.getStatus())) badgeClass = "badge-cancelled";
        %>
            <tr>
                <td><%= i++ %></td>
                <td>
                    <strong>
                        <a href="${pageContext.request.contextPath}/appointments/search?appointmentNo=<%= a.getAppointmentNo() %>" style="color:var(--primary); text-decoration:underline;">
                            <%= a.getAppointmentNo() %>
                        </a>
                    </strong>
                </td>
                <td>
                    <strong><%= a.getPatientName() %></strong><br>
                    <small style="color:var(--text-muted);"><%= a.getPatientContact() %></small>
                    <% if (a.getPatientEmail() != null && !a.getPatientEmail().isBlank()) { %>
                        <br>
                        <small style="color:#0284c7; display:inline-flex; align-items:center; gap:3px;">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                            <%= a.getPatientEmail() %>
                        </small>
                    <% } %>
                </td>
                <td><%= a.getDentistName() %></td>
                <td><span style="font-weight:500;"><%= a.getTreatmentType() %></span></td>
                <td>
                    <strong><%= a.getAppointmentDate() %></strong><br>
                    <small style="color:var(--text-muted);"><%= a.getAppointmentTime() %></small>
                </td>
                <td><span class="badge <%= badgeClass %>"><%= a.getStatus() %></span></td>
                <td class="action-icons" style="white-space:nowrap;">
                    <!-- View Details -->
                    <a href="${pageContext.request.contextPath}/appointments/search?appointmentNo=<%= a.getAppointmentNo() %>"
                       class="btn-action-view"
                       title="View Details & Email">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                    </a>

                    <!-- Billing Action -->
                    <a href="${pageContext.request.contextPath}/billing/generate/<%= a.getId() %>"
                       class="btn-action-bill"
                       title="Generate / View Bill">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="5" width="20" height="14" rx="2"/>
                            <line x1="2" y1="10" x2="22" y2="10"/>
                            <path d="M6 15h4M16 15h2"/>
                        </svg>
                    </a>

                    <!-- Complete Action (Proceed to Billing) -->
                    <% if (!"Completed".equals(a.getStatus()) && !"Cancelled".equals(a.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/appointments/complete/<%= a.getId() %>"
                           class="btn-action-complete"
                           title="Complete Appointment &amp; Generate Bill"
                           onclick="return confirm('Complete appointment <%= a.getAppointmentNo() %> and proceed to Bill Generation?')">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 6L9 17l-5-5"/>
                            </svg>
                        </a>
                    <% } %>

                    <!-- Edit Action -->
                    <a href="${pageContext.request.contextPath}/appointments/edit/<%= a.getId() %>"
                       class="btn-action-edit"
                       title="Edit Appointment">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                    </a>

                    <!-- Admin Delete Action -->
                    <% if (currentUser != null && currentUser.isAdmin()) { %>
                    <a href="${pageContext.request.contextPath}/appointments/delete/<%= a.getId() %>"
                       class="btn-action-delete"
                       style="color:#ef4444;"
                       title="Delete Appointment (Admin Only)"
                       onclick="return confirm('Are you sure you want to permanently delete appointment <%= a.getAppointmentNo() %> for patient <%= a.getPatientName().replace("'", "\\'") %>?')">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                        </svg>
                    </a>
                    <% } %>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="8" style="text-align:center; padding:30px; color:var(--text-muted);">
                    No booking records found matching the filter criteria.
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
