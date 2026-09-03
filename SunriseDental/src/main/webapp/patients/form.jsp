<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Patient" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Patient patient = (Patient) request.getAttribute("patient");
    boolean isEdit = patient != null;
%>

<h1 class="page-title"><%= isEdit ? "Edit Patient" : "Add New Patient" %></h1>

<% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger" style="background:#fef2f2; border:1.5px solid #ef4444; color:#991b1b; padding:12px 16px; border-radius:8px; margin-bottom:20px; font-weight:500; display:flex; align-items:center; gap:8px;">
        <span style="font-size:1.2rem;">⚠️</span>
        <span><%= request.getAttribute("errorMessage") %></span>
    </div>
<% } %>

<div class="card">
    <form action="${pageContext.request.contextPath}/patients/<%= isEdit ? "edit/" + patient.getId() : "add" %>" method="post" id="patientForm" onsubmit="return validatePatientForm()">
        <div class="form-grid">
            <div class="form-group">
                <label for="name">Patient Name *</label>
                <input type="text" id="name" name="name" class="form-control"
                       value="<%= request.getAttribute("inputName") != null ? request.getAttribute("inputName") : (isEdit ? patient.getName() : "") %>" 
                       placeholder="e.g. John Smith" required>
                <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">Full legal name of the patient.</small>
            </div>
            <div class="form-group">
                <label for="contact">Contact Number (10 Digits) *</label>
                <input type="tel" id="contact" name="contact" class="form-control"
                       value="<%= request.getAttribute("inputContact") != null ? request.getAttribute("inputContact") : (isEdit ? patient.getContact() : "") %>" 
                       pattern="[0-9]{10}" maxlength="10" minlength="10"
                       title="Contact number must be exactly 10 digits (e.g. 0771234567)"
                       placeholder="e.g. 0771234567"
                       oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">Must contain exactly 10 numeric digits.</small>
            </div>
            <div class="form-group">
                <label for="email">Email Address *</label>
                <input type="email" id="email" name="email" class="form-control"
                       value="<%= request.getAttribute("inputEmail") != null ? request.getAttribute("inputEmail") : (isEdit && patient.getEmail() != null ? patient.getEmail() : "") %>"
                       pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}"
                       title="Please enter a valid email format (e.g. patient@example.com)"
                       placeholder="e.g. patient@example.com" required>
                <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">Required for automated receipts and appointment confirmations.</small>
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" class="form-control"
                       value="<%= request.getAttribute("inputAddress") != null ? request.getAttribute("inputAddress") : (isEdit && patient.getAddress() != null ? patient.getAddress() : "") %>"
                       placeholder="e.g. 123 Main Street, Colombo">
                <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">Residential or postal address.</small>
            </div>
        </div>
        <div class="btn-group">
            <button type="submit" class="btn btn-primary"><%= isEdit ? "Update Patient" : "Save Patient" %></button>
            <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<script>
function validatePatientForm() {
    var name = document.getElementById('name').value.trim();
    var contact = document.getElementById('contact').value.trim();
    var email = document.getElementById('email').value.trim();

    if (!name) {
        alert("Please enter the patient's full name.");
        document.getElementById('name').focus();
        return false;
    }

    var contactRegex = /^[0-9]{10}$/;
    if (!contactRegex.test(contact)) {
        alert("Contact number must contain exactly 10 numeric digits (e.g. 0771234567).");
        document.getElementById('contact').focus();
        return false;
    }

    var emailRegex = /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
        alert("Please enter a valid email address (e.g. patient@example.com).");
        document.getElementById('email').focus();
        return false;
    }

    return true;
}
</script>

<%@ include file="/includes/layout-bottom.jsp" %>
