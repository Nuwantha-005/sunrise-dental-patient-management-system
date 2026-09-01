<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Portal - Sunrise Dental Clinic</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <style>
        .patient-portal-badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd;
            font-size: 0.78rem; font-weight: 600; padding: 4px 12px;
            border-radius: 20px; margin-bottom: 10px; letter-spacing: 0.3px;
        }
        .hint-box {
            background: #f0f9ff; border: 1px solid #bae6fd; color: #0369a1;
            border-radius: 8px; padding: 10px 14px; font-size: 0.82rem;
            line-height: 1.6; margin-bottom: 18px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-header">
                <div class="logo-wrapper">
                    <img src="${pageContext.request.contextPath}/images/sunrise-logo.png"
                         alt="Sunrise Dental Clinic Logo" class="login-logo-img">
                </div>
                <div class="patient-portal-badge">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                    </svg>
                    Patient Portal
                </div>
                <h2>Sunrise Dental Clinic</h2>
                <p class="login-subtitle">Access Your Appointment &amp; Billing History</p>
            </div>

            <% if (request.getParameter("logout") != null) { %>
                <div class="alert alert-success" style="display:flex; align-items:center; gap:8px; margin-bottom:18px; background:#ecfdf5; border:1px solid #10b981; color:#065f46; border-radius:8px; padding:10px 14px; font-size:0.9rem;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                    <span>You have been logged out successfully.</span>
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error" style="display:flex; align-items:center; gap:8px; margin-bottom:18px; background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:10px 14px; font-size:0.88rem;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>

            <div class="hint-box">
                <div style="display:flex; align-items:center; gap:6px; margin-bottom:4px;">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#0284c7" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    <strong>How to login:</strong>
                </div>
                Your <strong>Username</strong> is your Unique Patient ID (e.g. <code>PAT-001</code>) or Appointment ID (e.g. <code>APT-001</code>).<br>
                Your <strong>Password</strong> was sent in your appointment confirmation email.
            </div>

            <%
                String rememberedUsername = (String) request.getAttribute("rememberedPatientUsername");
                if (rememberedUsername == null) rememberedUsername = "";
            %>

            <form class="login-form" action="${pageContext.request.contextPath}/patient-login" method="post">
                <div class="form-group">
                    <label for="username">Patient ID or Appointment ID (Username)</label>
                    <div class="input-icon-wrapper">
                        <svg class="field-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                        <input type="text" id="username" name="username" class="form-control"
                               value="<%= rememberedUsername %>"
                               placeholder="e.g. PAT-001 or APT-001" required autofocus
                               style="text-transform:uppercase; letter-spacing:1px;">
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-icon-wrapper">
                        <svg class="field-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Enter your password" required>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom:20px;">
                    <label style="display:flex; align-items:center; gap:8px; font-weight:normal; cursor:pointer; font-size:0.85rem; color:#475569;">
                        <input type="checkbox" name="remember" value="true" <%= !rememberedUsername.isEmpty() ? "checked" : "" %> style="width:16px; height:16px; accent-color:#0284c7; cursor:pointer;">
                        <span>Remember my Patient ID on this browser</span>
                    </label>
                </div>

                <button type="submit" class="btn btn-primary login-btn">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/><polyline points="10 17 15 12 10 7"/><line x1="15" y1="12" x2="3" y2="12"/>
                    </svg>
                    <span>Access My Dashboard</span>
                </button>
            </form>
        </div>
    </div>
</body>
</html>
