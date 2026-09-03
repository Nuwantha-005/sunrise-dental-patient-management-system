<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.User" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    User staff = (User) request.getAttribute("staff");
    boolean isEdit = (staff != null);

    String fullName = isEdit ? staff.getFullName() : (request.getAttribute("inputFullName") != null ? (String) request.getAttribute("inputFullName") : "");
    String username = isEdit ? staff.getUsername() : (request.getAttribute("inputUsername") != null ? (String) request.getAttribute("inputUsername") : "");
    String email = isEdit ? (staff.getEmail() != null ? staff.getEmail() : "") : (request.getAttribute("inputEmail") != null ? (String) request.getAttribute("inputEmail") : "");
    String contact = isEdit ? (staff.getContact() != null ? staff.getContact() : "") : (request.getAttribute("inputContact") != null ? (String) request.getAttribute("inputContact") : "");
%>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
    <div>
        <h1 class="page-title" style="margin:0;"><%= isEdit ? "Edit Receptionist Account" : "Add New Receptionist" %></h1>
        <p style="color:var(--text-muted); margin-top:4px; font-size:0.92rem;">
            <%= isEdit ? "Update receptionist details or reset their login password." : "Create a receptionist profile with username & password to grant front-desk dashboard access." %>
        </p>
    </div>
</div>

<% if (request.getAttribute("errorMessage") != null) { %>
<div style="background:#fef2f2; border:1.5px solid #ef4444; color:#991b1b; border-radius:8px; padding:14px 18px; margin-bottom:20px; font-size:0.95rem; display:flex; align-items:center; gap:10px;">
    <span style="font-size:1.4rem;">🚫</span>
    <div><%= request.getAttribute("errorMessage") %></div>
</div>
<% } %>

<div class="card" style="max-width:700px;">
    <form action="${pageContext.request.contextPath}/receptionists/<%= isEdit ? "edit/" + staff.getId() : "add" %>" method="post">
        
        <div class="form-group">
            <label for="fullName">Full Name *</label>
            <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. Sarah Jenkins" value="<%= fullName %>" required>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="username">Login Username *</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="e.g. sarah.j" value="<%= username %>" required>
                <small style="color:var(--text-muted); font-size:0.8rem; margin-top:4px; display:block;">Used by receptionist to sign in to the portal.</small>
            </div>

            <div class="form-group">
                <label for="password"><%= isEdit ? "New Password (Optional)" : "Login Password *" %></label>
                <input type="password" id="password" name="password" class="form-control" 
                       placeholder="<%= isEdit ? "Leave blank to keep existing password" : "Enter account password" %>" 
                       <%= isEdit ? "" : "required" %>>
                <small style="color:var(--text-muted); font-size:0.8rem; margin-top:4px; display:block;">
                    <%= isEdit ? "Only enter a value if resetting the password." : "Secure password for this receptionist." %>
                </small>
            </div>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="email">Email Address *</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="e.g. sarah@sunrisedental.com" value="<%= email %>" required>
            </div>

            <div class="form-group">
                <label for="contact">Contact Number *</label>
                <input type="text" id="contact" name="contact" class="form-control" placeholder="e.g. 0771234567" value="<%= contact %>" required>
            </div>
        </div>

        <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; padding:14px 16px; margin:16px 0 24px; font-size:0.88rem; color:#475569;">
            <div style="font-weight:700; color:var(--primary-dark); margin-bottom:4px;">ℹ️ Receptionist Permissions:</div>
            <ul style="margin:0; padding-left:18px; line-height:1.6;">
                <li>Can register &amp; manage appointments, bookings, billing, and patient records.</li>
                <li><strong>Restricted:</strong> Cannot delete patients, cannot add or modify dentists, and cannot manage other staff.</li>
            </ul>
        </div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/receptionists/list" class="btn btn-secondary">Cancel</a>
            <button type="submit" class="btn btn-primary"><%= isEdit ? "Save Changes" : "Create Receptionist Account" %></button>
        </div>
    </form>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
