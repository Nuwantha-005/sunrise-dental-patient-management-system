<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Dentist" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Dentist dentist = (Dentist) request.getAttribute("dentist");
    boolean isEdit = dentist != null;
%>

<h1 class="page-title"><%= isEdit ? "Edit Dentist" : "Add New Dentist" %></h1>

<div class="card">
    <form action="${pageContext.request.contextPath}/dentists/<%= isEdit ? "edit/" + dentist.getId() : "add" %>" method="post">
        <div class="form-grid">
            <div class="form-group">
                <label for="name">Dentist Name *</label>
                <input type="text" id="name" name="name" class="form-control"
                       value="<%= isEdit ? dentist.getName() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="specialization">Specialization *</label>
                <select id="specialization" name="specialization" class="form-control" required>
                    <option value="">-- Select --</option>
                    <%
                        String[] specs = {"General Dentistry", "Orthodontics", "Cosmetic Dentistry",
                                          "Pediatric Dentistry", "Oral Surgery", "Endodontics"};
                        for (String s : specs) {
                    %>
                    <option value="<%= s %>" <%= isEdit && s.equals(dentist.getSpecialization()) ? "selected" : "" %>><%= s %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="contact">Contact Number *</label>
                <input type="text" id="contact" name="contact" class="form-control"
                       value="<%= isEdit ? dentist.getContact() : "" %>" required>
            </div>
        </div>
        <div class="btn-group">
            <button type="submit" class="btn btn-primary"><%= isEdit ? "Update" : "Save" %></button>
            <a href="${pageContext.request.contextPath}/dentists/list" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
