package com.lifehub.dao;

import com.lifehub.model.Task;
import com.lifehub.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    // Add new task
    public boolean addTask(Task task) {
        String sql = "INSERT INTO tasks (user_id, title, description, status, category, priority, due_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, task.getUserId());
            p.setString(2, task.getTitle());
            p.setString(3, task.getDescription());
            p.setString(4, task.getStatus());
            p.setString(5, task.getCategory());
            p.setString(6, task.getPriority());
            p.setString(7, task.getDueDate());
            
            int rows = p.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all task through user id 
    public List<Task> getTasksByUserId(int userId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE user_id=?";
        
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            ResultSet r = p.executeQuery();
            while (r.next()) {
                Task t = new Task();
                t.setId(r.getInt("id"));
                t.setUserId(r.getInt("user_id"));
                t.setTitle(r.getString("title"));
                t.setDescription(r.getString("description"));
                t.setStatus(r.getString("status"));
                t.setCategory(r.getString("category"));
                t.setPriority(r.getString("priority"));
                t.setDueDate(r.getString("due_date"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Delete task
    public boolean deleteTask(int taskId, int userId) {
        String sql = "DELETE FROM tasks WHERE id=? AND user_id=?";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, taskId);
            p.setInt(2, userId);
            int rows = p.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get data from id, user_id
    public Task getTaskById(int taskId, int userId) {
        Task t = null;
        String sql = "SELECT * FROM tasks WHERE id=? AND user_id=?";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, taskId);
            p.setInt(2, userId);
            ResultSet r = p.executeQuery();
            if (r.next()) {
                t = new Task();
                t.setId(r.getInt("id"));
                t.setUserId(r.getInt("user_id"));
                t.setTitle(r.getString("title"));
                t.setDescription(r.getString("description"));
                t.setStatus(r.getString("status"));
                t.setCategory(r.getString("category"));
                t.setPriority(r.getString("priority"));
                t.setDueDate(r.getString("due_date"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return t;
    }

    // Update data
    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title=?, description=?, status=?, category=?, priority=?, due_date=? WHERE id=? AND user_id=?";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, task.getTitle());
            p.setString(2, task.getDescription());
            p.setString(3, task.getStatus());
            p.setString(4, task.getCategory());
            p.setString(5, task.getPriority());
            p.setString(6, task.getDueDate());
            p.setInt(7, task.getId());
            p.setInt(8, task.getUserId());
            
            int rows = p.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 // Update status របស់ task (Completed <-> In Progress)
    public boolean updateTaskStatus(int taskId, int userId, String status) {
        String sql = "UPDATE tasks SET status=? WHERE id=? AND user_id=?";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, status);
            p.setInt(2, taskId);
            p.setInt(3, userId);
            
            int rows = p.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}