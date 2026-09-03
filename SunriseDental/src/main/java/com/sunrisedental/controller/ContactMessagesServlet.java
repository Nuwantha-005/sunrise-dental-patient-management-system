package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.sunrisedental.dao.ContactMessageDAO;
import com.sunrisedental.model.ContactMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ContactMessagesServlet extends HttpServlet {

    private final ContactMessageDAO dao = new ContactMessageDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = getRequestPath(req);
        try {
            if (path.startsWith("/contact-messages/delete/")) {
                int id = Integer.parseInt(path.substring("/contact-messages/delete/".length()));
                deleteMessage(req, resp, id);
            } else {
                // Mark all as read when admin/staff opens the page
                dao.markAllRead();

                List<ContactMessage> messages = dao.findRecent(100);
                req.setAttribute("messages",   messages);
                req.setAttribute("pageTitle",  "Contact Messages");
                req.setAttribute("activeMenu", "contactMessages");
                req.getRequestDispatcher("/contactMessages.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to process contact messages request", e);
        }
    }

    /** DELETE a single message via POST with action=delete&id=X */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isBlank()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    deleteMessage(req, resp, id);
                    return;
                } catch (Exception e) {
                    // Fall through to redirect
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/contact-messages");
    }

    private void deleteMessage(HttpServletRequest req, HttpServletResponse resp, int id)
            throws SQLException, IOException {
        HttpSession session = req.getSession(false);
        com.sunrisedental.model.User user = (session != null) ? (com.sunrisedental.model.User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/contact-messages?error=unauthorized");
            return;
        }
        dao.delete(id);
        resp.sendRedirect(req.getContextPath() + "/contact-messages?success=deleted");
    }

    private String getRequestPath(HttpServletRequest req) {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();
        return pathInfo != null ? servletPath + pathInfo : servletPath;
    }
}
