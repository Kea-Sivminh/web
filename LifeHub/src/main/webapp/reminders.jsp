<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lifehub.model.Reminder" %>
<%@ page import="com.lifehub.model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    List<Reminder> reminders = (List<Reminder>) request.getAttribute("reminderList");
    Reminder editReminder = (Reminder) request.getAttribute("editReminder");
    boolean isEdit = (editReminder != null);

    int totalReminders = (reminders != null) ? reminders.size() : 0;
    int pendingReminders = 0;
    int completedReminders = 0;
    
    if (reminders != null) {
        for (Reminder r : reminders) {
            if ("Pending".equalsIgnoreCase(r.getStatus())) pendingReminders++;
            else if ("Completed".equalsIgnoreCase(r.getStatus())) completedReminders++;
        }
    }
%>
<!DOCTYPE html>
<html lang="km">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reminders & Alerts - LifeHub</title>
    
    <!-- External Libraries (Bootstrap & Font Awesome) -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --card-border: #e2e8f0;
            --text-main: #0f172a;
            --text-sub: #64748b;
            --table-bg: #ffffff; /* ពណ៌ Background របស់តារាងសម្រាប់ Light Mode */
            --table-row-hover: #f1f5f9; /* ពណ៌ពេលយក Mouse មកពាក់កណ្តាលជួរដេក */
        }

        [data-bs-theme="dark"], body.dark-mode, .dark {
            --bg-color: #0f172a;
            --card-bg: #1e293b;
            --card-border: rgba(255, 255, 255, 0.08);
            --text-main: #f8fafc;
            --text-sub: #94a3b8;
            --table-bg: #1e293b; /* ពណ៌ Background របស់តារាងសម្រាប់ Dark Mode */
            --table-row-hover: #263348; /* ពណ៌ពេលយក Mouse មកពាក់កណ្តាលជួរដេក Dark Mode */
        }

        * { box-sizing: border-box; }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            font-family: 'Plus Jakarta Sans', sans-serif;
            margin: 0; padding: 0;
            min-height: 100vh;
        }

        .main-wrapper {
            margin-left: var(--sidebar-width, 260px);
            padding: 2.5rem;
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body.sidebar-collapsed .main-wrapper { margin-left: 80px; }

        @media (max-width: 991.98px) {
            .main-wrapper { margin-left: 0; padding: 1.25rem; }
        }

        .white-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 1.75rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.03);
        }

        .hero-banner {
            background: linear-gradient(135deg, #FEF3C7 100%, #FFFBEB 0%);
            border: 1px solid #FDE68A;
            border-radius: 20px;
            padding: 1.75rem 2rem;
        }

        [data-bs-theme="dark"] .hero-banner, body.dark-mode .hero-banner {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.1), rgba(217, 119, 6, 0.1));
            border-color: rgba(255, 255, 255, 0.08);
        }

        .stat-box {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
        }

        .modal-content {
            background-color: var(--card-bg) !important;
            color: var(--text-main) !important;
            border-radius: 24px;
            border: 1px solid var(--card-border);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }

        .form-label-custom {
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 0.4rem;
        }

        .form-control-custom {
            border-radius: 12px;
            border: 1.5px solid var(--card-border);
            background-color: var(--card-bg);
            color: var(--text-main);
            padding: 0.75rem 1rem;
            font-size: 0.95rem;
        }

        .form-control-custom:focus {
            border-color: #d97706;
            background-color: var(--card-bg);
            color: var(--text-main);
            box-shadow: 0 0 0 4px rgba(217, 119, 6, 0.15);
        }

        /* កែតម្រូវ Background របស់ Table ទាំងមូល */
        .table-custom {
            background-color: var(--table-bg) !important;
        }

        .table-custom th {
            background-color: var(--table-bg) !important;
            color: var(--text-sub) !important;
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 800;
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--card-border) !important;
        }

        .table-custom td {
            background-color: var(--table-bg) !important;
            color: var(--text-main);
            padding: 1.25rem;
            vertical-align: middle;
            border-bottom: 1px solid var(--card-border) !important;
        }

        /* បន្ថែមពណ៌ពេលយក Mouse ចង្អុលលើជួរតារាង */
        .table-custom tbody tr:hover td {
            background-color: var(--table-row-hover) !important;
        }

        .action-icon-btn {
            width: 34px; height: 34px;
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 10px;
            border: 1px solid var(--card-border);
            background: var(--card-bg);
            color: var(--text-sub);
            text-decoration: none;
            cursor: pointer;
        }
        .action-icon-btn:hover { background: #FEF3C7; color: #D97706; }
        .action-icon-btn.danger:hover { background: #FEF2F2; color: #DC2626; }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp" />

    <div class="main-wrapper">
        <div class="container-fluid px-0">
            
            <!-- Hero Banner -->
            <div class="hero-banner mb-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h3 class="fw-bold mb-1" style="color: var(--text-main);">Reminders & Alerts</h3>
                    <p class="mb-0 text-muted small">Never miss an important event, meeting, or personal task.</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <!-- Dark/Light Mode Toggle Button -->
                    <button type="button" class="action-icon-btn" id="themeToggleBtn" title="Toggle Light/Dark Mode">
                        <i class="fa-solid fa-moon" id="themeIcon"></i>
                    </button>
                    <button type="button" class="btn rounded-pill px-4 fw-bold shadow-sm text-white" id="openAddModalBtn" style="background-color: #d97706; border: none;">
                        <i class="fa-solid fa-bell-plus me-1"></i> Add Reminder
                    </button>
                </div>
            </div>

            <!-- Stats Overview Grid -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="stat-box d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted d-block small fw-bold text-uppercase">Total Reminders</span>
                            <h2 class="fw-bold mb-0"><%= totalReminders %></h2>
                        </div>
                        <div class="p-3 rounded-4" style="background: #FEF3C7; color: #D97706;">
                            <i class="fa-solid fa-bell fs-3"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted d-block small fw-bold text-uppercase">Pending Alerts</span>
                            <h2 class="fw-bold mb-0 text-warning"><%= pendingReminders %></h2>
                        </div>
                        <div class="p-3 rounded-4" style="background: #FEF9C3; color: #CA8A04;">
                            <i class="fa-solid fa-clock fs-3"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-box d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-muted d-block small fw-bold text-uppercase">Completed</span>
                            <h2 class="fw-bold mb-0 text-success"><%= completedReminders %></h2>
                        </div>
                        <div class="p-3 rounded-4" style="background: #DCFCE7; color: #16A34A;">
                            <i class="fa-solid fa-circle-check fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reminder List Table -->
            <div class="white-card p-0 overflow-hidden">
                <div class="p-4 border-bottom">
                    <h5 class="fw-bold mb-0">Upcoming Reminders</h5>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Date & Time</th>
                                <th>Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (reminders != null && !reminders.isEmpty()) {
                                for (Reminder r : reminders) {
                            %>
                            <tr>
                                <td>
                                    <div class="fw-bold"><%= r.getTitle() %></div>
                                </td>
                                <td>
                                    <small class="text-muted font-monospace"><i class="fa-regular fa-calendar-days me-1"></i> <%= r.getReminderDate() != null ? r.getReminderDate() : "" %></small>
                                </td>
                                <td>
                                    <span class="badge rounded-pill px-3 py-2 <%= "Completed".equalsIgnoreCase(r.getStatus()) ? "bg-success-subtle text-success" : "bg-warning-subtle text-warning" %>">
                                        <%= r.getStatus() %>
                                    </span>
                                </td>
                                <td class="text-end">
                                    <div class="d-inline-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/ReminderServlet?action=edit&id=<%= r.getId() %>" class="action-icon-btn" title="Edit">
                                            <i class="fa-solid fa-pen fa-xs"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/ReminderServlet?action=delete&id=<%= r.getId() %>" onclick="return confirm('Remove this reminder permanently?')" class="action-icon-btn danger" title="Delete">
                                            <i class="fa-solid fa-trash fa-xs"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% 
                                }
                            } else {
                            %>
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-5">
                                        <i class="fa-regular fa-bell-slash fs-1 mb-2 opacity-50"></i>
                                        <p class="mb-0">No reminders added yet.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

    <!-- Modal Popup for Adding/Editing Reminder -->
    <div class="modal fade" id="reminderModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content p-3">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold mb-0"><%= isEdit ? "Edit Reminder" : "Add Reminder" %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pt-3">
                    <form action="${pageContext.request.contextPath}/ReminderServlet" method="post" id="reminderForm">
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= editReminder.getId() %>">
                        <% } %>

                        <!-- Title -->
                        <div class="mb-4">
                            <label class="form-label-custom">Reminder Title <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-custom" name="title" value="<%= isEdit ? editReminder.getTitle() : "" %>" placeholder="e.g. Team Standup Meeting" required>
                        </div>

                        <!-- Date & Time -->
                        <div class="mb-4">
                            <label class="form-label-custom">Date & Time <span class="text-danger">*</span></label>
                            <input type="datetime-local" class="form-control form-control-custom" name="reminder_date" value="<%= isEdit && editReminder.getReminderDate() != null ? editReminder.getReminderDate().replace(" ", "T") : "" %>" required>
                        </div>

                        <!-- Status -->
                        <% if (isEdit) { %>
                        <div class="mb-4">
                            <label class="form-label-custom">Status</label>
                            <select class="form-control form-control-custom" name="status">
                                <option value="Pending" <%= "Pending".equalsIgnoreCase(editReminder.getStatus()) ? "selected" : "" %>>Pending</option>
                                <option value="Completed" <%= "Completed".equalsIgnoreCase(editReminder.getStatus()) ? "selected" : "" %>>Completed</option>
                            </select>
                        </div>
                        <% } %>

                        <div class="d-flex justify-content-end gap-2 pt-2">
                            <button type="button" class="btn btn-light rounded-pill px-4 fw-bold" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn rounded-pill px-4 fw-bold text-white" style="background-color: #d97706; border: none;">
                                <%= isEdit ? "Save Changes" : "Save Reminder" %>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const reminderModalElement = document.getElementById('reminderModal');
            const reminderModal = new bootstrap.Modal(reminderModalElement);

            const openAddModalBtn = document.getElementById('openAddModalBtn');
            if (openAddModalBtn) {
                openAddModalBtn.addEventListener('click', function () {
                    reminderModal.show();
                });
            }

            <% if (isEdit) { %>
                reminderModal.show();
            <% } %>

            // Dark/Light Mode Logic
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const themeIcon = document.getElementById('themeIcon');

            function updateThemeUI(isDark) {
                if (isDark) {
                    document.documentElement.setAttribute('data-bs-theme', 'dark');
                    document.body.classList.add('dark-mode');
                    themeIcon.className = "fa-solid fa-sun";
                } else {
                    document.documentElement.removeAttribute('data-bs-theme');
                    document.body.classList.remove('dark-mode');
                    themeIcon.className = "fa-solid fa-moon";
                }
            }

            // Check saved theme on load
            const savedTheme = localStorage.getItem('theme') || localStorage.getItem('darkMode');
            if (savedTheme === 'dark' || document.documentElement.getAttribute('data-bs-theme') === 'dark' || document.body.classList.contains('dark-mode')) {
                updateThemeUI(true);
            } else {
                updateThemeUI(false);
            }

            // Toggle on click
            if (themeToggleBtn) {
                themeToggleBtn.addEventListener('click', function () {
                    const isDarkMode = document.body.classList.contains('dark-mode');
                    if (isDarkMode) {
                        localStorage.setItem('theme', 'light');
                        updateThemeUI(false);
                    } else {
                        localStorage.setItem('theme', 'dark');
                        updateThemeUI(true);
                    }
                });
            }
        });
    </script>
</body>
</html>