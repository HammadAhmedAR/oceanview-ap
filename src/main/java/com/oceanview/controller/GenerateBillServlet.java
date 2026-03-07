package com.oceanview.controller;

import com.oceanview.model.Bill;
import com.oceanview.model.User;
import com.oceanview.service.BillingService;
import com.oceanview.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/generate-bill")
public class GenerateBillServlet extends HttpServlet {

    private final BillingService billingService = new BillingService();
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String resIdParam = request.getParameter("reservationId");
        if (resIdParam == null) { response.sendRedirect("reservations"); return; }

        try {
            int reservationId = Integer.parseInt(resIdParam);

            // 1. Generate bill (or reuse existing)
            Bill bill = billingService.getBillByReservationId(reservationId);
            if (bill == null) {
                String error = billingService.generateBillFromReservation(reservationId);
                if (error != null) {
                    response.sendRedirect("reservations");
                    return;
                }
                bill = billingService.getBillByReservationId(reservationId);
            }

            // 2. Auto-record payment if not already paid
            if (bill != null && !"PAID".equals(bill.getBillStatus())) {
                String payError = paymentService.recordPayment(bill.getBillId(), "Cash", bill.getBillAmount());
                if (payError != null) {
                    System.err.println("Auto-payment error: " + payError);
                }
            }

            // 3. Redirect to bill details
            if (bill != null) {
                response.sendRedirect("bill-details?billId=" + bill.getBillId());
            } else {
                response.sendRedirect("reservations");
            }

        } catch (Exception e) {
            response.sendRedirect("reservations");
        }
    }
}
