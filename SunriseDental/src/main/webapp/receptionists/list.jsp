<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.User" %>
<%@ include file="/includes/layout-top.jsp" %>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
    <div>
        <h1 class="page-title" style="margin:0;">Receptionists &amp; Staff</h1>
        <p style="color:var(--text-muted); margin-top:4px; font-size:0.92rem;">Manage front-desk receptionist user accounts and dashboard login credentials.</p>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/receptionists/add" class="btn btn-primary btn-sm" style="display:inline-flex; align-items:center; gap:6px;">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            + Add New Receptionist
        </a>
    </div>
</div>

<% if ("added".equals(request.getParameter("success"))) { %>
<div class="alert alert-success auto-dismiss" style="background:#ecfdf5; border:1px solid #10b981; color:#065f46; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem;">
    ✅ New receptionist account created successfully! They can now log in using their username and password.
</div>
<% } else if ("updated".equals(request.getParameter("success"))) { %>
<div class="alert alert-success auto-dismiss" style="background:#ecfdf5; border:1px solid #10b981; color:#065f46; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem;">
    ✅ Receptionist account details updated successfully.
</div>
<% } else if ("deleted".equals(request.getParameter("success"))) { %>
<div class="alert alert-success auto-dismiss" style="background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem;">
    🗑️ Receptionist account deleted.
</div>
<% } %>

<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
        <h3 style="margin:0;">Registered Receptionists</h3>
        <small style="color:var(--text-muted);">Front-desk staff accounts</small>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Full Name</th>
                <th>Login Username</th>
                <th>Email Address</th>
                <th>Contact Number</th>
                <th>Assigned Role</th>
                <th style="text-align:center;">Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            List<User> list = (List<User>) request.getAttribute("receptionists");
            if (list != null && !list.isEmpty()) {
                int i = 1;
                for (User u : list) {
        %>
            <tr>
                <td><%= i++ %></td>
                <td>
                    <div style="font-weight:700; color:var(--primary-dark);"><%= u.getFullName() %></div>
                </td>
                <td>
                    <code style="background:#f1f5f9; padding:3px 8px; border-radius:4px; font-size:0.9rem; color:#0f172a; font-weight:600;"><%= u.getUsername() %></code>
                </td>
                <td>
                    <%= (u.getEmail() != null && !u.getEmail().isBlank()) ? u.getEmail() : "<span style='color:#94a3b8;'>—</span>" %>
                </td>
                <td>
                    <%= (u.getContact() != null && !u.getContact().isBlank()) ? u.getContact() : "<span style='color:#94a3b8;'>—</span>" %>
                </td>
                <td>
                    <span style="background:#e0f2fe; color:#0369a1; font-weight:700; font-size:0.78rem; padding:3px 10px; border-radius:50px; display:inline-block;">
                        Receptionist
                    </span>
                </td>
                <td class="action-icons" style="text-align:center; white-space:nowrap;">
                    <a href="${pageContext.request.contextPath}/receptionists/edit/<%= u.getId() %>" class="btn-action-edit" title="Edit Details / Password">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                    </a>
                    <a href="${pageContext.request.contextPath}/receptionists/delete/<%= u.getId() %>"
                       class="btn-action-delete"
                       style="color:#ef4444;"
                       title="Delete Receptionist"
                       onclick="return confirm('Are you sure you want to delete receptionist <%= u.getFullName().replace("'", "\\'") %>?')">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                        </svg>
                    </a>
                </td>
            </tr>
        <%      }
            } else { %>
            <tr>
                <td colspan="7" style="text-align:center; padding:32px; color:var(--text-muted);">
                    No receptionists added yet. Click <strong>+ Add New Receptionist</strong> above to create an account for front-desk staff.
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
