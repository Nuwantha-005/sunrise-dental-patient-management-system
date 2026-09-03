<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.User" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    User profile = (User) request.getAttribute("userProfile");
%>

<h1 class="page-title">Settings</h1>

<% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
<% } %>
<% if (request.getAttribute("passwordSuccess") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("passwordSuccess") %></div>
<% } %>
<% if (request.getAttribute("passwordError") != null) { %>
    <div class="alert alert-error"><%= request.getAttribute("passwordError") %></div>
<% } %>

<div class="settings-grid">
    <div class="card">
        <h3 style="margin-bottom:20px;">Profile Settings</h3>
        <form action="${pageContext.request.contextPath}/settings" method="post">
            <input type="hidden" name="action" value="profile">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control"
                       value="<%= profile.getFullName() %>" required>
            </div>
            <div class="form-group">
                <label>Username</label>
                <input type="text" class="form-control" value="<%= profile.getUsername() %>" readonly>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control"
                       value="<%= profile.getEmail() != null ? profile.getEmail() : "" %>">
            </div>
            <div class="form-group">
                <label for="contact">Contact Number</label>
                <input type="text" id="contact" name="contact" class="form-control"
                       value="<%= profile.getContact() != null ? profile.getContact() : "" %>">
            </div>
            <button type="submit" class="btn btn-primary">Update Profile</button>
        </form>
    </div>

    <div class="card">
        <h3 style="margin-bottom:20px;">Change Password</h3>
        <form action="${pageContext.request.contextPath}/settings" method="post">
            <input type="hidden" name="action" value="password">
            <div class="form-group">
                <label for="currentPassword">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Update Password</button>
        </form>
    </div>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
