<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div style="display:flex; align-items:center; gap:10px;">
            <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 2C8.5 2 6 4.5 6 8c0 3 1.5 6 2 9 .4 2.4 1.5 5 4 5s3.6-2.6 4-5c.5-3 2-6 2-9 0-3.5-2.5-6-6-6z"/>
                <path d="M12 7v4m-2-2h4"/>
            </svg>
            <h2 style="margin:0; font-size:1.25rem; color:#ffffff;">Sunrise Dental</h2>
        </div>
        <span style="color:rgba(255,255,255,0.8);">Patient Management System</span>
    </div>
    <nav class="sidebar-nav">
        <%
            com.sunrisedental.model.User sidebarUser = (com.sunrisedental.model.User) session.getAttribute("user");
        %>
        <a href="${pageContext.request.contextPath}/dashboard"
           class="nav-item ${activeMenu == 'dashboard' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="3" width="7" height="9" rx="1.5"/>
                    <rect x="14" y="3" width="7" height="5" rx="1.5"/>
                    <rect x="14" y="12" width="7" height="9" rx="1.5"/>
                    <rect x="3" y="16" width="7" height="5" rx="1.5"/>
                </svg>
            </span>
            <span>Dashboard</span>
        </a>

        <% if (sidebarUser == null || !sidebarUser.isAdmin()) { %>
        <a href="${pageContext.request.contextPath}/appointments/register"
           class="nav-item ${activeMenu == 'appointments' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                    <line x1="16" y1="2" x2="16" y2="6"/>
                    <line x1="8" y1="2" x2="8" y2="6"/>
                    <line x1="3" y1="10" x2="21" y2="10"/>
                    <path d="M12 14v4M10 16h4"/>
                </svg>
            </span>
            <span>Appointments</span>
        </a>
        <% } %>

        <a href="${pageContext.request.contextPath}/appointments/history"
           class="nav-item ${activeMenu == 'history' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="9"/>
                    <polyline points="12 7 12 12 15 15"/>
                    <path d="M3.05 11a9 9 0 0 1 .5-2m-.5 2H6m-3-2V6"/>
                </svg>
            </span>
            <span>Booking History</span>
        </a>

        <a href="${pageContext.request.contextPath}/bills/list"
           class="nav-item ${activeMenu == 'bills' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
            </span>
            <span>Bills & Invoices</span>
        </a>

        <a href="${pageContext.request.contextPath}/patients/list"
           class="nav-item ${activeMenu == 'patients' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                </svg>
            </span>
            <span>Patients</span>
        </a>


        <a href="${pageContext.request.contextPath}/dentists/list"
           class="nav-item ${activeMenu == 'dentists' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <line x1="19" y1="8" x2="19" y2="14"/>
                    <line x1="16" y1="11" x2="22" y2="11"/>
                </svg>
            </span>
            <span>Dentists</span>
        </a>

        <a href="${pageContext.request.contextPath}/treatments/list"
           class="nav-item ${activeMenu == 'treatments' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>
                </svg>
            </span>
            <span>Treatments</span>
        </a>

        <%
            if (sidebarUser != null && sidebarUser.isAdmin()) {
        %>
        <a href="${pageContext.request.contextPath}/receptionists/list"
           class="nav-item ${activeMenu == 'receptionists' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                </svg>
            </span>
            <span>Receptionists</span>
        </a>
        <% } %>

        <a href="${pageContext.request.contextPath}/contact-messages"
           class="nav-item ${activeMenu == 'contactMessages' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                    <polyline points="22,6 12,13 2,6"/>
                </svg>
            </span>
            <span>Messages</span>
        </a>

        <a href="${pageContext.request.contextPath}/help"
           class="nav-item ${activeMenu == 'help' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
            </span>
            <span>Help</span>
        </a>

        <a href="${pageContext.request.contextPath}/settings"
           class="nav-item ${activeMenu == 'settings' ? 'active' : ''}">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="3"/>
                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/>
                </svg>
            </span>
            <span>Settings</span>
        </a>

        <a href="#" class="nav-item" onclick="openLogoutModal(); return false;">
            <span class="icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                    <polyline points="16 17 21 12 16 7"/>
                    <line x1="21" y1="12" x2="9" y2="12"/>
                </svg>
            </span>
            <span>Logout</span>
        </a>
    </nav>
</aside>
