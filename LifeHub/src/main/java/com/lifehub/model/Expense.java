package com.lifehub.model;

public class Expense {
    private int id;
    private int userId;
    private String category;
    private double amount;
    private String title;
    private String expenseDate;

    public Expense() {
    }

    public Expense(int userId, String title, double amount, String expenseDate, String category) {
        this.userId = userId;
        this.category = category;
        this.amount = amount;
        this.title = title;
        this.expenseDate = expenseDate;
    }

    public Expense(int id, int userId, String title, double amount, String expenseDate, String category) {
        this.id = id;
        this.userId = userId;
        this.category = category;
        this.amount = amount;
        this.title = title;
        this.expenseDate = expenseDate;
    }

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

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getExpenseDate() {
        return expenseDate;
    }

    public void setExpenseDate(String expenseDate) {
        this.expenseDate = expenseDate;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}