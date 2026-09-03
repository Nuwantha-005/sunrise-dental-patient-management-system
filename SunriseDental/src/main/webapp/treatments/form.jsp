<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Treatment, com.sunrisedental.model.Dentist" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Treatment treatment = (Treatment) request.getAttribute("treatment");
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    boolean isEdit = (treatment != null);
%>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
    <div>
        <h1 class="page-title" style="margin:0;"><%= isEdit ? "Edit Treatment & Price" : "Add New Treatment Procedure" %></h1>
        <p style="color:var(--text-muted); margin-top:4px; font-size:0.92rem;">
            <%= isEdit ? "Update treatment procedure details and pricing for the assigned dentist." : "Assign a dental treatment procedure to a dentist and define its standard service charge." %>
        </p>
    </div>
</div>

<div class="card" style="max-width:720px;">
    <form action="${pageContext.request.contextPath}/treatments/<%= isEdit ? "edit/" + treatment.getId() : "add" %>" method="post">
        
        <div class="form-group">
            <label for="dentistId">Assigned Dentist / Specialist *</label>
            <select id="dentistId" name="dentistId" class="form-control" required>
                <option value="">-- Select Dentist --</option>
                <%
                    if (dentists != null) {
                        for (Dentist d : dentists) {
                            boolean isSel = isEdit && d.getId() == treatment.getDentistId();
                %>
                <option value="<%= d.getId() %>" <%= isSel ? "selected" : "" %>><%= d.getDentistCode() %> — <%= d.getName() %> (<%= d.getSpecialization() %>)</option>
                <%      }
                    }
                %>
            </select>
            <small style="color:var(--text-muted); font-size:0.8rem; margin-top:4px; display:block;">The doctor who offers this specific procedure.</small>
        </div>

        <div class="form-grid">
            <div class="form-group">
                <label for="treatmentName">Treatment / Procedure Name *</label>
                <input type="text" id="treatmentName" name="treatmentName" class="form-control"
                       list="treatmentSuggestions"
                       placeholder="e.g. Root Canal Therapy, Dental Implant, Teeth Whitening"
                       value="<%= isEdit ? treatment.getTreatmentName() : "" %>" required>
                <datalist id="treatmentSuggestions">
                    <option value="Teeth Cleaning & Scaling">
                    <option value="Root Canal Therapy">
                    <option value="Teeth Whitening">
                    <option value="Composite Tooth Filling">
                    <option value="Dental Checkup & Consultation">
                    <option value="Tooth Extraction">
                    <option value="Surgical Extraction">
                    <option value="Braces Consultation & Fitting">
                    <option value="Braces Monthly Adjustment">
                    <option value="Crown & Bridge Placement">
                    <option value="Complete / Partial Dentures">
                    <option value="Periodontal Gum Treatment">
                    <option value="Dental Implant">
                    <option value="Pediatric Dental Care">
                </datalist>
            </div>

            <div class="form-group">
                <label for="price">Standard Price (Rs. / LKR) *</label>
                <input type="number" id="price" name="price" class="form-control" step="0.01" min="0"
                       placeholder="e.g. 8500.00"
                       value="<%= isEdit ? String.format("%.2f", treatment.getPrice()) : "" %>" required>
                <small style="color:var(--text-muted); font-size:0.8rem; margin-top:4px; display:block;">Procedure fee charged during billing.</small>
            </div>
        </div>

        <div class="form-group" style="margin-top:16px;">
            <label style="font-weight:700; color:var(--primary-dark);">Dentist Available Schedule Days *</label>
            <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(130px, 1fr)); gap:10px; margin-top:8px; background:#f8fafc; padding:14px 16px; border-radius:8px; border:1px solid #cbd5e1;">
                <%
                    String curDays = isEdit && treatment.getAvailableDays() != null ? treatment.getAvailableDays() : "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday";
                    String[] weekDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
                    for (String day : weekDays) {
                        boolean checked = curDays.contains(day);
                %>
                <label style="display:inline-flex; align-items:center; gap:8px; font-weight:600; font-size:0.9rem; cursor:pointer; margin:0; color:#334155;">
                    <input type="checkbox" name="availableDays" value="<%= day %>" <%= checked ? "checked" : "" %> style="width:17px; height:17px; accent-color:#0284c7; cursor:pointer;">
                    <span><%= day %></span>
                </label>
                <% } %>
            </div>
            <small style="color:var(--text-muted); font-size:0.82rem; margin-top:6px; display:block;">
                📅 Select the days of the week when this doctor is available for this procedure. The appointment booking system will automatically enforce these available days.
            </small>
        </div>

        <div class="form-group">
            <label for="description">Clinical Notes / Procedure Description</label>
            <textarea id="description" name="description" class="form-control" rows="3"
                      placeholder="Brief details about the procedure, duration, or instructions..."><%= isEdit && treatment.getDescription() != null ? treatment.getDescription() : "" %></textarea>
        </div>

        <div class="btn-group" style="margin-top:24px;">
            <a href="${pageContext.request.contextPath}/treatments/list" class="btn btn-secondary">Cancel</a>
            <button type="submit" class="btn btn-primary"><%= isEdit ? "Update Treatment" : "Save Treatment & Price" %></button>
        </div>
    </form>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
