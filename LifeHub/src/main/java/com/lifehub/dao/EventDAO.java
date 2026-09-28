package com.lifehub.dao;

import com.lifehub.model.Event;
import com.lifehub.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public boolean addEvent(Event event) {
        String sql = "INSERT INTO events (user_id, title, event_date, start_time, end_time, location, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, event.getUserId());
            p.setString(2, event.getTitle());
            p.setString(3, event.getEventDate());
            p.setString(4, event.getStartTime());
            p.setString(5, event.getEndTime());
            p.setString(6, event.getLocation());
            p.setString(7, event.getDescription());
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Event> getEventByUserId(int userId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE user_id=? ORDER BY event_date ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, userId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Event e = new Event();
                    e.setId(r.getInt("id"));
                    e.setUserId(r.getInt("user_id"));
                    e.setTitle(r.getString("title"));
                    e.setEventDate(r.getString("event_date"));
                    e.setStartTime(r.getString("start_time"));
                    e.setEndTime(r.getString("end_time"));
                    e.setLocation(r.getString("location"));
                    e.setDescription(r.getString("description"));
                    list.add(e);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Event getEventById(int eventId, int userId) {
        Event e = null;
        String sql = "SELECT * FROM events WHERE id=? AND user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, eventId);
            p.setInt(2, userId);
            try (ResultSet r = p.executeQuery()) {
                if (r.next()) {
                    e = new Event();
                    e.setId(r.getInt("id"));
                    e.setUserId(r.getInt("user_id"));
                    e.setTitle(r.getString("title"));
                    e.setEventDate(r.getString("event_date"));
                    e.setStartTime(r.getString("start_time"));
                    e.setEndTime(r.getString("end_time"));
                    e.setLocation(r.getString("location"));
                    e.setDescription(r.getString("description"));
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return e;
    }

    public boolean updateEvent(Event event) {
        String sql = "UPDATE events SET title=?, event_date=?, start_time=?, end_time=?, location=?, description=? WHERE id=? AND user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setString(1, event.getTitle());
            p.setString(2, event.getEventDate());
            p.setString(3, event.getStartTime());
            p.setString(4, event.getEndTime());
            p.setString(5, event.getLocation());
            p.setString(6, event.getDescription());
            p.setInt(7, event.getId());
            p.setInt(8, event.getUserId());
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteEvent(int eventId, int userId) {
        String sql = "DELETE FROM events WHERE id=? AND user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, eventId);
            p.setInt(2, userId);
            return p.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}