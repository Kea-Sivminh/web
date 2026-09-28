<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lifehub.model.Task" %>
<%@ page import="com.lifehub.model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    List<Task> tasks = (List<Task>) request.getAttribute("taskList");
    Task editTask = (Task) request.getAttribute("taskToEdit");
    boolean isEdit = (editTask != null);

    int totalTasks = 0;
    int inProgressTasks = 0;
    int completedTasks = 0;
    int highPriorityTasks = 0;
    
    if (tasks != null) {
        totalTasks = tasks.size();
        for (Task t : tasks) {
            String status = t.getStatus() != null ? t.getStatus() : "";
            String priority = t.getPriority() != null ? t.getPriority() : "";
            
            if ("Completed".equalsIgnoreCase(status)) {
                completedTasks++;
            } else {
                inProgressTasks++; 
            }
            
            if ("High".equalsIgnoreCase(priority)) {
                highPriorityTasks++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management - LifeHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-light: #f8fafc;
            --card-bg: #ffffff;
            --primary-color: #4f46e5;
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --sidebar-width: 260px;
        }

        [data-theme="dark"] {
            --bg-light: #0f172a;
            --card-bg: #1e293b;
            --text-dark: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
        }

        body {
            background-color: var(--bg-light);
            color: var(--text-dark);
            font-family: 'Plus Jakarta Sans', sans-serif;
            overflow-x: hidden;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        [data-theme="dark"] .text-dark { color: #f8fafc !important; }
        [data-theme="dark"] .text-muted { color: #94a3b8 !important; }

        .main-wrapper {
            margin-left: var(--sidebar-width);
            padding: 2.5rem;
            transition: all 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .main-wrapper { margin-left: 0; padding: 1rem; }
        }

        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
            transition: transform 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-2px);
        }

        .custom-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        }

        .task-item-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            transition: all 0.2s ease;
        }
        .task-item-card:hover {
            border-color: var(--primary-color);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.08);
        }
        .task-item-card.completed {
            border-color: #dcfce7;
            background-color: rgba(240, 253, 244, 0.4);
        }
        [data-theme="dark"] .task-item-card.completed {
            background-color: rgba(20, 83, 45, 0.15);
            border-color: #14532d;
        }

        .btn-gradient {
            background: var(--primary-gradient);
            color: white;
            border: none;
            transition: all 0.2s ease;
        }
        .btn-gradient:hover {
            opacity: 0.95;
            color: white;
            transform: translateY(-1px);
        }

        .badge-category {
            background-color: #eef2ff;
            color: #4f46e5;
            font-weight: 600;
            font-size: 0.75rem;
            padding: 0.35em 0.75em;
            border-radius: 20px;
        }
        [data-theme="dark"] .badge-category {
            background-color: rgba(79, 70, 229, 0.2);
            color: #818cf8;
        }

        .badge-priority-high { background-color: #fef2f2; color: #dc2626; font-weight: 600; font-size: 0.75rem; padding: 0.35em 0.75em; border-radius: 20px; }
        .badge-priority-medium { background-color: #fffbeb; color: #d97706; font-weight: 600; font-size: 0.75rem; padding: 0.35em 0.75em; border-radius: 20px; }
        .badge-priority-low { background-color: #f8fafc; color: #64748b; font-weight: 600; font-size: 0.75rem; padding: 0.35em 0.75em; border-radius: 20px; border: 1px solid #e2e8f0; }

        [data-theme="dark"] .badge-priority-high { background-color: rgba(220, 38, 38, 0.2); color: #f87171; }
        [data-theme="dark"] .badge-priority-medium { background-color: rgba(217, 119, 6, 0.2); color: #fbbf24; }
        [data-theme="dark"] .badge-priority-low { background-color: rgba(100, 116, 139, 0.2); color: #94a3b8; border-color: #334155; }

        .btn-action-icon {
            color: #94a3b8;
            background: transparent;
            border: none;
            padding: 0.25rem 0.5rem;
            transition: color 0.2s ease;
        }
        .btn-action-icon:hover { color: #4f46e5; }
        .btn-action-icon.text-danger:hover { color: #dc2626; }

        .modal-content {
            background-color: var(--card-bg);
            color: var(--text-dark);
            border-radius: 24px;
            border: 1px solid var(--border-color);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        .form-control, .form-select {
            background-color: var(--card-bg);
            color: var(--text-dark);
            border-color: var(--border-color);
            padding: 0.65rem 1rem;
            font-size: 0.875rem;
            border-radius: 12px;
        }
        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
            border-color: #4f46e5;
            background-color: var(--card-bg);
            color: var(--text-dark);
        }
        [data-theme="dark"] .form-control::placeholder { color: #94a3b8; }

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
        .theme-toggle-btn:hover {
            background: var(--border-color);
            transform: scale(1.05);
        }
    </style>

    <script>
        (function() {
            const savedTheme = localStorage.getItem('theme') || localStorage.getItem('bs-theme') || 'dark';
            document.documentElement.setAttribute('data-theme', savedTheme);
        })();
    </script>
</head>
<body>

    <jsp:include page="sidebar.jsp" />

    <div class="main-wrapper">
        <div class="container-fluid px-0">

            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h3 class="fw-bold mb-1 text-dark"> Tasks </h3>
                    <p class="text-muted small mb-0">Managing activities for <strong><%= user.getName() %></strong></p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="theme-toggle-btn" id="themeToggleBtn" title="Toggle Light/Dark Mode">
                        <i class="fa-solid fa-moon" id="themeIcon"></i>
                    </button>
                    <button class="btn btn-gradient rounded-pill px-4 py-2 fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#taskModal" onclick="resetTaskForm()">
                        <i class="fa-solid fa-plus me-2"></i>New Task
                    </button>
                </div>
            </div>

            <!-- Stat Cards Section -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.5px;">TOTAL TASKS</span>
                            <h3 class="fw-bold text-dark mb-0 mt-1"><%= totalTasks %></h3>
                        </div>
                        <div class="p-3 rounded-4" style="background-color: #eef2ff; color: #4f46e5;">
                            <i class="fa-solid fa-clipboard-list fs-4"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.5px;">IN PROGRESS</span>
                            <h3 class="fw-bold mb-0 mt-1" style="color: #d97706;"><%= inProgressTasks %></h3>
                        </div>
                        <div class="p-3 rounded-4" style="background-color: #fffbeb; color: #d97706;">
                            <i class="fa-regular fa-clock fs-4"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.5px;">COMPLETED</span>
                            <h3 class="fw-bold mb-0 mt-1" style="color: #16a34a;"><%= completedTasks %></h3>
                        </div>
                        <div class="p-3 rounded-4" style="background-color: #f0fdf4; color: #16a34a;">
                            <i class="fa-regular fa-circle-check fs-4"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-sm-6">
                    <div class="stat-card d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.5px;">HIGH PRIORITY</span>
                            <h3 class="fw-bold mb-0 mt-1" style="color: #dc2626;"><%= highPriorityTasks %></h3>
                        </div>
                        <div class="p-3 rounded-4" style="background-color: #fef2f2; color: #dc2626;">
                            <i class="fa-solid fa-circle-exclamation fs-4"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="text-muted small">Showing <%= totalTasks %> of <%= totalTasks %> tasks</span>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small">Sort by:</span>
                    <select class="form-select form-select-sm rounded-pill py-1 px-3 text-muted border-light bg-white" style="width: 130px; font-size: 0.8rem;">
                        <option selected>Due Date</option>
                        <option>Priority</option>
                        <option>Title</option>
                    </select>
                </div>
            </div>

            <!-- Task List Display -->
            <div class="task-list">
                <% 
                if (tasks != null && !tasks.isEmpty()) {
                    for (Task t : tasks) {
                        boolean isCompleted = "Completed".equalsIgnoreCase(t.getStatus());
                        String priority = t.getPriority() != null ? t.getPriority() : "Medium";
                        String priorityBadgeClass = "badge-priority-medium";
                        if ("High".equalsIgnoreCase(priority)) priorityBadgeClass = "badge-priority-high";
                        else if ("Low".equalsIgnoreCase(priority)) priorityBadgeClass = "badge-priority-low";
                %>
                <div class="task-item-card d-flex align-items-center justify-content-between flex-wrap gap-3 <%= isCompleted ? "completed" : "" %>">
                    <div class="d-flex align-items-start gap-3">
                        <div class="pt-1">
                            <!-- Clickable Icon to Toggle Status -->
                            <a href="TaskServlet?action=toggleStatus&id=<%= t.getId() %>&status=<%= t.getStatus() %>" 
                               class="text-decoration-none" 
                               title="Click to toggle status">
                                <% if (isCompleted) { %>
                                    <span class="text-success fs-5"><i class="fa-solid fa-circle-check"></i></span>
                                <% } else { %>
                                    <span class="text-muted fs-5"><i class="fa-regular fa-circle"></i></span>
                                <% } %>
                            </a>
                        </div>
                        <div>
                            <h6 class="fw-bold text-dark mb-1 <%= isCompleted ? "text-decoration-line-through text-muted" : "" %>">
                                <%= t.getTitle() %>
                            </h6>
                            <p class="text-muted small mb-2"><%= t.getDescription() != null ? t.getDescription() : "" %></p>
                            <div class="d-flex align-items-center flex-wrap gap-2">
                                <span class="badge-category"><%= t.getCategory() != null ? t.getCategory() : "General" %></span>
                                <span class="<%= priorityBadgeClass %>"><%= priority %> Priority</span>
                                <span class="text-muted small"><i class="fa-regular fa-calendar me-1"></i> <%= t.getDueDate() != null ? t.getDueDate() : "No Date" %></span>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex align-items-center gap-1">
                        <a href="TaskServlet?action=edit&id=<%= t.getId() %>" class="btn btn-action-icon" title="Edit">
                            <i class="fa-solid fa-pen"></i>
                        </a>
                        <a href="TaskServlet?action=delete&id=<%= t.getId() %>" onclick="return confirm('Delete this task?')" class="btn btn-action-icon text-danger" title="Delete">
                            <i class="fa-solid fa-trash"></i>
                        </a>
                    </div>
                </div>
                <% 
                    }
                } else {
                %>
                    <div class="custom-card text-center text-muted py-5">
                        <i class="fa-solid fa-clipboard-list fs-1 mb-2 d-block opacity-25"></i>
                        No tasks found! Click <strong>"+ New Task"</strong> to add your activities.
                    </div>
                <% } %>
            </div>

        </div>
    </div>

    <!-- Modern Task Modal Form -->
    <div class="modal fade" id="taskModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-4">
                <div class="modal-header border-0 pb-3">
                    <h5 class="modal-title fw-bold text-dark fs-5">
                        <%= isEdit ? "Edit Task" : "Create New Task" %>
                    </h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-0">
                    <form action="TaskServlet" method="post" id="taskForm" onsubmit="preventDoubleSubmit(this)">
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= editTask.getId() %>">
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-dark">Task Title *</label>
                            <input type="text" class="form-control" name="title" value="<%= isEdit ? editTask.getTitle() : "" %>" placeholder="e.g., Complete quarterly budget audit" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-dark">Category</label>
                                <select class="form-select" name="category">
                                    <option value="Work" <%= isEdit && "Work".equalsIgnoreCase(editTask.getCategory()) ? "selected" : "" %>>Work</option>
                                    <option value="Personal" <%= isEdit && "Personal".equalsIgnoreCase(editTask.getCategory()) ? "selected" : "" %>>Personal</option>
                                    <option value="Health" <%= isEdit && "Health".equalsIgnoreCase(editTask.getCategory()) ? "selected" : "" %>>Health</option>
                                    <option value="Finance" <%= isEdit && "Finance".equalsIgnoreCase(editTask.getCategory()) ? "selected" : "" %>>Finance</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-dark">Priority</label>
                                <select class="form-select" name="priority">
                                    <option value="Low" <%= isEdit && "Low".equalsIgnoreCase(editTask.getPriority()) ? "selected" : "" %>>Low</option>
                                    <option value="Medium" <%= isEdit && "Medium".equalsIgnoreCase(editTask.getPriority()) ? "selected" : "" %> <%= !isEdit ? "selected" : "" %>>Medium</option>
                                    <option value="High" <%= isEdit && "High".equalsIgnoreCase(editTask.getPriority()) ? "selected" : "" %>>High</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-dark">Due Date</label>
                            <input type="date" class="form-control" name="dueDate" id="dueDateInput" value="<%= isEdit ? editTask.getDueDate() : "" %>">
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-dark">Notes / Description (Optional)</label>
                            <textarea class="form-control" name="description" rows="3" placeholder="Add any details or sub-steps..."><%= isEdit ? editTask.getDescription() : "" %></textarea>
                        </div>

                        <div class="d-flex align-items-center justify-content-end gap-2 pt-2 border-top border-light">
                            <button type="button" class="btn btn-light rounded-3 px-4 py-2 fw-semibold text-muted" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" id="submitBtn" class="btn btn-gradient rounded-3 px-4 py-2 fw-bold">
                                <%= isEdit ? "Update Task" : "Save Task" %>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const themeIcon = document.getElementById('themeIcon');

            function updateThemeUI(theme) {
                document.documentElement.setAttribute('data-theme', theme);
                if (theme === 'dark') {
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
                    localStorage.setItem('bs-theme', newTheme);
                    updateThemeUI(newTheme);
                });
            }

            window.addEventListener('storage', function(e) {
                if (e.key === 'theme' || e.key === 'bs-theme') {
                    updateThemeUI(e.newValue || 'dark');
                }
            });

            const dueDateInput = document.getElementById('dueDateInput');
            <% if (!isEdit) { %>
                const today = new Date().toISOString().split('T')[0];
                if (dueDateInput && !dueDateInput.value) {
                    dueDateInput.value = today;
                }
            <% } %>

            <% if (isEdit) { %>
                var taskModal = new bootstrap.Modal(document.getElementById('taskModal'));
                taskModal.show();
            <% } %>

            const sortSelect = document.querySelector('select.form-select');

            if (sortSelect) {
                sortSelect.addEventListener('change', function() {
                    const sortBy = this.value.trim();
                    const taskListContainer = document.querySelector('.task-list');
                    const taskItems = document.querySelectorAll('.task-list .task-item-card');
                    const tasksArray = Array.from(taskItems);

                    tasksArray.sort((a, b) => {
                        if (sortBy === 'Title') {
                            let titleA = a.querySelector('h6').textContent.trim().toLowerCase();
                            let titleB = b.querySelector('h6').textContent.trim().toLowerCase();
                            return titleA.localeCompare(titleB);
                        } else if (sortBy === 'Priority') {
                            const priorityWeight = { 'High': 1, 'Medium': 2, 'Low': 3 };
                            let pA = a.querySelector('[class*="badge-priority-"]').textContent.trim().replace(' Priority', '');
                            let pB = b.querySelector('[class*="badge-priority-"]').textContent.trim().replace(' Priority', '');
                            return (priorityWeight[pA] || 2) - (priorityWeight[pB] || 2);
                        } else if (sortBy === 'Due Date') {
                            let dateA = a.querySelector('.fa-calendar').parentNode.textContent.trim();
                            let dateB = b.querySelector('.fa-calendar').parentNode.textContent.trim();
                            if (dateA === 'No Date') return 1;
                            if (dateB === 'No Date') return -1;
                            return new Date(dateA) - new Date(dateB);
                        }
                        return 0;
                    });

                    tasksArray.forEach(task => taskListContainer.appendChild(task));
                });
            }
        });

        function resetTaskForm() {
            if (window.location.search.includes('action=edit')) {
                window.location.href = 'TaskServlet';
            }
        }

        function preventDoubleSubmit(form) {
            var btn = document.getElementById('submitBtn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin me-1"></i> Saving...';
        }
    </script>
</body>
</html>