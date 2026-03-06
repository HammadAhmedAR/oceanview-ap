package com.oceanview.controller;

import com.oceanview.model.Reservation;
import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/reservations")
public class ReservationListServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Reservation> reservations = reservationService.getAllReservations();
        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("reservations.jsp").forward(request, response);
    }
}
