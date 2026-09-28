<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lifehub.model.Event" %>
<%@ page import="com.lifehub.model.User" %>
<% 
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        // Mock user or handle null if needed for testing
    }
    List<Event> events = (List<Event>) request.getAttribute("eventList");
    Event editEvent = (Event) request.getAttribute("editEvent");
    boolean isEdit = (editEvent != null);
    int totalEvents = (events != null) ? events.size() : 0;
    
    int upcomingWeek = 4;
    int goingCount = 3;
    int activeCategories = 4;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Management - LifeHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --bg-light: #f8fafc;
            --card-bg: #ffffff;
            --primary-color: #10b981; 
            --primary-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%); 
            --text-dark: #0f172a;
            --text-body: #334155;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --sidebar-width: 260px;
        }

        [data-theme="dark"] {
            --bg-light: #0f172a;
            --card-bg: #1e293b;
            --text-dark: #ffffff;
            --text-body: #f1f5f9;
            --text-muted: #cbd5e1;
            --border-color: #334155;
        }

        [data-theme="dark"] .text-muted {
            color: var(--text-muted) !important;
        }

        body {
            background-color: var(--bg-light);
            color: var(--text-body);
            font-family: 'Plus Jakarta Sans', sans-serif;
            overflow-x: hidden;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .main-wrapper {
            margin-left: var(--sidebar-width);
            padding: 2rem;
            transition: all 0.3s ease;
        }

        @media (max-width: 991.98px) {
            .main-wrapper { margin-left: 0; padding: 1rem; }
        }

        .custom-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.02);
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.25rem;
            position: relative;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .stat-icon {
            width: 42px;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            background: #f0fdf4;
            color: #10b981;
        }

        .btn-success-gradient {
            background: #10b981;
            color: white;
            border: none;
            transition: all 0.2s ease;
        }

        .btn-success-gradient:hover {
            background: #059669;
            color: white;
            transform: translateY(-1px);
        }

        .event-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.25rem;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .event-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.05);
        }

        .event-list-item {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 1.25rem;
            transition: all 0.3s ease;
        }
        .event-list-item:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.05);
        }
        .date-box {
            width: 60px;
            height: 60px;
            background: var(--bg-light);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .badge-category {
            padding: 0.35em 0.8em;
            font-weight: 600;
            font-size: 0.75rem;
            border-radius: 6px;
        }
        .badge-work { background-color: #eff6ff; color: #3b82f6; }

        .badge-timer {
            background-color: #f0fdf4;
            color: #10b981;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.35em 0.6em;
            border-radius: 6px;
        }

        .btn-action {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background: transparent;
            color: var(--text-muted);
        }
        .btn-action:hover { background-color: var(--border-color); color: var(--text-dark); }

        .modal-content, .form-control {
            background-color: var(--card-bg);
            color: var(--text-dark);
            border-color: var(--border-color);
            border-radius: 16px;
        }

        .form-control::placeholder {
            color: var(--text-muted);
            opacity: 0.7;
        }

        /* Styles for Calendar View */
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 10px;
        }
        .calendar-day-header {
            text-align: center;
            font-weight: bold;
            font-size: 0.85rem;
            color: var(--text-muted);
            padding-bottom: 10px;
        }
        .calendar-cell {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            min-height: 110px;
            padding: 8px;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }
        .calendar-cell.has-event {
            border-color: #10b981;
        }
        .calendar-date-num {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-dark);
        }
        .calendar-event-badge {
            background-color: #ecfdf5;
            color: #047857;
            font-size: 0.7rem;
            padding: 2px 6px;
            border-radius: 4px;
            margin-top: 3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            text-decoration: none;
            display: block;
        }
        [data-theme="dark"] .calendar-event-badge {
            background-color: #064e3b;
            color: #6ee7b7;
        }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp" />

    <div class="main-wrapper">
        <div class="container-fluid">

            <!-- Top Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                <div>
                    <h4 class="fw-bold mb-1" style="color: var(--text-dark);">
                        Events
                    </h4>
                    <p class="text-muted small mb-0">Events & Schedule Manager for <strong>freya</strong></p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn btn-outline-secondary rounded-circle d-flex align-items-center justify-content-center" id="themeToggle" style="width: 40px; height: 40px;">
                        <i class="fa-regular fa-sun" id="themeIcon"></i>
                    </button>
                    <button class="btn btn-success-gradient rounded-pill px-4 py-2 fw-semibold" data-bs-toggle="modal" data-bs-target="#eventModal">
                        <i class="fa-solid fa-plus me-2"></i>New Event
                    </button>
                </div>
            </div>

            <!-- Stats Row -->
            <div class="row g-3 mb-4">
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-muted small fw-semibold text-uppercase" style="font-size: 0.7rem;">Total Events</span>
                            <h3 class="fw-bold mt-1 mb-0" style="color: var(--text-dark);"><%= totalEvents %></h3>
                        </div>
                        <div class="stat-icon"><i class="fa-regular fa-calendar"></i></div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-muted small fw-semibold text-uppercase" style="font-size: 0.7rem;">Upcoming This Week</span>
                            <h3 class="fw-bold mt-1 mb-0" style="color: var(--text-dark);"><%= upcomingWeek %></h3>
                        </div>
                        <div class="stat-icon" style="background: #fef3c7; color: #d97706;"><i class="fa-regular fa-clock"></i></div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-muted small fw-semibold text-uppercase" style="font-size: 0.7rem;">Going / RSVP'd</span>
                            <h3 class="fw-bold mt-1 mb-0" style="color: var(--text-dark);"><%= goingCount %></h3>
                        </div>
                        <div class="stat-icon" style="background: #f0fdf4; color: #10b981;"><i class="fa-regular fa-circle-check"></i></div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-muted small fw-semibold text-uppercase" style="font-size: 0.7rem;">Categories Active</span>
                            <h3 class="fw-bold mt-1 mb-0" style="color: var(--text-dark);"><%= activeCategories %></h3>
                        </div>
                        <div class="stat-icon" style="background: #faf5ff; color: #a855f7;"><i class="fa-solid fa-tag"></i></div>
                    </div>
                </div>
            </div>

            <!-- Filter & View Controls -->
            <div class="custom-card p-3 mb-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="input-group" style="max-width: 300px;">
                        <span class="input-group-text bg-transparent border-end-0 text-muted"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text" class="form-control border-start-0 ps-0 shadow-none" placeholder="Search events..." id="searchEventInput">
                    </div>

                    <div class="btn-group" role="group">
                        <button type="button" class="btn btn-sm btn-outline-secondary active" id="gridViewBtn"><i class="fa-solid fa-table-cells me-1"></i> Grid</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" id="listViewBtn"><i class="fa-solid fa-list me-1"></i> List</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" id="calendarViewBtn"><i class="fa-regular fa-calendar me-1"></i> Calendar</button>
                    </div>
                </div>
            </div>

            <!-- Events Grid View (Default) -->
            <div class="row g-4" id="eventGridViewContainer">
                <% 
                if (events != null && !events.isEmpty()) {
                    for (Event e : events) {
                %>
                <div class="col-md-4">
                    <div class="event-card h-100 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="badge-category badge-work"><%= e.getLocation() != null && e.getLocation().contains("Room") ? "Work" : "General" %></span>
                                <span class="badge-timer"><i class="fa-regular fa-clock me-1"></i>Active</span>
                            </div>
                            <h5 class="fw-bold mb-1" style="color: var(--text-dark);"><%= e.getTitle() %></h5>
                            <p class="text-muted small mb-3 text-truncate"><%= e.getDescription() != null ? e.getDescription() : "" %></p>
                            
                            <div class="small text-muted mb-2">
                                <i class="fa-regular fa-calendar me-2"></i><%= e.getEventDate() %> (<%= e.getStartTime() %>)
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="fa-solid fa-location-dot me-2"></i><%= e.getLocation() %>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color: var(--border-color) !important;">
                            <div class="form-check">
                                <input class="form-check-input shadow-none" type="checkbox" id="check<%= e.getId() %>">
                                <label class="form-check-label small fw-semibold text-success" for="check<%= e.getId() %>">Going</label>
                            </div>
                            <div>
                                <a href="EventServlet?action=edit&id=<%= e.getId() %>" class="btn-action me-1" title="Edit"><i class="fa-solid fa-pen text-secondary"></i></a>
                                <a href="EventServlet?action=delete&id=<%= e.getId() %>" onclick="return confirm('Delete this event?')" class="btn-action" title="Delete"><i class="fa-solid fa-trash text-danger"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
                <% 
                    }
                } else {
                %>
                <div class="col-12 text-center py-5">
                    <i class="fa-regular fa-calendar-xmark fs-1 mb-2 text-muted opacity-50"></i>
                    <p class="text-muted">No events found! Click <strong>"+ New Event"</strong> to create one.</p>
                </div>
                <% } %>
            </div>

            <!-- Events List View (Hidden by default) -->
            <div id="eventListViewContainer" class="d-none flex-column gap-3">
                <% 
                if (events != null && !events.isEmpty()) {
                    for (Event e : events) {
                %>
                <div class="event-list-item d-flex flex-wrap align-items-center justify-content-between gap-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="date-box text-center">
                            <span class="text-uppercase text-success fw-bold" style="font-size: 0.65rem;">SEP</span>
                            <span class="fw-bold fs-6" style="color: var(--text-dark); line-height: 1;">26</span>
                        </div>
                        <div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span class="badge-category badge-work"><%= e.getLocation() != null && e.getLocation().contains("Room") ? "Work" : "General" %></span>
                                <h5 class="fw-bold mb-0" style="color: var(--text-dark); font-size: 1rem;"><%= e.getTitle() %></h5>
                            </div>
                            <p class="text-muted small mb-2 text-truncate" style="max-width: 500px;"><%= e.getDescription() != null ? e.getDescription() : "" %></p>
                            <div class="d-flex flex-wrap gap-3 small text-muted">
                                <span><i class="fa-regular fa-calendar me-1"></i><%= e.getEventDate() %> (<%= e.getStartTime() %>)</span>
                                <span><i class="fa-solid fa-location-dot me-1"></i><%= e.getLocation() %></span>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex align-items-center gap-3">
                        <span class="badge-timer"><i class="fa-regular fa-clock me-1"></i>Active</span>
                        <div class="form-check m-0">
                            <input class="form-check-input shadow-none" type="checkbox" id="listCheck<%= e.getId() %>">
                            <label class="form-check-label small fw-semibold text-success" for="listCheck<%= e.getId() %>">Going</label>
                        </div>
                        <div>
                            <a href="EventServlet?action=edit&id=<%= e.getId() %>" class="btn-action me-1" title="Edit"><i class="fa-solid fa-pen text-secondary"></i></a>
                            <a href="EventServlet?action=delete&id=<%= e.getId() %>" onclick="return confirm('Delete this event?')" class="btn-action" title="Delete"><i class="fa-solid fa-trash text-danger"></i></a>
                        </div>
                    </div>
                </div>
                <% 
                    }
                } else {
                %>
                <div class="text-center py-5">
                    <p class="text-muted">No events found!</p>
                </div>
                <% } %>
            </div>

            <!-- Events Calendar View (Hidden by default) -->
            <div id="eventCalendarViewContainer" class="d-none custom-card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold mb-0" style="color: var(--text-dark);" id="calendarMonthYear">September 2026</h5>
                    <div class="d-flex align-items-center gap-2 text-success small">
                        <i class="fa-solid fa-circle" style="font-size: 8px;"></i> Event Scheduled
                    </div>
                </div>
                <div class="calendar-grid mb-2">
                    <div class="calendar-day-header">MON</div>
                    <div class="calendar-day-header">TUE</div>
                    <div class="calendar-day-header">WED</div>
                    <div class="calendar-day-header">THU</div>
                    <div class="calendar-day-header">FRI</div>
                    <div class="calendar-day-header">SAT</div>
                    <div class="calendar-day-header">SUN</div>
                </div>
                <div class="calendar-grid" id="calendarDaysGrid">
                    <% for(int i=1; i<=30; i++) { 
                        String dayStr = (i < 10) ? "2026-09-0" + i : "2026-09-" + i;
                %>
                <div class="calendar-cell" data-date="<%= dayStr %>">
                    <span class="calendar-date-num"><%= i %></span>
                    <div class="calendar-events-wrapper mt-1"></div>
                </div>
                <% } %>
                </div>
            </div>

        </div>
    </div>

    <!-- Modal Form for Add / Edit Event -->
    <div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-3">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold" style="color: var(--text-dark);">
                        <i class="fa-solid <%= isEdit ? "fa-pen-to-square text-warning" : "fa-calendar-plus text-success" %> me-2"></i>
                        <%= isEdit ? "Edit Event" : "Create New Event" %>
                    </h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="EventServlet" method="post">
                        <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= editEvent.getId() %>">
                        <% } %>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Event Title</label>
                            <input type="text" class="form-control shadow-none" name="title" value="<%= isEdit ? editEvent.getTitle() : "" %>" placeholder="e.g., Project Meeting" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Date</label>
                            <input type="date" class="form-control shadow-none" name="event_date" value="<%= isEdit ? editEvent.getEventDate() : "" %>" required>
                        </div>

                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label small fw-semibold text-muted">Start Time</label>
                                <input type="time" class="form-control shadow-none" name="start_time" value="<%= isEdit ? editEvent.getStartTime() : "" %>" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label small fw-semibold text-muted">End Time</label>
                                <input type="time" class="form-control shadow-none" name="end_time" value="<%= isEdit ? editEvent.getEndTime() : "" %>" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold text-muted">Location</label>
                            <input type="text" class="form-control shadow-none" name="location" value="<%= isEdit ? editEvent.getLocation() : "" %>" placeholder="e.g., Office Room / Online" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold text-muted">Description</label>
                            <textarea class="form-control shadow-none" name="description" rows="3" placeholder="Event details..." required><%= isEdit ? editEvent.getDescription() : "" %></textarea>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success-gradient py-2 fw-bold">
                                <%= isEdit ? "Update Event" : "Save Event" %>
                            </button>
                            <% if (isEdit) { %>
                                <a href="EventServlet" class="btn btn-light border py-2 text-center text-decoration-none text-dark">Cancel</a>
                            <% } %>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const serverEvents = [
            <% if (events != null) {
                for (Event e : events) { %>
                {
                    id: "<%= e.getId() %>",
                    title: "<%= e.getTitle() != null ? e.getTitle().replace("\"", "\\\"") : "" %>",
                    date: "<%= e.getEventDate() %>"
                },
            <% } } %>
        ];

        document.addEventListener("DOMContentLoaded", function() {
            const themeToggleBtn = document.getElementById("themeToggle");
            const themeIcon = document.getElementById("themeIcon");
            
            const savedTheme = localStorage.getItem("theme") || "light";
            document.documentElement.setAttribute("data-theme", savedTheme);
            updateThemeIcon(savedTheme);

            themeToggleBtn.addEventListener("click", function() {
                let currentTheme = document.documentElement.getAttribute("data-theme");
                let newTheme = currentTheme === "dark" ? "light" : "dark";
                
                document.documentElement.setAttribute("data-theme", newTheme);
                localStorage.setItem("theme", newTheme);
                updateThemeIcon(newTheme);
            });

            function updateThemeIcon(theme) {
                if (theme === "dark") {
                    themeIcon.className = "fa-regular fa-moon";
                } else {
                    themeIcon.className = "fa-regular fa-sun";
                }
            }

            const calendarCells = document.querySelectorAll(".calendar-cell");
            calendarCells.forEach(cell => {
                const cellDate = cell.getAttribute("data-date");
                const wrapper = cell.querySelector(".calendar-events-wrapper");
                
                const matchedEvents = serverEvents.filter(ev => ev.date === cellDate);
                if (matchedEvents.length > 0) {
                    cell.classList.add("has-event");
                    matchedEvents.forEach(ev => {
                        const badge = document.createElement("a");
                        badge.href = "EventServlet?action=edit&id=" + ev.id;
                        badge.className = "calendar-event-badge";
                        badge.title = ev.title;
                        badge.textContent = ev.title;
                        wrapper.appendChild(badge);
                  });
                }
            });

            const gridViewBtn = document.getElementById("gridViewBtn");
            const listViewBtn = document.getElementById("listViewBtn");
            const calendarViewBtn = document.getElementById("calendarViewBtn");
            
            const gridViewContainer = document.getElementById("eventGridViewContainer");
            const listViewContainer = document.getElementById("eventListViewContainer");
            const calendarViewContainer = document.getElementById("eventCalendarViewContainer");

            if(gridViewBtn && listViewBtn && calendarViewBtn) {
                gridViewBtn.addEventListener("click", function() {
                    gridViewBtn.classList.add("active");
                    listViewBtn.classList.remove("active");
                    calendarViewBtn.classList.remove("active");
                    
                    gridViewContainer.classList.remove("d-none");
                    listViewContainer.classList.add("d-none");
                    calendarViewContainer.classList.add("d-none");
                });

                listViewBtn.addEventListener("click", function() {
                    listViewBtn.classList.add("active");
                    gridViewBtn.classList.remove("active");
                    calendarViewBtn.classList.remove("active");
                    
                    listViewContainer.classList.remove("d-none");
                    listViewContainer.classList.add("d-flex");
                    gridViewContainer.classList.add("d-none");
                    calendarViewContainer.classList.add("d-none");
                });

                calendarViewBtn.addEventListener("click", function() {
                    calendarViewBtn.classList.add("active");
                    gridViewBtn.classList.remove("active");
                    listViewBtn.classList.remove("active");
                    
                    calendarViewContainer.classList.remove("d-none");
                    gridViewContainer.classList.add("d-none");
                    listViewContainer.classList.add("d-none");
                });
            }

            <% if (isEdit) { %>
                var eventModal = new bootstrap.Modal(document.getElementById('eventModal'));
                eventModal.show();
            <% } %>
        });
    </script>
</body>
</html>