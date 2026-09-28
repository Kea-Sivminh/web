package com.lifehub.dao;

import com.lifehub.model.Document;
import com.lifehub.util.DBConnection; 

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    // ១. មុខងារទាញយកបញ្ជីឯកសារទាំងអស់តាមរយៈ user_id
    public List<Document> getDocumentsByUserId(int userId) {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM documents WHERE user_id = ? ORDER BY upload_date DESC";
        
        try (Connection connection = DBConnection.getConnection(); 
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            
            preparedStatement.setInt(1, userId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String filePath = rs.getString("file_path");
                String uploadDate = rs.getString("upload_date");
                
                documents.add(new Document(id, userId, title, filePath, uploadDate));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return documents;
    }

    // ២. មុខងារបញ្ចូលឯកសារថ្មី (Upload) ចូលក្នុង Database
    public boolean insertDocument(Document document) {
        boolean rowInserted = false;
        String sql = "INSERT INTO documents (user_id, title, file_path) VALUES (?, ?, ?)";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, document.getUserId());
            statement.setString(2, document.getTitle());
            statement.setString(3, document.getFilePath());
            
            rowInserted = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowInserted;
    }

    // ៣. មុខងារលុបឯកសារចេញពី Database
    public boolean deleteDocument(int id) {
        boolean rowDeleted = false;
        String sql = "DELETE FROM documents WHERE id = ?";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowDeleted;
    }
}