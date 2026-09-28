package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.lifehub.dao.EventDAO;
import com.lifehub.model.Event;
import com.lifehub.model.User;

@WebServlet("/EventServlet")
public class EventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EventDAO eventDAO = new EventDAO();

    public EventServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            eventDAO.deleteEvent(id, user.getId());
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Event editEvent = eventDAO.getEventById(id, user.getId());
            request.setAttribute("editEvent", editEvent);
        }

        List<Event> events = eventDAO.getEventByUserId(user.getId());
        request.setAttribute("eventList", events);
        request.getRequestDispatcher("event.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String eventDate = request.getParameter("event_date");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");
        String location = request.getParameter("location");
        String description = request.getParameter("description");

        Event event = new Event();
        event.setUserId(user.getId());
        event.setTitle(title);
        event.setEventDate(eventDate);
        event.setStartTime(startTime);
        event.setEndTime(endTime);
        event.setLocation(location);
        event.setDescription(description);

        if (idStr != null && !idStr.trim().isEmpty()) {
            event.setId(Integer.parseInt(idStr));
            eventDAO.updateEvent(event);
        } else {
            eventDAO.addEvent(event);
        }

        response.sendRedirect("EventServlet");
    }
}