package com.oceanview.controller;

import com.oceanview.model.Bill;
import com.oceanview.model.Payment;
import com.oceanview.model.User;
import com.oceanview.service.BillingService;
import com.oceanview.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/bill-details")
public class BillDetailsServlet extends HttpServlet {

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

            if (bill == null) {
                response.sendRedirect("reservations");
                return;
            }

            List<Payment> payments = paymentService.getPaymentsByBillId(billId);

            request.setAttribute("bill", bill);
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("bill.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect("reservations");
        }
    }
}
