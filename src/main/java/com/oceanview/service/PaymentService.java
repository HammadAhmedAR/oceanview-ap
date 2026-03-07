package com.oceanview.service;

import com.oceanview.dao.BillDAO;
import com.oceanview.dao.PaymentDAO;
import com.oceanview.model.Bill;
import com.oceanview.model.Payment;

import java.math.BigDecimal;
import java.util.List;

public class PaymentService {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final BillDAO billDAO = new BillDAO();

    public String recordPayment(int billId, String paymentMethod, BigDecimal paymentAmount) {
        // Validate bill exists
        Bill bill = billDAO.getBillById(billId);
        if (bill == null) {
            return "Bill not found.";
        }

        if ("PAID".equals(bill.getBillStatus())) {
            return "Bill is already paid.";
        }

        // Validate payment amount
        if (paymentAmount == null || paymentAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return "Payment amount must be greater than zero.";
        }

        // Validate payment method
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            return "Payment method is required.";
        }

        // Create payment
        Payment payment = new Payment();
        payment.setBillId(billId);
        payment.setPaymentMethod(paymentMethod.trim());
        payment.setPaymentAmount(paymentAmount);
        payment.setPaymentStatus("COMPLETED");

        try {
            boolean paymentSuccess = paymentDAO.createPayment(payment);
            if (paymentSuccess) {
                // Update bill status to PAID
                billDAO.updateBillStatus(billId, "PAID");
                return null; // success
            }
            return "Failed to record payment.";
        } catch (Exception e) {
            return "Payment error: " + e.getMessage();
        }
    }

    public List<Payment> getPaymentsByBillId(int billId) {
        return paymentDAO.getPaymentsByBillId(billId);
    }

    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }
}
