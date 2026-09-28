package com.lifehub.controller;

import com.lifehub.dao.CalendarDAO;
import com.lifehub.model.CalendarEvent;
import com.lifehub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet("/CalendarServlet")
public class CalendarServlet extends HttpServlet {
    private CalendarDAO calendarDAO;

    @Override
    public void init() {
        calendarDAO = new CalendarDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int userId = currentUser.getId();

        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                calendarDAO.deleteEvent(id);
            }
            response.sendRedirect("CalendarServlet");
            return;
        }

        List<CalendarEvent> events = calendarDAO.getEventsByUserId(userId);
        request.setAttribute("events", events);
        request.getRequestDispatcher("calendar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            String action = request.getParameter("action");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String eventDateStr = request.getParameter("event_date");
            String startTimeStr = request.getParameter("start_time");

            if (eventDateStr == null || eventDateStr.trim().isEmpty()) {
                response.sendRedirect("CalendarServlet");
                return;
            }

            Date eventDate = Date.valueOf(eventDateStr);
            Time startTime = (startTimeStr != null && !startTimeStr.trim().isEmpty()) 
                    ? Time.valueOf(startTimeStr + (startTimeStr.length() == 5 ? ":00" : "")) 
                    : null;

            if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                CalendarEvent event = new CalendarEvent();
                event.setId(id);
                event.setTitle(title);
                event.setDescription(description);
                event.setEventDate(eventDate);
                event.setStartTime(startTime);

                calendarDAO.updateEvent(event);
            } else {
                int userId = currentUser.getId();
                CalendarEvent event = new CalendarEvent();
                event.setUserId(userId);
                event.setTitle(title);
                event.setDescription(description);
                event.setEventDate(eventDate);
                event.setStartTime(startTime);

                calendarDAO.addEvent(event);
            }

            // បន្ទាប់ពី Save រួច ធ្វើការ Redirect ត្រឡប់មក CalendarServlet វិញភ្លាមៗ
            response.sendRedirect("CalendarServlet");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CalendarServlet");
        }
    }
}