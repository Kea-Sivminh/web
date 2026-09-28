package com.lifehub.dao;

import com.lifehub.model.CalendarEvent;
import com.lifehub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CalendarDAO {
    public List<CalendarEvent> getEventsByUserId(int userId) {
        List<CalendarEvent> list = new ArrayList<>();
        String sql = "SELECT * FROM calendar_events WHERE user_id = ? ORDER BY event_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CalendarEvent ev = new CalendarEvent();
                ev.setId(rs.getInt("id"));
                ev.setUserId(rs.getInt("user_id"));
                ev.setTitle(rs.getString("title"));
                ev.setDescription(rs.getString("description"));
                ev.setEventDate(rs.getDate("event_date"));
                ev.setStartTime(rs.getTime("start_time"));
                ev.setEndTime(rs.getTime("end_time"));
                list.add(ev);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addEvent(CalendarEvent event) {
        String sql = "INSERT INTO calendar_events (user_id, title, description, event_date, start_time, end_time) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, event.getUserId());
            stmt.setString(2, event.getTitle());
            stmt.setString(3, event.getDescription());
            stmt.setDate(4, event.getEventDate());
            stmt.setTime(5, event.getStartTime());
            stmt.setTime(6, event.getEndTime());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean updateEvent(CalendarEvent event) {
        String sql = "UPDATE calendar_events SET title = ?, description = ?, event_date = ?, start_time = ?, end_time = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getDescription());
            stmt.setDate(3, event.getEventDate());
            stmt.setTime(4, event.getStartTime());
            stmt.setTime(5, event.getEndTime());
            stmt.setInt(6, event.getId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEvent(int id) {
        String sql = "DELETE FROM calendar_events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public CalendarEvent getEventById(int id) {
        String sql = "SELECT * FROM calendar_events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                CalendarEvent ev = new CalendarEvent();
                ev.setId(rs.getInt("id"));
                ev.setUserId(rs.getInt("user_id"));
                ev.setTitle(rs.getString("title"));
                ev.setDescription(rs.getString("description"));
                ev.setEventDate(rs.getDate("event_date"));
                ev.setStartTime(rs.getTime("start_time"));
                ev.setEndTime(rs.getTime("end_time"));
                return ev;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}