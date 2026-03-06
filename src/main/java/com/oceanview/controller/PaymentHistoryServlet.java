package com.oceanview.controller;

import com.oceanview.model.Payment;
import com.oceanview.model.User;
import com.oceanview.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/payment-history")
public class PaymentHistoryServlet extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        List<Payment> payments = paymentService.getAllPayments();
        request.setAttribute("payments", payments);
        request.getRequestDispatcher("payment-history.jsp").forward(request, response);
    }
}
