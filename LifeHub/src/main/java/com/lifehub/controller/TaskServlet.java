package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.lifehub.dao.TaskDAO;
import com.lifehub.model.Task;
import com.lifehub.model.User;
/**
 * Servlet implementation class TaskServlet
 */
@WebServlet("/TaskServlet")
public class TaskServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private TaskDAO taskDAO = new TaskDAO();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TaskServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        
        // ឆែក Session បើអត់ទាន់ Login ឱ្យទៅ Login.jsp
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // ករណី User ចុច Toggle Status (In Progress <-> Completed)
        if ("toggleStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String currentStatus = request.getParameter("status");
            
            // បើ status បច្ចុប្បន្នជា Completed ត្រូវប្តូរទៅ In Progress, បើមិនមែនទេប្តូរទៅ Completed
            String newStatus = "Completed".equalsIgnoreCase(currentStatus) ? "In Progress" : "Completed";
            
            taskDAO.updateTaskStatus(id, user.getId(), newStatus);
            
            // Refresh ទំព័រឡើងវិញ
            response.sendRedirect("TaskServlet");
            return;
        }

        // ករណី User ចុច Delete 
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            taskDAO.deleteTask(id, user.getId());
        }
        
        // ករណី User ចុច update 
        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Task editTask = taskDAO.getTaskById(id, user.getId());
            request.setAttribute("taskToEdit", editTask);
        }

        List<Task> tasks = taskDAO.getTasksByUserId(user.getId());
        request.setAttribute("taskList", tasks);
        request.getRequestDispatcher("task.jsp").forward(request, response); 
    }
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
 @Override
 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     HttpSession session = request.getSession();
     User user = (User) session.getAttribute("currentUser");
     if (user == null) {
         response.sendRedirect("Login.jsp");
         return;
     }
     
     String idStr = request.getParameter("id");
     String title = request.getParameter("title");
     String description = request.getParameter("description");
     String status = request.getParameter("status");
     String category = request.getParameter("category");
     String priority = request.getParameter("priority");
     String dueDate = request.getParameter("dueDate");
     
     Task task = new Task();
     task.setUserId(user.getId());
     task.setTitle(title);
     task.setDescription(description);
     task.setStatus(status != null && !status.isEmpty() ? status : "Pending");
     task.setCategory(category != null ? category : "General");
     task.setPriority(priority != null ? priority : "Medium");
     task.setDueDate(dueDate);
     
     if (idStr != null && !idStr.isEmpty()) {
         int id = Integer.parseInt(idStr);
         task.setId(id);
         taskDAO.updateTask(task);
     } else {
         taskDAO.addTask(task);
     }
     
     response.sendRedirect("TaskServlet");
 }
 
}
