package com.lifehub.model;

public class Event {
    private int id;
    private int userId;
    private String title;
    private String eventDate;
    private String startTime;
    private String endTime;
    private String location;
    private String description;

    public Event() {}

    public Event(int userId, String title, String eventDate, String startTime, String endTime, String location, String description) {
        this.userId = userId;
        this.title = title;
        this.eventDate = eventDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.location = location;
        this.description = description;
    }

    public Event(int id, int userId, String title, String eventDate, String startTime, String endTime, String location, String description) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.eventDate = eventDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.location = location;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}