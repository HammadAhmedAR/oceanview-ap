package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/add-staff")
public class AddStaffServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin security check
        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("add-staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin security check
        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("add-staff.jsp").forward(request, response);
            return;
        }

        if (userDAO.usernameExists(username.trim())) {
            request.setAttribute("errorMessage", "Username already taken.");
            request.getRequestDispatcher("add-staff.jsp").forward(request, response);
            return;
        }

        User newStaff = new User();
        newStaff.setUsername(username.trim());
        newStaff.setPassword(password);
        newStaff.setRole("STAFF");

        try {
            boolean success = userDAO.registerUser(newStaff);
            if (success) {
                response.sendRedirect("staff-list");
            } else {
                request.setAttribute("errorMessage", "Failed to add staff member.");
                request.getRequestDispatcher("add-staff.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("add-staff.jsp").forward(request, response);
        }
    }
}
