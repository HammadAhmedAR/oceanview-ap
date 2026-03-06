package com.oceanview.dao;

import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    public int getTotalRooms() {
        return countQuery("SELECT COUNT(*) FROM rooms");
    }

    public int getBookedToday() {
        return countQuery(
            "SELECT COUNT(*) FROM reservations " +
            "WHERE status = 'ACTIVE' AND check_in_date <= CURRENT_DATE AND check_out_date > CURRENT_DATE"
        );
    }

    public int getTotalGuests() {
        return countQuery("SELECT COUNT(*) FROM guests");
    }

    public int getAvailableRooms() {
        return countQuery(
            "SELECT COUNT(*) FROM rooms WHERE room_id NOT IN (" +
            "SELECT room_id FROM reservations " +
            "WHERE status = 'ACTIVE' AND check_in_date <= CURRENT_DATE AND check_out_date > CURRENT_DATE)"
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
