package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public boolean addReservation(Reservation res) {
        String sql = "INSERT INTO reservations (reservation_number, guest_id, room_id, " +
                     "check_in_date, check_out_date, number_of_nights, total_amount, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, res.getReservationNumber());
            stmt.setInt(2, res.getGuestId());
            stmt.setInt(3, res.getRoomId());
            stmt.setDate(4, Date.valueOf(res.getCheckInDate()));
            stmt.setDate(5, Date.valueOf(res.getCheckOutDate()));
            stmt.setInt(6, res.getNumberOfNights());
            stmt.setBigDecimal(7, res.getTotalAmount());
            stmt.setString(8, res.getStatus());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("DB error: " + e.getMessage(), e);
        }
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "g.first_name || ' ' || g.last_name AS guest_name, " +
                     "rm.room_code, rm.room_type " +
                     "FROM reservations r " +
                     "JOIN guests g ON r.guest_id = g.guest_id " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "ORDER BY r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(mapReservationWithJoin(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Reservation getReservationByNumber(String reservationNumber) {
        Reservation res = null;
        String sql = "SELECT r.*, " +
                     "g.first_name || ' ' || g.last_name AS guest_name, " +
                     "g.phone AS guest_phone, g.email AS guest_email, " +
                     "rm.room_code, rm.room_type, rm.price_per_night " +
                     "FROM reservations r " +
                     "JOIN guests g ON r.guest_id = g.guest_id " +
                     "JOIN rooms rm ON r.room_id = rm.room_id " +
                     "WHERE r.reservation_number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, reservationNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                res = mapReservationWithJoin(rs);
                // Extra detail fields
                try { res.setGuestPhone(rs.getString("guest_phone")); } catch (Exception ignored) {}
                try { res.setGuestEmail(rs.getString("guest_email")); } catch (Exception ignored) {}
                try { res.setPricePerNight(rs.getBigDecimal("price_per_night")); } catch (Exception ignored) {}
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return res;
    }

    public boolean existsByReservationNumber(String reservationNumber) {
        String sql = "SELECT 1 FROM reservations WHERE reservation_number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, reservationNumber);
            return stmt.executeQuery().next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut) {
        // A room is unavailable if an ACTIVE reservation overlaps
        String sql = "SELECT 1 FROM reservations " +
                     "WHERE room_id = ? AND status = 'ACTIVE' " +
                     "AND check_in_date < ? AND check_out_date > ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomId);
            stmt.setDate(2, Date.valueOf(checkOut));
            stmt.setDate(3, Date.valueOf(checkIn));

            return !stmt.executeQuery().next(); // available if NO overlap found

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Availability check error: " + e.getMessage(), e);
        }
    }

    public boolean cancelReservation(int reservationId) {
        String sql = "UPDATE reservations SET status = 'CANCELLED' WHERE reservation_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, reservationId);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Reservation mapReservationWithJoin(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setReservationId(rs.getInt("reservation_id"));
        res.setReservationNumber(rs.getString("reservation_number"));
        res.setGuestId(rs.getInt("guest_id"));
        res.setRoomId(rs.getInt("room_id"));
        res.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        res.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        res.setNumberOfNights(rs.getInt("number_of_nights"));
        res.setTotalAmount(rs.getBigDecimal("total_amount"));
        res.setStatus(rs.getString("status"));
        res.setCreatedAt(rs.getTimestamp("created_at"));
        // JOIN fields
        try { res.setGuestName(rs.getString("guest_name")); } catch (Exception ignored) {}
        try { res.setRoomCode(rs.getString("room_code")); } catch (Exception ignored) {}
        try { res.setRoomType(rs.getString("room_type")); } catch (Exception ignored) {}
        return res;
    }

    public boolean deleteReservation(int reservationId) {
        String sql = "DELETE FROM reservations WHERE reservation_id = ? AND status = 'CANCELLED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, reservationId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
