package com.oceanview.dao;

import com.oceanview.model.Payment;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean createPayment(Payment payment) {
        String sql = "INSERT INTO payments (bill_id, payment_method, payment_amount, payment_status) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payment.getBillId());
            stmt.setString(2, payment.getPaymentMethod());
            stmt.setBigDecimal(3, payment.getPaymentAmount());
            stmt.setString(4, payment.getPaymentStatus());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("DB error: " + e.getMessage(), e);
        }
    }

    public List<Payment> getPaymentsByBillId(int billId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, b.bill_number " +
                     "FROM payments p " +
                     "JOIN bills b ON p.bill_id = b.bill_id " +
                     "WHERE p.bill_id = ? " +
                     "ORDER BY p.payment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                payments.add(mapPayment(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payments;
    }

    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, b.bill_number " +
                     "FROM payments p " +
                     "JOIN bills b ON p.bill_id = b.bill_id " +
                     "ORDER BY p.payment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                payments.add(mapPayment(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payments;
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE payments SET payment_status = ? WHERE payment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, paymentId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setBillId(rs.getInt("bill_id"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentAmount(rs.getBigDecimal("payment_amount"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setPaymentDate(rs.getTimestamp("payment_date"));
        try { p.setBillNumber(rs.getString("bill_number")); } catch (Exception ignored) {}
        return p;
    }
}
