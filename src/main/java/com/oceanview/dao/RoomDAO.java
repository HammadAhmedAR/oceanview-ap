package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomCode(rs.getString("room_code"));
                room.setRoomType(rs.getString("room_type"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setStatus(rs.getString("status"));
                rooms.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE room_id NOT IN (" +
                     "SELECT DISTINCT room_id FROM reservations WHERE status = 'ACTIVE') " +
                     "ORDER BY room_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomCode(rs.getString("room_code"));
                room.setRoomType(rs.getString("room_type"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setStatus(rs.getString("status"));
                rooms.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public Room getRoomById(int roomId) {
        Room room = null;
        String sql = "SELECT * FROM rooms WHERE room_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomCode(rs.getString("room_code"));
                room.setRoomType(rs.getString("room_type"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return room;
    }

    /**
     * Returns all rooms with current booking status.
     * Each Object[] contains: Room, bookingStatus (String), guestName (String or null)
     */
    public List<Object[]> getRoomsWithBookingInfo() {
        List<Object[]> results = new ArrayList<>();
        String sql = "SELECT rm.*, " +
                     "r.reservation_number, " +
                     "g.first_name || ' ' || g.last_name AS guest_name " +
                     "FROM rooms rm " +
                     "LEFT JOIN reservations r ON rm.room_id = r.room_id " +
                     "AND r.status = 'ACTIVE' " +
                     "LEFT JOIN guests g ON r.guest_id = g.guest_id " +
                     "ORDER BY rm.room_code";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomCode(rs.getString("room_code"));
                room.setRoomType(rs.getString("room_type"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setStatus(rs.getString("status"));

                String guestName = rs.getString("guest_name");
                String bookingStatus = (guestName != null) ? "BOOKED" : "AVAILABLE";

                results.add(new Object[]{ room, bookingStatus, guestName });
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return results;
    }
}
