<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    com.sunrisedental.model.User currentUser =
        (com.sunrisedental.model.User) session.getAttribute("user");
    String initials = "A";
    if (currentUser != null && currentUser.getFullName() != null && !currentUser.getFullName().isEmpty()) {
        initials = currentUser.getFullName().substring(0, 1).toUpperCase();
    }
%>
<header class="top-header">
    <div class="breadcrumb">
        Home &gt; <strong>${pageTitle}</strong>
    </div>
    <div class="user-info">
        <div style="display:flex; flex-direction:column; align-items:flex-end;">
            <span style="font-weight:700; color:var(--text); line-height:1.2;"><%= currentUser != null ? currentUser.getFullName() : "Admin" %></span>
            <% if (currentUser != null && currentUser.isReceptionist()) { %>
            <span style="background:#e0f2fe; color:#0284c7; font-size:0.72rem; font-weight:700; padding:1px 8px; border-radius:4px; margin-top:2px;">
                Receptionist
            </span>
            <% } else { %>
            <span style="background:#f1f5f9; color:var(--primary-dark); font-size:0.72rem; font-weight:700; padding:1px 8px; border-radius:4px; margin-top:2px;">
                Administrator
            </span>
            <% } %>
        </div>
        <div class="user-avatar"><%= initials %></div>
    </div>
</header>
