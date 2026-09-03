package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.sunrisedental.dao.UserDAO;
import com.sunrisedental.model.User;
import com.sunrisedental.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");
        try {
            User user = userDAO.findById(sessionUser.getId());
            req.setAttribute("userProfile", user);
            req.setAttribute("pageTitle", "Settings");
            req.setAttribute("activeMenu", "settings");
            req.getRequestDispatcher("/settings/profile.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        User sessionUser = (User) session.getAttribute("user");

        try {
            if ("profile".equals(action)) {
                User user = new User();
                user.setId(sessionUser.getId());
                user.setFullName(req.getParameter("fullName"));
                user.setEmail(req.getParameter("email"));
                user.setContact(req.getParameter("contact"));
                userDAO.updateProfile(user);

                sessionUser.setFullName(user.getFullName());
                sessionUser.setEmail(user.getEmail());
                sessionUser.setContact(user.getContact());
                req.setAttribute("success", "Profile updated successfully");
            } else if ("password".equals(action)) {
                String current = req.getParameter("currentPassword");
                String newPass = req.getParameter("newPassword");
                String confirm = req.getParameter("confirmPassword");
                String hash = userDAO.getPasswordHash(sessionUser.getId());

                if (!PasswordUtil.matches(current, hash)) {
                    req.setAttribute("passwordError", "Current password is incorrect");
                } else if (!newPass.equals(confirm)) {
                    req.setAttribute("passwordError", "New passwords do not match");
                } else {
                    userDAO.updatePassword(sessionUser.getId(), newPass);
                    req.setAttribute("passwordSuccess", "Password updated successfully");
                }
            }

            User user = userDAO.findById(sessionUser.getId());
            req.setAttribute("userProfile", user);
            req.setAttribute("pageTitle", "Settings");
            req.setAttribute("activeMenu", "settings");
            req.getRequestDispatcher("/settings/profile.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
