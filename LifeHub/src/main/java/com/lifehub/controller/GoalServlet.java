package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

import com.lifehub.dao.GoalDAO;
import com.lifehub.model.Goal;
import com.lifehub.model.User;

@WebServlet("/GoalServlet")
public class GoalServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private GoalDAO goalDAO = new GoalDAO();

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
                goalDAO.deleteGoal(id, user.getId());
            }
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Goal editGoal = goalDAO.getGoalById(id, user.getId());
                request.setAttribute("editGoal", editGoal);
            }
        }

        List<Goal> goals = goalDAO.getGoalsByUserId(user.getId());
        request.setAttribute("goalList", goals);
        request.getRequestDispatcher("goal.jsp").forward(request, response);
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
        String description = request.getParameter("description");
        String targetDate = request.getParameter("target_date");
        String progressStr = request.getParameter("progress");
        String status = request.getParameter("status");
        String category = request.getParameter("category");
        String priority = request.getParameter("priority");

        int progress = 0;
        try {
            if (progressStr != null && !progressStr.isEmpty()) {
                progress = Integer.parseInt(progressStr);
            }
        } catch (NumberFormatException e) {
            progress = 0;
        }

        if (idStr != null && !idStr.isEmpty()) {
            // Update Goal
            int id = Integer.parseInt(idStr);
            Goal goal = goalDAO.getGoalById(id, user.getId());
            if (goal != null) {
                goal.setTitle(title);
                goal.setDescription(description);
                goal.setTargetDate(targetDate);
                goal.setProgress(progress);
                goal.setStatus(status != null ? status : "In Progress");
                goal.setCategory(category != null ? category : "Personal");
                goal.setPriority(priority != null ? priority : "Medium");
                goalDAO.updateGoal(goal);
            }
        } else {
            // Add New Goal
            Goal newGoal = new Goal();
            newGoal.setUserId(user.getId());
            newGoal.setTitle(title);
            newGoal.setDescription(description);
            newGoal.setTargetDate(targetDate);
            newGoal.setProgress(progress);
            newGoal.setStatus(status != null ? status : "In Progress");
            newGoal.setCategory(category != null ? category : "Personal");
            newGoal.setPriority(priority != null ? priority : "Medium");
            goalDAO.addGoal(newGoal);
        }

        response.sendRedirect("GoalServlet");
    }
}