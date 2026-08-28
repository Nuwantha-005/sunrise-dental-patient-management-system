package com.sunrisedental.controller;

import com.sunrisedental.dao.ContactMessageDAO;
import com.sunrisedental.model.ContactMessage;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private final ContactMessageDAO dao = new ContactMessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/public/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ContactMessage msg = new ContactMessage();
        msg.setFirstName(request.getParameter("firstName"));
        msg.setLastName(request.getParameter("lastName"));
        msg.setEmail(request.getParameter("email"));
        msg.setPhone(request.getParameter("phone"));
        msg.setSubject(request.getParameter("subject"));
        msg.setMessage(request.getParameter("message"));

        try {
            dao.save(msg);
        } catch (SQLException e) {
            // Log error but still redirect — don't break user experience
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/contact?status=success");
    }
}

