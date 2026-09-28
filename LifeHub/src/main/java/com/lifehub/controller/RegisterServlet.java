package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.lifehub.dao.UserDAO;
import com.lifehub.model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Read form inputs (Updated parameter name to 'fullname')
        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation check
        if (name == null || email == null || password == null || name.trim().isEmpty() || email.trim().isEmpty()) {
            response.sendRedirect("Register.jsp?error=invalid_input");
            return;
        }

        try {
            User user = new User(name, email, password);
            UserDAO userDAO = new UserDAO();
            boolean isSuccess = userDAO.registerUser(user);

            if (isSuccess) {
                response.sendRedirect("Login.jsp?msg=registered");
            } else {
                response.sendRedirect("Register.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Prints the error details in your IDE console
            response.sendRedirect("Register.jsp?error=failed");
        }
    }
}