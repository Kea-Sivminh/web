package com.lifehub.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.lifehub.model.User;
import com.lifehub.util.DBConnection;

public class UserDAO {

    // 1. Function Register សមាជិកថ្មីចូល Table 'users' (មាន s)
    public boolean registerUser(User user) {
        String sql = "INSERT INTO user (name, email, password) VALUES (?, ?, ?)";
        try {
        		Connection conn = DBConnection.getConnection();
             PreparedStatement p = conn.prepareStatement(sql);
            
           p.setString(1, user.getName());
            p.setString(2, user.getEmail());
            p.setString(3, user.getPassword());
            
            int rows = p.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User loginUser(String email, String password) {
        User user = null;
        String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
        try {
        	Connection conn = DBConnection.getConnection();
             PreparedStatement p = conn.prepareStatement(sql);
             p.setString(1, email);
            p.setString(2, password);
            ResultSet rs = p.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
    public boolean updateUser(User user) {
    	String sql="UPDATE user SET name=? , email=? , password=? WHERE=?";
    	try {
    		Connection conn = DBConnection.getConnection();
            PreparedStatement p = conn.prepareStatement(sql);
            p.setString(1, user.getName());
           p.setString(2, user.getEmail());
           p.setString(3, user.getPassword());
           p.setInt(4, user.getId());
    	}catch (Exception e) {
            e.printStackTrace();
        }
    	return false;
    }
}