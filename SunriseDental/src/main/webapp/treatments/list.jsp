<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Treatment, com.sunrisedental.model.Dentist" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    List<Treatment> treatments = (List<Treatment>) request.getAttribute("treatments");
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    String selectedDentist = (String) request.getAttribute("selectedDentist");
%>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px; flex-wrap:wrap; gap:10px;">
    <div>
        <h1 class="page-title" style="margin:0;">Treatments &amp; Doctor Pricing</h1>
        <p style="color:var(--text-muted); margin-top:4px; font-size:0.92rem;">
            Manage dental treatments, assign suitable procedures to dentists, and configure doctor-specific service prices.
        </p>
    </div>
    <% if (currentUser != null && currentUser.isAdmin()) { %>
    <div>
        <a href="${pageContext.request.contextPath}/treatments/add" class="btn btn-primary btn-sm" style="display:inline-flex; align-items:center; gap:6px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            + Add New Treatment
        </a>
    </div>
    <% } %>
</div>

<% if ("added".equals(request.getParameter("success"))) { %>
<div class="alert alert-success auto-dismiss" style="background:#ecfdf5; border:1px solid #10b981; color:#065f46; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem;">
    ✅ Treatment and doctor pricing configured successfully!
</div>
<% } else if ("updated".equals(request.getParameter("success"))) { %>
<div class="alert alert-success auto-dismiss" style="background:#ecfdf5; border:1px solid #10b981; color:#065f46; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem;">
    ✅ Treatment details and price updated successfully.
</div>
<% } else if ("deleted".equals(request.getParameter("success"))) { %>
<div class="alert alert-success auto-dismiss" style="background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem;">
    🗑️ Treatment removed successfully.
</div>
<% } else if ("unauthorized".equals(request.getParameter("error"))) { %>
<div class="alert alert-danger" style="background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem;">
    🚫 Only Administrators can add, edit, or delete treatment configurations.
</div>
<% } %>

<!-- Filter by Dentist Bar -->
<div class="card" style="margin-bottom:20px; padding:16px 20px;">
    <form action="${pageContext.request.contextPath}/treatments/list" method="get" style="display:flex; align-items:center; gap:12px; flex-wrap:wrap; margin:0;">
        <label for="dentistId" style="font-weight:600; font-size:0.9rem; margin:0; color:var(--text);">Filter by Dentist:</label>
        <select id="dentistId" name="dentistId" class="form-control" style="max-width:320px; margin:0;" onchange="this.form.submit()">
            <option value="0">All Dentists &amp; Treatments</option>
            <%
                if (dentists != null) {
                    for (Dentist d : dentists) {
                        boolean isSel = selectedDentist != null && String.valueOf(d.getId()).equals(selectedDentist);
            %>
            <option value="<%= d.getId() %>" <%= isSel ? "selected" : "" %>><%= d.getDentistCode() %> — <%= d.getName() %> (<%= d.getSpecialization() %>)</option>
            <%      }
                }
            %>
        </select>
        <% if (selectedDentist != null && !"0".equals(selectedDentist) && !selectedDentist.isBlank()) { %>
            <a href="${pageContext.request.contextPath}/treatments/list" class="btn btn-secondary btn-sm">Reset Filter</a>
        <% } %>
    </form>
</div>

<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
        <div>
            <h3 style="margin:0;">Configured Procedures &amp; Fee Schedule</h3>
            <small style="color:var(--text-muted);">These procedures and prices appear automatically when booking appointments and generating patient bills.</small>
        </div>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Assigned Dentist</th>
                <th>Treatment Procedure</th>
                <th style="text-align:right;">Price (LKR)</th>
                <th>Available Schedule Days</th>
                <th>Description / Clinical Notes</th>
                <% if (currentUser != null && currentUser.isAdmin()) { %>
                <th style="text-align:center;">Actions</th>
                <% } %>
            </tr>
        </thead>
        <tbody>
        <%
            if (treatments != null && !treatments.isEmpty()) {
                int i = 1;
                for (Treatment t : treatments) {
        %>
            <tr>
                <td><%= i++ %></td>
                <td>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <span style="background:#eff6ff; border:1px solid #3b82f6; color:#1e40af; font-size:0.75rem; font-weight:700; padding:2px 8px; border-radius:4px; font-family:monospace;">
                            <%= t.getDentistCode() != null ? t.getDentistCode() : "DOC" %>
                        </span>
                        <strong><%= t.getDentistName() %></strong>
                    </div>
                </td>
                <td>
                    <strong style="color:var(--primary-dark); font-size:0.95rem;"><%= t.getTreatmentName() %></strong>
                </td>
                <td style="text-align:right;">
                    <span style="font-weight:700; color:#0369a1; font-size:0.95rem; background:#f0f9ff; padding:3px 10px; border-radius:6px; border:1px solid #bae6fd;">
                        Rs. <%= String.format("%,.2f", t.getPrice()) %>
                    </span>
                </td>
                <td>
                    <span style="font-size:0.82rem; color:#0369a1; background:#f0f9ff; border:1px solid #bae6fd; padding:3px 8px; border-radius:6px; font-weight:600; display:inline-flex; align-items:center; gap:4px;">
                        📅 <%= t.getAvailableDays() %>
                    </span>
                </td>
                <td>
                    <%= (t.getDescription() != null && !t.getDescription().isBlank()) ? t.getDescription() : "<span style='color:#94a3b8;'>—</span>" %>
                </td>
                <% if (currentUser != null && currentUser.isAdmin()) { %>
                <td class="action-icons" style="text-align:center; white-space:nowrap;">
                    <a href="${pageContext.request.contextPath}/treatments/edit/<%= t.getId() %>" class="btn-action-edit" title="Edit Treatment & Price">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/treatments/delete/<%= t.getId() %>"
                       class="btn-action-delete"
                       style="color:#ef4444;"
                       title="Delete Treatment"
                       onclick="return confirm('Are you sure you want to delete treatment \'<%= t.getTreatmentName().replace("'", "\\'") %>\' for <%= t.getDentistName().replace("'", "\\'") %>?')">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                        </svg>
                    </a>
                </td>
                <% } %>
            </tr>
        <%      }
            } else { %>
            <tr>
                <td colspan="<%= (currentUser != null && currentUser.isAdmin()) ? 6 : 5 %>" style="text-align:center; padding:36px; color:var(--text-muted);">
                    No treatments found. Click <strong>+ Add New Treatment</strong> to configure services and prices for dentists.
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
