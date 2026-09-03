<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Appointment, com.sunrisedental.model.Bill, com.sunrisedental.dao.TreatmentDAO, java.math.BigDecimal" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Bill bill = (Bill) request.getAttribute("bill");
    TreatmentDAO treatmentDAO = (TreatmentDAO) request.getAttribute("treatmentDAO");
    if (treatmentDAO == null) treatmentDAO = new TreatmentDAO();

    String[] treatmentList = (appointment != null && appointment.getTreatmentType() != null)
            ? appointment.getTreatmentType().split(",\\s*")
            : new String[]{"Dental Checkup"};
%>

<h1 class="page-title">Generate Patient Bill</h1>

<div class="card" style="margin-bottom: 20px;">
    <h3 style="margin-bottom:15px; color:var(--primary);">Appointment Information</h3>
    <div class="detail-grid">
        <div class="detail-item"><label>Appointment No</label><span><strong><%= appointment.getAppointmentNo() %></strong></span></div>
        <div class="detail-item"><label>Patient Name</label><span><%= appointment.getPatientName() %></span></div>
        <div class="detail-item"><label>Dentist</label><span><%= appointment.getDentistName() %></span></div>
        <div class="detail-item"><label>Treatments (<%= treatmentList.length %>)</label><span><strong><%= appointment.getTreatmentType() %></strong></span></div>
    </div>
</div>

<% if (bill != null) { %>
    <div class="card" style="text-align:center; padding:30px;">
        <div style="color:#16a34a; font-size:1.2rem; font-weight:700; margin-bottom:10px;">
            ✓ Bill already generated for this appointment!
        </div>
        <p style="color:var(--text-muted); margin-bottom:20px;">Bill Number: <strong><%= bill.getBillNo() %></strong> &bull; Total: <strong>Rs. <%= String.format("%,.2f", bill.getTotalAmount()) %></strong></p>
        <a href="${pageContext.request.contextPath}/billing/receipt/<%= appointment.getId() %>" class="btn btn-primary" style="padding:10px 25px;">
            🧾 View and Print Official Receipt
        </a>
    </div>
<% } else { %>
<div class="card">
    <h3 style="margin-bottom:15px; color:var(--primary);">Billing Charges Breakdown</h3>
    <form action="${pageContext.request.contextPath}/billing/save/<%= appointment.getId() %>" method="post">
        <table class="data-table">
            <thead>
                <tr>
                    <th style="width: 60%;">Description</th>
                    <th style="width: 40%;">Amount (Rs.)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    double initialTreatmentsSum = 0;
                    for (int i = 0; i < treatmentList.length; i++) {
                        String tName = treatmentList[i].trim();
                        BigDecimal dbPrice = (appointment != null) ? treatmentDAO.findPriceByDentistAndName(appointment.getDentistId(), tName) : null;
                        double baseFee = (dbPrice != null) ? dbPrice.doubleValue() : 5000.00;
                        initialTreatmentsSum += baseFee;
                %>
                <tr>
                    <td>
                        <div style="display:flex; align-items:center; gap:8px;">
                            <span style="background:#e0f2fe; color:#0369a1; font-weight:700; font-size:0.75rem; padding:2px 8px; border-radius:4px;">
                                Procedure <%= (i + 1) %>
                            </span>
                            <strong><%= tName %></strong>
                        </div>
                        <small style="color:var(--text-muted);">
                            <%= (dbPrice != null) ? "Configured doctor price for " + appointment.getDentistName() : "Standard procedure fee" %>
                        </small>
                    </td>
                    <td>
                        <input type="number" name="treatmentAmount" class="form-control calc-input treatment-amount-field" 
                               step="0.01" value="<%= String.format("%.2f", baseFee) %>" oninput="calculateTotal()" required>
                    </td>
                </tr>
                <% } %>
                <tr>
                    <td>
                        <strong>Doctor Consultation &amp; Diagnosis Fee</strong><br>
                        <small style="color:var(--text-muted);">Clinical examination and consultation</small>
                    </td>
                    <td>
                        <input type="number" id="consultationFee" name="consultationFee" class="form-control calc-input" 
                               step="0.01" value="1500.00" oninput="calculateTotal()" required>
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong>Other Clinical Charges / Sundries / Medicines</strong><br>
                        <small style="color:var(--text-muted);">Sterilization, disposables and supplies</small>
                    </td>
                    <td>
                        <input type="number" id="otherCharges" name="otherCharges" class="form-control calc-input" 
                               step="0.01" value="0.00" oninput="calculateTotal()" required>
                    </td>
                </tr>
                <tr style="background:#f8fafc; font-weight:bold;">
                    <td style="font-size:1.1rem; color:var(--primary);">Calculated Total:</td>
                    <td style="font-size:1.2rem; color:#0369a1;">
                        Rs. <span id="totalDisplay"><%= String.format("%,.2f", initialTreatmentsSum + 1500.00) %></span>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="btn-group" style="margin-top:20px; display:flex; gap:10px;">
            <button type="submit" class="btn btn-primary" style="padding:10px 24px; font-weight:600;">
                🧾 Save Bill and Open Official Printable Receipt
            </button>
            <a href="${pageContext.request.contextPath}/billing" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<script>
    function calculateTotal() {
        var treatmentInputs = document.querySelectorAll('.treatment-amount-field');
        var treatmentTotal = 0;
        treatmentInputs.forEach(function(input) {
            treatmentTotal += parseFloat(input.value) || 0;
        });

        var consultation = parseFloat(document.getElementById('consultationFee').value) || 0;
        var other = parseFloat(document.getElementById('otherCharges').value) || 0;
        var grandTotal = treatmentTotal + consultation + other;

        document.getElementById('totalDisplay').textContent = grandTotal.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
</script>
<% } %>

<%@ include file="/includes/layout-bottom.jsp" %>
