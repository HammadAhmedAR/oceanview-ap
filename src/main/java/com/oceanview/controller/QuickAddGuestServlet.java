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

@WebServlet("/quick-add-guest")
public class QuickAddGuestServlet extends HttpServlet {

    private final GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            response.sendRedirect("add-reservation");
            return;
        }

        Guest guest = new Guest();
        guest.setFirstName(firstName.trim());
        guest.setLastName(lastName.trim());
        guest.setPhone(phone != null ? phone.trim() : "");
        guest.setEmail(email != null ? email.trim() : "");
        guest.setAddress("");

        try {
            guestDAO.addGuest(guest);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to add-reservation — the new guest will appear in the dropdown
        response.sendRedirect("add-reservation");
    }
}
