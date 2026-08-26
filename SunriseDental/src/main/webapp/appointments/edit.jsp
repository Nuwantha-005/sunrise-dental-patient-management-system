<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Dentist, com.sunrisedental.model.Appointment, com.sunrisedental.model.Patient" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    Patient patient = (Patient) request.getAttribute("patient");
    String patientEmail = (patient != null && patient.getEmail() != null) ? patient.getEmail() :
                          (appointment.getPatientEmail() != null ? appointment.getPatientEmail() : "");
%>

<h1 class="page-title">Edit Appointment</h1>

<div class="card">
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div style="background:#fef2f2; border:1.5px solid #ef4444; color:#991b1b; border-radius:8px; padding:14px 18px; margin-bottom:20px; font-size:0.95rem; display:flex; align-items:center; gap:10px;">
        <span style="font-size:1.4rem;">🚫</span>
        <div><%= request.getAttribute("errorMessage") %></div>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/appointments/edit/<%= appointment.getId() %>" method="post">
        <div class="form-grid">
            <div>
                <div class="form-group">
                    <label>Appointment No</label>
                    <input type="text" class="form-control" value="<%= appointment.getAppointmentNo() %>" readonly>
                </div>
                <div class="form-group">
                    <label for="patientName">Patient Name *</label>
                    <input type="text" id="patientName" name="patientName" class="form-control"
                           value="<%= appointment.getPatientName() %>" required>
                </div>
                <div class="form-group">
                    <label for="email">Patient Email Address *</label>
                    <input type="email" id="email" name="email" class="form-control"
                           value="<%= patientEmail %>" placeholder="e.g. patient@example.com" required>
                </div>
                <div class="form-group">
                    <label for="contact">Contact Number *</label>
                    <input type="text" id="contact" name="contact" class="form-control"
                           value="<%= appointment.getPatientContact() %>" required>
                </div>
                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" class="form-control"
                           value="<%= appointment.getPatientAddress() != null ? appointment.getPatientAddress() : "" %>">
                </div>
            </div>
            <div>
                <div class="form-group">
                    <label for="dentistId">Dentist *</label>
                    <select id="dentistId" name="dentistId" class="form-control" required>
                        <% for (Dentist d : dentists) { %>
                        <option value="<%= d.getId() %>" <%= d.getId() == appointment.getDentistId() ? "selected" : "" %>>
                            <%= d.getName() %> - <%= d.getSpecialization() %>
                        </option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="treatmentType">Treatment Type *</label>
                    <input type="text" id="treatmentType" name="treatmentType" class="form-control"
                           value="<%= appointment.getTreatmentType() %>" required>
                </div>
                <div class="form-group">
                    <label for="appointmentDate">Date *</label>
                    <input type="date" id="appointmentDate" name="appointmentDate" class="form-control"
                           value="<%= appointment.getAppointmentDate() %>" required>
                </div>
                <div class="form-group">
                    <label for="appointmentTime">Time *</label>
                    <input type="time" id="appointmentTime" name="appointmentTime" class="form-control"
                           value="<%= appointment.getAppointmentTime().toString().substring(0,5) %>" required>
                </div>
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="Pending" <%= "Pending".equals(appointment.getStatus()) ? "selected" : "" %>>Pending</option>
                        <option value="Confirmed" <%= "Confirmed".equals(appointment.getStatus()) ? "selected" : "" %>>Confirmed</option>
                        <option value="Completed" <%= "Completed".equals(appointment.getStatus()) ? "selected" : "" %>>Completed</option>
                        <option value="Cancelled" <%= "Cancelled".equals(appointment.getStatus()) ? "selected" : "" %>>Cancelled</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="btn-group">
            <button type="submit" class="btn btn-primary">Update Appointment</button>
            <a href="${pageContext.request.contextPath}/appointments/search?appointmentNo=<%= appointment.getAppointmentNo() %>" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
