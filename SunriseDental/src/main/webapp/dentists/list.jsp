<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Dentist" %>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Dentists List</h1>

<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
        <div>
            <h3 style="margin:0;">All Dentists</h3>
            <% if (!currentUser.isAdmin()) { %>
            <small style="color:var(--text-muted);">View-only access for Receptionist staff</small>
            <% } %>
        </div>
        <% if (currentUser.isAdmin()) { %>
        <a href="${pageContext.request.contextPath}/dentists/add" class="btn btn-primary btn-sm">+ Add New Dentist</a>
        <% } %>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Dentist ID</th>
                <th>Dentist Name</th>
                <th>Specialization</th>
                <th>Contact Number</th>
                <% if (currentUser.isAdmin()) { %>
                <th style="text-align:center;">Actions</th>
                <% } %>
            </tr>
        </thead>
        <tbody>
        <%
            List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
            if (dentists != null && !dentists.isEmpty()) {
                int i = 1;
                for (Dentist d : dentists) {
        %>
            <tr>
                <td><%= i++ %></td>
                <td>
                    <span style="background:#eff6ff; border:1.5px solid #3b82f6; color:#1e40af;
                                 font-size:0.83rem; font-weight:700; padding:3px 10px;
                                 border-radius:6px; letter-spacing:0.5px; font-family:monospace;">
                        <%= d.getDentistCode() %>
                    </span>
                </td>
                <td><strong><%= d.getName() %></strong></td>
                <td><%= d.getSpecialization() %></td>
                <td><%= d.getContact() %></td>
                <% if (currentUser.isAdmin()) { %>
                <td class="action-icons" style="text-align:center;">
                    <a href="${pageContext.request.contextPath}/dentists/edit/<%= d.getId() %>" title="Edit Dentist">&#9998;</a>
                    <a href="${pageContext.request.contextPath}/dentists/delete/<%= d.getId() %>"
                       title="Delete Dentist" onclick="return confirm('Delete this dentist?')">&#128465;</a>
                </td>
                <% } %>
            </tr>
        <%      }
            } else { %>
            <tr><td colspan="<%= currentUser.isAdmin() ? 6 : 5 %>" style="text-align:center; padding:28px; color:var(--text-muted);">No dentists found</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
