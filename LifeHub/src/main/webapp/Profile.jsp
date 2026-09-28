<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lifehub.model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Settings - LifeHub</title>
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
            --input-bg: #f8fafc;
        }

        [data-theme="dark"] {
            --bg-light: #0f172a;
            --card-bg: #1e293b;
            --text-dark: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --input-bg: #0f172a;
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

        .custom-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.02);
            padding: 2rem;
        }

        .profile-banner {
            height: 150px;
            background: var(--primary-gradient);
            border-radius: 16px;
            position: relative;
            overflow: hidden;
        }
        .profile-banner::after {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, rgba(0,0,0,0.2) 100%);
        }

        .profile-avatar-container {
            position: relative;
            margin-top: -65px;
            margin-bottom: 1rem;
        }

        .profile-avatar {
            width: 110px;
            height: 110px;
            background: var(--primary-gradient);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 800;
            border: 4px solid var(--card-bg);
            box-shadow: 0 10px 25px rgba(79, 70, 229, 0.25);
        }

        .form-control, .form-select {
            background-color: var(--input-bg);
            color: var(--text-dark);
            border-color: var(--border-color);
            padding: 0.75rem 1rem;
            font-size: 0.92rem;
            border-radius: 12px;
            transition: all 0.2s ease;
        }
        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.12);
            border-color: #4f46e5;
            background-color: var(--card-bg);
            color: var(--text-dark);
        }
        [data-theme="dark"] .form-control::placeholder { color: #64748b; }

        .nav-pills .nav-link {
            color: var(--text-muted);
            font-weight: 600;
            border-radius: 12px;
            padding: 0.75rem 1.25rem;
            transition: all 0.2s ease;
        }
        .nav-pills .nav-link:hover {
            color: var(--primary-color);
            background-color: rgba(79, 70, 229, 0.05);
        }
        .nav-pills .nav-link.active {
            background: var(--primary-gradient);
            color: white;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
        }

        .btn-gradient {
            background: var(--primary-gradient);
            color: white;
            border: none;
            transition: all 0.2s ease;
        }
        .btn-gradient:hover {
            opacity: 0.92;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
        }

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
            transition: all 0.2s ease;
        }
        .theme-toggle-btn:hover {
            background: var(--border-color);
            transform: scale(1.05);
        }

        .badge-status {
            background-color: rgba(16, 185, 129, 0.1);
            color: #10b981;
            font-weight: 600;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
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
        <div class="container-fluid px-0" style="max-width: 1000px;">

            <!-- Header Title & Action Buttons -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h3 class="fw-extrabold mb-1 text-dark">Profile Settings</h3>
                    <p class="text-muted small mb-0">Manage your profile credentials, security and app preferences.</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="theme-toggle-btn" id="themeToggleBtn" title="Toggle Light/Dark Mode">
                        <i class="fa-solid fa-moon" id="themeIcon"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-danger rounded-pill px-4 py-2 fw-semibold d-flex align-items-center gap-2">
                        <i class="fa-solid fa-right-from-bracket"></i> Logout
                    </a>
                </div>
            </div>

            <!-- Alerts -->
            <% if (successMessage != null && !successMessage.isEmpty()) { %>
                <div class="alert alert-success alert-dismissible fade show rounded-4 mb-4 shadow-sm border-0" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert alert-danger alert-dismissible fade show rounded-4 mb-4 shadow-sm border-0" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <!-- Layout Grid -->
            <div class="row g-4">
                
                <!-- Left Column: Summary Card -->
                <div class="col-lg-4">
                    <div class="custom-card text-center h-100 d-flex flex-column align-items-center justify-content-between">
                        <div class="w-100">
                            <div class="profile-banner mb-3"></div>
                            <div class="profile-avatar-container d-flex justify-content-center">
                                <div class="profile-avatar">
                                    <%= user.getName() != null && !user.getName().isEmpty() ? user.getName().substring(0, 1).toUpperCase() : "U" %>
                                </div>
                            </div>
                            <h4 class="fw-bold text-dark mb-1"><%= user.getName() %></h4>
                            <p class="text-muted small mb-3"><%= user.getEmail() %></p>
                            <span class="badge-status d-inline-flex align-items-center gap-1 mb-4">
                                <i class="fa-solid fa-circle" style="font-size: 6px;"></i> Active Account
                            </span>
                        </div>

                        <div class="w-100 border-top pt-3 text-start">
                            <div class="d-flex justify-content-between text-muted small mb-2">
                                <span>Member Role:</span>
                                <span class="fw-semibold text-dark">Standard User</span>
                            </div>
                            <div class="d-flex justify-content-between text-muted small">
                                <span class="text-muted">System Platform:</span>
                                <span class="fw-semibold text-dark">LifeHub v2.0</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Settings Form Tabs -->
                <div class="col-lg-8">
                    <div class="custom-card">
                        
                        <!-- Tabs Navigation -->
                        <ul class="nav nav-pills mb-4 gap-2 border-bottom pb-3" id="profileTab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active d-flex align-items-center gap-2" id="general-tab" data-bs-toggle="pill" data-bs-target="#general" type="button" role="tab">
                                    <i class="fa-regular fa-user"></i> General Info
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link d-flex align-items-center gap-2" id="security-tab" data-bs-toggle="pill" data-bs-target="#security" type="button" role="tab">
                                    <i class="fa-solid fa-shield-halved"></i> Security & Password
                                </button>
                            </li>
                        </ul>

                        <form action="${pageContext.request.contextPath}/ProfileServlet" method="post">
                            <input type="hidden" name="action" value="update">

                            <div class="tab-content" id="profileTabContent">
                                
                                <!-- General Tab Pane -->
                                <div class="tab-pane fade show active" id="general" role="tabpanel">
                                    <h5 class="fw-bold text-dark mb-3 fs-6">Personal Details</h5>
                                    
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-dark">Full Name</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-transparent border-end-0 text-muted" style="border-radius: 12px 0 0 12px;"><i class="fa-regular fa-user"></i></span>
                                            <input type="text" class="form-control border-start-0 ps-0" name="name" value="<%= user.getName() != null ? user.getName() : "" %>" required placeholder="Enter your full name">
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label small fw-bold text-dark">Email Address</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-transparent border-end-0 text-muted" style="border-radius: 12px 0 0 12px;"><i class="fa-regular fa-envelope"></i></span>
                                            <input type="email" class="form-control border-start-0 ps-0" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required placeholder="Enter your email address">
                                        </div>
                                    </div>
                                </div>

                                <!-- Security Tab Pane -->
                                <div class="tab-pane fade" id="security" role="tabpanel">
                                    <h5 class="fw-bold text-dark mb-3 fs-6">Password Management</h5>
                                    <p class="text-muted small mb-4">Ensure your account is using a secure password to stay safe.</p>

                                    <div class="mb-3">
                                        <label class="form-label small fw-bold text-dark">New Password</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-transparent border-end-0 text-muted" style="border-radius: 12px 0 0 12px;"><i class="fa-solid fa-lock"></i></span>
                                            <input type="password" class="form-control border-start-0 border-end-0 ps-0" id="newPassword" name="newPassword" placeholder="Leave blank to keep current password">
                                            <button class="btn btn-outline-secondary border-start-0 bg-transparent text-muted" type="button" onclick="togglePassword('newPassword', this)" style="border-radius: 0 12px 12px 0;"><i class="fa-regular fa-eye"></i></button>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label small fw-bold text-dark">Confirm New Password</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-transparent border-end-0 text-muted" style="border-radius: 12px 0 0 12px;"><i class="fa-solid fa-lock"></i></span>
                                            <input type="password" class="form-control border-start-0 border-end-0 ps-0" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password">
                                            <button class="btn btn-outline-secondary border-start-0 bg-transparent text-muted" type="button" onclick="togglePassword('confirmPassword', this)" style="border-radius: 0 12px 12px 0;"><i class="fa-regular fa-eye"></i></button>
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <!-- Form Buttons -->
                            <div class="d-flex justify-content-end gap-2 pt-3 border-top mt-4">
                                <button type="reset" class="btn btn-light rounded-3 px-4 py-2 fw-semibold text-muted border">Reset</button>
                                <button type="submit" class="btn btn-gradient rounded-3 px-4 py-2 fw-bold shadow-sm">
                                    <i class="fa-solid fa-floppy-disk me-2"></i> Save Changes
                                </button>
                            </div>

                        </form>

                    </div>
                </div>

            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password Visibility Toggle Function
        function togglePassword(fieldId, btn) {
            const input = document.getElementById(fieldId);
            const icon = btn.querySelector('i');
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fa-regular fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fa-regular fa-eye';
            }
        }

        // Theme Toggle Handler
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
        });
    </script>
</body>
</html>