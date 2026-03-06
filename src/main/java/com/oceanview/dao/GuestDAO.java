package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GuestDAO {

    public boolean addGuest(Guest guest) {
        String sql = "INSERT INTO guests (first_name, last_name, phone, email, address) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, guest.getFirstName());
            stmt.setString(2, guest.getLastName());
            stmt.setString(3, guest.getPhone());
            stmt.setString(4, guest.getEmail());
            stmt.setString(5, guest.getAddress());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("DB error: " + e.getMessage(), e);
        }
    }

    public List<Guest> getAllGuests() {
        List<Guest> guestList = new ArrayList<>();
        String sql = "SELECT * FROM guests ORDER BY guest_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setFirstName(rs.getString("first_name"));
                guest.setLastName(rs.getString("last_name"));
                guest.setPhone(rs.getString("phone"));
                guest.setEmail(rs.getString("email"));
                guest.setAddress(rs.getString("address"));
                guestList.add(guest);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return guestList;
    }

    public Guest getGuestById(int guestId) {
        Guest guest = null;
        String sql = "SELECT * FROM guests WHERE guest_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, guestId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setFirstName(rs.getString("first_name"));
                guest.setLastName(rs.getString("last_name"));
                guest.setPhone(rs.getString("phone"));
                guest.setEmail(rs.getString("email"));
                guest.setAddress(rs.getString("address"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return guest;
    }

    public boolean updateGuest(Guest guest) {
        String sql = "UPDATE guests SET first_name = ?, last_name = ?, phone = ?, email = ?, address = ? WHERE guest_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, guest.getFirstName());
            stmt.setString(2, guest.getLastName());
            stmt.setString(3, guest.getPhone());
            stmt.setString(4, guest.getEmail());
            stmt.setString(5, guest.getAddress());
            stmt.setInt(6, guest.getGuestId());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteGuest(int guestId) {
        String sql = "DELETE FROM guests WHERE guest_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, guestId);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
