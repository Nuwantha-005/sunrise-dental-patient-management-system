<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Dentist" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Dentist dentist = (Dentist) request.getAttribute("dentist");
    boolean isEdit = dentist != null;
    String nextCode = (String) request.getAttribute("nextDentistCode");
    if (nextCode == null) nextCode = "DOC-AUTO";
%>

<h1 class="page-title"><%= isEdit ? "Edit Dentist" : "Add New Dentist" %></h1>

<div class="card" style="max-width:720px;">
    <form action="${pageContext.request.contextPath}/dentists/<%= isEdit ? "edit/" + dentist.getId() : "add" %>" method="post">

        <%-- Dentist Code (read-only badge) --%>
        <div class="form-group" style="margin-bottom:20px;">
            <label>Dentist ID</label>
            <div style="display:inline-flex; align-items:center; gap:10px;">
                <span style="background:#eff6ff; border:1.5px solid #3b82f6; color:#1e40af; font-size:1.05rem;
                             font-weight:700; padding:6px 18px; border-radius:8px; letter-spacing:1px; font-family:monospace;">
                    <%= isEdit ? dentist.getDentistCode() : nextCode %>
                </span>
                <small style="color:var(--text-muted); font-size:0.82rem;">
                    <%= isEdit ? "Assigned ID — cannot be changed" : "Auto-assigned when saved" %>
                </small>
            </div>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="name">Dentist Name *</label>
                <input type="text" id="name" name="name" class="form-control"
                       placeholder="e.g. Dr. John Smith"
                       value="<%= isEdit ? dentist.getName() : "" %>" required>
            </div>
            <div class="form-group">
                <label for="specialization">Specialization *</label>
                <select id="specialization" name="specialization" class="form-control" required>
                    <option value="">-- Select --</option>
                    <%
                        String[] specs = {"General Dentistry", "Orthodontics", "Cosmetic Dentistry",
                                          "Pediatric Dentistry", "Oral Surgery", "Endodontics",
                                          "Oral & Maxillofacial", "Periodontics"};
                        for (String s : specs) {
                    %>
                    <option value="<%= s %>" <%= isEdit && s.equals(dentist.getSpecialization()) ? "selected" : "" %>><%= s %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label for="contact">Contact Number *</label>
                <input type="text" id="contact" name="contact" class="form-control"
                       placeholder="e.g. 0771234567"
                       value="<%= isEdit ? dentist.getContact() : "" %>" required>
            </div>
        </div>

        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/dentists/list" class="btn btn-secondary">Cancel</a>
            <button type="submit" class="btn btn-primary"><%= isEdit ? "Update Dentist" : "Save Dentist" %></button>
        </div>
    </form>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
