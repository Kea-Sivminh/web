package com.lifehub.controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.lifehub.model.User;
import com.lifehub.model.Task;
import com.lifehub.model.Goal;
import com.lifehub.model.Reminder;
import com.lifehub.model.Event;
import com.lifehub.model.Document; // 1. Import Document Model (សូមធានាថាឈ្មោះ Model ត្រូវគ្នា)

import com.lifehub.dao.TaskDAO;
import com.lifehub.dao.EventDAO;
import com.lifehub.dao.ReminderDAO;
import com.lifehub.dao.DocumentDAO; // 2. Import DocumentDAO
import com.lifehub.dao.GoalDAO;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int userId = user.getId();

        try {
            // 1. ទាញយក Tasks សម្រាប់បង្ហាញថ្ងៃនេះ
            try {
                TaskDAO taskDAO = new TaskDAO();
                List<Task> taskList = taskDAO.getTasksByUserId(userId);
                request.setAttribute("taskList", taskList);
                request.setAttribute("taskCount", taskList != null ? taskList.size() : 0);
            } catch (Exception e) {
                request.setAttribute("taskCount", 0);
            }

            // 2. ទាញយក Events (ព្រឹត្តិការណ៍)
            try {
                EventDAO eventDAO = new EventDAO();
                List<Event> eventList = eventDAO.getEventByUserId(userId);
                request.setAttribute("eventList", eventList);
                request.setAttribute("eventCount", eventList != null ? eventList.size() : 0);
            } catch (Exception e) {
                request.setAttribute("eventCount", 0);
            }

            // 3. ទាញយក Reminders (ការរំលឹក)
            try {
                ReminderDAO reminderDAO = new ReminderDAO();
                List<Reminder> reminderList = reminderDAO.getRemindersByUserId(userId);
                request.setAttribute("reminderList", reminderList);
                request.setAttribute("reminderCount", reminderList != null ? reminderList.size() : 0);
            } catch (Exception e) {
                request.setAttribute("reminderCount", 0);
            }

            // 4. ទាញយក Documents (ឯកសារពិតប្រាកដពី Database)
            try {
                DocumentDAO documentDAO = new DocumentDAO();
                List<Document> documentList = documentDAO.getDocumentsByUserId(userId); // ធានាថាមាន Method នេះក្នុង DocumentDAO
                request.setAttribute("documentList", documentList);
                request.setAttribute("documentCount", documentList != null ? documentList.size() : 0);
            } catch (Exception e) {
                request.setAttribute("documentCount", 0);
            }

            // 5. ទាញយក Goals សម្រាប់គណនាកម្រិតសម្រេចបាន (Goal Progress)
            try {
                GoalDAO goalDAO = new GoalDAO();
                List<Goal> goalList = goalDAO.getGoalsByUserId(userId);
                double overallProgress = 0;
                if (goalList != null && !goalList.isEmpty()) {
                    double total = 0;
                    for(Goal g : goalList) { total += g.getProgress(); }
                    overallProgress = total / goalList.size();
                }
                request.setAttribute("overallProgress", overallProgress);
                request.setAttribute("goalList", goalList);
            } catch (Exception e) {
                request.setAttribute("overallProgress", 0.0);
            }

            // 6. ទាញយក Finance Data
            request.setAttribute("totalBalance", 450.00);
            request.setAttribute("totalIncome", 1200.00);
            request.setAttribute("totalExpense", 750.00);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ការពារ Error NullPointerException នៅលើ JSP
        if (request.getAttribute("taskCount") == null) request.setAttribute("taskCount", 0);
        if (request.getAttribute("eventCount") == null) request.setAttribute("eventCount", 0);
        if (request.getAttribute("reminderCount") == null) request.setAttribute("reminderCount", 0);
        if (request.getAttribute("documentCount") == null) request.setAttribute("documentCount", 0);

        // បញ្ជូនបន្តទៅកាន់ dashboard.jsp
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}