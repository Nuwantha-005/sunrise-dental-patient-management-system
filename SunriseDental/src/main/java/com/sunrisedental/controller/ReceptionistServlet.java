package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.sunrisedental.dao.UserDAO;
import com.sunrisedental.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ReceptionistServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        String path = getRequestPath(req);
        try {
            if (path.equals("/receptionists") || path.equals("/receptionists/list")) {
                listReceptionists(req, resp);
            } else if (path.equals("/receptionists/add")) {
                req.setAttribute("pageTitle", "Add Receptionist");
                req.setAttribute("activeMenu", "receptionists");
                req.getRequestDispatcher("/receptionists/form.jsp").forward(req, resp);
            } else if (path.startsWith("/receptionists/edit/")) {
                int id = Integer.parseInt(path.substring("/receptionists/edit/".length()));
                User staff = userDAO.findById(id);
                if (staff != null && staff.isReceptionist()) {
                    req.setAttribute("staff", staff);
                    req.setAttribute("pageTitle", "Edit Receptionist");
                    req.setAttribute("activeMenu", "receptionists");
                    req.getRequestDispatcher("/receptionists/form.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/receptionists/list");
                }
            } else if (path.startsWith("/receptionists/delete/")) {
                int id = Integer.parseInt(path.substring("/receptionists/delete/".length()));
                userDAO.deleteStaff(id);
                resp.sendRedirect(req.getContextPath() + "/receptionists/list?success=deleted");
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in ReceptionistServlet", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        String path = getRequestPath(req);
        try {
            String fullName = req.getParameter("fullName");
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String email = req.getParameter("email");
            String contact = req.getParameter("contact");

            boolean isEdit = path.startsWith("/receptionists/edit/");
            int editId = isEdit ? Integer.parseInt(path.substring("/receptionists/edit/".length())) : -1;

            // Check if username is already taken
            if (userDAO.isUsernameTaken(username, editId)) {
                req.setAttribute("errorMessage", "⚠️ The username '" + username + "' is already taken. Please choose a different username.");
                req.setAttribute("inputFullName", fullName);
                req.setAttribute("inputUsername", username);
                req.setAttribute("inputEmail", email);
                req.setAttribute("inputContact", contact);
                if (isEdit) {
                    User staff = new User(editId, username, fullName, email, contact, "RECEPTIONIST");
                    req.setAttribute("staff", staff);
                    req.setAttribute("pageTitle", "Edit Receptionist");
                } else {
                    req.setAttribute("pageTitle", "Add Receptionist");
                }
                req.setAttribute("activeMenu", "receptionists");
                req.getRequestDispatcher("/receptionists/form.jsp").forward(req, resp);
                return;
            }

            if (isEdit) {
                User staff = userDAO.findById(editId);
                if (staff != null && staff.isReceptionist()) {
                    staff.setFullName(fullName);
                    staff.setUsername(username);
                    staff.setEmail(email);
                    staff.setContact(contact);
                    userDAO.updateStaff(staff, password);
                }
                resp.sendRedirect(req.getContextPath() + "/receptionists/list?success=updated");
            } else {
                if (password == null || password.isBlank()) {
                    req.setAttribute("errorMessage", "⚠️ Password is required for creating a new receptionist account.");
                    req.setAttribute("inputFullName", fullName);
                    req.setAttribute("inputUsername", username);
                    req.setAttribute("inputEmail", email);
                    req.setAttribute("inputContact", contact);
                    req.setAttribute("pageTitle", "Add Receptionist");
                    req.setAttribute("activeMenu", "receptionists");
                    req.getRequestDispatcher("/receptionists/form.jsp").forward(req, resp);
                    return;
                }

                User newStaff = new User(0, username, fullName, email, contact, "RECEPTIONIST");
                userDAO.insertStaff(newStaff, password);
                resp.sendRedirect(req.getContextPath() + "/receptionists/list?success=added");
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in ReceptionistServlet", e);
        }
    }

    private void listReceptionists(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        List<User> list = userDAO.findAllReceptionists();
        req.setAttribute("receptionists", list);
        req.setAttribute("pageTitle", "Receptionists (Staff)");
        req.setAttribute("activeMenu", "receptionists");
        req.getRequestDispatcher("/receptionists/list.jsp").forward(req, resp);
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return false;
        }
        return true;
    }

    private String getRequestPath(HttpServletRequest req) {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();
        return pathInfo != null ? servletPath + pathInfo : servletPath;
    }
}
