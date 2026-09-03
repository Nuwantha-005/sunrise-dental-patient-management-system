<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Reports</h1>

<div class="help-layout">
    <div class="help-topics">
        <h4>Select Report Type</h4>
        <ul>
            <li><a href="?type=daily">Daily Appointments</a></li>
            <li><a href="?type=monthly">Monthly Summary</a></li>
            <li><a href="?type=treatment">Treatment Revenue</a></li>
            <li><a href="?type=dentist">Dentist Performance</a></li>
            <li><a href="?type=patient">Patient History</a></li>
        </ul>
    </div>

    <div class="card">
        <div class="card-header">
            <h3>Daily Appointment Report</h3>
            <form action="${pageContext.request.contextPath}/reports" method="get" style="display:flex; gap:10px;">
                <input type="hidden" name="type" value="<%= request.getAttribute("reportType") %>">
                <input type="date" name="date" class="form-control" value="<%= request.getAttribute("reportDate") %>">
                <button type="submit" class="btn btn-primary btn-sm">Generate</button>
            </form>
        </div>

        <div class="stats-grid" style="grid-template-columns: repeat(4, 1fr);">
            <div class="stat-card">
                <div class="stat-info"><h3><%= request.getAttribute("total") %></h3><p>Total</p></div>
            </div>
            <div class="stat-card">
                <div class="stat-info"><h3><%= request.getAttribute("completed") %></h3><p>Completed</p></div>
            </div>
            <div class="stat-card">
                <div class="stat-info"><h3><%= request.getAttribute("pending") %></h3><p>Pending / Confirmed</p></div>
            </div>
            <div class="stat-card">
                <div class="stat-info"><h3><%= request.getAttribute("cancelled") %></h3><p>Cancelled</p></div>
            </div>
        </div>

        <div class="btn-group">
            <button class="btn btn-secondary" onclick="window.print()">Download PDF / Print</button>
        </div>
    </div>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
