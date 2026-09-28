package com.lifehub.dao;

import com.lifehub.model.Reminder;
import com.lifehub.util.DBConnection; // ផ្លាស់ប្តូរតាម Package ភ្ជាប់ Database របស់អ្នក

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReminderDAO {

    // ទាញយកបញ្ជី Reminders ទាំងអស់របស់អ្នកប្រើប្រាស់ម្នាក់ៗ
    public List<Reminder> getRemindersByUserId(int userId) {
        List<Reminder> reminders = new ArrayList<>();
        String sql = "SELECT * FROM reminders WHERE user_id = ? ORDER BY reminder_date ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reminder r = new Reminder();
                    r.setId(rs.getInt("id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setTitle(rs.getString("title"));
                    r.setReminderDate(rs.getString("reminder_date"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getString("created_at"));
                    reminders.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reminders;
    }

    // ទាញយក Reminder តាម ID សម្រាប់ពេល Edit
    public Reminder getReminderById(int id, int userId) {
        Reminder r = null;
        String sql = "SELECT * FROM reminders WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.setInt(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    r = new Reminder();
                    r.setId(rs.getInt("id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setTitle(rs.getString("title"));
                    r.setReminderDate(rs.getString("reminder_date"));
                    r.setStatus(rs.getString("status"));
                    r.setCreatedAt(rs.getString("created_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }

    // បន្ថែម Reminder ថ្មី
    public void addReminder(Reminder reminder) {
        String sql = "INSERT INTO reminders (user_id, title, reminder_date, status) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reminder.getUserId());
            pstmt.setString(2, reminder.getTitle());
            pstmt.setString(3, reminder.getReminderDate());
            pstmt.setString(4, reminder.getStatus());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // កែប្រែ Reminder
    public void updateReminder(Reminder reminder) {
        String sql = "UPDATE reminders SET title = ?, reminder_date = ?, status = ? WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, reminder.getTitle());
            pstmt.setString(2, reminder.getReminderDate());
            pstmt.setString(3, reminder.getStatus());
            pstmt.setInt(4, reminder.getId());
            pstmt.setInt(5, reminder.getUserId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // លុប Reminder
    public void deleteReminder(int id, int userId) {
        String sql = "DELETE FROM reminders WHERE id = ? AND user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}