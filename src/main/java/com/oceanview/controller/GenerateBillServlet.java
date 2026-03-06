package com.oceanview.controller;

import com.oceanview.model.Bill;
import com.oceanview.model.User;
import com.oceanview.service.BillingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/generate-bill")
public class GenerateBillServlet extends HttpServlet {

    private final BillingService billingService = new BillingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String resIdParam = request.getParameter("reservationId");
        if (resIdParam == null) { response.sendRedirect("reservations"); return; }

        try {
            int reservationId = Integer.parseInt(resIdParam);
            String error = billingService.generateBillFromReservation(reservationId);

            if (error == null) {
                // Bill generated — redirect to bill details
                Bill bill = billingService.getBillByReservationId(reservationId);
                response.sendRedirect("bill-details?billId=" + bill.getBillId());
            } else if (error.startsWith("Bill already exists")) {
                // Bill exists — show existing bill
                Bill bill = billingService.getBillByReservationId(reservationId);
                response.sendRedirect("bill-details?billId=" + bill.getBillId());
            } else {
                request.setAttribute("errorMessage", error);
                response.sendRedirect("reservations");
            }

        } catch (Exception e) {
            response.sendRedirect("reservations");
        }
    }
}
