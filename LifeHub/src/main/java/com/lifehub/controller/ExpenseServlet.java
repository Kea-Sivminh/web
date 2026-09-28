package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.List;
import com.lifehub.dao.ExpenseDAO;
import com.lifehub.model.Expense;
import com.lifehub.model.User;
/**
 * Servlet implementation class ExpenseServlet
 */
@WebServlet("/ExpenseServlet")
public class ExpenseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ExpenseDAO expenseDAO=new ExpenseDAO();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ExpenseServlet() {
    	
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
        if(user==null) {
        	response.sendRedirect("Login.jsp");
        	return;
        }
        
        String action=request.getParameter("action");
      
        if("delete".equals(action)) {
        	int id=Integer.parseInt(request.getParameter("id"));
        	expenseDAO.deleteExpense(id, user.getId());
        }
        else if("edit".equals(action)){
        	int id = Integer.parseInt(request.getParameter("id"));
            Expense editExpense = expenseDAO.getExpenseById(id, user.getId());
            request.setAttribute("editExpense", editExpense);
        }
        String filterCat = request.getParameter("filterCategory");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        List<Expense> expenses;
        //ពិនិត្យមើលថាមាន Parameter filter ផ្ញើមកឬអត់
        boolean hasCategory = (filterCat != null && !filterCat.trim().isEmpty());
        boolean hasStartDate = (startDate != null && !startDate.trim().isEmpty());
        boolean hasEndDate = (endDate != null && !endDate.trim().isEmpty());
        if ((filterCat != null && !filterCat.trim().isEmpty()) || 
                (startDate != null && !startDate.trim().isEmpty()) || 
                (endDate != null && !endDate.trim().isEmpty())) {
                expenses = expenseDAO.filterExpense(user.getId(), filterCat, startDate, endDate);
            } else {
                expenses = expenseDAO.getExpenseByUserId(user.getId());
            }
        
        Map<String, Double> categoryTotals = expenseDAO.getCategoryTotals(user.getId());

        request.setAttribute("expenseList", expenses);
        request.setAttribute("categoryTotals", categoryTotals);
        request.getRequestDispatcher("expense.jsp").forward(request, response);
        
        
	}
    

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if(user==null) {
        	response.sendRedirect("Login.jsp");
        	return;
        }
        String idStr=request.getParameter("id");
        String title=request.getParameter("title");
        String amountStr=request.getParameter("amount");
        String expenseDate=request.getParameter("expense_date");
        String category=request.getParameter("category");
        
        double amount = 0.0;
        if (amountStr != null && !amountStr.isEmpty()) {
            amount = Double.parseDouble(amountStr);
        }
        
        Expense expense=new Expense();
        expense.setUserId(user.getId());
        expense.setCategory(category);
        expense.setAmount(amount);
        expense.setTitle(title);
        expense.setExpenseDate(expenseDate);
        
        if (idStr != null && !idStr.trim().isEmpty()) {
            //  ប្រសិនបើមាន ID គឺត្រូវ Update
            expense.setId(Integer.parseInt(idStr));
            expenseDAO.updateExpense(expense);
        } else {
            //  ប្រសិនបើគ្មាន ID ទេ គឺត្រូវ Add ថ្មី
            expenseDAO.addExpense(expense);
        }
        
        doGet(request, response);
         
        //expenseDAO.addExpense(expense);
        //List<Expense> expenses = expenseDAO.getExpenseByUserId(user.getId());
       // request.setAttribute("expenseList", expenses);
       // request.getRequestDispatcher("expense.jsp").forward(request, response);
	}

}
