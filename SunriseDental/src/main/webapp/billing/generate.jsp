<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Appointment, com.sunrisedental.model.Bill" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    Bill bill = (Bill) request.getAttribute("bill");
%>

<h1 class="page-title">Generate Patient Bill</h1>

<div class="card" style="margin-bottom: 20px;">
    <h3 style="margin-bottom:15px; color:var(--primary);">Appointment Information</h3>
    <div class="detail-grid">
        <div class="detail-item"><label>Appointment No</label><span><strong><%= appointment.getAppointmentNo() %></strong></span></div>
        <div class="detail-item"><label>Patient Name</label><span><%= appointment.getPatientName() %></span></div>
        <div class="detail-item"><label>Dentist</label><span><%= appointment.getDentistName() %></span></div>
        <div class="detail-item"><label>Treatment</label><span><%= appointment.getTreatmentType() %></span></div>
    </div>
</div>

<% if (bill != null) { %>
    <div class="card" style="text-align:center; padding:30px;">
        <div style="color:#16a34a; font-size:1.2rem; font-weight:700; margin-bottom:10px;">
            ✓ Bill already generated for this appointment!
        </div>
        <p style="color:var(--text-muted); margin-bottom:20px;">Bill Number: <strong><%= bill.getBillNo() %></strong> &bull; Total: <strong>Rs. <%= bill.getTotalAmount() %></strong></p>
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
                <tr>
                    <td>
                        <strong>Dental Treatment (<%= appointment.getTreatmentType() %>)</strong><br>
                        <small style="color:var(--text-muted);">Standard procedure fee</small>
                    </td>
                    <td>
                        <input type="number" id="treatmentAmount" name="treatmentAmount" class="form-control calc-input" step="0.01" value="5000.00" oninput="calculateTotal()" required>
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong>Consultation Fee</strong><br>
                        <small style="color:var(--text-muted);">Doctor examination and diagnosis</small>
                    </td>
                    <td>
                        <input type="number" id="consultationFee" name="consultationFee" class="form-control calc-input" step="0.01" value="1500.00" oninput="calculateTotal()" required>
                    </td>
                </tr>
                <tr>
                    <td>
                        <strong>Other Clinical Charges / Medicines</strong><br>
                        <small style="color:var(--text-muted);">Sterilization, sundries and supplies</small>
                    </td>
                    <td>
                        <input type="number" id="otherCharges" name="otherCharges" class="form-control calc-input" step="0.01" value="0.00" oninput="calculateTotal()" required>
                    </td>
                </tr>
                <tr style="background:#f8fafc; font-weight:bold;">
                    <td style="font-size:1.1rem; color:var(--primary);">Calculated Total:</td>
                    <td style="font-size:1.15rem; color:#0369a1;">
                        Rs. <span id="totalDisplay">6,500.00</span>
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
        var treatment = parseFloat(document.getElementById('treatmentAmount').value) || 0;
        var consultation = parseFloat(document.getElementById('consultationFee').value) || 0;
        var other = parseFloat(document.getElementById('otherCharges').value) || 0;
        var total = treatment + consultation + other;
        document.getElementById('totalDisplay').textContent = total.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
</script>
<% } %>

<%@ include file="/includes/layout-bottom.jsp" %>
