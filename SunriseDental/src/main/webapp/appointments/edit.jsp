<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Dentist, com.sunrisedental.model.Appointment, com.sunrisedental.model.Patient, com.sunrisedental.model.Treatment" %>
<%@ include file="/includes/layout-top.jsp" %>
<%
    Appointment appointment = (Appointment) request.getAttribute("appointment");
    List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
    List<Treatment> allTreatments = (List<Treatment>) request.getAttribute("treatments");
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

    <form action="${pageContext.request.contextPath}/appointments/edit/<%= appointment.getId() %>" method="post" id="appointmentEditForm" onsubmit="return validateEditAppointmentForm()">
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
                           value="<%= patientEmail %>" placeholder="e.g. patient@example.com"
                           pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}"
                           title="Please enter a valid email format (e.g. patient@example.com)" required>
                    <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">Must be a valid email format.</small>
                </div>
                <div class="form-group">
                    <label for="contact">Contact Number (10 Digits) *</label>
                    <input type="tel" id="contact" name="contact" class="form-control"
                           value="<%= appointment.getPatientContact() %>"
                           pattern="[0-9]{10}" maxlength="10" minlength="10"
                           title="Contact number must be exactly 10 digits (e.g. 0771234567)"
                           oninput="this.value=this.value.replace(/[^0-9]/g,'')" required>
                    <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">Must contain exactly 10 numeric digits.</small>
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
                    <select id="dentistId" name="dentistId" class="form-control" onchange="onDentistChanged()" required>
                        <% for (Dentist d : dentists) { %>
                        <option value="<%= d.getId() %>" <%= d.getId() == appointment.getDentistId() ? "selected" : "" %>>
                            <%= d.getDentistCode() %> — <%= d.getName() %> (<%= d.getSpecialization() %>)
                        </option>
                        <% } %>
                    </select>
                </div>

                <%-- Dynamic Multi-Treatment Section (Filtered by Dentist) --%>
                <div class="form-group">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                        <label style="margin:0;">Assigned Dentist Treatments *</label>
                        <button type="button" onclick="addTreatmentRow()" class="btn btn-primary btn-sm" style="padding:4px 12px; font-size:0.8rem; display:inline-flex; align-items:center; gap:4px;">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            Add Treatment
                        </button>
                    </div>
                    <div id="treatmentContainer">
                        <!-- Loaded dynamically via JS -->
                    </div>
                    <small id="treatmentHelperText" style="color:var(--text-muted); font-size:0.8rem;">Click <strong>+ Add Treatment</strong> to append additional procedures for this doctor.</small>
                </div>

                <div class="form-group">
                    <label for="appointmentDate">Date *</label>
                    <input type="date" id="appointmentDate" name="appointmentDate" class="form-control"
                           value="<%= appointment.getAppointmentDate() %>" onchange="checkDoctorAvailabilityDate()" required>
                    <div id="doctorAvailabilityWarning" style="display:none; background:#fef2f2; border:1.5px solid #ef4444; color:#991b1b; padding:10px 14px; border-radius:8px; margin-top:8px; font-size:0.88rem;"></div>
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
            <a href="${pageContext.request.contextPath}/appointments/history" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<script>
// ========== Dentist Treatments Data Map ==========
const dentistTreatmentsMap = {
<%
    if (allTreatments != null) {
        java.util.Map<Integer, java.util.List<Treatment>> grouped = new java.util.HashMap<>();
        for (Treatment t : allTreatments) {
            grouped.computeIfAbsent(t.getDentistId(), k -> new java.util.ArrayList<>()).add(t);
        }
        for (java.util.Map.Entry<Integer, java.util.List<Treatment>> entry : grouped.entrySet()) {
%>
    "<%= entry.getKey() %>": [
        <% for (Treatment t : entry.getValue()) { %>
        { name: "<%= t.getTreatmentName().replace("\"", "\\\"") %>", price: "<%= String.format("%,.2f", t.getPrice()) %>", availableDays: "<%= t.getAvailableDays().replace("\"", "\\\"") %>" },
        <% } %>
    ],
<%      }
    }
%>
};

let initialSavedTreatments = [
<%
    if (appointment.getTreatmentType() != null) {
        String[] parts = appointment.getTreatmentType().split(",\\s*");
        for (String p : parts) {
%>
    "<%= p.trim().replace("\"", "\\\"") %>",
<%      }
    }
%>
];

function buildTreatmentOptionsHTML(dentistId, selectedValue) {
    const list = dentistTreatmentsMap[dentistId];
    let html = '';
    if (!dentistId || !list || list.length === 0) {
        if (selectedValue) {
            html += '<option value="' + selectedValue + '" selected>' + selectedValue + '</option>';
        }
        html += '<option value="">-- No treatments found for this dentist --</option>';
        return html;
    }
    html += '<option value="">-- Select Treatment Procedure --</option>';
    let matched = false;
    list.forEach(function(item) {
        const isSel = (selectedValue && (selectedValue.toLowerCase() === item.name.toLowerCase())) ? 'selected' : '';
        if (isSel) matched = true;
        html += '<option value="' + item.name + '" ' + isSel + '>' + item.name + ' — Rs. ' + item.price + ' (' + item.availableDays + ')</option>';
    });
    if (selectedValue && !matched) {
        html += '<option value="' + selectedValue + '" selected>' + selectedValue + ' (Current)</option>';
    }
    return html;
}

function onDentistChanged() {
    const dentistSelect = document.getElementById('dentistId');
    const dentistId = dentistSelect.value;
    const container = document.getElementById('treatmentContainer');
    const helper = document.getElementById('treatmentHelperText');

    if (!dentistId) {
        container.innerHTML = '<div style="background:#f8fafc; border:1px dashed #cbd5e1; padding:12px; border-radius:6px; color:#64748b; font-size:0.88rem; text-align:center;">👈 Please select a dentist first to see their available procedures.</div>';
        helper.textContent = 'Select a dentist above to view their available treatments & pricing.';
        checkDoctorAvailabilityDate();
        return;
    }

    const availableTreatments = dentistTreatmentsMap[dentistId] || [];
    helper.innerHTML = 'Showing <strong>' + availableTreatments.length + '</strong> treatments available with this doctor. Click <strong>+ Add Treatment</strong> for multiple procedures.';

    const rowsToCreate = (initialSavedTreatments.length > 0) ? initialSavedTreatments : [''];
    container.innerHTML = '';

    rowsToCreate.forEach(function(savedVal) {
        createTreatmentRowElement(dentistId, savedVal);
    });

    initialSavedTreatments = [];
    checkDoctorAvailabilityDate();
}

function createTreatmentRowElement(dentistId, selectedValue) {
    const container = document.getElementById('treatmentContainer');
    const row = document.createElement('div');
    row.className = 'treatment-row';
    row.style.cssText = 'display:flex; align-items:center; gap:8px; margin-bottom:8px;';

    const optionsHtml = buildTreatmentOptionsHTML(dentistId, selectedValue);

    row.innerHTML = '<select name="treatmentType" class="form-control" required style="flex:1;" onchange="checkDoctorAvailabilityDate()">'
        + optionsHtml
        + '</select>'
        + '<button type="button" onclick="removeTreatmentRow(this)" style="background:none; border:none; color:#ef4444; cursor:pointer; font-size:1.3rem; padding:4px;" title="Remove this treatment">✕</button>';

    container.appendChild(row);
    return row;
}

function addTreatmentRow() {
    const dentistId = document.getElementById('dentistId').value;
    if (!dentistId) {
        alert('Please select a dentist first.');
        document.getElementById('dentistId').focus();
        return;
    }
    const newRow = createTreatmentRowElement(dentistId, '');
    newRow.querySelector('select').focus();
    checkDoctorAvailabilityDate();
}

function removeTreatmentRow(btn) {
    const container = document.getElementById('treatmentContainer');
    const rows = container.querySelectorAll('.treatment-row');
    if (rows.length <= 1) {
        alert('At least one treatment procedure is required.');
        return;
    }
    btn.closest('.treatment-row').remove();
    checkDoctorAvailabilityDate();
}

function checkDoctorAvailabilityDate() {
    const dentistId = document.getElementById('dentistId').value;
    const dateInput = document.getElementById('appointmentDate');
    const warningBox = document.getElementById('doctorAvailabilityWarning');
    if (!warningBox || !dateInput) return true;

    if (!dentistId || !dateInput.value) {
        warningBox.style.display = 'none';
        dateInput.style.borderColor = '';
        return true;
    }

    const parts = dateInput.value.split('-');
    if (parts.length !== 3) return true;
    const dateObj = new Date(parts[0], parts[1] - 1, parts[2]);
    const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const selectedDayName = daysOfWeek[dateObj.getDay()];

    const dentistTreatments = dentistTreatmentsMap[dentistId] || [];
    const selectedTreatmentSelects = document.querySelectorAll('#treatmentContainer select[name="treatmentType"]');
    
    let unavailableTreatments = [];

    selectedTreatmentSelects.forEach(function(sel) {
        const val = sel.value;
        if (val) {
            const matched = dentistTreatments.find(t => t.name === val);
            if (matched && matched.availableDays) {
                if (!matched.availableDays.toLowerCase().includes(selectedDayName.toLowerCase())) {
                    unavailableTreatments.push({ name: matched.name, days: matched.availableDays });
                }
            }
        }
    });

    if (unavailableTreatments.length > 0) {
        let msg = '⚠️ <strong>Doctor Schedule Availability Alert:</strong> The selected dentist is <strong>NOT available on ' + selectedDayName + 's</strong> for: <ul style="margin:4px 0 0 18px;">';
        unavailableTreatments.forEach(function(item) {
            msg += '<li><strong>' + item.name + '</strong> (Doctor\'s available days: <em>' + item.days + '</em>)</li>';
        });
        msg += '</ul>Please select an appointment date matching the doctor\'s available schedule.';
        
        warningBox.innerHTML = msg;
        warningBox.style.display = 'block';
        dateInput.style.borderColor = '#ef4444';
        return false;
    } else {
        warningBox.style.display = 'none';
        dateInput.style.borderColor = '';
        return true;
    }
}

function validateEditAppointmentForm() {
    var name = document.getElementById('patientName').value.trim();
    var email = document.getElementById('email').value.trim();
    var contact = document.getElementById('contact').value.trim();
    var dentistId = document.getElementById('dentistId').value;
    var appDate = document.getElementById('appointmentDate').value;
    var appTime = document.getElementById('appointmentTime').value;

    if (!name) {
        alert("Please enter the patient's full name.");
        document.getElementById('patientName').focus();
        return false;
    }

    var emailRegex = /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;
    if (!email || !emailRegex.test(email)) {
        alert("Please enter a valid email address (e.g. patient@example.com).");
        document.getElementById('email').focus();
        return false;
    }

    var contactRegex = /^[0-9]{10}$/;
    if (!contactRegex.test(contact)) {
        alert("Contact number must contain exactly 10 digits (e.g. 0771234567).");
        document.getElementById('contact').focus();
        return false;
    }

    if (!dentistId) {
        alert("Please select a Dentist.");
        document.getElementById('dentistId').focus();
        return false;
    }

    var treatmentSelects = document.querySelectorAll('#treatmentContainer select[name="treatmentType"]');
    var hasSelectedTreatment = false;
    treatmentSelects.forEach(function(sel) {
        if (sel.value && sel.value.trim().length > 0) {
            hasSelectedTreatment = true;
        }
    });

    if (!hasSelectedTreatment) {
        alert("Please select at least one treatment procedure.");
        return false;
    }

    if (!appDate) {
        alert("Please select an appointment date.");
        document.getElementById('appointmentDate').focus();
        return false;
    }

    if (!appTime) {
        alert("Please select an appointment time.");
        document.getElementById('appointmentTime').focus();
        return false;
    }

    if (!checkDoctorAvailabilityDate()) {
        alert("The selected appointment date is not valid for the assigned dentist's schedule.");
        return false;
    }

    return true;
}

window.addEventListener('DOMContentLoaded', function() {
    onDentistChanged();
});
</script>

<%@ include file="/includes/layout-bottom.jsp" %>
