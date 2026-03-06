package com.oceanview.dao;

import com.oceanview.model.Bill;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    public boolean createBill(Bill bill) {
        String sql = "INSERT INTO bills (bill_number, reservation_id, bill_amount, bill_status) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, bill.getBillNumber());
            stmt.setInt(2, bill.getReservationId());
            stmt.setBigDecimal(3, bill.getBillAmount());
            stmt.setString(4, bill.getBillStatus());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("DB error: " + e.getMessage(), e);
        }
    }

    public Bill getBillByReservationId(int reservationId) {
        String sql = "SELECT b.*, " +
                     "r.reservation_number, r.check_in_date, r.check_out_date, r.number_of_nights, " +
                     "g.first_name || ' ' || g.last_name AS guest_name, g.phone AS guest_phone, g.email AS guest_email, " +
                     "rm.room_code, rm.room_type, rm.price_per_night " +
                     "FROM bills b " +
                     "JOIN reservations r ON b.reservation_id = r.reservation_id " +
                     "JOIN guests g ON r.guest_id = g.guest_id " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "WHERE b.reservation_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapBillWithJoin(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Bill getBillById(int billId) {
        String sql = "SELECT b.*, " +
                     "r.reservation_number, r.check_in_date, r.check_out_date, r.number_of_nights, " +
                     "g.first_name || ' ' || g.last_name AS guest_name, g.phone AS guest_phone, g.email AS guest_email, " +
                     "rm.room_code, rm.room_type, rm.price_per_night " +
                     "FROM bills b " +
                     "JOIN reservations r ON b.reservation_id = r.reservation_id " +
                     "JOIN guests g ON r.guest_id = g.guest_id " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "WHERE b.bill_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapBillWithJoin(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "r.reservation_number, " +
                     "g.first_name || ' ' || g.last_name AS guest_name " +
                     "FROM bills b " +
                     "JOIN reservations r ON b.reservation_id = r.reservation_id " +
                     "JOIN guests g ON r.guest_id = g.guest_id " +
                     "ORDER BY b.generated_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setBillNumber(rs.getString("bill_number"));
                bill.setReservationId(rs.getInt("reservation_id"));
                bill.setBillAmount(rs.getBigDecimal("bill_amount"));
                bill.setBillStatus(rs.getString("bill_status"));
                bill.setGeneratedAt(rs.getTimestamp("generated_at"));
                try { bill.setReservationNumber(rs.getString("reservation_number")); } catch (Exception ignored) {}
                try { bill.setGuestName(rs.getString("guest_name")); } catch (Exception ignored) {}
                bills.add(bill);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bills;
    }

    public boolean updateBillStatus(int billId, String status) {
        String sql = "UPDATE bills SET bill_status = ? WHERE bill_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, billId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Bill mapBillWithJoin(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setBillNumber(rs.getString("bill_number"));
        bill.setReservationId(rs.getInt("reservation_id"));
        bill.setBillAmount(rs.getBigDecimal("bill_amount"));
        bill.setBillStatus(rs.getString("bill_status"));
        bill.setGeneratedAt(rs.getTimestamp("generated_at"));
        try { bill.setReservationNumber(rs.getString("reservation_number")); } catch (Exception ignored) {}
        try { bill.setGuestName(rs.getString("guest_name")); } catch (Exception ignored) {}
        try { bill.setGuestPhone(rs.getString("guest_phone")); } catch (Exception ignored) {}
        try { bill.setGuestEmail(rs.getString("guest_email")); } catch (Exception ignored) {}
        try { bill.setRoomCode(rs.getString("room_code")); } catch (Exception ignored) {}
        try { bill.setRoomType(rs.getString("room_type")); } catch (Exception ignored) {}
        try { bill.setCheckInDate(rs.getString("check_in_date")); } catch (Exception ignored) {}
        try { bill.setCheckOutDate(rs.getString("check_out_date")); } catch (Exception ignored) {}
        try { bill.setNumberOfNights(rs.getInt("number_of_nights")); } catch (Exception ignored) {}
        try { bill.setRatePerNight(rs.getBigDecimal("price_per_night")); } catch (Exception ignored) {}
        return bill;
    }
}
