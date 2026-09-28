<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lifehub.model.Goal" %>
<%@ page import="com.lifehub.model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    List<Goal> goals = (List<Goal>) request.getAttribute("goalList");
    Goal editGoal = (Goal) request.getAttribute("editGoal");
    boolean isEdit = (editGoal != null);

    int totalGoals = (goals != null) ? goals.size() : 0;
    int completedGoals = 0;
    int inProgressGoals = 0;
    double totalProgressSum = 0;
    
    if (goals != null) {
        for (Goal g : goals) {
            if ("Completed".equalsIgnoreCase(g.getStatus())) completedGoals++;
            else if ("In Progress".equalsIgnoreCase(g.getStatus()) || "Active".equalsIgnoreCase(g.getStatus())) inProgressGoals++;
            totalProgressSum += g.getProgress();
        }
    }
    double overallProgress = totalGoals > 0 ? totalProgressSum / totalGoals : 0;
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Goals & Milestones - LifeHub</title>
    
    <!-- Sync Theme immediately with Dashboard before rendering to prevent flickering -->
    <script>
        const savedTheme = localStorage.getItem('theme') || 'dark';
        document.documentElement.setAttribute('data-bs-theme', savedTheme);
    </script>

    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            /* Light Mode Theme Variables */
            --bg-color: #f8fafc;
            --text-color: #0b0f19;
            --text-muted: #64748b;
            --card-bg: rgba(255, 255, 255, 0.85);
            --card-border: rgba(0, 0, 0, 0.08);
            --hero-bg: linear-gradient(135deg, rgba(99, 102, 241, 0.08) 0%, rgba(168, 85, 247, 0.08) 100%);
            --hero-border: rgba(99, 102, 241, 0.15);
            --modal-bg: #ffffff;
            --input-bg: #f1f5f9;
            --input-border: #cbd5e1;
            --input-text: #0b0f19;
            --badge-bg: #e2e8f0;
            --badge-text: #334155;
        }

        [data-bs-theme="dark"] {
            /* Dark Mode Theme Variables */
            --bg-color: #0b0f19;
            --text-color: #f8fafc;
            --text-muted: #94a3b8;
            --card-bg: rgba(17, 24, 39, 0.7);
            --card-border: rgba(255, 255, 255, 0.08);
            --hero-bg: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(168, 85, 247, 0.1) 100%);
            --hero-border: rgba(99, 102, 241, 0.2);
            --modal-bg: #111827;
            --input-bg: #1f2937;
            --input-border: rgba(255, 255, 255, 0.1);
            --input-text: #ffffff;
            --badge-bg: rgba(255, 255, 255, 0.05);
            --badge-text: #cbd5e1;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Plus Jakarta Sans', sans-serif;
            margin: 0;
            padding: 0;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        /* Main Content Layout to avoid Sidebar overlap */
        .main-content {
            margin-left: 260px;
            padding: 2.5rem;
            min-height: 100vh;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
        }

        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 1.75rem;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .hero-banner {
            background: var(--hero-bg);
            border: 1px solid var(--hero-border);
            border-radius: 24px;
            padding: 2rem;
            margin-bottom: 2rem;
            transition: background 0.3s ease, border-color 0.3s ease;
        }

        .stat-box {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 18px;
            padding: 1.5rem;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .text-dynamic-muted {
            color: var(--text-muted) !important;
        }

        .btn-gradient {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            border: none;
            color: #fff;
            font-weight: 700;
            border-radius: 50px;
            padding: 0.6rem 1.5rem;
            transition: opacity 0.2s;
        }
        .btn-gradient:hover { opacity: 0.9; color: #fff; }

        /* Theme Toggle Button Style */
        .theme-toggle-btn {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            color: var(--text-color);
            width: 42px; 
            height: 42px;
            display: inline-flex; 
            align-items: center; 
            justify-content: center;
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .theme-toggle-btn:hover {
            background: rgba(99, 102, 241, 0.15);
            color: #6366f1;
        }

        .progress-custom {
            height: 8px;
            background-color: var(--input-border);
            border-radius: 10px;
        }
        .progress-fill {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            border-radius: 10px;
            height: 100%;
        }

        /* Dynamic Badges */
        .badge-dynamic {
            background-color: var(--badge-bg);
            color: var(--badge-text);
        }

        /* Modal Customization */
        .modal-content {
            background-color: var(--modal-bg);
            border: 1px solid var(--card-border);
            color: var(--text-color);
            border-radius: 24px;
        }
        
        .btn-close {
            filter: var(--bs-btn-close-white-filter, none);
        }
        [data-bs-theme="dark"] .btn-close {
            filter: invert(1) grayscale(100%) brightness(200%);
        }

        .form-control, .form-select {
            background-color: var(--input-bg);
            border: 1px solid var(--input-border);
            color: var(--input-text);
            border-radius: 12px;
            padding: 0.75rem 1rem;
        }
        .form-control:focus, .form-select:focus {
            background-color: var(--input-bg);
            color: var(--input-text);
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.2);
        }

        .action-btn {
            background: var(--input-bg);
            border: 1px solid var(--input-border);
            color: var(--text-muted);
            width: 34px; height: 34px;
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 10px;
            text-decoration: none;
        }
        .action-btn:hover { background: rgba(99, 102, 241, 0.2); color: #818cf8; }
        .action-btn.danger:hover { background: rgba(239, 68, 68, 0.2); color: #f87171; }
    </style>
</head>
<body>

    <!-- ដាក់បញ្ចូល Sidebar នៅទីนี่ -->
    <jsp:include page="sidebar.jsp" />

    <!-- ຫ่อหุ้มเนื้อหาทั้งหมดให้อยู่ใน main-content -->
    <div class="main-content">
        <div class="container-fluid py-4">
            <!-- Hero Header -->
            <div class="hero-banner d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h1 class="fw-bold mb-1 fs-2">Your Master Plan</h1>
                    <p class="mb-0 text-dynamic-muted">Track aspirations, maintain momentum, and build your ideal future.</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <!-- Theme Toggle Button -->
                    <button class="theme-toggle-btn" id="themeToggleBtn" onclick="toggleTheme()" title="Toggle Light/Dark Mode">
                        <i class="fa-solid fa-moon" id="themeIcon"></i>
                    </button>
                    <button class="btn btn-gradient" data-bs-toggle="modal" data-bs-target="#goalModal">
                        <i class="fa-solid fa-plus me-1"></i> New Goal
                    </button>
                </div>
            </div>

            <!-- Statistics Grid -->
            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="stat-box">
                        <span class="text-dynamic-muted small fw-bold text-uppercase d-block mb-1">Total Goals</span>
                        <h2 class="fw-bold mb-0"><%= totalGoals %></h2>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <span class="text-dynamic-muted small fw-bold text-uppercase d-block mb-1">In Progress</span>
                        <h2 class="fw-bold mb-0 text-warning"><%= inProgressGoals %></h2>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <span class="text-dynamic-muted small fw-bold text-uppercase d-block mb-1">Completed</span>
                        <h2 class="fw-bold mb-0 text-success"><%= completedGoals %></h2>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-box">
                        <span class="text-dynamic-muted small fw-bold text-uppercase d-block mb-1">Overall Progress</span>
                        <h2 class="fw-bold mb-0 text-info"><%= String.format("%.0f", overallProgress) %>%</h2>
                    </div>
                </div>
            </div>

            <!-- Goals Cards / Grid View -->
            <div class="row g-4">
                <% 
                if (goals != null && !goals.isEmpty()) {
                    for (Goal g : goals) {
                %>
                <div class="col-md-4">
                    <div class="glass-card d-flex flex-column justify-content-between h-100">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="badge badge-dynamic px-3 py-1 rounded-pill small fw-bold text-uppercase"><%= g.getCategory() != null ? g.getCategory() : "Personal" %></span>
                                <span class="small fw-bold text-<%= "High".equalsIgnoreCase(g.getPriority()) ? "danger" : ("Medium".equalsIgnoreCase(g.getPriority()) ? "warning" : "success") %>">● <%= g.getPriority() != null ? g.getPriority() : "Medium" %> Priority</span>
                            </div>
                            <h4 class="fw-bold mb-2 fs-5"><%= g.getTitle() %></h4>
                            <p class="text-dynamic-muted small mb-4"><%= g.getDescription() != null ? g.getDescription() : "No details provided." %></p>
                        </div>
                        <div>
                            <div class="d-flex justify-content-between small text-dynamic-muted mb-2 font-monospace">
                                <span>Progress</span>
                                <span class="fw-bold"><%= g.getProgress() %>%</span>
                            </div>
                            <div class="progress progress-custom mb-3">
                                <div class="progress-fill" style="width: <%= g.getProgress() %>%;"></div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="small text-dynamic-muted"><i class="fa-regular fa-calendar me-1"></i> <%= g.getTargetDate() != null ? g.getTargetDate() : "No date" %></span>
                                <div class="d-flex gap-2">
                                    <a href="GoalServlet?action=edit&id=<%= g.getId() %>" class="action-btn" title="Edit">
                                        <i class="fa-solid fa-pen fa-xs"></i>
                                    </a>
                                    <a href="GoalServlet?action=delete&id=<%= g.getId() %>" onclick="return confirm('Delete this goal?')" class="action-btn danger" title="Delete">
                                        <i class="fa-solid fa-trash fa-xs"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% 
                    }
                } else {
                %>
                <div class="col-12 text-center py-5 text-dynamic-muted">
                    <i class="fa-regular fa-folder-open fs-1 mb-3 opacity-50"></i>
                    <p>No goals found. Click "New Goal" to add your first objective!</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Modal Form -->
    <div class="modal fade" id="goalModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold mb-0"><%= isEdit ? "Edit Goal" : "Add New Goal" %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-3">
                    <form action="GoalServlet" method="post">
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= editGoal.getId() %>">
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-dynamic-muted text-uppercase">Goal Title</label>
                            <input type="text" class="form-control" name="title" value="<%= isEdit ? editGoal.getTitle() : "" %>" placeholder="e.g. Master Full-Stack Architecture" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-dynamic-muted text-uppercase">Description & Action Steps</label>
                            <textarea class="form-control" name="description" rows="3" placeholder="Briefly describe what success looks like..."><%= isEdit && editGoal.getDescription() != null ? editGoal.getDescription() : "" %></textarea>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-dynamic-muted text-uppercase">Category</label>
                                <select class="form-select" name="category">
                                    <option value="Career" <%= isEdit && "Career".equals(editGoal.getCategory()) ? "selected" : "" %>>Career</option>
                                    <option value="Health" <%= isEdit && "Health".equals(editGoal.getCategory()) ? "selected" : "" %>>Health</option>
                                    <option value="Finance" <%= isEdit && "Finance".equals(editGoal.getCategory()) ? "selected" : "" %>>Finance</option>
                                    <option value="Personal" <%= isEdit && "Personal".equals(editGoal.getCategory()) ? "selected" : (!isEdit ? "selected" : "") %>>Personal</option>
                                    <option value="Learning" <%= isEdit && "Learning".equals(editGoal.getCategory()) ? "selected" : "" %>>Learning</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-dynamic-muted text-uppercase">Priority</label>
                                <select class="form-select" name="priority">
                                    <option value="High" <%= isEdit && "High".equals(editGoal.getPriority()) ? "selected" : "" %>>High</option>
                                    <option value="Medium" <%= isEdit && "Medium".equals(editGoal.getPriority()) ? "selected" : (!isEdit ? "selected" : "") %>>Medium</option>
                                    <option value="Low" <%= isEdit && "Low".equals(editGoal.getPriority()) ? "selected" : "" %>>Low</option>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-dynamic-muted text-uppercase">Status</label>
                                <select class="form-select" name="status">
                                    <option value="Not Started" <%= isEdit && "Not Started".equals(editGoal.getStatus()) ? "selected" : "" %>>Not Started</option>
                                    <option value="In Progress" <%= isEdit && "In Progress".equals(editGoal.getStatus()) ? "selected" : (!isEdit ? "selected" : "") %>>In Progress</option>
                                    <option value="Completed" <%= isEdit && "Completed".equals(editGoal.getStatus()) ? "selected" : "" %>>Completed</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-dynamic-muted text-uppercase">Target Date</label>
                                <input type="date" class="form-control" name="target_date" value="<%= isEdit && editGoal.getTargetDate() != null ? editGoal.getTargetDate() : "" %>">
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold text-dynamic-muted text-uppercase">Progress (%)</label>
                            <input type="number" class="form-control" name="progress" min="0" max="100" value="<%= isEdit ? editGoal.getProgress() : "0" %>">
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-gradient px-4">Save Goal</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Open Modal Automatically on Edit Action -->
    <% if (isEdit) { %>
    <script>
        window.addEventListener('DOMContentLoaded', (event) => {
            var goalModal = new bootstrap.Modal(document.getElementById('goalModal'));
            goalModal.show();
        });
    </script>
    <% } %>

    <!-- Script for Theme Toggle Functionality -->
    <script>
        function updateThemeIcon(theme) {
            const icon = document.getElementById('themeIcon');
            if (theme === 'dark') {
                icon.className = 'fa-solid fa-moon';
            } else {
                icon.className = 'fa-solid fa-sun';
            }
        }

        function toggleTheme() {
            const currentTheme = document.documentElement.getAttribute('data-bs-theme');
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            
            document.documentElement.setAttribute('data-bs-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeIcon(newTheme);
        }

        // Initialize icon on page load based on current theme
        document.addEventListener('DOMContentLoaded', () => {
            const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'dark';
            updateThemeIcon(currentTheme);
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>