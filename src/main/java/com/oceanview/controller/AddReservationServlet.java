package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/add-reservation")
public class AddReservationServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();
    private final GuestDAO guestDAO = new GuestDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadFormData(request);
        request.getRequestDispatcher("add-reservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String reservationNumber = request.getParameter("reservationNumber");
        String guestIdParam = request.getParameter("guestId");
        String roomIdParam = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");

        // Basic validation
        if (reservationNumber == null || reservationNumber.trim().isEmpty() ||
            guestIdParam == null || guestIdParam.trim().isEmpty() ||
            roomIdParam == null || roomIdParam.trim().isEmpty() ||
            checkInStr == null || checkInStr.trim().isEmpty() ||
            checkOutStr == null || checkOutStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            loadFormData(request);
            request.getRequestDispatcher("add-reservation.jsp").forward(request, response);
            return;
        }

        try {
            Reservation res = new Reservation();
            res.setReservationNumber(reservationNumber.trim());
            res.setGuestId(Integer.parseInt(guestIdParam));
            res.setRoomId(Integer.parseInt(roomIdParam));
            res.setCheckInDate(LocalDate.parse(checkInStr));
            res.setCheckOutDate(LocalDate.parse(checkOutStr));

            String error = reservationService.validateAndCreate(res);

            if (error == null) {
                response.sendRedirect("reservations");
            } else {
                request.setAttribute("errorMessage", error);
                loadFormData(request);
                request.getRequestDispatcher("add-reservation.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            loadFormData(request);
            request.getRequestDispatcher("add-reservation.jsp").forward(request, response);
        }
    }

    private void loadFormData(HttpServletRequest request) {
        List<Guest> guests = guestDAO.getAllGuests();
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("guests", guests);
        request.setAttribute("rooms", rooms);
    }
}
