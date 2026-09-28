package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import jakarta.servlet.http.HttpSession;
import com.lifehub.model.User;
import com.lifehub.dao.UserDAO;
/**
 * Servlet implementation class ProfileServlet
 */
@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ProfileServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("currentUser");
		if(currentUser == null) {
			response.sendRedirect("Login.jsp");
			return;
		}
		request.getRequestDispatcher("Profile.jsp").forward(request, response);
		
	}

	/**	
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	// ២. ទទួល Update ទិន្នន័យ (POST Method)
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession(false);
		if(session == null || session.getAttribute(" currentUser")== null) {
			response.sendRedirect("Login.jsp");
			return ;
		}
		User currentUser =(User) session.getAttribute("currentUser");
		String name=request.getParameter("name");
		String email=request.getParameter("email");
		String newPassword=request.getParameter("password");
		try {
			// update profile
			currentUser.setName(name);
			currentUser.setEmail(email);
			//if user input new password 
			if(newPassword !=null && !newPassword.trim().isEmpty()) {
				currentUser.setPassword(newPassword);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			request.setAttribute("error","An error occurred: "+e.getMessage());
		}
		// stor in database 
		UserDAO userDAO=new UserDAO();
		boolean isUpdated = userDAO.updateUser(currentUser);
		if(isUpdated) {
			session.setAttribute("currentUser", currentUser);
			request.setAttribute("message", "Profile update sueccfully!");
			
		}else {
			request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
		}
		
	}

}
