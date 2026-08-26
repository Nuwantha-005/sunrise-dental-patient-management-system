<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.model.Appointment, com.sunrisedental.util.EmailUtil, com.sunrisedental.util.EmailUtil.EmailRecord" %>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Search and Manage Appointment</h1>

<% if ("registered".equals(request.getParameter("success")) || Boolean.TRUE.equals(request.getAttribute("emailSentNotice"))) { %>
    <div class="alert alert-success" style="display:flex; align-items:center; justify-content:space-between; gap:10px;">
        <div>
            <strong>✓ Appointment Registered Successfully!</strong><br>
            <span style="font-size:0.9rem;">📧 An automated appointment confirmation email has been dispatched to the patient.</span>
        </div>
        <button type="button" class="btn btn-sm btn-primary" onclick="openEmailModal()" style="white-space:nowrap;">
            ✉️ Preview Email
        </button>
    </div>
<% } else if ("resent".equals(request.getParameter("success")) || Boolean.TRUE.equals(request.getAttribute("resendNotice"))) { %>
    <div class="alert alert-success" style="display:flex; align-items:center; justify-content:space-between; gap:10px;">
        <div>
            <strong>✓ Email Resent!</strong><br>
            <span style="font-size:0.9rem;">Confirmation email details have been refreshed and sent to the patient.</span>
        </div>
        <button type="button" class="btn btn-sm btn-primary" onclick="openEmailModal()" style="white-space:nowrap;">
            ✉️ Preview Email
        </button>
    </div>
<% } %>

<% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error"><%= request.getAttribute("error") %></div>
<% } %>

<div class="card">
    <form action="${pageContext.request.contextPath}/appointments/search" method="post" class="search-bar">
        <input type="text" name="appointmentNo" class="form-control"
               placeholder="Search by Appointment Number (e.g. APT-001)"
               value="<%= request.getAttribute("appointmentNo") != null ? request.getAttribute("appointmentNo") : "" %>"
               required>
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <%
        Appointment appointment = (Appointment) request.getAttribute("appointment");
        EmailRecord emailRecord = (EmailRecord) request.getAttribute("emailRecord");
        String emailHtml = (String) request.getAttribute("emailHtml");
        if (appointment != null) {
            String badgeClass = "badge-pending";
            if ("Confirmed".equals(appointment.getStatus())) badgeClass = "badge-confirmed";
            else if ("Completed".equals(appointment.getStatus())) badgeClass = "badge-completed";
            else if ("Cancelled".equals(appointment.getStatus())) badgeClass = "badge-cancelled";
    %>
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px; border-bottom:1px solid var(--border); padding-bottom:10px;">
        <h3 style="margin:0;">Appointment Details</h3>
        <span class="badge <%= badgeClass %>" style="font-size:0.9rem;"><%= appointment.getStatus() %></span>
    </div>

    <div class="detail-grid">
        <div class="detail-item"><label>Appointment No</label><span><strong><%= appointment.getAppointmentNo() %></strong></span></div>
        <div class="detail-item"><label>Status</label><span class="badge <%= badgeClass %>"><%= appointment.getStatus() %></span></div>
        <div class="detail-item"><label>Patient Name</label><span><%= appointment.getPatientName() %></span></div>
        <div class="detail-item"><label>Email Address</label><span><%= appointment.getPatientEmail() != null && !appointment.getPatientEmail().isBlank() ? appointment.getPatientEmail() : "<em style='color:#94a3b8;'>Not provided</em>" %></span></div>
        <div class="detail-item"><label>Contact</label><span><%= appointment.getPatientContact() %></span></div>
        <div class="detail-item"><label>Address</label><span><%= appointment.getPatientAddress() != null ? appointment.getPatientAddress() : "-" %></span></div>
        <div class="detail-item"><label>Dentist</label><span><%= appointment.getDentistName() %></span></div>
        <div class="detail-item"><label>Treatment</label><span><%= appointment.getTreatmentType() %></span></div>
        <div class="detail-item"><label>Date and Time</label><span><%= appointment.getAppointmentDate() %> at <%= appointment.getAppointmentTime() %></span></div>
    </div>

    <div class="btn-group" style="margin-top:25px; display:flex; flex-wrap:wrap; gap:10px;">
        <% if (!"Completed".equals(appointment.getStatus()) && !"Cancelled".equals(appointment.getStatus())) { %>
            <a href="${pageContext.request.contextPath}/appointments/complete/<%= appointment.getId() %>"
               class="btn btn-primary"
               style="background:#16a34a; border-color:#16a34a;"
               onclick="return confirm('Mark this appointment as Completed and archive into Booking History?')">
                ✓ Complete Booking
            </a>
        <% } %>
        <button type="button" class="btn btn-primary" onclick="openEmailModal()">
            ✉️ View Sent Email
        </button>
        <a href="${pageContext.request.contextPath}/billing/generate/<%= appointment.getId() %>" class="btn btn-secondary">
            💳 Generate Bill
        </a>
        <a href="${pageContext.request.contextPath}/appointments/resend-email/<%= appointment.getId() %>" class="btn btn-secondary" onclick="return confirm('Resend confirmation email to patient?')">
            🔄 Resend Email
        </a>
        <a href="${pageContext.request.contextPath}/appointments/edit/<%= appointment.getId() %>" class="btn btn-secondary">
            ✏️ Edit
        </a>
        <a href="${pageContext.request.contextPath}/appointments/history" class="btn btn-secondary">
            📜 Booking History
        </a>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
            ← Dashboard
        </a>
    </div>

    <!-- Hidden Raw HTML container for email preview -->
    <textarea id="rawEmailHtml" style="display:none;"><%= emailHtml != null ? emailHtml : "" %></textarea>

    <!-- Email Preview Modal -->
    <div id="emailModal" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.5); backdrop-filter:blur(3px); align-items:center; justify-content:center;">
        <div style="background:#fff; border-radius:12px; max-width:680px; width:92%; max-height:90vh; display:flex; flex-direction:column; box-shadow:0 10px 30px rgba(0,0,0,0.25); overflow:hidden;">
            <div style="padding:15px 20px; background:var(--primary); color:#fff; display:flex; justify-content:space-between; align-items:center;">
                <h4 style="margin:0; font-size:1.1rem;">📧 Automated Patient Email Preview</h4>
                <button type="button" onclick="closeEmailModal()" style="background:transparent; border:none; color:#fff; font-size:1.4rem; cursor:pointer; line-height:1;">&times;</button>
            </div>
            <div style="padding:12px 20px; background:#f8fafc; border-bottom:1px solid #e2e8f0; font-size:0.85rem; color:#475569;">
                <div><strong>To:</strong> <%= appointment.getPatientEmail() != null ? appointment.getPatientEmail() : "patient@example.com" %> (<%= appointment.getPatientName() %>)</div>
                <div><strong>Subject:</strong> Appointment Confirmation [<%= appointment.getAppointmentNo() %>] - Sunrise Dental Clinic</div>
                <% if (emailRecord != null) { %>
                    <div style="margin-top:4px; font-size:0.8rem; color:#0369a1;"><em>Status: <%= emailRecord.getStatusMessage() %> (<%= emailRecord.getTimestamp() %>)</em></div>
                <% } %>
            </div>
            <div style="padding:20px; overflow-y:auto; flex:1; background:#f1f5f9;">
                <iframe id="emailIframe" style="width:100%; min-height:420px; border:none; background:#fff; border-radius:8px; box-shadow:0 1px 4px rgba(0,0,0,0.08);"></iframe>
            </div>
            <div style="padding:12px 20px; background:#f8fafc; border-top:1px solid #e2e8f0; display:flex; justify-content:flex-end; gap:10px;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="closeEmailModal()">Close Preview</button>
                <a href="${pageContext.request.contextPath}/appointments/resend-email/<%= appointment.getId() %>" class="btn btn-primary btn-sm">Resend Now</a>
            </div>
        </div>
    </div>

    <script>
        function openEmailModal() {
            var modal = document.getElementById('emailModal');
            modal.style.display = 'flex';
            var iframe = document.getElementById('emailIframe');
            var rawHtml = document.getElementById('rawEmailHtml').value;
            var doc = iframe.contentWindow || iframe.contentDocument.document || iframe.contentDocument;
            doc = doc.document ? doc.document : doc;
            doc.open();
            doc.write(rawHtml);
            doc.close();
        }

        function closeEmailModal() {
            document.getElementById('emailModal').style.display = 'none';
        }

        window.onclick = function(event) {
            var modal = document.getElementById('emailModal');
            if (event.target === modal) {
                closeEmailModal();
            }
        };
    </script>
    <% } %>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
