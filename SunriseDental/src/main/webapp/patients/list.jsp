<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Patient" %>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Patients List</h1>

<div class="card">
    <div class="card-header">
        <form action="${pageContext.request.contextPath}/patients/list" method="get" class="search-bar" style="margin:0;">
            <input type="text" name="search" class="form-control" placeholder="Search by name, contact, or email..."
                   value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>">
            <button type="submit" class="btn btn-primary btn-sm">Search</button>
        </form>
        <a href="${pageContext.request.contextPath}/patients/add" class="btn btn-primary btn-sm">+ Add New Patient</a>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Patient Name</th>
                <th>Email Address</th>
                <th>Contact Number</th>
                <th>Address</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            List<Patient> patients = (List<Patient>) request.getAttribute("patients");
            if (patients != null && !patients.isEmpty()) {
                int i = 1;
                for (Patient p : patients) {
        %>
            <tr>
                <td><%= i++ %></td>
                <td><strong><%= p.getName() %></strong></td>
                <td><%= p.getEmail() != null && !p.getEmail().isBlank() ? p.getEmail() : "<span style='color:#94a3b8;'>—</span>" %></td>
                <td><%= p.getContact() %></td>
                <td><%= p.getAddress() != null && !p.getAddress().isBlank() ? p.getAddress() : "<span style='color:#94a3b8;'>—</span>" %></td>
                <td class="action-icons">
                    <a href="${pageContext.request.contextPath}/patients/edit/<%= p.getId() %>" title="Edit">&#9998;</a>
                    <a href="${pageContext.request.contextPath}/patients/delete/<%= p.getId() %>"
                       title="Delete" onclick="return confirm('Delete this patient?')">&#128465;</a>
                </td>
            </tr>
        <%      }
            } else { %>
            <tr><td colspan="6" style="text-align:center;">No patients found</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
