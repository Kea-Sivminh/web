package com.lifehub.dao;

import com.lifehub.model.Goal;
import com.lifehub.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GoalDAO {

	public boolean addGoal(Goal goal) {
	    String sql = "INSERT INTO goals (user_id, title, description, target_date, progress, status, category, priority) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	    try (Connection c = DBConnection.getConnection();
	         PreparedStatement p = c.prepareStatement(sql)) {
	        p.setInt(1, goal.getUserId());
	        p.setString(2, goal.getTitle());
	        p.setString(3, goal.getDescription());
	        
	        // ការពារករណី target_date ទទេរ ឬ null
	        if (goal.getTargetDate() == null || goal.getTargetDate().trim().isEmpty()) {
	            p.setNull(4, java.sql.Types.DATE);
	        } else {
	            p.setString(4, goal.getTargetDate());
	        }

	        p.setInt(5, goal.getProgress());
	        p.setString(6, goal.getStatus());
	        p.setString(7, goal.getCategory());
	        p.setString(8, goal.getPriority());
	        return p.executeUpdate() > 0;
	    } catch (Exception e) {
	        System.err.println("=== ERROR IN addGoal: " + e.getMessage() + " ===");
	        e.printStackTrace();
	    }
	    return false;
	}
    

    public List<Goal> getGoalsByUserId(int userId) {
        List<Goal> list = new ArrayList<>();
        String sql = "SELECT * FROM goals WHERE user_id = ? ORDER BY target_date ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, userId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Goal g = new Goal();
                    g.setId(r.getInt("id"));
                    g.setUserId(r.getInt("user_id"));
                    g.setTitle(r.getString("title"));
                    g.setDescription(r.getString("description"));
                    g.setTargetDate(r.getString("target_date"));
                    g.setProgress(r.getInt("progress"));
                    g.setStatus(r.getString("status"));
                    g.setCategory(r.getString("category"));
                    g.setPriority(r.getString("priority"));
                    list.add(g);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Goal getGoalById(int goalId, int userId) {
        Goal g = null;
        String sql = "SELECT * FROM goals WHERE id = ? AND user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, goalId);
            p.setInt(2, userId);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    g = new Goal();
                    g.setId(r.getInt("id"));
                    g.setUserId(r.getInt("user_id"));
                    g.setTitle(r.getString("title"));
                    g.setDescription(r.getString("description"));
                    g.setTargetDate(r.getString("target_date"));
                    g.setProgress(r.getInt("progress"));
                    g.setStatus(r.getString("status"));
                    g.setCategory(r.getString("category"));
                    g.setPriority(r.getString("priority"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return g;
    }

    public boolean updateGoal(Goal goal) {
        String sql = "UPDATE goals SET title = ?, description = ?, target_date = ?, progress = ?, status = ?, category = ?, priority = ? WHERE id = ? AND user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, goal.getTitle());
            p.setString(2, goal.getDescription());
            
            // ការពារករណី target_date ទទេរ ឬ null ពេល Update
            if (goal.getTargetDate() == null || goal.getTargetDate().trim().isEmpty()) {
                p.setNull(3, java.sql.Types.DATE);
            } else {
                p.setString(3, goal.getTargetDate());
            }

            p.setInt(4, goal.getProgress());
            p.setString(5, goal.getStatus());
            p.setString(6, goal.getCategory());
            p.setString(7, goal.getPriority());
            p.setInt(8, goal.getId());
            p.setInt(9, goal.getUserId());
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("=== ERROR IN updateGoal: " + e.getMessage() + " ===");
            e.printStackTrace();
        }
        return false;
    }
    public boolean deleteGoal(int goalId, int userId) {
        String sql = "DELETE FROM goals WHERE id = ? AND user_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, goalId);
            p.setInt(2, userId);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}