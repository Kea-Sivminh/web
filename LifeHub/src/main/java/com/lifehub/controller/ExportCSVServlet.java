package com.lifehub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.List;

import com.lifehub.dao.ExpenseDAO;
import com.lifehub.model.Expense;
import com.lifehub.model.User;

@WebServlet("/ExportCSVServlet")
public class ExportCSVServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExpenseDAO expenseDAO = new ExpenseDAO();

    public ExportCSVServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            response.sendRedirect("Login.jsp");
            return;
        }
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"expenses_report.csv\"");
        List<Expense> list = expenseDAO.getExpenseByUserId(user.getId());
        PrintWriter out = response.getWriter();
        out.println("ID,Category,Amount,Description,Date");
        if (list != null) {
            for (Expense ex : list) {
                out.println(ex.getId() + "," + ex.getCategory() + "," + ex.getAmount() + ",\"" + ex.getTitle() + "\"," + ex.getExpenseDate());
            }
        }
        out.flush();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}