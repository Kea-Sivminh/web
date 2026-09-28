<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LifeHub - Login</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: { primary: '#6366f1', accent: '#06b6d4' }
                }
            }
        }
    </script>

    <script>
        if (localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            document.documentElement.classList.add('dark');
        } else {
            document.documentElement.classList.remove('dark');
        }
    </script>

    <style>
        input::-ms-reveal,
        input::-ms-clear,
        input::-webkit-contacts-auto-fill-button,
        input::-webkit-credentials-auto-fill-button {
            display: none !important;
            visibility: hidden !important;
            pointer-events: none !important;
        }

        .neon-border-card {
            box-shadow: 0 0 25px rgba(99, 102, 241, 0.25), 0 0 10px rgba(6, 182, 212, 0.2);
        }
        .dark .neon-border-card {
            box-shadow: 0 0 35px rgba(99, 102, 241, 0.4), 0 0 15px rgba(6, 182, 212, 0.3);
        }

        .neon-btn-glow {
            box-shadow: 0 0 15px rgba(99, 102, 241, 0.5), 0 0 30px rgba(6, 182, 212, 0.3);
        }
        .neon-btn-glow:hover {
            box-shadow: 0 0 25px rgba(99, 102, 241, 0.8), 0 0 45px rgba(6, 182, 212, 0.5);
        }
    </style>
</head>
<body class="bg-slate-100 dark:bg-slate-950 text-slate-800 dark:text-slate-100 min-h-screen flex items-center justify-center p-4 md:p-8 transition-colors duration-300 relative overflow-x-hidden">

    <div class="absolute -top-20 -left-20 w-96 h-96 bg-indigo-500/20 rounded-full blur-3xl pointer-events-none"></div>
    <div class="absolute -bottom-20 -right-20 w-96 h-96 bg-cyan-500/20 rounded-full blur-3xl pointer-events-none"></div>

    <!-- Theme Toggle Button -->
    <button id="themeToggle" class="fixed top-6 right-6 z-50 p-3 rounded-full bg-white/80 dark:bg-slate-800/80 backdrop-blur-md shadow-lg border border-indigo-200 dark:border-indigo-900/50 hover:scale-110 transition-all">
        <svg id="themeToggleLightIcon" class="hidden w-5 h-5 text-amber-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4.22 2.32a1 1 0 011.415 0l.707.707a1 1 0 01-1.414 1.414l-.707-.707a1 1 0 010-1.414zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zm-2.32 4.22a1 1 0 010 1.415l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 0zM10 18a1 1 0 01-1-1v-1a1 1 0 112 0v1a1 1 0 01-1 1zm-4.22-2.32a1 1 0 01-1.415 0l-.707-.707a1 1 0 011.414-1.414l.707.707a1 1 0 010 1.414zM2 10a1 1 0 011-1h1a1 1 0 110 2H3a1 1 0 01-1-1zm2.32-4.22a1 1 0 010-1.415l.707-.707a1 1 0 011.414 1.414l-.707.707a1 1 0 01-1.414 0zM10 15a5 5 0 100-10 5 5 0 000 10z" clip-rule="evenodd"></path></svg>
        <svg id="themeToggleDarkIcon" class="hidden w-5 h-5 text-indigo-600" fill="currentColor" viewBox="0 0 20 20"><path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path></svg>
    </button>

    <div class="w-full max-w-4xl bg-white dark:bg-slate-900 rounded-3xl overflow-hidden grid grid-cols-1 md:grid-cols-2 border border-indigo-300 dark:border-indigo-500/30 neon-border-card relative z-10">
        
        <div class="p-8 md:p-12 flex flex-col justify-center relative overflow-hidden">
            <div class="absolute -right-10 -bottom-10 opacity-[0.04] dark:opacity-[0.06] pointer-events-none select-none">
                <span class="text-9xl font-black text-indigo-600 dark:text-indigo-400 tracking-tighter">LH</span>
            </div>

            <div class="mb-6">
                <h2 class="text-3xl font-extrabold bg-gradient-to-r from-indigo-600 to-cyan-500 bg-clip-text text-transparent">Sign In</h2>
                <p class="text-slate-500 dark:text-slate-400 text-sm mt-1">Welcome back to LifeHub ecosystem</p>
            </div>

            <!-- Messages & Alerts -->
            <% if ("registered".equals(request.getParameter("msg"))) { %>
                <div class="mb-4 p-3 bg-emerald-500/10 border border-emerald-500/30 rounded-xl text-emerald-600 dark:text-emerald-400 text-xs font-semibold text-center">
                    Account created successfully! Please sign in.
                </div>
            <% } %>

            <% if (request.getParameter("error") != null) { %>
                <div class="mb-4 p-3 bg-rose-500/10 border border-rose-500/30 rounded-xl text-rose-500 text-xs font-semibold text-center">
                    Invalid email or password. Please try again.
                </div>
            <% } %>

            <form action="LoginServlet" method="POST" id="loginForm" onsubmit="return handleLoginSubmit()" class="space-y-5 relative z-10">
                <div>
                    <label class="block text-xs uppercase font-bold tracking-wider text-slate-500 dark:text-slate-400 mb-2">Email</label>
                    <div class="relative flex items-center">
                        <input type="email" name="email" required 
                            class="w-full pl-4 pr-12 py-3 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all dark:text-white"
                            placeholder="name@example.com">
                        <span class="absolute right-4 text-slate-400 pointer-events-none">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"></path></svg>
                        </span>
                    </div>
                </div>

                <div>
                    <label class="block text-xs uppercase font-bold tracking-wider text-slate-500 dark:text-slate-400 mb-2">Password</label>
                    <div class="relative flex items-center">
                        <input type="password" id="loginPass" name="password" required 
                            class="w-full pl-4 pr-12 py-3 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all dark:text-white"
                            placeholder="••••••••">
                        <button type="button" onclick="togglePass('loginPass', 'eyeIconLogin')" class="absolute right-3.5 p-1 text-slate-400 hover:text-indigo-500 focus:outline-none">
                            <svg id="eyeIconLogin" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                            </svg>
                        </button>
                    </div>
                    <div class="text-right mt-2">
                        <a href="#" class="text-xs font-semibold text-indigo-500 hover:text-indigo-600 dark:hover:text-indigo-400">Forgot Password?</a>
                    </div>
                </div>

                <button type="submit" id="loginBtn" class="w-full py-3.5 px-4 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-500 hover:from-indigo-500 hover:to-cyan-400 text-white font-bold text-sm tracking-wide neon-btn-glow transform active:scale-95 transition-all duration-200">
                    SIGN IN
                </button>
            </form>

            <div class="mt-8 text-center text-xs text-slate-500 dark:text-slate-400">
                Don't have an account? 
                <a href="Register.jsp" class="font-bold text-indigo-500 hover:underline">Sign up here</a>
            </div>
        </div>

        <div class="hidden md:flex bg-gradient-to-br from-indigo-900 via-slate-900 to-slate-950 p-12 text-white flex-col justify-between items-center text-center relative overflow-hidden border-l border-indigo-500/20">
            <div class="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(99,102,241,0.15)_0,transparent_100%)]"></div>
            <div class="w-64 h-64 border-4 border-cyan-400/30 rounded-full absolute -right-20 -top-20 animate-pulse"></div>
            <div class="w-80 h-80 border-2 border-indigo-500/20 rounded-full absolute -left-20 -bottom-20"></div>

            <div class="z-10 mt-6">
                <div class="w-20 h-20 rounded-2xl bg-gradient-to-tr from-indigo-500 to-cyan-400 flex items-center justify-center shadow-2xl shadow-cyan-500/30 mx-auto mb-4 border border-white/20">
                    <span class="text-3xl font-black text-white tracking-wider">LH</span>
                </div>
                <h3 class="text-2xl font-black tracking-wide">LifeHub</h3>
            </div>

            <div class="z-10 my-auto">
                <h2 class="text-3xl font-bold mb-3 bg-gradient-to-r from-cyan-300 to-indigo-200 bg-clip-text text-transparent">Join Us!</h2>
                <p class="text-slate-300 text-sm max-w-xs mx-auto leading-relaxed">
                    Organize your life, tasks, events, and finances seamlessly in one place.
                </p>
            </div>

            <div class="z-10 text-xs text-slate-400">
                &copy; 2026 LifeHub. All rights reserved.
            </div>
        </div>

    </div>

    <script>
        // Password Visibility Toggle
        function togglePass(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858-5.908A9.954 9.954 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21M3 3l18 18"></path>`;
            } else {
                input.type = 'password';
                icon.innerHTML = `<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>`;
            }
        }

        // Prevent Double Submission
        function handleLoginSubmit() {
            const btn = document.getElementById('loginBtn');
            btn.disabled = true;
            btn.classList.add('opacity-75', 'cursor-not-allowed');
            btn.innerHTML = 'Signing In...';
            return true;
        }

        // Dark / Light Theme Toggle Functionality
        const themeToggleBtn = document.getElementById('themeToggle');
        const darkIcon = document.getElementById('themeToggleDarkIcon');
        const lightIcon = document.getElementById('themeToggleLightIcon');

        if (document.documentElement.classList.contains('dark')) {
            lightIcon.classList.remove('hidden');
        } else {
            darkIcon.classList.remove('hidden');
        }

        themeToggleBtn.addEventListener('click', function() {
            darkIcon.classList.toggle('hidden');
            lightIcon.classList.toggle('hidden');

            if (document.documentElement.classList.contains('dark')) {
                document.documentElement.classList.remove('dark');
                localStorage.setItem('theme', 'light');
            } else {
                document.documentElement.classList.add('dark');
                localStorage.setItem('theme', 'dark');
            }
        });
    </script>
</body>
</html>