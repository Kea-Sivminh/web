package com.lifehub.model;

public class Task {
    private int id;
    private int userId;
    private String title;
    private String description;
    private String status;
    private String category;
    private String priority;
    private String dueDate; // ឬអាចប្រើ java.time.LocalDate

    public Task() {
    }

    public Task(int userId, String title, String description, String status, String category, String priority, String dueDate) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.category = category;
        this.priority = priority;
        this.dueDate = dueDate;
    }

    public Task(int id, int userId, String title, String description, String status, String category, String priority, String dueDate) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.category = category;
        this.priority = priority;
        this.dueDate = dueDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getDueDate() { return dueDate; }
    public void setDueDate(String dueDate) { this.dueDate = dueDate; }
}