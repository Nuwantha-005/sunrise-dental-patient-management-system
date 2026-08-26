<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Dentist, com.sunrisedental.model.Patient" %>
<%@ include file="/includes/layout-top.jsp" %>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
    <div>
        <h1 class="page-title" style="margin:0;">Register New Appointment</h1>
        <p style="color:var(--text-muted); margin-top:4px; font-size:0.92rem;">Book a new consultation or treatment for a registered or new patient.</p>
    </div>
</div>

<div class="card">
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div style="background:#fef2f2; border:1.5px solid #ef4444; color:#991b1b; border-radius:8px; padding:14px 18px; margin-bottom:20px; font-size:0.95rem; display:flex; align-items:center; gap:10px;">
        <span style="font-size:1.4rem;">🚫</span>
        <div><%= request.getAttribute("errorMessage") %></div>
    </div>
    <% } %>

    <!-- Auto-fill Notification Badge -->
    <div id="patientAutofillBadge" style="display:none; background:#ecfdf5; border:1.5px solid #10b981; color:#065f46; border-radius:8px; padding:12px 16px; margin-bottom:20px; font-size:0.92rem; justify-content:space-between; align-items:center;">
        <div style="display:flex; align-items:center; gap:8px;">
            <span style="font-size:1.2rem;">✅</span>
            <span>Auto-filled details for registered patient: <strong id="autofillPatientName"></strong> (<span id="autofillPatientContact"></span>)</span>
        </div>
        <button type="button" onclick="clearAutofilledPatient()" style="background:none; border:none; color:#065f46; font-weight:700; cursor:pointer; font-size:0.85rem; text-decoration:underline;">
            Clear / Enter New
        </button>
    </div>

    <form action="${pageContext.request.contextPath}/appointments/register" method="post">
        <input type="hidden" id="patientId" name="patientId" value="<%= request.getAttribute("inputPatientId") != null ? request.getAttribute("inputPatientId") : "" %>">
        <div class="form-grid">
            <div>
                <div class="form-group">
                    <label>Appointment No</label>
                    <input type="text" class="form-control" value="<%= request.getAttribute("nextAppointmentNo") %>" readonly>
                </div>
                <div class="form-group">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                        <label for="contact" style="margin:0;">Contact Number *</label>
                        <button type="button" onclick="openPatientSearchModal()" style="background:none; border:none; color:var(--primary); font-size:0.82rem; font-weight:600; cursor:pointer; padding:0; display:flex; align-items:center; gap:4px;">
                            🔍 Search Registered Patient
                        </button>
                    </div>
                    <input type="text" id="contact" name="contact" class="form-control" 
                           placeholder="e.g. 0771234567" 
                           value="<%= request.getAttribute("inputContact") != null ? request.getAttribute("inputContact") : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="patientName">Patient Name *</label>
                    <input type="text" id="patientName" name="patientName" class="form-control" 
                           placeholder="e.g. John Smith" 
                           value="<%= request.getAttribute("inputPatientName") != null ? request.getAttribute("inputPatientName") : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="email">Patient Email Address *</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="e.g. patient@example.com" 
                           value="<%= request.getAttribute("inputEmail") != null ? request.getAttribute("inputEmail") : "" %>" required>
                    <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">
                        📧 An automated appointment confirmation with schedule and clinic details will be sent to this email.
                    </small>
                </div>
                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" class="form-control" 
                           placeholder="e.g. 123 Main Street, Colombo"
                           value="<%= request.getAttribute("inputAddress") != null ? request.getAttribute("inputAddress") : "" %>">
                </div>
            </div>
            <div>
                <div class="form-group">
                    <label for="dentistId">Select Dentist *</label>
                    <select id="dentistId" name="dentistId" class="form-control" required>
                        <option value="">-- Select Dentist --</option>
                        <%
                            List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
                            Object selectedDentistObj = request.getAttribute("inputDentistId");
                            Integer selectedDentistId = (selectedDentistObj instanceof Integer) ? (Integer) selectedDentistObj : null;
                            if (dentists != null) {
                                for (Dentist d : dentists) {
                                    boolean isSel = selectedDentistId != null && selectedDentistId == d.getId();
                        %>
                        <option value="<%= d.getId() %>" <%= isSel ? "selected" : "" %>><%= d.getName() %> - <%= d.getSpecialization() %></option>
                        <%      }
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="treatmentType">Treatment Type *</label>
                    <%
                        String selTreat = (String) request.getAttribute("inputTreatmentType");
                    %>
                    <select id="treatmentType" name="treatmentType" class="form-control" required>
                        <option value="">-- Select Treatment --</option>
                        <option value="Teeth Cleaning" <%= "Teeth Cleaning".equals(selTreat) ? "selected" : "" %>>Teeth Cleaning</option>
                        <option value="Root Canal" <%= "Root Canal".equals(selTreat) ? "selected" : "" %>>Root Canal</option>
                        <option value="Teeth Whitening" <%= "Teeth Whitening".equals(selTreat) ? "selected" : "" %>>Teeth Whitening</option>
                        <option value="Braces Adjustment" <%= "Braces Adjustment".equals(selTreat) ? "selected" : "" %>>Braces Adjustment</option>
                        <option value="Dental Checkup" <%= "Dental Checkup".equals(selTreat) ? "selected" : "" %>>Dental Checkup</option>
                        <option value="Tooth Extraction" <%= "Tooth Extraction".equals(selTreat) ? "selected" : "" %>>Tooth Extraction</option>
                        <option value="Filling" <%= "Filling".equals(selTreat) ? "selected" : "" %>>Filling</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="appointmentDate">Appointment Date *</label>
                    <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" 
                           value="<%= request.getAttribute("inputAppointmentDate") != null ? request.getAttribute("inputAppointmentDate") : "" %>" required>
                </div>
                <div class="form-group">
                    <label for="appointmentTime">Appointment Time *</label>
                    <input type="time" id="appointmentTime" name="appointmentTime" class="form-control" 
                           value="<%= request.getAttribute("inputAppointmentTime") != null ? request.getAttribute("inputAppointmentTime") : "" %>" required>
                </div>
            </div>
        </div>
        <div class="btn-group" style="margin-top:20px;">
            <button type="reset" class="btn btn-secondary" onclick="clearAutofilledPatient()">Reset</button>
            <button type="submit" class="btn btn-primary">Save Appointment and Send Email</button>
        </div>
    </form>
</div>

<div class="card" style="margin-top: 14px; display:flex; gap:12px; align-items:center; flex-wrap:wrap;">
    <a href="${pageContext.request.contextPath}/appointments/search" class="btn btn-secondary btn-sm" style="display:inline-flex; align-items:center; gap:6px;">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        Search Existing Appointment
    </a>
    <button type="button" class="btn btn-primary btn-sm" onclick="openPatientSearchModal()" style="display:inline-flex; align-items:center; gap:6px;">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
        Search Patients
    </button>
</div>

<!-- Modal for Searching Registered Patients by Contact Number -->
<div id="patientSearchModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.55); z-index:2500; align-items:center; justify-content:center; padding:20px;">
    <div style="background:white; border-radius:12px; padding:28px; max-width:760px; width:100%; box-shadow:0 12px 36px rgba(0,0,0,0.25); position:relative; max-height:88vh; display:flex; flex-direction:column;">
        <button onclick="closePatientSearchModal()" style="position:absolute; top:16px; right:16px; background:none; border:none; font-size:1.5rem; cursor:pointer; color:var(--text-muted);">&times;</button>
        
        <div style="margin-bottom:16px;">
            <h3 style="margin:0 0 4px; color:var(--primary-dark); font-size:1.3rem; display:flex; align-items:center; gap:8px;">
                <span>📞</span> Search Patient by Contact Number
            </h3>
            <p style="color:var(--text-muted); font-size:0.88rem; margin:0;">Enter patient's contact number to quickly find and auto-fill their details.</p>
        </div>

        <div style="margin-bottom:14px; position:relative;">
            <input type="text" id="patientContactSearchInput" 
                   onkeyup="filterPatientTable()" 
                   placeholder="Type contact number (e.g. 077... / 071...) or patient name..." 
                   class="form-control" 
                   style="padding:12px 16px; font-size:1rem; border:2px solid var(--primary-light); background:#f8fafc;" 
                   autofocus>
        </div>

        <div style="overflow-y:auto; flex:1; border:1px solid #e2e8f0; border-radius:8px;">
            <table class="data-table" id="patientsLookupTable" style="margin:0;">
                <thead>
                    <tr style="position:sticky; top:0; background:#f1f5f9; z-index:1;">
                        <th>Contact No</th>
                        <th>Patient Name</th>
                        <th>Email</th>
                        <th>Address</th>
                        <th style="text-align:center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    List<Patient> patientList = (List<Patient>) request.getAttribute("patients");
                    if (patientList != null && !patientList.isEmpty()) {
                        for (Patient p : patientList) {
                            String cNo = p.getContact() != null ? p.getContact() : "";
                            String pName = p.getName() != null ? p.getName() : "";
                            String pEmail = p.getEmail() != null ? p.getEmail() : "";
                            String pAddr = p.getAddress() != null ? p.getAddress() : "";
                %>
                    <tr class="patient-row" data-contact="<%= cNo.toLowerCase() %>" data-name="<%= pName.toLowerCase() %>" data-email="<%= pEmail.toLowerCase() %>">
                        <td>
                            <strong style="color:var(--primary-dark); font-size:0.95rem;">📞 <%= cNo %></strong>
                        </td>
                        <td>
                            <strong><%= pName %></strong>
                        </td>
                        <td>
                            <%= (!pEmail.isBlank()) ? pEmail : "<span style='color:#94a3b8;'>—</span>" %>
                        </td>
                        <td>
                            <span style="font-size:0.85rem; color:var(--text-muted);"><%= (!pAddr.isBlank()) ? pAddr : "—" %></span>
                        </td>
                        <td style="text-align:center; white-space:nowrap;">
                            <button type="button" 
                                    class="btn btn-primary btn-sm" 
                                    onclick="selectPatient('<%= p.getId() %>', '<%= pName.replace("'", "\\'") %>', '<%= cNo.replace("'", "\\'") %>', '<%= pEmail.replace("'", "\\'") %>', '<%= pAddr.replace("'", "\\'") %>')"
                                    style="padding:5px 12px; font-size:0.82rem;">
                                Select &amp; Autofill
                            </button>
                        </td>
                    </tr>
                <%      }
                    } else { %>
                    <tr id="noPatientsInitialRow">
                        <td colspan="5" style="text-align:center; padding:24px; color:var(--text-muted);">
                            No registered patients found in system.
                        </td>
                    </tr>
                <% } %>
                    <tr id="noMatchingPatientsRow" style="display:none;">
                        <td colspan="5" style="text-align:center; padding:28px; color:var(--text-muted);">
                            ❌ No patient found matching that contact number.
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:16px;">
            <span style="font-size:0.82rem; color:var(--text-muted);">Tip: Click <strong>Select &amp; Autofill</strong> to transfer patient details into the form.</span>
            <button type="button" class="btn btn-secondary btn-sm" onclick="closePatientSearchModal()">Cancel</button>
        </div>
    </div>
</div>

<script>
function openPatientSearchModal() {
    var modal = document.getElementById('patientSearchModal');
    modal.style.display = 'flex';
    var input = document.getElementById('patientContactSearchInput');
    // If contact number is already typed in form, prefill the search
    var existingContact = document.getElementById('contact').value.trim();
    if (existingContact) {
        input.value = existingContact;
    }
    input.focus();
    filterPatientTable();
}

function closePatientSearchModal() {
    document.getElementById('patientSearchModal').style.display = 'none';
}

function filterPatientTable() {
    var query = document.getElementById('patientContactSearchInput').value.toLowerCase().trim();
    var rows = document.querySelectorAll('.patient-row');
    var matchCount = 0;

    rows.forEach(function(row) {
        var contact = row.getAttribute('data-contact') || '';
        var name = row.getAttribute('data-name') || '';
        var email = row.getAttribute('data-email') || '';

        if (!query || contact.includes(query) || name.includes(query) || email.includes(query)) {
            row.style.display = '';
            matchCount++;
        } else {
            row.style.display = 'none';
        }
    });

    var noMatchRow = document.getElementById('noMatchingPatientsRow');
    if (noMatchRow) {
        noMatchRow.style.display = (rows.length > 0 && matchCount === 0) ? '' : 'none';
    }
}

function selectPatient(id, name, contact, email, address) {
    document.getElementById('patientId').value = id || '';
    document.getElementById('patientName').value = name || '';
    document.getElementById('contact').value = contact || '';
    document.getElementById('email').value = email || '';
    document.getElementById('address').value = address || '';

    // Show badge
    var badge = document.getElementById('patientAutofillBadge');
    document.getElementById('autofillPatientName').textContent = name;
    document.getElementById('autofillPatientContact').textContent = contact;
    badge.style.display = 'flex';

    closePatientSearchModal();

    // Focus on dentist selection for next step
    document.getElementById('dentistId').focus();
}

function clearAutofilledPatient() {
    document.getElementById('patientId').value = '';
    document.getElementById('patientName').value = '';
    document.getElementById('contact').value = '';
    document.getElementById('email').value = '';
    document.getElementById('address').value = '';
    document.getElementById('patientAutofillBadge').style.display = 'none';
}

document.getElementById('patientSearchModal').addEventListener('click', function(e) {
    if (e.target === this) closePatientSearchModal();
});
</script>

<%@ include file="/includes/layout-bottom.jsp" %>
