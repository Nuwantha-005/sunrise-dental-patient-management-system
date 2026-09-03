<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.ContactMessage, java.text.SimpleDateFormat" %>
<%@ include file="/includes/layout-top.jsp" %>

<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
    <div>
        <h1 class="page-title" style="margin:0;">Contact Messages</h1>
        <p style="color:var(--text-muted); margin-top:4px; font-size:0.92rem;">Inquiries and feedback submitted through the public website Contact page.</p>
    </div>
</div>

<% if ("deleted".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success" style="display:flex; align-items:center; gap:8px; margin-bottom:20px; background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:12px 16px;">
        <span style="font-size:1.2rem;">🗑️</span>
        <span><strong>Message Deleted:</strong> The selected contact message has been permanently deleted.</span>
    </div>
<% } else if ("unauthorized".equals(request.getParameter("error"))) { %>
    <div class="alert alert-danger" style="display:flex; align-items:center; gap:8px; margin-bottom:20px; background:#fef2f2; border:1px solid #ef4444; color:#991b1b; border-radius:8px; padding:12px 16px;">
        <span style="font-size:1.2rem;">⚠️</span>
        <span><strong>Access Denied:</strong> Only Administrators are authorized to delete contact messages.</span>
    </div>
<% } %>

<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
        <h3 style="margin:0;">All Inquiries</h3>
        <small style="color:var(--text-muted);">Showing recent messages</small>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Sender</th>
                <th>Subject</th>
                <th>Message</th>
                <th>Phone</th>
                <th>Received At</th>
                <th style="text-align:center;">Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            List<ContactMessage> messages = (List<ContactMessage>) request.getAttribute("messages");
            if (messages != null && !messages.isEmpty()) {
                int i = 1;
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
                for (ContactMessage m : messages) {
                    String timeStr = m.getCreatedAt() != null ? sdf.format(m.getCreatedAt()) : "—";
                    String msg = m.getMessage() != null ? m.getMessage() : "";
                    String preview = msg.length() > 60 ? msg.substring(0, 60) + "…" : msg;
        %>
            <tr>
                <td><%= i++ %></td>
                <td>
                    <div style="font-weight:700; color:var(--primary-dark);"><%= m.getFullName() %></div>
                    <div style="font-size:0.82rem; color:var(--text-muted);"><%= m.getEmail() %></div>
                </td>
                <td>
                    <span style="display:inline-block; font-weight:600; color:var(--primary);"><%= m.getSubject() %></span>
                </td>
                <td style="color:var(--text-muted); max-width: 320px;">
                    <%= preview %>
                </td>
                <td>
                    <%= (m.getPhone() != null && !m.getPhone().isBlank()) ? m.getPhone() : "<span style='color:#94a3b8;'>—</span>" %>
                </td>
                <td style="font-size:0.85rem; color:var(--text-muted); white-space:nowrap;">
                    <%= timeStr %>
                </td>
                <td class="action-icons" style="text-align:center; white-space:nowrap;">
                    <!-- View Full Message Button -->
                    <button type="button" 
                            class="btn-action-view" 
                            style="border:none; background:transparent; cursor:pointer;"
                            title="View Full Message"
                            onclick="viewMessage('<%= m.getId() %>', '<%= m.getFullName().replace("'", "\\'") %>', '<%= m.getEmail().replace("'", "\\'") %>', '<%= (m.getPhone() != null ? m.getPhone() : "").replace("'", "\\'") %>', '<%= m.getSubject().replace("'", "\\'") %>', '<%= msg.replace("'", "\\'").replace("\n", "\\n").replace("\r", "") %>', '<%= timeStr %>')">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                    <!-- Quick Reply Email -->
                    <a href="mailto:<%= m.getEmail() %>?subject=Re: <%= m.getSubject() %>"
                       class="btn-action-edit"
                       title="Reply via Email">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                            <polyline points="22,6 12,13 2,6"/>
                        </svg>
                    </a>
                    <!-- Admin Delete Action -->
                    <% if (currentUser != null && currentUser.isAdmin()) { %>
                    <a href="${pageContext.request.contextPath}/contact-messages/delete/<%= m.getId() %>"
                       class="btn-action-delete"
                       style="color:#ef4444; border:none; background:transparent; cursor:pointer; display:inline-flex; align-items:center; padding:4px;"
                       title="Delete Message (Admin Only)"
                       onclick="return confirm('Are you sure you want to permanently delete this message from <%= m.getFullName().replace("'", "\\'") %>?')">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                        </svg>
                    </a>
                    <% } %>
                </td>
            </tr>
        <%      }
            } else { %>
            <tr>
                <td colspan="7" style="text-align:center; padding:32px; color:var(--text-muted);">
                    No contact messages received yet.
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<!-- Modal for Viewing Message Details -->
<div id="messageModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:2000; align-items:center; justify-content:center; padding:20px;">
    <div style="background:white; border-radius:12px; padding:30px; max-width:600px; width:100%; box-shadow:0 10px 30px rgba(0,0,0,0.2); position:relative;">
        <button onclick="closeModal()" style="position:absolute; top:16px; right:16px; background:none; border:none; font-size:1.5rem; cursor:pointer; color:var(--text-muted);">&times;</button>
        
        <h3 id="modalSubject" style="margin-top:0; margin-bottom:12px; color:var(--primary-dark); font-size:1.3rem;"></h3>
        
        <div style="background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; padding:14px; margin-bottom:18px; font-size:0.9rem;">
            <div style="display:flex; justify-content:space-between; margin-bottom:6px;">
                <span><strong>From:</strong> <span id="modalSender"></span></span>
                <span id="modalTime" style="color:var(--text-muted); font-size:0.82rem;"></span>
            </div>
            <div style="margin-bottom:6px;">
                <strong>Email:</strong> <a id="modalEmailLink" href="#" style="color:var(--primary); text-decoration:underline;"></a>
            </div>
            <div>
                <strong>Phone:</strong> <span id="modalPhone"></span>
            </div>
        </div>

        <div style="margin-bottom:24px;">
            <label style="font-weight:700; font-size:0.9rem; color:var(--text-muted); display:block; margin-bottom:6px;">Message Content:</label>
            <div id="modalMessage" style="background:#ffffff; border:1px solid #e2e8f0; border-radius:8px; padding:14px; font-size:0.95rem; line-height:1.6; white-space:pre-wrap; max-height:220px; overflow-y:auto; color:#1e293b;"></div>
        </div>

        <div style="display:flex; justify-content:space-between; align-items:center; gap:10px;">
            <div>
                <% if (currentUser != null && currentUser.isAdmin()) { %>
                <a id="modalDeleteBtn" href="#" class="btn btn-danger" style="background:#ef4444; color:white; border:none; display:inline-flex; align-items:center; gap:6px; padding:8px 16px; border-radius:6px; font-weight:600; text-decoration:none; font-size:0.88rem;" onclick="return confirm('Are you sure you want to permanently delete this message?')">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                    </svg>
                    Delete Message
                </a>
                <% } %>
            </div>
            <div style="display:flex; gap:10px;">
                <button type="button" class="btn btn-secondary" onclick="closeModal()">Close</button>
                <a id="modalReplyBtn" href="#" class="btn btn-primary">Reply via Email</a>
            </div>
        </div>
    </div>
</div>

<script>
function viewMessage(id, sender, email, phone, subject, message, time) {
    document.getElementById('modalSender').textContent = sender;
    document.getElementById('modalEmailLink').textContent = email;
    document.getElementById('modalEmailLink').href = 'mailto:' + email + '?subject=Re: ' + encodeURIComponent(subject);
    document.getElementById('modalPhone').textContent = phone || 'Not provided';
    document.getElementById('modalSubject').textContent = subject;
    document.getElementById('modalMessage').textContent = message;
    document.getElementById('modalTime').textContent = time;
    document.getElementById('modalReplyBtn').href = 'mailto:' + email + '?subject=Re: ' + encodeURIComponent(subject);
    
    var modalDelBtn = document.getElementById('modalDeleteBtn');
    if (modalDelBtn) {
        modalDelBtn.href = '${pageContext.request.contextPath}/contact-messages/delete/' + id;
    }

    var modal = document.getElementById('messageModal');
    modal.style.display = 'flex';
}

function closeModal() {
    document.getElementById('messageModal').style.display = 'none';
}

document.getElementById('messageModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});
</script>

<%@ include file="/includes/layout-bottom.jsp" %>
