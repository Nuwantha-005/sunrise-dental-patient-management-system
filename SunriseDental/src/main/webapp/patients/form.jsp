<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Patient" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Patient patient = (Patient) request.getAttribute("patient");
    boolean isEdit = patient != null;
%>

<h1 class="page-title"><%= isEdit ? "Edit Patient" : "Add New Patient" %></h1>

<div class="card">
    <form action="${pageContext.request.contextPath}/patients/<%= isEdit ? "edit/" + patient.getId() : "add" %>" method="post">
        <div class="form-grid">
            <div class="form-group">
                <label for="name">Patient Name *</label>
                <input type="text" id="name" name="name" class="form-control"
                       value="<%= isEdit ? patient.getName() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       value="<%= isEdit && patient.getEmail() != null ? patient.getEmail() : "" %>"
                       placeholder="e.g. patient@example.com">
            </div>
            <div class="form-group">
                <label for="contact">Contact Number *</label>
                <input type="text" id="contact" name="contact" class="form-control"
                       value="<%= isEdit ? patient.getContact() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" class="form-control"
                       value="<%= isEdit && patient.getAddress() != null ? patient.getAddress() : "" %>">
            </div>
        </div>
        <div class="btn-group">
            <button type="submit" class="btn btn-primary"><%= isEdit ? "Update Patient" : "Save Patient" %></button>
            <a href="${pageContext.request.contextPath}/patients/list" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
