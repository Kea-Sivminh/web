package com.lifehub.model;

public class Reminder {
    private int id;
    private int userId;
    private String title;
    private String reminderDate;
    private String status;
    private String createdAt;
    private String notes;

    public Reminder() {}

    // Getters and Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    public String getReminderDate() {
        return reminderDate;
    }
    public void setReminderDate(String reminderDate) {
        this.reminderDate = reminderDate;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    public String getNotes() {
        return notes;
    }
    public void setNotes(String notes) {
        this.notes = notes;
    }
}