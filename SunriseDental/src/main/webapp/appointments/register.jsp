<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Dentist, com.sunrisedental.model.Patient, com.sunrisedental.model.Treatment" %>
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

    <form action="${pageContext.request.contextPath}/appointments/register" method="post" id="appointmentForm" onsubmit="return validateAppointmentForm()">
        <input type="hidden" id="patientId" name="patientId" value="<%= request.getAttribute("inputPatientId") != null ? request.getAttribute("inputPatientId") : "" %>">
        <div class="form-grid">
            <div>
                <div class="form-group">
                    <label>Appointment No</label>
                    <input type="text" class="form-control" value="<%= request.getAttribute("nextAppointmentNo") %>" readonly>
                </div>
                <div class="form-group">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
                        <label for="contact" style="margin:0;">Contact Number (10 Digits) *</label>
                        <button type="button" onclick="openPatientSearchModal()" style="background:none; border:none; color:var(--primary); font-size:0.82rem; font-weight:600; cursor:pointer; padding:0; display:flex; align-items:center; gap:4px;">
                            🔍 Search Registered Patient
                        </button>
                    </div>
                    <input type="tel" id="contact" name="contact" class="form-control" 
                           placeholder="e.g. 0771234567" 
                           pattern="[0-9]{10}" maxlength="10" minlength="10"
                           title="Contact number must be exactly 10 digits (e.g. 0771234567)"
                           oninput="this.value=this.value.replace(/[^0-9]/g,'')"
                           value="<%= request.getAttribute("inputContact") != null ? request.getAttribute("inputContact") : "" %>" required>
                    <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">Must contain exactly 10 numeric digits.</small>
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
                           pattern="[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}"
                           title="Please enter a valid email format (e.g. patient@example.com)"
                           value="<%= request.getAttribute("inputEmail") != null ? request.getAttribute("inputEmail") : "" %>" required>
                    <small style="color: #64748b; font-size: 0.82rem; margin-top: 4px; display: block;">
                        📧 Automated appointment confirmation and portal credentials will be sent to this email address.
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
                    <select id="dentistId" name="dentistId" class="form-control" onchange="onDentistChanged()" required>
                        <option value="">-- Select Dentist --</option>
                        <%
                            List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
                            Object selectedDentistObj = request.getAttribute("inputDentistId");
                            Integer selectedDentistId = (selectedDentistObj instanceof Integer) ? (Integer) selectedDentistObj : null;
                            if (dentists != null) {
                                for (Dentist d : dentists) {
                                    boolean isSel = selectedDentistId != null && selectedDentistId == d.getId();
                        %>
                        <option value="<%= d.getId() %>" <%= isSel ? "selected" : "" %>><%= d.getDentistCode() %> — <%= d.getName() %> (<%= d.getSpecialization() %>)</option>
                        <%      }
                            }
                        %>
                    </select>
                </div>

                <%-- Dynamic Multi-Treatment Section (Filtered by Dentist) --%>
                <div class="form-group">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                        <label style="margin:0;">Assigned Dentist Treatments *</label>
                        <button type="button" id="btnAddTreatment" onclick="addTreatmentRow()" class="btn btn-primary btn-sm" style="padding:4px 12px; font-size:0.8rem; display:inline-flex; align-items:center; gap:4px;">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            Add Treatment
                        </button>
                    </div>
                    <div id="treatmentContainer">
                        <!-- Populated dynamically based on chosen Dentist -->
                    </div>
                    <small id="treatmentHelperText" style="color:var(--text-muted); font-size:0.8rem;">Select a dentist above to view their available treatments &amp; pricing.</small>
                </div>

                <div class="form-group">
                    <label for="appointmentDate">Appointment Date *</label>
                    <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" 
                           value="<%= request.getAttribute("inputAppointmentDate") != null ? request.getAttribute("inputAppointmentDate") : "" %>"
                           onchange="checkDoctorAvailabilityDate()" required>
                    <div id="doctorAvailabilityWarning" style="display:none; background:#fef2f2; border:1.5px solid #ef4444; color:#991b1b; padding:10px 14px; border-radius:8px; margin-top:8px; font-size:0.88rem;"></div>
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

// ========== Dentist Treatments Data Map ==========
<%
    List<Treatment> allTreatments = (List<Treatment>) request.getAttribute("treatments");
    String[] savedTreatments = (String[]) request.getAttribute("inputTreatments");
%>
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
    if (savedTreatments != null) {
        for (String st : savedTreatments) {
%>
    "<%= st.replace("\"", "\\\"") %>",
<%      }
    }
%>
];

function buildTreatmentOptionsHTML(dentistId, selectedValue) {
    const list = dentistTreatmentsMap[dentistId];
    let html = '';
    if (!dentistId || !list || list.length === 0) {
        html = '<option value="">-- No treatments found for this dentist --</option>';
        return html;
    }
    html += '<option value="">-- Select Treatment Procedure --</option>';
    list.forEach(function(item) {
        const isSel = (selectedValue && (selectedValue === item.name || selectedValue.startsWith(item.name))) ? 'selected' : '';
        html += '<option value="' + item.name + '" ' + isSel + '>' + item.name + ' — Rs. ' + item.price + ' (' + item.availableDays + ')</option>';
    });
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
    if (availableTreatments.length === 0) {
        container.innerHTML = '<div style="background:#fffbeb; border:1px solid #fde68a; padding:12px; border-radius:6px; color:#92400e; font-size:0.88rem;">⚠️ No treatments currently configured for this dentist. Please configure treatments in Admin Dashboard &gt; Treatments.</div>';
        helper.textContent = 'No procedures assigned to this doctor yet.';
        checkDoctorAvailabilityDate();
        return;
    }

    helper.innerHTML = 'Showing <strong>' + availableTreatments.length + '</strong> treatments available with this doctor. Click <strong>+ Add Treatment</strong> for multiple procedures.';

    const rowsToCreate = (initialSavedTreatments.length > 0) ? initialSavedTreatments : [''];
    container.innerHTML = '';

    rowsToCreate.forEach(function(savedVal) {
        createTreatmentRowElement(dentistId, savedVal);
    });

    initialSavedTreatments = [];
    checkDuplicateTreatments();
    checkDoctorAvailabilityDate();
}

function createTreatmentRowElement(dentistId, selectedValue) {
    const container = document.getElementById('treatmentContainer');
    const row = document.createElement('div');
    row.className = 'treatment-row';
    row.style.cssText = 'display:flex; align-items:center; gap:8px; margin-bottom:8px;';

    const optionsHtml = buildTreatmentOptionsHTML(dentistId, selectedValue);

    row.innerHTML = '<select name="treatmentType" class="form-control" required style="flex:1;" onchange="onTreatmentSelectChanged()">'
        + optionsHtml
        + '</select>'
        + '<button type="button" onclick="removeTreatmentRow(this)" style="background:none; border:none; color:#ef4444; cursor:pointer; font-size:1.3rem; padding:4px;" title="Remove this treatment">✕</button>';

    container.appendChild(row);
    return row;
}

function onTreatmentSelectChanged() {
    checkDuplicateTreatments();
    checkDoctorAvailabilityDate();
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
    checkDuplicateTreatments();
    checkDoctorAvailabilityDate();
}

function checkDuplicateTreatments() {
    const selects = document.querySelectorAll('#treatmentContainer select[name="treatmentType"]');
    const values = [];
    selects.forEach(function(sel) {
        sel.style.borderColor = '';
        if (sel.value && values.indexOf(sel.value) !== -1) {
            sel.style.borderColor = '#ef4444';
        }
        if (sel.value) values.push(sel.value);
    });
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

function validateAppointmentForm() {
    var contact = document.getElementById('contact').value.trim();
    var name = document.getElementById('patientName').value.trim();
    var email = document.getElementById('email').value.trim();
    var dentistId = document.getElementById('dentistId').value;
    var appDate = document.getElementById('appointmentDate').value;
    var appTime = document.getElementById('appointmentTime').value;

    if (!contact) {
        alert("Please enter the patient's contact number.");
        document.getElementById('contact').focus();
        return false;
    }

    var contactRegex = /^[0-9]{10}$/;
    if (!contactRegex.test(contact)) {
        alert("Contact number must contain exactly 10 digits (e.g. 0771234567).");
        document.getElementById('contact').focus();
        return false;
    }

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

    if (!dentistId) {
        alert("Please select a Dentist for the appointment.");
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
        alert("Please select at least one treatment procedure for the appointment.");
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
