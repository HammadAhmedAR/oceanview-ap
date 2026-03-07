package com.oceanview.dao;

import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    public int getTotalRooms() {
        return countQuery("SELECT COUNT(*) FROM rooms");
    }

    public int getBookedRooms() {
        return countQuery(
            "SELECT COUNT(DISTINCT room_id) FROM reservations WHERE status = 'ACTIVE'"
        );
    }

    public int getTotalGuests() {
        return countQuery("SELECT COUNT(*) FROM guests");
    }

    public int getAvailableRooms() {
        return countQuery(
            "SELECT COUNT(*) FROM rooms WHERE room_id NOT IN (" +
            "SELECT DISTINCT room_id FROM reservations WHERE status = 'ACTIVE')"
        );
    }

    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
