package com.lifehub.controller;

import com.lifehub.dao.DocumentDAO;
import com.lifehub.model.Document;
import com.lifehub.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/DocumentServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB 
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class DocumentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DocumentDAO documentDAO;

    public void init() {
        documentDAO = new DocumentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        User user = (User) request.getSession().getAttribute("currentUser");
        int userId = (user != null) ? user.getId() : 1;

        switch (action) {
            case "delete":
                int id = Integer.parseInt(request.getParameter("id"));
                documentDAO.deleteDocument(id);
                response.sendRedirect("DocumentServlet");
                break;
            default:
                // ទាញយកបញ្ជីឯកសារពី Database មកបង្ហាញលើ UI
                List<Document> list = documentDAO.getDocumentsByUserId(userId);
                request.setAttribute("documents", list);
                request.getRequestDispatcher("documents.jsp").forward(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("upload".equals(action)) {
            User user = (User) request.getSession().getAttribute("currentUser");
            int userId = (user != null) ? user.getId() : 1;
            
            String title = request.getParameter("title");
            
            // កែពី "flie" មកជា "file" វិញ
            Part filePart = request.getPart("file");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // រក្សាទុកក្នុង Folder uploads ក្នុង Server
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String filePath = "uploads" + "/" + fileName;
            filePart.write(uploadPath + File.separator + fileName);

            // រក្សាទុកព័ត៌មានចូល Database តាមរយៈ DAO
            Document newDoc = new Document();
            newDoc.setUserId(userId);
            newDoc.setTitle(title);
            newDoc.setFilePath(filePath);

            documentDAO.insertDocument(newDoc);
            response.sendRedirect("DocumentServlet");
        }
    }
}