package com.oceanview.controller;

import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String resIdParam = request.getParameter("reservationId");
        if (resIdParam != null) {
            try {
                int reservationId = Integer.parseInt(resIdParam);
                reservationService.cancelReservation(reservationId);
            } catch (NumberFormatException e) {
                // ignore invalid id
            }
        }

        response.sendRedirect("reservations");
    }
}
