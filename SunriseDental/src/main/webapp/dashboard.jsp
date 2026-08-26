<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Appointment, java.math.BigDecimal" %>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Dashboard</h1>

<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon blue">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                <line x1="16" y1="2" x2="16" y2="6"/>
                <line x1="8" y1="2" x2="8" y2="6"/>
                <line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
        </div>
        <div class="stat-info">
            <h3><%= request.getAttribute("totalAppointments") %></h3>
            <p>Total Appointments</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon green">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/>
                <polyline points="12 6 12 12 16 14"/>
            </svg>
        </div>
        <div class="stat-info">
            <h3><%= request.getAttribute("todayCount") %></h3>
            <p>Today's Appointments</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon orange">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                <circle cx="9" cy="7" r="4"/>
                <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
            </svg>
        </div>
        <div class="stat-info">
            <h3><%= request.getAttribute("totalPatients") %></h3>
            <p>Total Patients</p>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon purple">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="2" y="5" width="20" height="14" rx="2"/>
                <line x1="2" y1="10" x2="22" y2="10"/>
                <path d="M6 15h4M16 15h2"/>
            </svg>
        </div>
        <div class="stat-info">
            <h3>Rs. <%= request.getAttribute("totalRevenue") %></h3>
            <p>Total Revenue</p>
        </div>
    </div>
</div>

<!-- Appointments Table -->
<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
        <div>
            <h3 style="margin:0;">Active Appointments and Bookings</h3>
            <small style="color:var(--text-muted);">Manage upcoming dental visits and complete treatments</small>
        </div>
        <div style="display:flex; gap:8px;">
            <a href="${pageContext.request.contextPath}/appointments/history" class="btn btn-secondary btn-sm" style="display:flex; align-items:center; gap:6px;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><polyline points="12 7 12 12 15 15"/><path d="M3.05 11a9 9 0 0 1 .5-2m-.5 2H6m-3-2V6"/></svg>
                Booking History
            </a>
            <a href="${pageContext.request.contextPath}/appointments/search" class="btn btn-secondary btn-sm" style="display:flex; align-items:center; gap:6px;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                Search
            </a>
            <a href="${pageContext.request.contextPath}/appointments/register" class="btn btn-primary btn-sm" style="display:flex; align-items:center; gap:6px;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                New Appointment
            </a>
        </div>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Appointment No</th>
                <th>Patient Name</th>
                <th>Email Address</th>
                <th>Dentist</th>
                <th>Scheduled Date</th>
                <th>Time</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            List<Appointment> recentList = (List<Appointment>) request.getAttribute("recentAppointments");
            if (recentList != null && !recentList.isEmpty()) {
                int j = 1;
                for (Appointment r : recentList) {
                    String badgeClass = "badge-pending";
                    if ("Confirmed".equals(r.getStatus())) badgeClass = "badge-confirmed";
                    else if ("Completed".equals(r.getStatus())) badgeClass = "badge-completed";
                    else if ("Cancelled".equals(r.getStatus())) badgeClass = "badge-cancelled";
        %>
            <tr>
                <td><%= j++ %></td>
                <td><strong><a href="${pageContext.request.contextPath}/appointments/search?appointmentNo=<%= r.getAppointmentNo() %>" style="color:var(--primary); text-decoration:underline;"><%= r.getAppointmentNo() %></a></strong></td>
                <td><%= r.getPatientName() %></td>
                <td><%= r.getPatientEmail() != null && !r.getPatientEmail().isBlank() ? r.getPatientEmail() : "<span style='color:#94a3b8;'>—</span>" %></td>
                <td><%= r.getDentistName() %></td>
                <td><strong><%= r.getAppointmentDate() %></strong></td>
                <td><%= r.getAppointmentTime() %></td>
                <td><span class="badge <%= badgeClass %>"><%= r.getStatus() %></span></td>
                <td class="action-icons" style="white-space:nowrap;">
                    <!-- View / Details -->
                    <a href="${pageContext.request.contextPath}/appointments/search?appointmentNo=<%= r.getAppointmentNo() %>"
                       class="btn-action-view"
                       title="View Details & Email">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                    </a>

                    <!-- Complete Action -->
                    <% if (!"Completed".equals(r.getStatus()) && !"Cancelled".equals(r.getStatus())) { %>
                        <a href="${pageContext.request.contextPath}/appointments/complete/<%= r.getId() %>"
                           class="btn-action-complete"
                           title="Mark as Completed"
                           onclick="return confirm('Complete this appointment and move to Booking History?')">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 6L9 17l-5-5"/>
                            </svg>
                        </a>
                    <% } %>

                    <!-- Edit Action -->
                    <a href="${pageContext.request.contextPath}/appointments/edit/<%= r.getId() %>"
                       class="btn-action-edit"
                       title="Edit Appointment">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                    </a>

                    <!-- Billing Action -->
                    <a href="${pageContext.request.contextPath}/billing/generate/<%= r.getId() %>"
                       class="btn-action-bill"
                       title="Generate / View Bill">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="2" y="5" width="20" height="14" rx="2"/>
                            <line x1="2" y1="10" x2="22" y2="10"/>
                            <path d="M6 15h4M16 15h2"/>
                        </svg>
                    </a>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr><td colspan="9" style="text-align:center; padding:20px; color:var(--text-muted);">No appointments recorded yet.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
