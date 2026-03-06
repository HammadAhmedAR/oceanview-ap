package com.oceanview.controller;

import com.oceanview.dao.DashboardDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("totalRooms", dashboardDAO.getTotalRooms());
        request.setAttribute("bookedToday", dashboardDAO.getBookedToday());
        request.setAttribute("totalGuests", dashboardDAO.getTotalGuests());
        request.setAttribute("availableRooms", dashboardDAO.getAvailableRooms());

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
