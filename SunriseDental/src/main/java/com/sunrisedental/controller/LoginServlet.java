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

public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User user = userDAO.findByUsername(username);
            if (user != null && PasswordUtil.matches(password, user.getPassword())) {
                user.setPassword(null);
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }
            req.setAttribute("error", "Invalid username or password");
        } catch (SQLException e) {
            String msg = e.getMessage() != null ? e.getMessage() : "";
            if (msg.contains("Access denied")) {
                req.setAttribute("error",
                        "MySQL login failed. Open src/main/resources/db.properties and set db.password to your MySQL root password.");
            } else if (msg.contains("Unknown database")) {
                req.setAttribute("error",
                        "Database 'sunrise_dental' not found. Run sql/schema.sql in MySQL Workbench first.");
            } else if (msg.contains("Communications link failure") || msg.contains("Connection refused")) {
                req.setAttribute("error", "Cannot reach MySQL. Make sure MySQL Server is running on port 3306.");
            } else {
                req.setAttribute("error", "Database connection error: " + msg);
            }
            e.printStackTrace();
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
