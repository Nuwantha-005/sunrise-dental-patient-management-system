package com.sunrisedental.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.sunrisedental.dao.DentistDAO;
import com.sunrisedental.model.Dentist;
import com.sunrisedental.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DentistServlet extends HttpServlet {

    private final DentistDAO dentistDAO = new DentistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = getRequestPath(req);
        try {
            if (path.equals("/dentists/list")) {
                listDentists(req, resp);
            } else if (path.equals("/dentists/add")) {
                if (!requireAdmin(req, resp)) return;
                req.setAttribute("nextDentistCode", dentistDAO.generateNextDentistCode());
                req.setAttribute("pageTitle", "Add Dentist");
                req.setAttribute("activeMenu", "dentists");
                req.getRequestDispatcher("/dentists/form.jsp").forward(req, resp);
            } else if (path.startsWith("/dentists/edit/")) {
                if (!requireAdmin(req, resp)) return;
                int id = Integer.parseInt(path.substring("/dentists/edit/".length()));
                req.setAttribute("dentist", dentistDAO.findById(id));
                req.setAttribute("pageTitle", "Edit Dentist");
                req.setAttribute("activeMenu", "dentists");
                req.getRequestDispatcher("/dentists/form.jsp").forward(req, resp);
            } else if (path.startsWith("/dentists/delete/")) {
                if (!requireAdmin(req, resp)) return;
                int id = Integer.parseInt(path.substring("/dentists/delete/".length()));
                dentistDAO.delete(id);
                resp.sendRedirect(req.getContextPath() + "/dentists/list");
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!requireAdmin(req, resp)) return;

        String path = getRequestPath(req);
        try {
            Dentist dentist = new Dentist();
            dentist.setName(req.getParameter("name"));
            dentist.setSpecialization(req.getParameter("specialization"));
            dentist.setContact(req.getParameter("contact"));

            if (path.startsWith("/dentists/edit/")) {
                dentist.setId(Integer.parseInt(path.substring("/dentists/edit/".length())));
                dentistDAO.update(dentist);
            } else {
                dentistDAO.insert(dentist);
            }
            resp.sendRedirect(req.getContextPath() + "/dentists/list");
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }

    private boolean requireAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/dentists/list?error=unauthorized");
            return false;
        }
        return true;
    }

    private String getRequestPath(HttpServletRequest req) {
        String servletPath = req.getServletPath();
        String pathInfo = req.getPathInfo();
        return pathInfo != null ? servletPath + pathInfo : servletPath;
    }

    private void listDentists(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        List<Dentist> dentists = dentistDAO.findAll();
        req.setAttribute("dentists", dentists);
        req.setAttribute("pageTitle", "Dentists List");
        req.setAttribute("activeMenu", "dentists");
        req.getRequestDispatcher("/dentists/list.jsp").forward(req, resp);
    }
}
