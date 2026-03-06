package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/edit-staff")
public class UpdateStaffServlet extends HttpServlet {

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

        String userIdParam = request.getParameter("userId");
        if (userIdParam == null) {
            response.sendRedirect("staff-list");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            User staffUser = userDAO.getUserById(userId);

            if (staffUser == null) {
                response.sendRedirect("staff-list");
                return;
            }

            request.setAttribute("staffUser", staffUser);
            request.getRequestDispatcher("edit-staff.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("staff-list");
        }
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

        String userIdParam = request.getParameter("userId");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (userIdParam == null || username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            // Reload staff user for form re-display
            try {
                User staffUser = userDAO.getUserById(Integer.parseInt(userIdParam));
                request.setAttribute("staffUser", staffUser);
            } catch (Exception ignored) {}
            request.getRequestDispatcher("edit-staff.jsp").forward(request, response);
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            User updatedUser = new User();
            updatedUser.setUserId(userId);
            updatedUser.setUsername(username.trim());
            updatedUser.setPassword(password);

            boolean success = userDAO.updateUser(updatedUser);

            if (success) {
                response.sendRedirect("staff-list");
            } else {
                request.setAttribute("errorMessage", "Failed to update staff.");
                request.setAttribute("staffUser", updatedUser);
                request.getRequestDispatcher("edit-staff.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("staff-list");
        }
    }
}
