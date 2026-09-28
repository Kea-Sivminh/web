<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LifeHub - Smart Calendar & Schedule</title>
    <!-- Tailwind CSS & FontAwesome CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script> tailwind.config = { darkMode: 'class' } </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        #main-wrapper {
            margin-left: 250px;
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        body.sidebar-collapsed #main-wrapper {
            margin-left: 80px;
        }
        @media (max-width: 768px) {
            #main-wrapper { margin-left: 0 !important; }
        }
    </style>
    <script>
        if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            document.documentElement.classList.add('dark');
        } else {
            document.documentElement.classList.remove('dark');
        }
        if (localStorage.getItem('sidebarCollapsed') === 'true') {
            document.body.classList.add('sidebar-collapsed');
        }
    </script>
</head>
<body class="bg-slate-50 dark:bg-slate-950 font-sans text-slate-800 dark:text-slate-100 min-h-screen flex overflow-x-hidden">

    <!-- Global Navigation Sidebar Component -->
    <jsp:include page="/sidebar.jsp" />

    <!-- Main Content Wrapper -->
    <div id="main-wrapper" class="flex-1 flex flex-col min-h-screen w-full relative z-10">
        
        <!-- Main Workspace Container -->
        <main class="p-4 sm:p-6 md:p-8 space-y-6 max-w-7xl w-full mx-auto">
            
            <!-- Header Title Section -->
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 class="text-xl sm:text-2xl font-bold text-slate-900 dark:text-white flex items-center gap-2">
                        Smart Calendar & Schedule <i class="fa-solid fa-calendar-check text-indigo-600"></i>
                    </h1>
                    <p class="text-xs text-slate-400 mt-1">Organize your tasks, daily schedules, and keep track of special events.</p>
                </div>
                
                <div class="flex items-center gap-3">
                    <button onclick="toggleTheme()" class="w-10 h-10 rounded-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 text-slate-600 dark:text-slate-300 flex items-center justify-center shadow-sm hover:bg-slate-50 dark:hover:bg-slate-800 transition-all cursor-pointer" title="Toggle Light/Dark Mode">
                        <i id="themeIcon" class="fa-solid fa-moon"></i>
                    </button>

                    <button onclick="openAddModal()" class="px-4 py-2.5 rounded-2xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs sm:text-sm flex items-center gap-2 shadow-lg shadow-indigo-500/25 transition-all cursor-pointer">
                        <i class="fa-solid fa-plus"></i> Add Event
                    </button>
                </div>
            </div>

            <!-- Stat Cards Row -->
            <div class="grid grid-cols-2 lg:grid-cols-3 gap-4">
                <div class="p-4 rounded-3xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm flex items-center gap-4">
                    <div class="w-12 h-12 rounded-2xl bg-indigo-50 dark:bg-indigo-950/50 text-indigo-600 dark:text-indigo-400 flex items-center justify-center text-lg">
                        <i class="fa-solid fa-list-check"></i>
                    </div>
                    <div>
                        <p class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Total Events</p>
                        <h3 id="stat-total" class="text-xl font-extrabold text-slate-700 dark:text-slate-200 mt-0.5">0</h3>
                    </div>
                </div>

                <div class="p-4 rounded-3xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm flex items-center gap-4">
                    <div class="w-12 h-12 rounded-2xl bg-amber-50 dark:bg-amber-950/50 text-amber-600 dark:text-amber-400 flex items-center justify-center text-lg">
                        <i class="fa-solid fa-clock"></i>
                    </div>
                    <div>
                        <p class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">Today's Agenda</p>
                        <h3 id="stat-today" class="text-xl font-extrabold text-slate-700 dark:text-slate-200 mt-0.5">0</h3>
                    </div>
                </div>

                <div class="p-4 rounded-3xl bg-white dark:bg-slate-900 border border-slate-100 dark:border-slate-800 shadow-sm flex items-center gap-4 col-span-2 lg:col-span-1">
                    <div class="w-12 h-12 rounded-2xl bg-emerald-50 dark:bg-emerald-950/50 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-lg">
                        <i class="fa-solid fa-calendar-days"></i>
                    </div>
                    <div>
                        <p class="text-[11px] font-bold text-slate-400 uppercase tracking-wider">This Month</p>
                        <h3 id="stat-month" class="text-xl font-extrabold text-slate-700 dark:text-slate-200 mt-0.5">0</h3>
                    </div>
                </div>
            </div>

            <!-- Main Workspace (Calendar & Agenda Grid) -->
            <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
                
                <!-- Calendar Section (2 Columns) -->
                <div class="xl:col-span-2 bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm flex flex-col">
                    
                    <div class="flex flex-wrap items-center justify-between gap-4 mb-6">
                        <div class="flex items-center gap-3">
                            <span id="currentMonthYearLabel" class="text-base font-extrabold text-slate-900 dark:text-white">September 2026</span>
                            <input type="hidden" id="selectMonth" value="8">
                            <input type="hidden" id="selectYear" value="2026">
                        </div>

                        <div class="flex items-center gap-2">
                            <button onclick="goToToday()" class="px-3 py-2 rounded-xl bg-indigo-50 dark:bg-indigo-950/60 text-indigo-600 dark:text-indigo-400 font-bold text-xs cursor-pointer hover:bg-indigo-100">Today</button>
                            <button onclick="changeMonth(-1)" class="w-8 h-8 rounded-xl bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 flex items-center justify-center text-xs cursor-pointer hover:bg-slate-100"><i class="fa-solid fa-chevron-left"></i></button>
                            <button onclick="changeMonth(1)" class="w-8 h-8 rounded-xl bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 flex items-center justify-center text-xs cursor-pointer hover:bg-slate-100"><i class="fa-solid fa-chevron-right"></i></button>
                        </div>
                    </div>

                    <div class="grid grid-cols-7 gap-2 mb-2 text-center">
                        <span class="text-[11px] font-extrabold text-slate-400">SUN</span>
                        <span class="text-[11px] font-extrabold text-slate-400">MON</span>
                        <span class="text-[11px] font-extrabold text-slate-400">TUE</span>
                        <span class="text-[11px] font-extrabold text-slate-400">WED</span>
                        <span class="text-[11px] font-extrabold text-slate-400">THU</span>
                        <span class="text-[11px] font-extrabold text-slate-400">FRI</span>
                        <span class="text-[11px] font-extrabold text-slate-400">SAT</span>
                    </div>

                    <div id="calendarGrid" class="grid grid-cols-7 gap-2"></div>
                </div>

                <!-- Daily Agenda Section (1 Column) -->
                <div class="bg-white dark:bg-slate-900 p-6 rounded-3xl border border-slate-100 dark:border-slate-800 shadow-sm flex flex-col">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-sm font-extrabold flex items-center gap-2">
                            <i class="fa-solid fa-list text-indigo-600"></i> Daily Agenda
                        </h3>
                    </div>

                    <div class="space-y-3 mb-4">
                        <div class="relative">
                            <i class="fa-solid fa-search absolute left-3.5 top-3 text-xs text-slate-400"></i>
                            <input type="text" id="agendaSearchInput" onkeyup="filterAgenda()" placeholder="Search events..." class="w-full pl-9 pr-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl text-xs font-semibold focus:outline-none focus:border-indigo-500">
                        </div>
                    </div>

                    <div id="agenda-list" class="space-y-3 overflow-y-auto max-h-[360px] pr-1"></div>
                </div>

            </div>
        </main>
    </div>

    <!-- Modal Form for Add/Edit -->
    <div id="calendarModal" class="hidden fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 flex items-center justify-center p-4 overflow-y-auto">
        <div class="bg-white dark:bg-slate-900 w-full max-w-xl rounded-3xl shadow-2xl border border-slate-100 dark:border-slate-800 p-6 my-auto">
            <div class="flex items-center justify-between pb-4 border-b border-slate-100 dark:border-slate-800">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-2xl bg-indigo-50 dark:bg-indigo-950/50 text-indigo-600 flex items-center justify-center text-lg shrink-0">
                        <i class="fa-solid fa-calendar-plus"></i>
                    </div>
                    <div>
                        <h3 id="modalTitle" class="text-base font-extrabold">Add New Event</h3>
                        <p class="text-xs text-slate-400">Fill in details for your schedule.</p>
                    </div>
                </div>
                <button onclick="closeModal()" class="w-8 h-8 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-400 hover:text-slate-600 flex items-center justify-center cursor-pointer">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <form action="CalendarServlet" method="POST" class="space-y-4 pt-4">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="eventId">

                <div>
                    <label class="block text-xs font-extrabold text-slate-600 dark:text-slate-300 mb-1.5">Title *</label>
                    <input type="text" name="title" id="eventTitle" required placeholder="e.g. Project Meeting" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl text-xs font-semibold focus:outline-none focus:border-indigo-500">
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-extrabold text-slate-600 dark:text-slate-300 mb-1.5">Event Date *</label>
                        <input type="date" name="event_date" id="eventDate" required class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl text-xs font-semibold focus:outline-none focus:border-indigo-500">
                    </div>
                    <div>
                        <label class="block text-xs font-extrabold text-slate-600 dark:text-slate-300 mb-1.5">Start Time</label>
                        <input type="time" name="start_time" id="eventStartTime" class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl text-xs font-semibold focus:outline-none focus:border-indigo-500">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-extrabold text-slate-600 dark:text-slate-300 mb-1.5">Description</label>
                    <textarea name="description" id="eventDescription" rows="3" placeholder="Add description..." class="w-full px-4 py-2.5 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-2xl text-xs font-semibold focus:outline-none focus:border-indigo-500"></textarea>
                </div>

                <div class="flex items-center justify-end gap-3 pt-4 border-t border-slate-100 dark:border-slate-800">
                    <button type="button" onclick="closeModal()" class="px-4 py-2.5 rounded-2xl bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 font-bold text-xs cursor-pointer">Cancel</button>
                    <button type="submit" class="px-6 py-2.5 rounded-2xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs shadow-lg shadow-indigo-500/25 cursor-pointer">Save Event</button>
                </div>
            </form>
        </div>
    </div>

    <!-- JavaScript Logic -->
    <script>
        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
        
        let eventsData = [
            <c:forEach var="item" items="${events}" varStatus="loop">
                {
                    id: "${item.id}",
                    title: "${item.title}",
                    date: "${item.eventDate}",
                    startTime: "${item.startTime != null ? item.startTime : ''}",
                    description: "${item.description != null ? item.description : ''}"
                }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        document.addEventListener('DOMContentLoaded', () => {
            const today = new Date();
            document.getElementById('selectMonth').value = today.getMonth();
            document.getElementById('selectYear').value = today.getFullYear();
            renderCalendar();
            renderAgenda(eventsData);
            updateStats();
            updateThemeIcon();
        });

        function toggleTheme() {
            if (document.documentElement.classList.contains('dark')) {
                document.documentElement.classList.remove('dark');
                localStorage.setItem('theme', 'light');
            } else {
                document.documentElement.classList.add('dark');
                localStorage.setItem('theme', 'dark');
            }
            updateThemeIcon();
        }

        function updateThemeIcon() {
            const icon = document.getElementById('themeIcon');
            if (!icon) return;
            if (document.documentElement.classList.contains('dark')) {
                icon.className = "fa-solid fa-sun text-amber-400";
            } else {
                icon.className = "fa-solid fa-moon text-slate-600";
            }
        }

        function openAddModal(dateStr = '') {
            document.getElementById('formAction').value = 'add';
            document.getElementById('eventId').value = '';
            document.getElementById('modalTitle').innerText = 'Add New Event';
            document.getElementById('eventTitle').value = '';
            document.getElementById('eventDate').value = dateStr || new Date().toISOString().split('T')[0];
            document.getElementById('eventStartTime').value = '';
            document.getElementById('eventDescription').value = '';
            document.getElementById('calendarModal').classList.remove('hidden');
        }

        function openEditModal(id, title, date, startTime, description) {
            document.getElementById('formAction').value = 'update';
            document.getElementById('eventId').value = id;
            document.getElementById('modalTitle').innerText = 'Edit Event';
            document.getElementById('eventTitle').value = title;
            document.getElementById('eventDate').value = date;
            document.getElementById('eventStartTime').value = startTime;
            document.getElementById('eventDescription').value = description;
            document.getElementById('calendarModal').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('calendarModal').classList.add('hidden');
        }

        function changeMonth(dir) {
            let m = parseInt(document.getElementById('selectMonth').value) + dir;
            let y = parseInt(document.getElementById('selectYear').value);
            if(m > 11) { m = 0; y++; }
            else if(m < 0) { m = 11; y--; }
            document.getElementById('selectMonth').value = m;
            document.getElementById('selectYear').value = y;
            renderCalendar();
        }

        function goToToday() {
            const now = new Date();
            document.getElementById('selectMonth').value = now.getMonth();
            document.getElementById('selectYear').value = now.getFullYear();
            renderCalendar();
        }

        function renderCalendar() {
            const month = parseInt(document.getElementById('selectMonth').value);
            const year = parseInt(document.getElementById('selectYear').value);
            document.getElementById('currentMonthYearLabel').innerText = monthNames[month] + ' ' + year;

            const calendarGrid = document.getElementById('calendarGrid');
            if (!calendarGrid) return;

            const firstDay = new Date(year, month, 1).getDay();
            const daysInMonth = new Date(year, month + 1, 0).getDate();
            calendarGrid.innerHTML = '';

            for (let i = 0; i < firstDay; i++) {
                calendarGrid.innerHTML += '<div class="h-24 sm:h-28 bg-slate-50/40 dark:bg-slate-900/40 rounded-2xl border border-dashed border-slate-100 dark:border-slate-800"></div>';
            }

            const todayStr = new Date().toISOString().split('T')[0];

            for (let day = 1; day <= daysInMonth; day++) {
                const mStr = String(month + 1).padStart(2, '0');
                const dStr = String(day).padStart(2, '0');
                const dateStr = year + '-' + mStr + '-' + dStr;
                const matchedEvents = eventsData.filter(e => e.date === dateStr);
                const isToday = (dateStr === todayStr);

                let eventsHtml = matchedEvents.map(e => `
                    <div onclick="event.stopPropagation(); openEditModal('\${e.id}', '\${e.title}', '\${e.date}', '\${e.startTime}', '\${e.description}')" class="px-2 py-1 bg-indigo-50 dark:bg-indigo-950/60 border border-indigo-200/50 dark:border-indigo-800/50 rounded-lg text-[10px] font-bold text-indigo-700 dark:text-indigo-300 truncate cursor-pointer hover:bg-indigo-100 flex items-center justify-between">
                        <span class="truncate">\${e.startTime ? e.startTime + ' ' : ''}\${e.title}</span>
                    </div>
                `).join('');

                calendarGrid.innerHTML += `
                    <div onclick="openAddModal('\${dateStr}')" class="h-24 sm:h-28 bg-slate-50/60 dark:bg-slate-800/40 rounded-2xl p-2 border border-slate-100 dark:border-slate-800/80 flex flex-col justify-between transition-all hover:border-indigo-500 cursor-pointer overflow-hidden">
                        <div class="flex items-center justify-between">
                            <span class="text-xs font-bold \${isToday ? 'w-6 h-6 rounded-full bg-indigo-600 text-white flex items-center justify-center' : 'text-slate-600 dark:text-slate-400'}">\${day}</span>
                            <i class="fa-solid fa-plus text-[10px] text-slate-300 dark:text-slate-600 hover:text-indigo-600"></i>
                        </div>
                        <div class="space-y-1 overflow-y-auto max-h-16 pr-1">
                            \${eventsHtml}
                        </div>
                    </div>
                `;
            }
            updateStats();
        }

        function renderAgenda(data) {
            const listContainer = document.getElementById('agenda-list');
            if(!listContainer) return;

            if(data.length === 0) {
                listContainer.innerHTML = '<p class="text-xs text-slate-400 text-center py-6">No events scheduled.</p>';
                return;
            }

            listContainer.innerHTML = data.map(e => `
                <div class="p-3 bg-slate-50 dark:bg-slate-800/60 rounded-2xl border border-slate-100 dark:border-slate-800 flex items-center justify-between gap-3">
                    <div class="min-w-0 flex-1">
                        <h4 class="text-xs font-bold text-slate-800 dark:text-slate-200 truncate">\${e.title}</h4>
                        <p class="text-[10px] text-slate-400 mt-0.5"><i class="fa-regular fa-calendar mr-1"></i> \${e.date} \${e.startTime ? 'at ' + e.startTime : ''}</p>
                    </div>
                    <div class="flex items-center gap-1 shrink-0">
                        <button onclick="openEditModal('\${e.id}', '\${e.title}', '\${e.date}', '\${e.startTime}', '\${e.description}')" class="w-7 h-7 rounded-xl bg-slate-200/60 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-indigo-600 hover:text-white flex items-center justify-center text-xs cursor-pointer transition-all"><i class="fa-solid fa-pen"></i></button>
                        <a href="CalendarServlet?action=delete&id=\${e.id}" onclick="return confirm('Are you sure you want to delete this event?');" class="w-7 h-7 rounded-xl bg-rose-50 dark:bg-rose-950/50 text-rose-600 hover:bg-rose-600 hover:text-white flex items-center justify-center text-xs cursor-pointer transition-all"><i class="fa-solid fa-trash"></i></a>
                    </div>
                </div>
            `).join('');
        }

        function filterAgenda() {
            const keyword = document.getElementById('agendaSearchInput').value.toLowerCase();
            const filtered = eventsData.filter(e => e.title.toLowerCase().includes(keyword) || (e.description && e.description.toLowerCase().includes(keyword)));
            renderAgenda(filtered);
        }

        function updateStats() {
            document.getElementById('stat-total').innerText = eventsData.length;
            const todayStr = new Date().toISOString().split('T')[0];
            const todayCount = eventsData.filter(e => e.date === todayStr).length;
            document.getElementById('stat-today').innerText = todayCount;

            const currentMonth = String(parseInt(document.getElementById('selectMonth').value) + 1).padStart(2, '0');
            const currentYear = document.getElementById('selectYear').value;
            const monthCount = eventsData.filter(e => e.date.startsWith(currentYear + '-' + currentMonth)).length;
            document.getElementById('stat-month').innerText = monthCount;
        }
    </script>
</body>
</html>