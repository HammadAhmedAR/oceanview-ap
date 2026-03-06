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

@WebServlet("/update-guest")
public class UpdateGuestServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String guestIdParam = request.getParameter("guestId");
        if (guestIdParam == null) {
            response.sendRedirect("guests");
            return;
        }

        try {
            int guestId = Integer.parseInt(guestIdParam);
            Guest guest = guestDAO.getGuestById(guestId);

            if (guest == null) {
                response.sendRedirect("guests");
                return;
            }

            request.setAttribute("guest", guest);
            request.getRequestDispatcher("edit-guest.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("guests");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String guestIdParam = request.getParameter("guestId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        if (guestIdParam == null || firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "First name and last name are required.");
            try {
                Guest guest = guestDAO.getGuestById(Integer.parseInt(guestIdParam));
                request.setAttribute("guest", guest);
            } catch (Exception ignored) {}
            request.getRequestDispatcher("edit-guest.jsp").forward(request, response);
            return;
        }

        try {
            int guestId = Integer.parseInt(guestIdParam);
            Guest guest = new Guest();
            guest.setGuestId(guestId);
            guest.setFirstName(firstName.trim());
            guest.setLastName(lastName.trim());
            guest.setPhone(phone != null ? phone.trim() : "");
            guest.setEmail(email != null ? email.trim() : "");
            guest.setAddress(address != null ? address.trim() : "");

            boolean success = guestDAO.updateGuest(guest);

            if (success) {
                response.sendRedirect("guests");
            } else {
                request.setAttribute("errorMessage", "Failed to update guest.");
                request.setAttribute("guest", guest);
                request.getRequestDispatcher("edit-guest.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("guests");
        }
    }
}
