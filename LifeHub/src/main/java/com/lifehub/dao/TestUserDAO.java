package com.lifehub.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.lifehub.util.DBConnection;

public class TestUserDAO {

    public boolean registerUser(String name, String email, String password) {
        String sql = "INSERT INTO user (name, email, password) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (conn == null) {
                System.out.println("Error: Database connection is NULL!");
                return false;
            }

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}