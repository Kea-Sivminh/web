<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.lifehub.model.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    String username = (currentUser != null && currentUser.getName() != null) ? currentUser.getName() : "User";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LifeHub - Documents Vault</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --bg-main: #f8fafc;
            --bg-card: #ffffff;
            --border-color: #e2e8f0;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
        }

        [data-bs-theme="dark"] {
            --bg-main: #0b0f19;
            --bg-card: #131b2e;
            --border-color: #1e293b;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
        }

        body {
            background-color: var(--bg-main);
            color: var(--text-main);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: background-color 0.3s, color 0.3s;
        }

        .main-content {
            margin-left: 250px;
            transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            min-height: 100vh;
        }

        .workspace-header {
            background: transparent;
            border: none;
            padding: 0;
            margin-bottom: 24px;
        }

        .card-custom {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .btn-gradient {
            background: var(--primary-gradient);
            border: none;
            color: white;
            font-weight: 600;
            padding: 8px 15px;
            border-radius: 10px;
            transition: opacity 0.2s;
        }

        .btn-gradient:hover {
            opacity: 0.9;
            color: white;
        }

        .form-control {
            background-color: var(--bg-main);
            border-color: var(--border-color);
            color: var(--text-main);
            border-radius: 10px;
            padding: 12px;
        }

        .form-control:focus {
            background-color: var(--bg-main);
            border-color: #6366f1;
            color: var(--text-main);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .modal-content {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            color: var(--text-main);
            border-radius: 16px;
        }

        .stat-card {
            background-color: var(--bg-card);
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .stat-icon {
            width: 45px;
            height: 45px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .theme-toggle-btn {
            width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            background: var(--bg-card);
            color: var(--text-main);
            cursor: pointer;
            transition: background 0.2s;
        }
        .theme-toggle-btn:hover {
            background: var(--border-color);
        }
    </style>

    <!-- Script to Sync Theme with Dashboard -->
    <script>
        (function() {
            const savedTheme = localStorage.getItem('theme') || localStorage.getItem('bs-theme') || 'dark';
            document.documentElement.setAttribute('data-bs-theme', savedTheme);
        })();
    </script>
</head>
<body>

    <!-- Sidebar Include -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main Content Workspace -->
    <div class="main-content p-4">
        <div class="container-fluid px-2">
            
            <!-- Workspace Header -->
            <div class="workspace-header d-flex justify-content-between align-items-center flex-wrap gap-3">
                <div>
                    <h2><i class="fa-solid fa-folder-open me-2" style="color: #a855f7;"></i> Documents Vault</h2>
                    <p class="text-muted mb-0">Organize, store, and manage your important files for <span class="fw-semibold" style="color: var(--text-main);"><%= username %></span></p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <!-- Light / Dark Mode Toggle Button -->
                    <button type="button" class="theme-toggle-btn" id="themeToggleBtn" title="Toggle Light/Dark Mode">
                        <i class="fa-solid fa-moon" id="themeIcon"></i>
                    </button>
                    <button type="button" class="btn btn-gradient" data-bs-toggle="modal" data-bs-target="#uploadDocModal">
                        <i class="fa-solid fa-upload me-2"></i> Upload Document
                    </button>
                </div>
            </div>

            <!-- Statistics Top Row -->
            <div class="row g-3 mb-4">
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="fa-solid fa-file-lines"></i>
                        </div>
                        <div>
                            <span class="text-muted small d-block">TOTAL FILES</span>
                            <h4 class="mb-0 fw-bold">${documents.size()}</h4>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                            <i class="fa-solid fa-file-pdf"></i>
                        </div>
                        <div>
                            <span class="text-muted small d-block">PDF DOCUMENTS</span>
                            <h4 class="mb-0 fw-bold">
                                <c:set var="pdfCount" value="0" />
                                <c:forEach var="doc" items="${documents}">
                                    <c:if test="${doc.filePath.toLowerCase().endsWith('.pdf')}">
                                        <c:set var="pdfCount" value="${pdfCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${pdfCount}
                            </h4>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="fa-solid fa-file-word"></i>
                        </div>
                        <div>
                            <span class="text-muted small d-block">WORD FILES</span>
                            <h4 class="mb-0 fw-bold">
                                <c:set var="wordCount" value="0" />
                                <c:forEach var="doc" items="${documents}">
                                    <c:if test="${doc.filePath.toLowerCase().endsWith('.doc') || doc.filePath.toLowerCase().endsWith('.docx')}">
                                        <c:set var="wordCount" value="${wordCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${wordCount}
                            </h4>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-card">
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="fa-solid fa-file-excel"></i>
                        </div>
                        <div>
                            <span class="text-muted small d-block">EXCEL FILES</span>
                            <h4 class="mb-0 fw-bold">
                                <c:set var="excelCount" value="0" />
                                <c:forEach var="doc" items="${documents}">
                                    <c:if test="${doc.filePath.toLowerCase().endsWith('.xls') || doc.filePath.toLowerCase().endsWith('.xlsx') || doc.filePath.toLowerCase().endsWith('.csv')}">
                                        <c:set var="excelCount" value="${excelCount + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${excelCount}
                            </h4>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Documents Grid Cards -->
            <div class="row g-4">
                <c:choose>
                    <c:when test="${not empty documents}">
                        <c:forEach var="doc" items="${documents}">
                            <div class="col-md-4">
                                <div class="card card-custom p-3 position-relative">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div class="d-flex align-items-center gap-2">
                                            <!-- កំណត់ Icon និង Badge ទៅតាមប្រភេទ File (PDF, Word, Excel ឬ Other) -->
                                            <c:choose>
                                                <c:when test="${doc.filePath.toLowerCase().endsWith('.pdf')}">
                                                    <div class="p-2 rounded bg-danger bg-opacity-10 text-danger">
                                                        <i class="fa-solid fa-file-pdf fa-lg"></i>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-danger bg-opacity-20 text-danger" style="font-size: 0.65rem;">PDF</span>
                                                    </div>
                                                </c:when>
                                                <c:when test="${doc.filePath.toLowerCase().endsWith('.doc') || doc.filePath.toLowerCase().endsWith('.docx')}">
                                                    <div class="p-2 rounded bg-primary bg-opacity-10 text-primary">
                                                        <i class="fa-solid fa-file-word fa-lg"></i>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-primary bg-opacity-20 text-primary" style="font-size: 0.65rem;">WORD</span>
                                                    </div>
                                                </c:when>
                                                <c:when test="${doc.filePath.toLowerCase().endsWith('.xls') || doc.filePath.toLowerCase().endsWith('.xlsx') || doc.filePath.toLowerCase().endsWith('.csv')}">
                                                    <div class="p-2 rounded bg-success bg-opacity-10 text-success">
                                                        <i class="fa-solid fa-file-excel fa-lg"></i>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-success bg-opacity-20 text-success" style="font-size: 0.65rem;">EXCEL</span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="p-2 rounded bg-secondary bg-opacity-10 text-secondary">
                                                        <i class="fa-solid fa-file-lines fa-lg"></i>
                                                    </div>
                                                    <div>
                                                        <span class="badge bg-secondary bg-opacity-20 text-secondary" style="font-size: 0.65rem;">FILE</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <a href="DocumentServlet?action=delete&id=${doc.id}" class="text-danger bg-transparent border-0" title="Delete" onclick="return confirm('Are you sure you want to delete this document?');">
                                            <i class="fa-solid fa-trash-can"></i>
                                        </a>
                                    </div>
                                    <h5 class="fw-bold text-truncate mb-1" style="font-size: 1rem;" title="${doc.title}">${doc.title}</h5>
                                    <p class="text-muted small mb-3">Updated: ${doc.uploadDate}</p>
                                    
                                    <!-- ប៊ូតុង View និង Download ដាច់ពីគ្នា -->
                                    <div class="d-flex align-items-center gap-2 pt-2 border-top border-secondary border-opacity-10">
                                        <a href="${doc.filePath}" class="btn btn-sm btn-outline-primary w-50 rounded-pill" target="_blank">
                                            <i class="fa-solid fa-eye me-1"></i> View
                                        </a>
                                        <a href="${doc.filePath}" class="btn btn-sm btn-gradient w-50 rounded-pill text-white text-center" download>
                                            <i class="fa-solid fa-download me-1"></i> Download
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-12 text-center text-muted py-5">
                            <i class="fa-regular fa-folder-open fa-3x mb-3"></i>
                            <p class="mb-0">No documents found in vault.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>

    <!-- Modal for Uploading Document -->
    <div class="modal fade" id="uploadDocModal" tabindex="-1" aria-labelledby="uploadDocModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-3">
                <div class="modal-header border-0">
                    <h5 class="modal-title" id="uploadDocModalLabel"><i class="fa-solid fa-upload"></i> Upload New Document</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="DocumentServlet?action=upload" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Document Title</label>
                            <input type="text" class="form-control" name="title" placeholder="e.g., Employment Contract..." required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Choose File (.pdf, .doc, .docx, .xls, .xlsx)</label>
                            <input type="file" class="form-control" name="file" accept=".pdf,.doc,.docx,.xls,.xlsx,.csv" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-gradient rounded-pill px-4">Upload</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const themeIcon = document.getElementById('themeIcon');

            function updateThemeUI(theme) {
                document.documentElement.setAttribute('data-bs-theme', theme);
                if (theme === 'dark') {
                    themeIcon.className = "fa-solid fa-sun";
                } else {
                    themeIcon.className = "fa-solid fa-moon";
                }
            }

            // Get initial theme
            const currentTheme = document.documentElement.getAttribute('data-bs-theme') || 'dark';
            updateThemeUI(currentTheme);

            // Toggle click event
            if (themeToggleBtn) {
                themeToggleBtn.addEventListener('click', function () {
                    const activeTheme = document.documentElement.getAttribute('data-bs-theme');
                    const newTheme = activeTheme === 'dark' ? 'light' : 'dark';
                    
                    localStorage.setItem('theme', newTheme);
                    localStorage.setItem('bs-theme', newTheme);
                    updateThemeUI(newTheme);
                });
            }

            // Sync across tabs/windows
            window.addEventListener('storage', function(e) {
                if (e.key === 'theme' || e.key === 'bs-theme') {
                    updateThemeUI(e.newValue || 'dark');
                }
            });
        });
    </script>
</body>
</html>