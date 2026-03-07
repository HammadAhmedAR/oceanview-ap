package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/rooms")
public class RoomStatusServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) { response.sendRedirect("login.jsp"); return; }

        String filter = request.getParameter("filter"); // "all", "booked", "available"
        List<Object[]> roomsWithInfo = roomDAO.getRoomsWithBookingInfo();

        request.setAttribute("roomsWithInfo", roomsWithInfo);
        request.setAttribute("filter", filter != null ? filter : "all");
        request.getRequestDispatcher("rooms.jsp").forward(request, response);
    }
}
