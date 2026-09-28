package com.lifehub.dao;

import com.lifehub.model.Expense;
import com.lifehub.util.DBConnection;

import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class ExpenseDAO {

    public boolean addExpense(Expense expense) {
        String sql = "INSERT INTO expenses (user_id, category, amount, title, expense_date) VALUES (?, ?, ?, ?, ?)";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            
            p.setInt(1, expense.getUserId());
            p.setString(2, expense.getCategory());
            p.setDouble(3, expense.getAmount());
            p.setString(4, expense.getTitle()); // ប្រើ title ជំនួស description
            p.setString(5, expense.getExpenseDate());
            
            int rows = p.executeUpdate();
            return rows > 0;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Expense> getExpenseByUserId(int userId) {
        List<Expense> list = new ArrayList<>();
        String sql = "SELECT * FROM expenses WHERE user_id = ? ORDER BY expense_date DESC";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, userId);
            ResultSet r = p.executeQuery();
            while(r.next()) {
                Expense ex = new Expense();
                ex.setId(r.getInt("id"));
                ex.setUserId(r.getInt("user_id"));
                ex.setCategory(r.getString("category"));
                ex.setAmount(r.getDouble("amount"));
                ex.setTitle(r.getString("title")); // ប្រើ title ជំនួស description
                ex.setExpenseDate(r.getString("expense_date"));
                
                list.add(ex);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Expense getExpenseById(int expenseId, int userId) {
        Expense ex = null;
        String sql = "SELECT * FROM expenses WHERE id = ? AND user_id = ?";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, expenseId);
            p.setInt(2, userId);
            ResultSet r = p.executeQuery();
            if(r.next()) {
                ex = new Expense();
                ex.setId(r.getInt("id"));
                ex.setUserId(r.getInt("user_id"));
                ex.setCategory(r.getString("category"));
                ex.setAmount(r.getDouble("amount"));
                ex.setTitle(r.getString("title")); // ប្រើ title ជំនួស description
                ex.setExpenseDate(r.getString("expense_date"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return ex;
    }

    public boolean updateExpense(Expense expense) {
        String sql = "UPDATE expenses SET category = ?, amount = ?, title = ?, expense_date = ? WHERE id = ? AND user_id = ?";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setString(1, expense.getCategory());
            p.setDouble(2, expense.getAmount());
            p.setString(3, expense.getTitle()); // ប្រើ title ជំនួស description
            p.setString(4, expense.getExpenseDate());
            p.setInt(5, expense.getId());
            p.setInt(6, expense.getUserId());
            
            int rows = p.executeUpdate();
            return rows > 0;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteExpense(int expenseId, int userId) {
        String sql = "DELETE FROM expenses WHERE id = ? AND user_id = ?";
        try {
            Connection c = DBConnection.getConnection();
            PreparedStatement p = c.prepareStatement(sql);
            p.setInt(1, expenseId);
            p.setInt(2, userId);
            int rows = p.executeUpdate();
            return rows > 0;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Expense> filterExpense(int userId, String category, String startDate, String endDate) {
        List<Expense> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM expenses WHERE user_id = ?");
        List<Object> params = new ArrayList<>();

        if (category != null && !category.trim().isEmpty() && !"All".equalsIgnoreCase(category.trim())) {
            sql.append(" AND category = ?");
            params.add(category.trim());
        }

        if (startDate != null && startDate.trim().length() == 10) {
            sql.append(" AND expense_date >= ?");
            params.add(startDate.trim());
        }

        if (endDate != null && endDate.trim().length() == 10) {
            sql.append(" AND expense_date <= ?");
            params.add(endDate.trim());
        }

        sql.append(" ORDER BY expense_date DESC");

        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql.toString())) {
            
            p.setInt(1, userId);
            for (int i = 0; i < params.size(); i++) {
                p.setObject(i + 2, params.get(i));
            }

            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    Expense ex = new Expense();
                    ex.setId(r.getInt("id"));
                    ex.setUserId(r.getInt("user_id"));
                    ex.setCategory(r.getString("category"));
                    ex.setAmount(r.getDouble("amount"));
                    ex.setTitle(r.getString("title")); // ប្រើ title ជំនួស description
                    ex.setExpenseDate(r.getString("expense_date"));
                    list.add(ex);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public java.util.Map<String, Double> getCategoryTotals(int userId) {
        java.util.Map<String, Double> map = new java.util.HashMap<>();
        String sql = "SELECT category, SUM(amount) as total FROM expenses WHERE user_id = ? GROUP BY category";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement p = c.prepareStatement(sql)) {
            p.setInt(1, userId);
            try (ResultSet r = p.executeQuery()) {
                while (r.next()) {
                    map.put(r.getString("category"), r.getDouble("total"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}