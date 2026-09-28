package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.lifehub.dao.ReminderDAO;
import com.lifehub.model.Reminder;
import com.lifehub.model.User;

@WebServlet("/ReminderServlet")
public class ReminderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReminderDAO reminderDAO = new ReminderDAO();

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
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                reminderDAO.deleteReminder(id, user.getId());
            }
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Reminder editReminder = reminderDAO.getReminderById(id, user.getId());
                request.setAttribute("editReminder", editReminder);
            }
        }

        List<Reminder> reminders = reminderDAO.getRemindersByUserId(user.getId());
        request.setAttribute("reminderList", reminders);
        request.getRequestDispatcher("reminders.jsp").forward(request, response);
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
        String reminderDate = request.getParameter("reminder_date");
        String status = request.getParameter("status");

        if (status == null || status.isEmpty()) {
            status = "Pending";
        }

        if (idStr != null && !idStr.isEmpty()) {
            // Update Reminder
            int id = Integer.parseInt(idStr);
            Reminder reminder = reminderDAO.getReminderById(id, user.getId());
            if (reminder != null) {
                reminder.setTitle(title);
                reminder.setReminderDate(reminderDate);
                reminder.setStatus(status);
                reminderDAO.updateReminder(reminder);
            }
        } else {
            // Add New Reminder
            Reminder newReminder = new Reminder();
            newReminder.setUserId(user.getId());
            newReminder.setTitle(title);
            newReminder.setReminderDate(reminderDate);
            newReminder.setStatus(status);
            reminderDAO.addReminder(newReminder);
        }

        response.sendRedirect(request.getContextPath() + "/ReminderServlet");
    }
}