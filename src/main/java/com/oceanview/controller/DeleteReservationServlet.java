package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/delete-reservation")
public class DeleteReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String resIdParam = request.getParameter("reservationId");
        if (resIdParam == null) { response.sendRedirect("reservations"); return; }

        try {
            int reservationId = Integer.parseInt(resIdParam);
            reservationDAO.deleteReservation(reservationId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("reservations");
    }
}
