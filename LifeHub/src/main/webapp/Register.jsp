<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LifeHub - Register</title>
    
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

    <button id="themeToggle" class="fixed top-6 right-6 z-50 p-3 rounded-full bg-white/80 dark:bg-slate-800/80 backdrop-blur-md shadow-lg border border-indigo-200 dark:border-indigo-900/50 hover:scale-110 transition-all">
        <svg id="themeToggleLightIcon" class="hidden w-5 h-5 text-amber-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4.22 2.32a1 1 0 011.415 0l.707.707a1 1 0 01-1.414 1.414l-.707-.707a1 1 0 010-1.414zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zm-2.32 4.22a1 1 0 010 1.415l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 0zM10 18a1 1 0 01-1-1v-1a1 1 0 112 0v1a1 1 0 01-1 1zm-4.22-2.32a1 1 0 01-1.415 0l-.707-.707a1 1 0 011.414-1.414l.707.707a1 1 0 010 1.414zM2 10a1 1 0 011-1h1a1 1 0 110 2H3a1 1 0 01-1-1zm2.32-4.22a1 1 0 010-1.415l.707-.707a1 1 0 011.414 1.414l-.707.707a1 1 0 01-1.414 0zM10 15a5 5 0 100-10 5 5 0 000 10z" clip-rule="evenodd"></path></svg>
        <svg id="themeToggleDarkIcon" class="hidden w-5 h-5 text-indigo-600" fill="currentColor" viewBox="0 0 20 20"><path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path></svg>
    </button>

    <div class="w-full max-w-4xl bg-white dark:bg-slate-900 rounded-3xl overflow-hidden grid grid-cols-1 md:grid-cols-2 border border-indigo-300 dark:border-indigo-500/30 neon-border-card relative z-10 my-6">
        
        <!-- Left Branding Panel -->
        <div class="hidden md:flex bg-gradient-to-br from-indigo-900 via-slate-900 to-slate-950 p-12 text-white flex-col justify-between items-center text-center relative overflow-hidden border-r border-indigo-500/20">
            <div class="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(99,102,241,0.15)_0,transparent_100%)]"></div>
            <div class="w-64 h-64 border-4 border-cyan-400/30 rounded-full absolute -left-20 -top-20 animate-pulse"></div>
            <div class="w-80 h-80 border-2 border-indigo-500/20 rounded-full absolute -right-20 -bottom-20"></div>

            <div class="z-10 mt-6">
                <div class="w-20 h-20 rounded-2xl bg-gradient-to-tr from-indigo-500 to-cyan-400 flex items-center justify-center shadow-2xl shadow-cyan-500/30 mx-auto mb-4 border border-white/20">
                    <span class="text-3xl font-black text-white tracking-wider">LH</span>
                </div>
                <h3 class="text-2xl font-black tracking-wide">LifeHub</h3>
            </div>

            <div class="z-10 my-auto">
                <h2 class="text-3xl font-bold mb-3 bg-gradient-to-r from-cyan-300 to-indigo-200 bg-clip-text text-transparent">Start Your Journey!</h2>
                <p class="text-slate-300 text-sm max-w-xs mx-auto leading-relaxed">
                    Create an account to unlock all features and organize your life with ease.
                </p>
            </div>

            <div class="z-10 text-xs text-slate-400">
                &copy; 2026 LifeHub. All rights reserved.
            </div>
        </div>

        <!-- Right Form Panel -->
        <div class="p-8 md:p-12 flex flex-col justify-center relative overflow-hidden">
            <div class="mb-6">
                <h2 class="text-3xl font-extrabold bg-gradient-to-r from-indigo-600 to-cyan-500 bg-clip-text text-transparent">Create Account</h2>
                <p class="text-slate-500 dark:text-slate-400 text-sm mt-1">Fill in your details to get started</p>
            </div>

            <form action="RegisterServlet" method="POST" id="regForm" onsubmit="return validateAndSubmit(this)" class="space-y-4 relative z-10">
                <div>
                    <label class="block text-xs uppercase font-bold tracking-wider text-slate-500 dark:text-slate-400 mb-1.5">Full Name</label>
                    <input type="text" name="fullname" required 
                        class="w-full px-4 py-2.5 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all dark:text-white"
                        placeholder="John Doe">
                </div>

                <div>
                    <label class="block text-xs uppercase font-bold tracking-wider text-slate-500 dark:text-slate-400 mb-1.5">Email Address</label>
                    <input type="email" name="email" required 
                        class="w-full px-4 py-2.5 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all dark:text-white"
                        placeholder="name@example.com">
                </div>

                <div>
                    <label class="block text-xs uppercase font-bold tracking-wider text-slate-500 dark:text-slate-400 mb-1.5">Password</label>
                    <div class="relative flex items-center">
                        <input type="password" id="regPass" name="password" required 
                            class="w-full pl-4 pr-12 py-2.5 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all dark:text-white"
                            placeholder="••••••••">
                        <button type="button" onclick="togglePass('regPass', 'eyeIconReg')" class="absolute right-3.5 p-1 text-slate-400 hover:text-indigo-500 focus:outline-none">
                            <svg id="eyeIconReg" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <div>
                    <label class="block text-xs uppercase font-bold tracking-wider text-slate-500 dark:text-slate-400 mb-1.5">Confirm Password</label>
                    <div class="relative flex items-center">
                        <input type="password" id="confirmPass" name="confirm_password" required 
                            class="w-full pl-4 pr-12 py-2.5 rounded-xl bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all dark:text-white"
                            placeholder="••••••••">
                        <button type="button" onclick="togglePass('confirmPass', 'eyeIconConfirm')" class="absolute right-3.5 p-1 text-slate-400 hover:text-indigo-500 focus:outline-none">
                            <svg id="eyeIconConfirm" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                            </svg>
                        </button>
                    </div>
                    <p id="passError" class="text-xs text-rose-500 mt-1 hidden">Passwords do not match.</p>
                </div>

                <button type="submit" id="submitBtn" class="w-full py-3.5 px-4 rounded-xl bg-gradient-to-r from-indigo-600 to-cyan-500 hover:from-indigo-500 hover:to-cyan-400 text-white font-bold text-sm tracking-wide neon-btn-glow transform active:scale-95 transition-all duration-200 mt-2">
                    SIGN UP
                </button>
            </form>

            <div class="mt-6 text-center text-xs text-slate-500 dark:text-slate-400">
                Already have an account? 
                <a href="Login.jsp" class="font-bold text-indigo-500 hover:underline">Sign in here</a>
            </div>
        </div>

    </div>

    <script>
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

        function validateAndSubmit(form) {
            const pass = document.getElementById('regPass').value;
            const confirmPass = document.getElementById('confirmPass').value;
            const errorMsg = document.getElementById('passError');
            const btn = document.getElementById('submitBtn');

            if (pass !== confirmPass) {
                errorMsg.classList.remove('hidden');
                return false;
            }
            errorMsg.classList.add('hidden');

            // Disable submit button to prevent double-submission
            btn.disabled = true;
            btn.classList.add('opacity-75', 'cursor-not-allowed');
            btn.innerHTML = 'Creating Account...';
            return true;
        }
    </script>
</body>
</html>