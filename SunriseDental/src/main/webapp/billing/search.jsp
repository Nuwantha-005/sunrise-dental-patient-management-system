<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Appointment, com.sunrisedental.model.Bill" %>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Billing</h1>

<% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error"><%= request.getAttribute("error") %></div>
<% } %>

<div class="card">
    <div class="card-header">
        <h3>Search Appointment to Generate Bill</h3>
    </div>
    <form action="${pageContext.request.contextPath}/billing/search" method="post" class="search-bar">
        <input type="text" name="appointmentNo" class="form-control"
               placeholder="Enter Appointment Number (e.g. APT-001)"
               value="<%= request.getAttribute("appointmentNo") != null ? request.getAttribute("appointmentNo") : "" %>"
               required>
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <%
        Appointment appointment = (Appointment) request.getAttribute("appointment");
        Bill bill = (Bill) request.getAttribute("bill");
        if (appointment != null) {
    %>
    <h3 style="margin:20px 0 15px;">Appointment Information</h3>
    <div class="detail-grid">
        <div class="detail-item"><label>Appointment No</label><span><%= appointment.getAppointmentNo() %></span></div>
        <div class="detail-item"><label>Patient Name</label><span><%= appointment.getPatientName() %></span></div>
        <div class="detail-item"><label>Dentist</label><span><%= appointment.getDentistName() %></span></div>
        <div class="detail-item"><label>Treatment</label><span><%= appointment.getTreatmentType() %></span></div>
        <div class="detail-item"><label>Date</label><span><%= appointment.getAppointmentDate() %></span></div>
        <div class="detail-item"><label>Status</label><span><%= appointment.getStatus() %></span></div>
    </div>

    <div class="btn-group">
        <% if (bill != null) { %>
            <a href="${pageContext.request.contextPath}/billing/receipt/<%= appointment.getId() %>" class="btn btn-primary">View Receipt</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/billing/generate/<%= appointment.getId() %>" class="btn btn-primary">Generate Bill</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/billing" class="btn btn-secondary">Back</a>
    </div>
    <% } %>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
