package com.oceanview.controller;

import com.oceanview.model.Bill;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;
import com.oceanview.service.BillingService;
import com.oceanview.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/reservation-details")
public class ReservationDetailsServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();
    private final BillingService billingService = new BillingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String resNumber = request.getParameter("resNumber");
        if (resNumber == null || resNumber.trim().isEmpty()) {
            response.sendRedirect("reservations");
            return;
        }

        Reservation reservation = reservationService.getReservationDetails(resNumber.trim());
        if (reservation == null) {
            response.sendRedirect("reservations");
            return;
        }

        // Check bill/payment status for this reservation
        Bill bill = billingService.getBillByReservationId(reservation.getReservationId());
        String paymentStatus = "UNPAID";
        if (bill != null && "PAID".equals(bill.getBillStatus())) {
            paymentStatus = "PAID";
        }
        request.setAttribute("paymentStatus", paymentStatus);

        request.setAttribute("reservation", reservation);
        request.getRequestDispatcher("reservation-details.jsp").forward(request, response);
    }
}
