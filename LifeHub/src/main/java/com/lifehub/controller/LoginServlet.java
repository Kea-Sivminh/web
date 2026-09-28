package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.lifehub.dao.UserDAO;
import com.lifehub.model.User;
/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private UserDAO userDAO =new UserDAO(); //ជា​obj class userDAO store field    
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
@Override
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    // Debug មើលតម្លៃដែលទាញបានពី Form
    System.out.println("DEBUG Email input: " + email);
    System.out.println("DEBUG Password input: " + password);
    
    User user = userDAO.loginUser(email, password);
    
    if(user != null) {
        System.out.println("DEBUG: Login Success! User ID: " + user.getId());
        HttpSession session = request.getSession();
        session.setAttribute("currentUser", user);
        response.sendRedirect("DashboardServlet");
    } else {
        System.out.println("DEBUG: Login Failed! User is null.");
        response.sendRedirect("Login.jsp?error=invalid");
    }
}

}
