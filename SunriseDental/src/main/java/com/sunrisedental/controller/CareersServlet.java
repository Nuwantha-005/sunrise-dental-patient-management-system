package com.sunrisedental.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/careers")
public class CareersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/public/careers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Job application form submission
        String position    = request.getParameter("position");
        String firstName   = request.getParameter("firstName");
        String lastName    = request.getParameter("lastName");
        String email       = request.getParameter("email");
        String phone       = request.getParameter("phone");
        String coverLetter = request.getParameter("coverLetter");

        // Log to console (replace with email/DB logic as needed)
        System.out.println("=== Job Application Received ===");
        System.out.println("Position : " + position);
        System.out.println("Applicant: " + firstName + " " + lastName);
        System.out.println("Email    : " + email);
        System.out.println("Phone    : " + phone);
        System.out.println("Cover    : " + coverLetter);

        // Redirect back with success message
        response.sendRedirect(request.getContextPath() + "/careers?status=applied");
    }
}
