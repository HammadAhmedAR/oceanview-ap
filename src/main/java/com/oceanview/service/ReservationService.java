package com.oceanview.service;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class ReservationService {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    public int calculateNumberOfNights(LocalDate checkIn, LocalDate checkOut) {
        return (int) ChronoUnit.DAYS.between(checkIn, checkOut);
    }

    public BigDecimal calculateTotalAmount(int roomId, int nights) {
        Room room = roomDAO.getRoomById(roomId);
        if (room == null || room.getPricePerNight() == null) {
            throw new RuntimeException("Room not found or has no price set.");
        }
        return room.getPricePerNight().multiply(BigDecimal.valueOf(nights));
    }

    public String validateAndCreate(Reservation res) {
        // 1. Validate reservation number
        if (res.getReservationNumber() == null || res.getReservationNumber().trim().isEmpty()) {
            return "Reservation number is required.";
        }

        // 2. Check unique reservation number
        if (reservationDAO.existsByReservationNumber(res.getReservationNumber().trim())) {
            return "Reservation number already exists.";
        }

        // 3. Validate dates
        if (res.getCheckInDate() == null || res.getCheckOutDate() == null) {
            return "Check-in and check-out dates are required.";
        }
        if (!res.getCheckOutDate().isAfter(res.getCheckInDate())) {
            return "Check-out date must be after check-in date.";
        }

        // 4. Check room availability
        if (!reservationDAO.isRoomAvailable(res.getRoomId(), res.getCheckInDate(), res.getCheckOutDate())) {
            return "Room is not available for the selected dates.";
        }

        // 5. Calculate nights and amount
        int nights = calculateNumberOfNights(res.getCheckInDate(), res.getCheckOutDate());
        BigDecimal total = calculateTotalAmount(res.getRoomId(), nights);

        res.setNumberOfNights(nights);
        res.setTotalAmount(total);
        res.setStatus("ACTIVE");

        // 6. Save
        boolean success = reservationDAO.addReservation(res);
        return success ? null : "Failed to save reservation.";
    }

    public Reservation getReservationDetails(String reservationNumber) {
        return reservationDAO.getReservationByNumber(reservationNumber);
    }

    public List<Reservation> getAllReservations() {
        return reservationDAO.getAllReservations();
    }

    public boolean cancelReservation(int reservationId) {
        return reservationDAO.cancelReservation(reservationId);
    }
}
