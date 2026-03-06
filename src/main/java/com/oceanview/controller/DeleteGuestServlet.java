package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/delete-guest")
public class DeleteGuestServlet extends HttpServlet {

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
        if (guestIdParam != null) {
            try {
                int guestId = Integer.parseInt(guestIdParam);
                guestDAO.deleteGuest(guestId);
            } catch (NumberFormatException e) {
                // ignore invalid id
            }
        }

        response.sendRedirect("guests");
    }
}
