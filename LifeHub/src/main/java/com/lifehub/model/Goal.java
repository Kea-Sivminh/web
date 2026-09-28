package com.lifehub.model;

public class Goal {
    private int id;
    private int userId;
    private String title;
    private String description;
    private String targetDate;
    private int progress;
    private String status;
    private String category; // បន្ថែមថ្មី
    private String priority; // បន្ថែមថ្មី

    public Goal() {}

    public Goal(int userId, String title, String description, String targetDate, int progress, String status, String category, String priority) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.targetDate = targetDate;
        this.progress = progress;
        this.status = status;
        this.category = category;
        this.priority = priority;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTargetDate() { return targetDate; }
    public void setTargetDate(String targetDate) { this.targetDate = targetDate; }

    public int getProgress() { return progress; }
    public void setProgress(int progress) { this.progress = progress; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
}