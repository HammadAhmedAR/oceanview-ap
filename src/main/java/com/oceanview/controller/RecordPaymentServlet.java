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
import java.math.BigDecimal;

@WebServlet("/record-payment")
public class RecordPaymentServlet extends HttpServlet {

    private final BillingService billingService = new BillingService();
    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String billIdParam = request.getParameter("billId");
        if (billIdParam == null) { response.sendRedirect("reservations"); return; }

        try {
            int billId = Integer.parseInt(billIdParam);
            Bill bill = billingService.getBillDetails(billId);
            if (bill == null) { response.sendRedirect("reservations"); return; }

            request.setAttribute("bill", bill);
            request.getRequestDispatcher("record-payment.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect("reservations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String billIdParam = request.getParameter("billId");
        String paymentMethod = request.getParameter("paymentMethod");
        String amountStr = request.getParameter("paymentAmount");

        if (billIdParam == null) { response.sendRedirect("reservations"); return; }

        try {
            int billId = Integer.parseInt(billIdParam);
            BigDecimal amount = new BigDecimal(amountStr);

            String error = paymentService.recordPayment(billId, paymentMethod, amount);

            if (error == null) {
                response.sendRedirect("bill-details?billId=" + billId);
            } else {
                Bill bill = billingService.getBillDetails(billId);
                request.setAttribute("bill", bill);
                request.setAttribute("errorMessage", error);
                request.getRequestDispatcher("record-payment.jsp").forward(request, response);
            }

        } catch (Exception e) {
            int billId = Integer.parseInt(billIdParam);
            Bill bill = billingService.getBillDetails(billId);
            request.setAttribute("bill", bill);
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("record-payment.jsp").forward(request, response);
        }
    }
}
