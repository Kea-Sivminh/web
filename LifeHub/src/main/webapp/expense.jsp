<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.lifehub.model.Expense" %>
<%@ page import="com.lifehub.model.User" %>
<% 
    User user = (User) session.getAttribute("currentUser");
    if (user == null) { response.sendRedirect("Login.jsp"); return; }
    List<Expense> expenses = (List<Expense>) request.getAttribute("expenseList");
    Map<String, Double> categoryTotals = (Map<String, Double>) request.getAttribute("categoryTotals");
    Expense editEx = (Expense) request.getAttribute("editExpense");
    boolean isEdit = (editEx != null);

    double totalExpense = 0.0;
    int totalItems = (expenses != null) ? expenses.size() : 0;
    if (expenses != null) {
        for (Expense ex : expenses) totalExpense += ex.getAmount();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Dashboard — LifeHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-light: #0f172a;
            --card-bg: #1e293b;
            --text-dark: #ffffff;      
            --text-muted: #e2e8f0;       
            --border-color: #334155;
            --primary-gradient: linear-gradient(135deg, #635bff 0%, #a855f7 50%, #e649a6 100%);
            --sidebar-width: 260px;
        }

        [data-theme="light"] {
            --bg-light: #f8f9ff;
            --card-bg: #ffffff;
            --text-dark: #0f172a;      
            --text-muted: #64748b;      
            --border-color: #eef2ff;
        }

        body { 
            background-color: var(--bg-light); 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            color: var(--text-dark);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        [data-theme="dark"] .text-muted {
            color: #e2e8f0 !important;
            opacity: 0.95;
        }

        .main-wrapper { margin-left: var(--sidebar-width); padding: 2rem; }
        @media (max-width: 991.98px) { .main-wrapper { margin-left: 0; padding: 1rem; } }

        .kpi-card {
            background: var(--card-bg);
            border-radius: 18px;
            border: 1px solid var(--border-color);
            padding: 1.25rem 1.5rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        [data-theme="dark"] .kpi-card .text-muted,
        [data-theme="dark"] .kpi-card span,
        [data-theme="dark"] .kpi-card small {
            color: #f8fafc !important;
            opacity: 0.95;
        }

        .custom-card {
            background: var(--card-bg);
            border-radius: 20px;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .btn-gradient { background: var(--primary-gradient); color: #fff; border: none; }
        .btn-gradient:hover { color: #fff; opacity: 0.95; }
        
        .badge-category { 
            background: rgba(99, 91, 255, 0.25); 
            color: #d8b4fe; 
            padding: 6px 12px; 
            border-radius: 20px; 
            font-weight: 600; 
            font-size: 0.75rem; 
        }

        [data-theme="light"] .badge-category {
            background: #f3f0ff; 
            color: #635bff;
        }

        .table { color: var(--text-dark); background-color: transparent; }
        .table thead th {
            background-color: transparent !important;
            color: var(--text-muted) !important;
            border-bottom: 2px solid var(--border-color) !important;
            font-weight: 600;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
        }
        .table tbody tr td {
            background-color: transparent !important;
            color: var(--text-dark) !important;
            border-color: var(--border-color) !important;
            vertical-align: middle;
        }
        .table tbody tr:hover td {
            background-color: rgba(99, 91, 255, 0.08) !important;
        }

        .form-control, .form-select {
            background-color: var(--card-bg);
            color: var(--text-dark);
            border-color: var(--border-color);
        }
        .form-control:focus, .form-select:focus {
            background-color: var(--card-bg);
            color: var(--text-dark);
            border-color: #635bff;
            box-shadow: 0 0 0 0.25rem rgba(99, 91, 255, 0.15);
        }
        .form-control::placeholder { color: var(--text-muted); opacity: 0.7; }

        .theme-toggle-btn {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            border: 1px solid var(--border-color);
            background: var(--card-bg);
            color: var(--text-dark);
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }
        .theme-toggle-btn:hover { background: var(--border-color); transform: scale(1.05); }

        .theme-text {
            color: var(--text-dark) !important;
        }
        
        .btn-export-theme {
            background-color: var(--card-bg);
            color: var(--text-dark) !important;
            border-color: var(--border-color) !important;
        }
        .btn-export-theme:hover {
            background-color: var(--border-color);
            color: var(--text-dark) !important;
        }

        /* ថែម CSS សម្រាប់ប៊ូតុង Edit និង Delete ឱ្យមានពណ៌ស និងប្តូរតាម Theme */
        .action-btn {
            background-color: var(--card-bg) !important;
            color: var(--text-dark) !important;
            border-color: var(--border-color) !important;
        }
        .action-btn:hover {
            background-color: var(--border-color) !important;
        }

        /* កែពណ៌សញ្ញា x (Close button) ក្នុង Modal ឱ្យទៅជាពណ៌ខ្មៅក្នុង Light Mode និងសក្នុង Dark Mode */
        [data-theme="dark"] .modal-content .btn-close {
            filter: invert(1) grayscale(100%) brightness(200%);
        }
        [data-theme="light"] .modal-content .btn-close {
            filter: none; 
        }
    </style>

    <script>
        (function() {
            const savedTheme = localStorage.getItem('theme') || 'dark';
            document.documentElement.setAttribute('data-theme', savedTheme);
        })();
    </script>
</head>
<body>
    <jsp:include page="sidebar.jsp" />

    <div class="main-wrapper">
        <div class="container-fluid">
            
            <!-- Top Header -->
            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                <div>
                    <h3 class="fw-bold mb-1 theme-text">Financial </h3>
                    <p class="text-muted small mb-0">Track assets, budgets, cash flow and monthly transactions for <%= user.getName() %></p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="theme-toggle-btn" id="themeToggleBtn" title="Toggle Light/Dark Mode">
                        <i class="fa-solid fa-moon" id="themeIcon"></i>
                    </button>
                    <a href="ExportCSVServlet" class="btn btn-export-theme rounded-pill px-3 py-2 fw-semibold border">
                        <i class="fa-solid fa-file-csv me-1 text-success"></i> Export CSV
                    </a>
                    <button class="btn btn-gradient rounded-pill px-4 py-2 fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#expenseModal">
                        <i class="fa-solid fa-plus me-2"></i>Add Transaction
                    </button>
                </div>
            </div>

            <!-- KPI Row -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="kpi-card d-flex align-items-center justify-content-between">
                        <div>
                            <span class="small fw-bold tracking-wider">TOTAL EXPENDITURE</span>
                            <h3 class="fw-bold my-1 text-danger">$<%= String.format("%.2f", totalExpense) %></h3>
                            <small><i class="fa-solid fa-wallet me-1 text-info"></i> Current total recorded</small>
                        </div>
                        <div class="rounded-circle p-3" style="background: rgba(230, 73, 166, 0.15);"><i class="fa-solid fa-dollar-sign fs-4 text-danger"></i></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="kpi-card d-flex align-items-center justify-content-between">
                        <div>
                            <span class="small fw-bold tracking-wider">TOTAL TRANSACTIONS</span>
                            <h3 class="fw-bold my-1 theme-text"><%= totalItems %></h3>
                            <small><i class="fa-solid fa-receipt me-1 text-info"></i> Recorded items</small>
                        </div>
                        <div class="rounded-circle p-3" style="background: rgba(99, 91, 255, 0.15);"><i class="fa-solid fa-list-check fs-4 text-primary"></i></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="kpi-card d-flex align-items-center justify-content-between">
                        <div>
                            <span class="small fw-bold tracking-wider">AVERAGE COST</span>
                            <h3 class="fw-bold my-1 theme-text">$<%= totalItems > 0 ? String.format("%.2f", totalExpense / totalItems) : "0.00" %></h3>
                            <small><i class="fa-solid fa-calculator me-1 text-warning"></i> Per transaction</small>
                        </div>
                        <div class="rounded-circle p-3" style="background: rgba(16, 185, 129, 0.15);"><i class="fa-solid fa-chart-line fs-4 text-success"></i></div>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <!-- Data Table -->
                <div class="col-lg-8">
                    <div class="custom-card">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h5 class="fw-bold mb-0 theme-text">Recent Transactions</h5>
                                <p class="text-muted small mb-0">Search, filter and inspect your financial records</p>
                            </div>
                            <form action="ExpenseServlet" method="get" class="d-flex gap-2">
                                <select class="form-select form-select-sm rounded-pill px-3 theme-text border-secondary" style="background-color: var(--card-bg);" name="filterCategory" onchange="this.form.submit()">
                                    <option value="All">All Categories</option>
                                    <option value="Food">Food</option>
                                    <option value="Transport">Transport</option>
                                    <option value="Bills">Bills</option>
                                    <option value="Entertainment">Entertainment</option>
                                    <option value="Other">Other</option>
                                </select>
                            </form>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>CATEGORY</th>
                                        <th>TITLE</th>
                                        <th>DATE</th>
                                        <th class="text-end">AMOUNT</th>
                                        <th class="text-end">ACTION</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (expenses != null && !expenses.isEmpty()) { 
                                        for (Expense ex : expenses) { %>
                                    <tr>
                                        <td><span class="badge-category"><%= ex.getCategory() %></span></td>
                                        <td class="fw-semibold theme-text"><%= ex.getTitle() %></td>
                                        <td class="text-muted small"><%= ex.getExpenseDate() %></td>
                                        <td class="text-end fw-bold text-danger">- $<%= String.format("%.2f", ex.getAmount()) %></td>
                                        <td class="text-end">
                                            <a href="ExpenseServlet?action=edit&id=<%= ex.getId() %>" class="btn btn-sm action-btn rounded-circle text-info me-1 shadow-sm" title="Edit"><i class="fa-solid fa-pen"></i></a>
                                            <a href="ExpenseServlet?action=delete&id=<%= ex.getId() %>" onclick="return confirm('Delete record?')" class="btn btn-sm action-btn rounded-circle text-danger shadow-sm" title="Delete"><i class="fa-solid fa-trash"></i></a>
                                        </td>
                                    </tr>
                                    <% }} else { %>
                                        <tr><td colspan="5" class="text-center text-muted py-4">No records found.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Doughnut Chart -->
                <div class="col-lg-4">
                    <div class="custom-card text-center d-flex flex-column justify-content-between h-100">
                        <div>
                            <h5 class="fw-bold text-start mb-1 theme-text">Expenses by Category</h5>
                            <p class="text-muted small text-start mb-4">Current distribution breakdown</p>
                        </div>
                        <div style="max-width: 240px; margin: 0 auto;">
                            <canvas id="expenseChart"></canvas>
                        </div>
                        <div class="mt-4 text-start">
                            <small class="text-muted"><i class="fa-solid fa-circle-info me-1"></i> Values calculated dynamically from active ledger items.</small>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Modal Popup for Add / Edit -->
    <div class="modal fade" id="expenseModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 p-4" style="background-color: var(--card-bg); color: var(--text-dark);">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0 theme-text"><%= isEdit ? "Edit Transaction" : "Add New Transaction" %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="ExpenseServlet" method="post">
                    <% if (isEdit) { %><input type="hidden" name="id" value="<%= editEx.getId() %>"><% } %>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Description / Title</label>
                        <input type="text" class="form-control rounded-3" name="title" value="<%= isEdit ? editEx.getTitle() : "" %>" placeholder="e.g., Grocery Store, Electric Bill" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Amount ($)</label>
                        <input type="number" step="0.01" class="form-control rounded-3" name="amount" value="<%= isEdit ? editEx.getAmount() : "" %>" placeholder="0.00" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Date</label>
                        <input type="date" class="form-control rounded-3" name="expense_date" value="<%= isEdit ? editEx.getExpenseDate() : "" %>" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted">Category</label>
                        <select class="form-select rounded-3" name="category">
                            <option value="Food" <%= isEdit && "Food".equals(editEx.getCategory()) ? "selected" : "" %>>Food</option>
                            <option value="Transport" <%= isEdit && "Transport".equals(editEx.getCategory()) ? "selected" : "" %>>Transport</option>
                            <option value="Bills" <%= isEdit && "Bills".equals(editEx.getCategory()) ? "selected" : "" %>>Bills</option>
                            <option value="Entertainment" <%= isEdit && "Entertainment".equals(editEx.getCategory()) ? "selected" : "" %>>Entertainment</option>
                            <option value="Other" <%= isEdit && "Other".equals(editEx.getCategory()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-gradient rounded-3 w-100 py-2 fw-bold shadow-sm">Save Transaction</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function getLegendColor() {
            return document.documentElement.getAttribute('data-theme') === 'light' ? '#0f172a' : '#f1f5f9';
        }

        let expenseChart;

        document.addEventListener("DOMContentLoaded", function() {
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const themeIcon = document.getElementById('themeIcon');

            function updateThemeUI(theme) {
                document.documentElement.setAttribute('data-theme', theme);
                if (theme === 'light') {
                    themeIcon.className = "fa-solid fa-sun";
                } else {
                    themeIcon.className = "fa-solid fa-moon";
                }
            }

            const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            updateThemeUI(currentTheme);

            if (themeToggleBtn) {
                themeToggleBtn.addEventListener('click', function () {
                    const activeTheme = document.documentElement.getAttribute('data-theme');
                    const newTheme = activeTheme === 'dark' ? 'light' : 'dark';
                    
                    localStorage.setItem('theme', newTheme);
                    updateThemeUI(newTheme);

                    if (expenseChart) {
                        expenseChart.options.plugins.legend.labels.color = getLegendColor();
                        expenseChart.update();
                    } else {
                        location.reload();
                    }
                });
            }
        });

        <% if (isEdit) { %>
            document.addEventListener("DOMContentLoaded", function() {
                new bootstrap.Modal(document.getElementById('expenseModal')).show();
            });
        <% } %>

        const ctx = document.getElementById('expenseChart').getContext('2d');
        expenseChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: [<% if (categoryTotals != null) { for (String cat : categoryTotals.keySet()) out.print("'" + cat + "',"); } %>],
                datasets: [{
                    data: [<% if (categoryTotals != null) { for (Double amt : categoryTotals.values()) out.print(amt + ","); } %>],
                    backgroundColor: ['#635bff', '#a855f7', '#e649a6', '#f59e0b', '#10b981'],
                    borderWidth: 0
                }]
            },
            options: { 
                plugins: { 
                    legend: { 
                        position: 'bottom',
                        labels: {
                            color: getLegendColor(),
                            font: { family: 'Plus Jakarta Sans', size: 12 }
                        }
                    } 
                }, 
                cutout: '75%' 
            }
        });
    </script>
</body>
</html>