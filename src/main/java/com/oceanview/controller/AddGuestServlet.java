package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.model.Guest;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/add-guest")
public class AddGuestServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("add-guest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "First name and last name are required.");
            request.getRequestDispatcher("add-guest.jsp").forward(request, response);
            return;
        }

        Guest guest = new Guest();
        guest.setFirstName(firstName.trim());
        guest.setLastName(lastName.trim());
        guest.setPhone(phone != null ? phone.trim() : "");
        guest.setEmail(email != null ? email.trim() : "");
        guest.setAddress(address != null ? address.trim() : "");

        try {
            boolean success = guestDAO.addGuest(guest);
            if (success) {
                response.sendRedirect("guests");
            } else {
                request.setAttribute("errorMessage", "Failed to add guest.");
                request.getRequestDispatcher("add-guest.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("add-guest.jsp").forward(request, response);
        }
    }
}
