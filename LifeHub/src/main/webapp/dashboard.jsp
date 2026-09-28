<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lifehub.model.User"%>
<%@ page import="com.lifehub.model.Task"%>
<%@ page import="com.lifehub.model.Reminder"%>
<%@ page import="com.lifehub.model.Event"%>
<%@ page import="com.lifehub.model.Document"%>
<%@ page import="java.util.List"%>
<% 
    User user = (User) session.getAttribute("currentUser"); 
    if(user == null){
        response.sendRedirect("Login.jsp");
        return;
    }

    int taskCount = 0;
    Object taskAttr = request.getAttribute("taskCount");
    if (taskAttr instanceof Integer) { taskCount = (Integer) taskAttr; }
    else if (taskAttr instanceof List) { taskCount = ((List<?>) taskAttr).size(); }

    Integer reminderCount = (Integer) request.getAttribute("reminderCount");
    if (reminderCount == null) reminderCount = 0;

    int documentCount = 0;
    Object docAttr = request.getAttribute("documentCount");
    if (docAttr instanceof Integer) { documentCount = (Integer) docAttr; }
    else if (docAttr instanceof List) { documentCount = ((List<?>) docAttr).size(); }

    List<Event> events = (List<Event>) request.getAttribute("eventList");
    int eventCount = (events != null) ? events.size() : 0;

    List<Task> taskList = (List<Task>) request.getAttribute("taskList");
    List<Reminder> reminderList = (List<Reminder>) request.getAttribute("reminderList");
    List<Document> documentList = (List<Document>) request.getAttribute("documentList");

    Double totalBalance = (Double) request.getAttribute("totalBalance");
    Double totalIncome = (Double) request.getAttribute("totalIncome");
    Double totalExpense = (Double) request.getAttribute("totalExpense");
    if(totalBalance == null) totalBalance = 0.0;
    if(totalIncome == null) totalIncome = 0.0;
    if(totalExpense == null) totalExpense = 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LifeHub - Professional Dashboard</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --bg-main: #f0f2f5;
            --card-bg: #ffffff;
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --border-light: #f1f5f9;
            --border-card: #e8ecf2;
            --input-bg: #f8fafc;
            --shadow-sm: 0 2px 4px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.04);
            --shadow-md: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -4px rgba(0, 0, 0, 0.03);
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            --accent-glow: 0 0 20px rgba(99, 102, 241, 0.15);
        }

        [data-theme="dark"] {
            --bg-main: #05070b;
            --card-bg: #111827;
            --text-dark: #f9fafb;
            --text-muted: #9ca3af;
            --border-light: rgba(255, 255, 255, 0.04);
            --border-card: rgba(255, 255, 255, 0.08);
            --input-bg: #0b0f19;
            --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.3);
            --shadow-md: 0 10px 15px -3px rgba(0, 0, 0, 0.4);
        }

        body {
            background-color: var(--bg-main);
            color: var(--text-dark);
            font-family: 'Plus Jakarta Sans', sans-serif;
            overflow-x: hidden;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .main-content {
            margin-left: 260px;
            padding: 2.5rem;
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .main-content { margin-left: 0; padding: 1.25rem; }
        }

        h1, h2, h3, h4, h5, h6, .fw-bold { color: var(--text-dark) !important; }
        .text-muted { color: var(--text-muted) !important; }

        .dashboard-card {
            background: var(--card-bg);
            border-radius: 20px;
            border: 1px solid var(--border-card);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .dashboard-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: rgba(99, 102, 241, 0.3);
        }

        .search-box {
            background: var(--card-bg);
            border: 1px solid var(--border-card);
            border-radius: 14px;
            padding: 0.6rem 1.1rem;
            display: flex;
            align-items: center;
            gap: 12px;
            width: 380px;
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
        }
        .search-box:focus-within {
            border-color: #6366f1;
            box-shadow: var(--accent-glow);
        }
        .search-box input {
            background: transparent;
            border: none;
            outline: none;
            color: var(--text-dark);
            font-size: 0.9rem;
            width: 100%;
        }

        .btn-quick {
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.8rem;
            padding: 0.5rem 1rem;
            border: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-quick:hover { transform: translateY(-2px); filter: brightness(0.95); }

        .stat-box {
            background: var(--card-bg);
            border-radius: 18px;
            border: 1px solid var(--border-card);
            padding: 1.25rem;
            display: flex;
            align-items: center;
            gap: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
            height: 100%;
            text-decoration: none;
        }
        .stat-box:hover { 
            transform: translateY(-4px); 
            box-shadow: var(--shadow-md); 
            border-color: rgba(99, 102, 241, 0.4); 
        }

        .stat-icon {
            width: 52px; height: 52px; border-radius: 16px;
            display: flex; align-items: center; justify-content: center; font-size: 1.35rem;
            flex-shrink: 0;
        }

        .theme-btn, .bell-btn {
            width: 44px; height: 44px; border-radius: 14px;
            border: 1px solid var(--border-card);
            background-color: var(--card-bg); color: var(--text-dark);
            display: flex; align-items: center; justify-content: center; cursor: pointer;
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
            position: relative;
        }
        .theme-btn:hover, .bell-btn:hover { background-color: var(--border-light); transform: scale(1.05); }

        .bell-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: #ef4444;
            color: white;
            font-size: 0.65rem;
            padding: 2px 6px;
            border-radius: 10px;
            font-weight: 700;
            border: 2px solid var(--card-bg);
        }

        .dropdown-menu {
            background-color: var(--card-bg);
            border: 1px solid var(--border-card);
            box-shadow: var(--shadow-md);
            border-radius: 18px;
            padding: 0.85rem;
            width: 330px;
        }

        .task-input-bar {
            background: var(--input-bg);
            border: 1px solid var(--border-card);
            border-radius: 14px;
            padding: 0.45rem 0.45rem 0.45rem 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.2s ease;
        }
        .task-input-bar:focus-within {
            border-color: #6366f1;
            box-shadow: var(--accent-glow);
        }
        .task-input-bar input {
            background: transparent; border: none; outline: none; color: var(--text-dark); font-size: 0.85rem; width: 100%;
        }

        .user-profile-pill {
            background-color: var(--card-bg); 
            border: 1px solid var(--border-card) !important;
            border-radius: 16px;
            padding: 0.4rem 0.9rem;
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
        }
        .user-profile-pill:hover {
            border-color: rgba(99, 102, 241, 0.4) !important;
        }

        .custom-scroll::-webkit-scrollbar { width: 5px; }
        .custom-scroll::-webkit-scrollbar-track { background: transparent; }
        .custom-scroll::-webkit-scrollbar-thumb { background: var(--border-card); border-radius: 10px; }
        .custom-scroll::-webkit-scrollbar-thumb:hover { background: var(--text-muted); }

        .list-item-hover {
            transition: background-color 0.15s ease;
            border-radius: 10px;
            padding: 8px 10px;
            margin-bottom: 6px;
        }
        .list-item-hover:hover { background-color: var(--border-light); }
    </style>
</head>
<body>

    <!-- Sidebar Include -->
    <jsp:include page="sidebar.jsp" />

    <div class="main-content">
        
        <!-- Top Navigation Bar -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass text-muted"></i>
                <input type="text" placeholder="Search tasks, events, documents...">
            </div>

            <div class="d-flex align-items-center gap-3">
                <!-- Bell Reminder Dropdown -->
                <div class="dropdown">
                    <button class="bell-btn dropdown-toggle hide-arrow" type="button" id="reminderDropdown" data-bs-toggle="dropdown" aria-expanded="false" title="Reminders">
                        <i class="fa-regular fa-bell"></i>
                        <% if(reminderCount > 0) { %>
                            <span class="bell-badge"><%= reminderCount %></span>
                        <% } %>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end mt-2 animate slideIn" aria-labelledby="reminderDropdown">
                        <li class="d-flex justify-content-between align-items-center px-2 pb-2 border-bottom" style="border-color: var(--border-card) !important;">
                            <span class="fw-bold" style="font-size: 0.85rem;">Reminders</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-2 py-1" style="font-size: 0.7rem;"><%= reminderCount %> New</span>
                        </li>
                        <div class="py-2 custom-scroll" style="max-height: 250px; overflow-y: auto;">
                            <% if(reminderList != null && !reminderList.isEmpty()) { 
                                for(Reminder r : reminderList) { %>
                                    <div class="list-item-hover d-flex align-items-start gap-2">
                                        <div class="bg-warning bg-opacity-10 text-warning rounded-circle d-flex align-items-center justify-content-center mt-1" style="width: 24px; height: 24px; font-size: 0.75rem; flex-shrink: 0;">
                                            <i class="fa-solid fa-bell"></i>
                                        </div>
                                        <div>
                                            <span class="fw-semibold text-dark d-block" style="font-size: 0.8rem;"><%= r.getTitle() %></span>
                                            <small class="text-muted" style="font-size: 0.7rem;"><%= r.getReminderDate() != null ? r.getReminderDate() : "" %></small>
                                        </div>
                                    </div>
                                <% } 
                            } else { %>
                                <div class="text-center py-4">
                                    <i class="fa-regular fa-bell-slash text-muted fs-4 mb-2 opacity-50"></i>
                                    <p class="text-muted small mb-0">No new reminders right now.</p>
                                </div>
                            <% } %>
                        </div>
                        <div class="pt-2 border-top" style="border-color: var(--border-card) !important;">
                            <a href="ReminderServlet" class="btn btn-sm btn-primary w-100 rounded-pill fw-bold shadow-sm" style="font-size: 0.75rem; background: var(--primary-gradient); border: none; padding: 0.5rem;">View All Reminders</a>
                        </div>
                    </ul>
                </div>

                <!-- Theme Toggle -->
                <button id="themeToggle" class="theme-btn" title="Toggle Dark/Light Mode">
                    <i id="themeIcon" class="fa-regular fa-moon"></i>
                </button>

                <!-- User Profile -->
                <a href="ProfileServlet" class="text-decoration-none d-flex align-items-center gap-2 user-profile-pill">
                    <div class="text-white d-flex align-items-center justify-content-center fw-bold shadow-sm" style="width: 36px; height: 36px; border-radius: 12px; font-size: 0.9rem; background: var(--primary-gradient);">
                        <%= user.getName().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="lh-1 pe-1">
                        <span class="fw-bold d-block" style="font-size: 0.85rem; color: var(--text-dark);"><%= user.getName() %></span>
                        <small class="text-muted" style="font-size: 0.7rem;">Workspace Member</small>
                    </div>
                </a>
            </div>
        </div>

        <!-- Banner Greeting & Quick Access Toolbar -->
        <div class="row align-items-center mb-4 g-3">
            <div class="col-lg-5">
                <h3 class="fw-bold mb-1" style="letter-spacing: -0.5px;">Welcome back, <%= user.getName() %>! 👋</h3>
                <p class="text-muted small mb-0">Here is a polished overview of your productivity today.</p>
            </div>
            <div class="col-lg-7">
                <div class="dashboard-card py-2 px-3 d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <span class="fw-bold text-muted text-uppercase" style="font-size: 0.7rem; letter-spacing: 0.8px;"><i class="fa-solid fa-bolt text-warning me-1"></i> Quick Actions</span>
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="TaskServlet" class="btn btn-quick bg-primary bg-opacity-10 text-primary">+ Task</a>
                        <a href="ExpenseServlet" class="btn btn-quick bg-success bg-opacity-10 text-success">+ Expense</a>
                        <a href="EventServlet" class="btn btn-quick bg-danger bg-opacity-10 text-danger">+ Event</a>
                        <a href="ReminderServlet" class="btn btn-quick bg-warning bg-opacity-10 text-warning">+ Reminder</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Stat Bar -->
        <div class="row g-3 mb-4">
            <div class="col-lg-8">
                <div class="row g-3">
                    <div class="col-6 col-md-3">
                        <a href="TaskServlet" class="stat-box">
                            <div class="stat-icon bg-primary bg-opacity-10 text-primary"><i class="fa-solid fa-clipboard-check"></i></div>
                            <div>
                                <small class="text-muted d-block fw-semibold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">Tasks</small>
                                <span class="fw-bold fs-4"><%= taskCount %></span>
                            </div>
                        </a>
                    </div>
                    <div class="col-6 col-md-3">
                        <a href="EventServlet" class="stat-box">
                            <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="fa-regular fa-calendar-days"></i></div>
                            <div>
                                <small class="text-muted d-block fw-semibold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">Events</small>
                                <span class="fw-bold fs-4"><%= eventCount %></span>
                            </div>
                        </a>
                    </div>
                    <div class="col-6 col-md-3">
                        <a href="ReminderServlet" class="stat-box">
                            <div class="stat-icon bg-warning bg-opacity-10 text-warning"><i class="fa-regular fa-bell"></i></div>
                            <div>
                                <small class="text-muted d-block fw-semibold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">Reminders</small>
                                <span class="fw-bold fs-4"><%= reminderCount %></span>
                            </div>
                        </a>
                    </div>
                    <div class="col-6 col-md-3">
                        <a href="DocumentServlet" class="stat-box">
                            <div class="stat-icon bg-info bg-opacity-10 text-info"><i class="fa-regular fa-folder-open"></i></div>
                            <div>
                                <small class="text-muted d-block fw-semibold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">Documents</small>
                                <span class="fw-bold fs-4"><%= documentCount %></span>
                            </div>
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="dashboard-card h-100 d-flex align-items-center justify-content-between p-4" style="background: var(--card-bg) !important;">
                    <div>
                        <h6 class="fw-bold mb-1" style="font-size: 0.85rem; line-height: 1.4;">"Small steps every day lead to massive success."</h6>
                        <small class="fw-bold d-flex align-items-center gap-1 mt-1 text-primary" style="font-size: 0.7rem;"><i class="fa-solid fa-fire text-danger"></i>Daily Inspiration</small>
                    </div>
                    <div class="p-3 bg-primary bg-opacity-10 rounded-4 text-primary flex-shrink-0">
                        <i class="fa-solid fa-lightbulb fs-4"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Content Grid Row 1 -->
        <div class="row g-4 mb-4">
            <!-- Today's Tasks -->
            <div class="col-lg-4">
                <div class="dashboard-card h-100 d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0">Today's Tasks</h6>
                        <a href="TaskServlet" class="text-decoration-none small text-primary fw-semibold">View all</a>
                    </div>
                    
                    <form action="TaskServlet" method="POST" class="task-input-bar mb-3">
                        <input type="hidden" name="action" value="add">
                        <input type="text" name="title" placeholder="Add a new task..." required>
                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-3 py-1 fw-bold shadow-sm" style="font-size: 0.75rem; background: var(--primary-gradient); border: none;">+ Add</button>
                    </form>

                    <div class="task-list flex-grow-1 custom-scroll" style="max-height: 240px; overflow-y: auto;">
                        <% if (taskList != null && !taskList.isEmpty()) { 
                            for (Task t : taskList) { %>
                                <div class="list-item-hover d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center gap-2">
                                        <input type="checkbox" class="form-check-input shadow-none cursor-pointer">
                                        <span style="font-size: 0.85rem; color: var(--text-dark);"><%= t.getTitle() %></span>
                                    </div>
                                </div>
                        <%   } 
                           } else { %>
                            <div class="text-center py-5 my-auto">
                                <i class="fa-regular fa-circle-check text-muted fs-2 mb-2 opacity-25"></i>
                                <p class="text-muted small mb-0">All caught up! No tasks for today.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Upcoming Events -->
            <div class="col-lg-4">
                <div class="dashboard-card h-100 d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0">Upcoming Events</h6>
                        <a href="EventServlet" class="text-decoration-none small text-primary fw-semibold">View all</a>
                    </div>
                    
                    <div class="flex-grow-1 custom-scroll mb-2" style="max-height: 230px; overflow-y: auto;">
                        <% if (events != null && !events.isEmpty()) { 
                            int eventDisplayCount = 0;
                            for (Event e : events) {
                                if (eventDisplayCount >= 4) break; 
                                eventDisplayCount++;
                        %>
                            <div class="list-item-hover d-flex align-items-center justify-content-between gap-2">
                                <div>
                                    <!-- កែពណ៌អក្សរឱ្យទៅជា var(--text-dark) ដើម្បីឱ្យវាច្បាស់ល្អក្នុង Dark/Light Mode -->
                                    <span class="fw-semibold d-block" style="font-size: 0.85rem; color: var(--text-dark);"><%= e.getTitle() %></span>
                                    <small class="text-muted" style="font-size: 0.7rem;">
                                        <i class="fa-regular fa-calendar me-1 text-primary"></i><%= e.getEventDate() != null ? e.getEventDate() : "" %>
                                        <% if(e.getLocation() != null && !e.getLocation().isEmpty()) { %>
                                            | <i class="fa-solid fa-location-dot me-1 text-danger"></i><%= e.getLocation() %>
                                        <% } %>
                                    </small>
                                </div>
                                <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-2 py-1" style="font-size: 0.65rem;">Active</span>
                            </div>
                        <%   } 
                           } else { %>
                            <div class="text-center py-5 my-auto">
                                <i class="fa-regular fa-calendar-xmark text-muted fs-2 mb-2 opacity-25"></i>
                                <p class="text-muted small mb-0">No upcoming events found.</p>
                            </div>
                        <% } %>
                    </div>

                    <div class="pt-2 mt-auto">
                        <a href="EventServlet" class="btn btn-sm btn-outline-secondary w-100 rounded-pill fw-bold py-2" style="font-size: 0.75rem; border-color: var(--border-card); color: var(--text-dark);">Manage Events</a>
                    </div>
                </div>
            </div>

            <!-- Active Reminders Card -->
            <div class="col-lg-4">
                <div class="dashboard-card h-100 d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6 class="fw-bold mb-0">Active Reminders</h6>
                        <a href="ReminderServlet" class="text-decoration-none small text-primary fw-semibold">View all</a>
                    </div>
                    
                    <div class="flex-grow-1 custom-scroll mb-2" style="max-height: 230px; overflow-y: auto;">
                        <% if (reminderList != null && !reminderList.isEmpty()) { 
                            for (Reminder r : reminderList) { %>
                                <div class="list-item-hover d-flex align-items-center justify-content-between">
                                    <div class="d-flex align-items-center gap-2 text-truncate">
                                        <i class="fa-regular fa-bell text-warning"></i>
                                        <span style="font-size: 0.85rem; color: var(--text-dark);" class="text-truncate"><%= r.getTitle() %></span>
                                    </div>
                                    <small class="text-muted flex-shrink-0" style="font-size: 0.68rem;"><%= r.getReminderDate() != null ? r.getReminderDate() : "" %></small>
                                </div>
                        <%   } 
                           } else { %>
                            <div class="text-center py-4 my-auto">
                                <i class="fa-regular fa-bell text-muted fs-2 mb-2 opacity-25"></i>
                                <p class="text-muted small mb-0">No active reminders.</p>
                            </div>
                        <% } %>
                    </div>
                    <div class="pt-2 mt-auto">
                        <a href="ReminderServlet" class="btn btn-sm btn-outline-primary w-100 rounded-pill fw-bold py-2" style="font-size: 0.75rem;">Manage Reminders</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Content Grid Row 2 -->
        <div class="row g-4 mb-4">
            <!-- Finance Overview -->
            <div class="col-lg-8">
                <div class="dashboard-card h-100">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h6 class="fw-bold mb-1 d-flex align-items-center gap-2">
                                Finance Overview <span class="badge bg-success rounded-circle p-1" style="width: 6px; height: 6px; display: inline-block;"></span>
                            </h6>
                            <small class="text-muted" style="font-size: 0.75rem;">Track income, expenses and balance</small>
                        </div>
                        <div>
                            <a href="ExpenseServlet" class="btn btn-sm btn-light border d-flex align-items-center gap-1 shadow-sm" style="border-color: var(--border-card) !important; background: var(--card-bg) !important; color: var(--text-dark) !important; font-size: 0.75rem; border-radius: 10px; padding: 0.4rem 0.8rem;">
                                Details <i class="fa-solid fa-arrow-up-right-from-square"></i>
                            </a>
                        </div>
                    </div>
                    <div class="mb-4">
                        <small class="text-muted d-block fw-semibold text-uppercase mb-1" style="font-size: 0.7rem; letter-spacing: 0.8px;">Total Balance</small>
                        <h2 class="fw-bold mb-0" style="letter-spacing: -1px; font-size: 2.2rem; color: var(--text-dark);">$<%= String.format("%.2f", totalBalance) %></h2>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="p-3 rounded-4 d-flex align-items-center gap-3" style="background: rgba(16, 185, 129, 0.05); border: 1px solid rgba(16, 185, 129, 0.12);">
                                <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center shadow-sm flex-shrink-0" style="width: 42px; height: 42px;"><i class="fa-solid fa-arrow-up text-sm"></i></div>
                                <div>
                                    <small class="text-muted d-block fw-semibold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">Income</small>
                                    <span class="fw-bold text-success fs-5">$<%= String.format("%.2f", totalIncome) %></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="p-3 rounded-4 d-flex align-items-center gap-3" style="background: rgba(239, 68, 68, 0.05); border: 1px solid rgba(239, 68, 68, 0.12);">
                                <div class="rounded-circle bg-danger text-white d-flex align-items-center justify-content-center shadow-sm flex-shrink-0" style="width: 42px; height: 42px;"><i class="fa-solid fa-arrow-down text-sm"></i></div>
                                <div>
                                    <small class="text-muted d-block fw-semibold text-uppercase" style="font-size: 0.65rem; letter-spacing: 0.5px;">Expense</small>
                                    <span class="fw-bold text-danger fs-5">$<%= String.format("%.2f", totalExpense) %></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Documents Card -->
            <div class="col-lg-4">
                <div class="dashboard-card h-100 d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <div class="d-flex align-items-center gap-2">
                            <div class="text-primary bg-primary bg-opacity-10 rounded-3 d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 0.9rem;">
                                <i class="fa-regular fa-folder-open"></i>
                            </div>
                            <h6 class="fw-bold mb-0" style="font-size: 0.95rem;">Recent Documents</h6>
                        </div>
                        <a href="DocumentServlet" class="text-decoration-none small text-primary fw-semibold" style="font-size: 0.8rem;">See all ></a>
                    </div>
                    <small class="text-muted mb-3" style="font-size: 0.72rem;">Your latest uploaded files</small>
                    
                    <div class="flex-grow-1 custom-scroll mb-2" style="max-height: 180px; overflow-y: auto;">
                        <% if (documentList != null && !documentList.isEmpty()) { 
                            int docDisplayCount = 0;
                            for (Document doc : documentList) {
                                  if (docDisplayCount >= 4) break; 
                                  docDisplayCount++;
                        %>
                            <div class="list-item-hover d-flex align-items-center justify-content-between text-truncate">
                              <div class="d-flex align-items-center gap-2 text-truncate">
                                  <i class="fa-regular fa-file-lines text-primary"></i>
                                  <span style="font-size: 0.82rem; color: var(--text-dark);" class="text-truncate"><%= doc.getTitle() %></span>
                              </div>
                              <small class="text-muted"><%= doc.getUploadDate() != null ? doc.getUploadDate() : "" %></small>
                            </div>
                        <%   } 
                           } else { %>
                            <div class="text-center py-4 my-auto">
                                <i class="fa-regular fa-folder-open text-muted fs-2 mb-2 opacity-25"></i>
                                <p class="text-muted small mb-0">No documents uploaded.</p>
                            </div>
                        <% } %>
                    </div>
                    <div class="pt-2 mt-auto">
                        <a href="DocumentServlet" class="btn btn-sm btn-outline-primary w-100 rounded-pill fw-bold py-2" style="font-size: 0.75rem;">Manage Documents</a>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Theme Toggle Script
        const themeToggle = document.getElementById('themeToggle');
        const themeIcon = document.getElementById('themeIcon');
        const htmlElement = document.documentElement;

        const currentTheme = localStorage.getItem('theme') || 'dark';
        htmlElement.setAttribute('data-theme', currentTheme);
        updateIcon(currentTheme);

        themeToggle.addEventListener('click', () => {
            let theme = htmlElement.getAttribute('data-theme');
            let newTheme = theme === 'dark' ? 'light' : 'dark';
            htmlElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateIcon(newTheme);
        });

        function updateIcon(theme) {
            if (theme === 'dark') {
                themeIcon.className = "fa-regular fa-sun";
            } else {
                themeIcon.className = "fa-regular fa-moon";
            }
        }
    </script>
</body>
</html>