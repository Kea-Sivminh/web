package com.lifehub.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // ជំនួសតម្លៃទាំងនេះដោយ Host, Port និង Database Name ពី Aiven Console របស់អ្នក
    private static final String HOST = "mysql-33a0a69-kimlangly73-84e9.i.aivencloud.com";
    private static final String PORT = "21477";
    private static final String DATABASE = "defaultdb"; 
    private static final String URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE + "?useSSL=true&requireSSL=true&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    
    private static final String USER = "avnadmin";      
    private static final String PASSWORD = "AVNS_hsyiy10iNC3StBi0-RF"; 

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connected to Aiven MySQL successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Connection failed!");
            e.printStackTrace();
        }
        return conn;
    }
    
    public static void main(String[] args) {
        System.out.println("Testing connection to Aiven MySQL...");
        
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("SUCCESS: Connected to Aiven MySQL successfully!");
            } else {
                System.out.println("FAILURE: Failed to make connection.");
            }
        } catch (SQLException e) {
            System.out.println("ERROR: An exception occurred during connection.");
            e.printStackTrace();
        }
    }
}