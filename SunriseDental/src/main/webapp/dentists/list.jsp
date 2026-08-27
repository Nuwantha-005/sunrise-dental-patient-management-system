<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.sunrisedental.model.Dentist" %>
<%@ include file="/includes/layout-top.jsp" %>

<h1 class="page-title">Dentists List</h1>

<div class="card">
    <div class="card-header">
        <h3>All Dentists</h3>
        <a href="${pageContext.request.contextPath}/dentists/add" class="btn btn-primary btn-sm">+ Add New Dentist</a>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>#</th>
                <th>Dentist Name</th>
                <th>Specialization</th>
                <th>Contact Number</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            List<Dentist> dentists = (List<Dentist>) request.getAttribute("dentists");
            if (dentists != null && !dentists.isEmpty()) {
                int i = 1;
                for (Dentist d : dentists) {
        %>
            <tr>
                <td><%= i++ %></td>
                <td><%= d.getName() %></td>
                <td><%= d.getSpecialization() %></td>
                <td><%= d.getContact() %></td>
                <td class="action-icons">
                    <a href="${pageContext.request.contextPath}/dentists/edit/<%= d.getId() %>" title="Edit">&#9998;</a>
                    <a href="${pageContext.request.contextPath}/dentists/delete/<%= d.getId() %>"
                       title="Delete" onclick="return confirm('Delete this dentist?')">&#128465;</a>
                </td>
            </tr>
        <%      }
            } else { %>
            <tr><td colspan="5" style="text-align:center;">No dentists found</td></tr>
        <% } %>
        </tbody>
    </table>
</div>

<%@ include file="/includes/layout-bottom.jsp" %>
