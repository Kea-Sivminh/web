<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lifehub.model.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String currentPage = request.getRequestURI();
%>

<style>
    /* === CSS VARIABLES FOR SIDEBAR (Light Mode Default) === */
    :root {
        --sidebar-width: 260px;
        --sidebar-bg: #ffffff;
        --sidebar-border: #e2e8f0;
        --sidebar-text: #1e1b4b;
        --sidebar-subtext: #64748b;
        --sidebar-hover-bg: #f8fafc;
        --sidebar-hover-color: #3b82f6;
        --sidebar-active-bg: #e0e7ff;
        --sidebar-active-color: #4338ca;
        --toggle-btn-bg: #ffffff;
        --toggle-btn-border: #cbd5e1;
        --toggle-btn-color: #64748b;
        /* Brand Colors */
        --brand-title-color: #1e3a8a;
        --brand-subtitle-color: #3b82f6;
    }

    /* === DARK MODE VARIABLES FOR SIDEBAR === */
    [data-bs-theme="dark"], 
    [data-theme="dark"], 
    html.dark,
    body.dark,
    .dark,
    body.dark-mode, 
    .dark-mode {
        --sidebar-bg: #0f172a !important;
        --sidebar-border: rgba(255, 255, 255, 0.08) !important;
        --sidebar-text: #f8fafc !important;
        --sidebar-subtext: #94a3b8 !important;
        --sidebar-hover-bg: rgba(99, 102, 241, 0.12) !important;
        --sidebar-hover-color: #818cf8 !important;
        --sidebar-active-bg: rgba(99, 102, 241, 0.18) !important;
        --sidebar-active-color: #818cf8 !important;
        --toggle-btn-bg: #0f172a !important;
        --toggle-btn-border: rgba(255, 255, 255, 0.1) !important;
        --toggle-btn-color: #94a3b8 !important;
        /* Brand Colors for Dark Mode */
        --brand-title-color: #f8fafc !important;
        --brand-subtitle-color: #60a5fa !important;
    }

    /* ពេល Sidebar ត្រូវបានបត់ (Collapsed) */
    body.sidebar-collapsed {
        --sidebar-width: 80px;
    }

    /* === SIDEBAR CONTAINER === */
    .sidebar {
        width: var(--sidebar-width);
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        background-color: var(--sidebar-bg) !important;
        border-right: 1px solid var(--sidebar-border) !important;
        padding: 1.25rem 0.85rem;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        z-index: 1050;
        transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1), background-color 0.3s ease, border-color 0.3s ease;
        overflow-x: hidden;
    }

    /* Brand Header Container */
    .brand-container {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 8px;
        white-space: nowrap;
        width: 100%;
    }

    .brand-logo {
        display: flex;
        align-items: center;
        gap: 12px;
        overflow: hidden;
    }

    /* កែសម្រួលទំហំអក្សរ Brand ឱ្យធំ និងច្បាស់ស្អាត */
    .brand-title {
        color: var(--brand-title-color) !important;
        font-size: 1.35rem;
        font-weight: 800;
        letter-spacing: -0.02em;
        line-height: 1.2;
        -webkit-font-smoothing: antialiased;
    }

    .brand-subtitle {
        color: var(--brand-subtitle-color) !important;
        font-size: 0.82rem;
        font-weight: 600;
        letter-spacing: -0.01em;
        -webkit-font-smoothing: antialiased;
    }

    .logo-box {
        min-width: 42px;
        height: 42px;
        background: linear-gradient(135deg, #6366f1, #4f46e5);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 800;
        font-size: 1.1rem;
    }

    /* Toggle Button Style */
    .toggle-btn {
        min-width: 30px;
        height: 30px;
        border-radius: 50%;
        border: 1px solid var(--toggle-btn-border);
        background: var(--toggle-btn-bg);
        color: var(--toggle-btn-color);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s ease;
        padding: 0;
        flex-shrink: 0;
    }

    .toggle-btn:hover {
        background-color: var(--sidebar-hover-bg);
        color: var(--sidebar-hover-color);
    }

    body.sidebar-collapsed .toggle-btn i {
        transform: rotate(180deg);
    }

    /* កែសម្រួលទំហំអក្សរเมנו (Nav Links) ឱ្យធំទូលាយ និងងាយមើល */
    .nav-item-link {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 0.9rem 1.1rem;
        color: var(--sidebar-subtext);
        text-decoration: none;
        border-radius: 12px;
        font-weight: 600;
        font-size: 1.12rem;
        transition: all 0.2s ease;
        margin-bottom: 0.4rem;
        white-space: nowrap;
        -webkit-font-smoothing: antialiased;
    }

    .nav-item-link i {
        font-size: 1.25rem;
        min-width: 26px;
        text-align: center;
    }

    .nav-item-link:hover {
        color: var(--sidebar-hover-color);
        background-color: var(--sidebar-hover-bg);
    }

    .nav-item-link.active {
        background-color: var(--sidebar-active-bg);
        color: var(--sidebar-active-color);
        border-radius: 12px !important;
    }

    /* Hide text elements when collapsed */
    body.sidebar-collapsed .nav-text,
    body.sidebar-collapsed .brand-text,
    body.sidebar-collapsed .profile-text {
        display: none !important;
    }

    body.sidebar-collapsed .sidebar-profile {
        justify-content: center;
    }

    .sidebar-profile {
        display: flex;
        align-items: center;
        gap: 12px;
        padding-top: 0.9rem;
        border-top: 1px solid var(--sidebar-border);
        white-space: nowrap;
        transition: border-color 0.3s ease;
    }

    .sidebar-profile h6 {
        color: var(--sidebar-text) !important;
        font-size: 0.95rem !important;
    }

    .sidebar-profile a {
        color: var(--sidebar-subtext) !important;
        font-size: 0.8rem !important;
    }

    .avatar-circle {
        min-width: 40px;
        height: 40px;
        background-color: #6366f1;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 1rem;
    }

    /* Layout Content Wrapper Class */
    .main-content {
        margin-left: var(--sidebar-width);
        transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        min-height: 100vh;
    }
</style>

<script>
    if (localStorage.getItem('sidebarCollapsed') === 'true') {
        document.body.classList.add('sidebar-collapsed');
    }
</script>

<aside class="sidebar">
    <div>
        <div class="brand-container mb-4 px-1">
            <div class="brand-logo">
                <div class="logo-box">LH</div>
                <div class="brand-text overflow-hidden">
                    <div class="brand-title text-truncate">LifeHub</div>
                    <div class="brand-subtitle text-truncate">Life, Organized.</div>
                </div>
            </div>
            <button type="button" id="sidebarToggle" class="toggle-btn" title="Toggle Sidebar">
                <i class="fa-solid fa-chevron-left" style="font-size: 0.75rem;"></i>
            </button>
        </div>

        <nav>
            <a href="DashboardServlet" class="nav-item-link <%= currentPage.contains("Dashboard") || currentPage.contains("dashboard") ? "active" : "" %>">
                <i class="fa-solid fa-shapes"></i>
                <span class="nav-text">Dashboard</span>
            </a>
            <a href="TaskServlet" class="nav-item-link <%= currentPage.contains("Task") || currentPage.contains("task") ? "active" : "" %>">
                <i class="fa-regular fa-circle-check"></i>
                <span class="nav-text">Tasks</span>
            </a>
            <a href="EventServlet" class="nav-item-link <%= currentPage.contains("Event") || currentPage.contains("event") ? "active" : "" %>">
                <i class="fa-regular fa-calendar-check"></i>
                <span class="nav-text">Events</span>
            </a>
            <a href="CalendarServlet" class="nav-item-link <%= currentPage.contains("Calendar") ? "active" : "" %>">
                <i class="fa-regular fa-calendar"></i>
                <span class="nav-text">Calendar</span>
            </a>
            <a href="ExpenseServlet" class="nav-item-link <%= currentPage.contains("Expense") || currentPage.contains("Finance") ? "active" : "" %>">
                <i class="fa-solid fa-wallet"></i>
                <span class="nav-text">Finance</span>
            </a>
            <a href="GoalServlet" class="nav-item-link <%= currentPage.contains("Goal") ? "active" : "" %>">
                <i class="fa-solid fa-bullseye"></i>
                <span class="nav-text">Goals</span>
            </a>
            <a href="DocumentServlet" class="nav-item-link <%= currentPage.contains("Document") ? "active" : "" %>">
                <i class="fa-regular fa-folder"></i>
                <span class="nav-text">Documents</span>
            </a>
            <a href="ReminderServlet" class="nav-item-link <%= currentPage.contains("Reminder") || currentPage.contains("reminder") ? "active" : "" %>">
                <i class="fa-regular fa-bell"></i>
                <span class="nav-text">Reminders</span>
            </a>
        </nav>
    </div>

    <% if (currentUser != null) { %>
    <div class="sidebar-profile">
        <div class="avatar-circle">
            <%= currentUser.getName() != null && !currentUser.getName().isEmpty() ? currentUser.getName().substring(0, 1).toUpperCase() : "U" %>
        </div>
        <div class="profile-text overflow-hidden">
            <h6 class="fw-bold mb-0 text-truncate"><%= currentUser.getName() %></h6>
            <a href="ProfileServlet" class="text-decoration-none d-block">View Profile</a>
        </div>
    </div>
    <% } %>
</aside>

<script>
    document.getElementById('sidebarToggle').addEventListener('click', function () {
        document.body.classList.toggle('sidebar-collapsed');
        var isCollapsed = document.body.classList.contains('sidebar-collapsed');
        localStorage.setItem('sidebarCollapsed', isCollapsed ? 'true' : 'false');
    });

    document.addEventListener("DOMContentLoaded", function () {
        const currentPath = window.location.href.toLowerCase();
        const navLinks = document.querySelectorAll('.nav-item-link');
        
        navLinks.forEach(link => {
            const href = link.getAttribute('href') ? link.getAttribute('href').toLowerCase() : '';
            if ((href && currentPath.includes(href)) || 
                (currentPath.includes('reminder') && href.includes('reminder')) ||
                (currentPath.includes('reminders') && href.includes('reminder'))) {
                link.classList.add('active');
            }
        });
    });
</script>