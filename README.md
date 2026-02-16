<div align="center">

# 🚀 ProjectMaker

Build full‑stack apps in minutes — not hours.

[![Made with FastAPI](https://img.shields.io/badge/Backend-FastAPI-05998b?logo=fastapi&logoColor=white)](#)
[![Frontend-React](https://img.shields.io/badge/Frontend-React-61dafb?logo=react&logoColor=0d1117)](#)
[![No Database](https://img.shields.io/badge/Database-None%20Required-ff6b6b)](#)
[![PDF](https://img.shields.io/badge/PDF-fpdf2-30363d)](#)
[![License](https://img.shields.io/badge/License-MIT-2ea043)](#)

</div>

A modern open‑source scaffolding engine that generates complete backend + frontend boilerplates with a polished PDF summary. Designed for developers who value speed, structure, and simplicity.

---

## Table of Contents
- Features
- Supported Frameworks
- How It Works
- Developer API
- [Easy Setup (Automated Scripts)](#-easy-setup-automated-scripts) ⭐ Recommended
- Installation (Manual Setup)
- Quick Start Commands
- Configuration (CORS, Rate Limiting, Logs)
- Troubleshooting
- Architecture
- Contributing & Support

---

## ✨ Features
- **No Database Required** - Works out of the box without any database setup
- Full‑stack generator with live preview and safe file creation
- Professional PDF summary (ASCII-only) with Ports & Scripts and Next Steps
- Per‑framework READMEs, .env.example hints, and .gitignore in subprojects
- Flexible CORS, optional rate limiting, structured JSON errors, Loguru logs
- Modular backend/frontend registry with aliasing and lazy loading

## 🧩 Supported Frameworks

| Category  | Frameworks |
|-----------|------------|
| Backend   | FastAPI • Express • NestJS • Next.js API • Bun.js • Koa • Spring Boot • Flask • Django |
| Frontend  | React • Vue • Svelte • Next.js • Angular • HTML/CSS |

> Special case: when both sides are Next.js (frontend + backend), a single full‑stack app can be generated.

## ⚙️ How It Works
1. Pick backend and frontend frameworks
2. Customize folders and libraries
3. Preview the tree and requirements
4. Build the project to disk
5. Download the PDF summary and start coding

## 🛠️ Developer API

| Endpoint                       | Description                         |
|--------------------------------|-------------------------------------|
| GET  `/version`               | Show version, git sha, build date   |
| POST `/api/projects/preview`  | Return live preview tree            |
| POST `/api/projects/build`    | Generate backend & frontend         |
| GET  `/api/projects/frameworks`| List frameworks and libraries       |
| GET  `/api/projects/generate-pdf` | Download polished PDF summary   |
| GET  `/api/fs/list`           | List files/folders (jailed)         |
| POST `/api/fs/create`         | Create file/folder (jailed)         |

---

## 🚀 Easy Setup (Automated Scripts) ⭐ RECOMMENDED

**The easiest way to get started!** These scripts automate the entire setup process.

### Prerequisites
- **Python 3.8+**: https://python.org
- **Node.js 18+**: https://nodejs.org

### One-Command Setup

Choose your operating system:

#### Linux
```bash
cd projectmaker
./Easy-SetUp/setup-linux.sh
```

#### macOS
```bash
cd projectmaker
./Easy-SetUp/setup-mac.sh
```

#### Windows (PowerShell) ⭐ Recommended
```powershell
cd projectmaker
powershell -ExecutionPolicy Bypass -File Easy-SetUp\setup-windows.ps1
```

#### Windows (Command Prompt)
```cmd
cd projectmaker
Easy-SetUp\setup-windows.bat
```

### What These Scripts Do
1. ✅ Check prerequisites (Python, Node.js)
2. ✅ Create and activate virtual environment
3. ✅ Install all Python dependencies
4. ✅ Install all npm dependencies
5. ✅ Start backend server (port 8000)
6. ✅ Start frontend server (port 5173)
7. ✅ Open browser automatically

### Access Your App
- 🌐 **Frontend**: http://localhost:5173
- ⚙️ **Backend API**: http://localhost:8000
- 📚 **API Docs**: http://localhost:8000/docs

### Stop the Servers
```bash
# Linux
./Easy-SetUp/stop-linux.sh

# macOS
./Easy-SetUp/stop-mac.sh

# Windows PowerShell
powershell -ExecutionPolicy Bypass -File Easy-SetUp\stop-windows.ps1

# Windows CMD
Easy-SetUp\stop-windows.bat
```

📖 **For more details**, see [Easy-SetUp/README.md](Easy-SetUp/README.md)

---

## 📦 Installation (Manual Setup)

### Prerequisites
- **Python 3.8+** installed
- **Node.js 18+** and **npm** installed

### 1) Clone the Repository

```bash
git clone https://github.com/SwagCode4U/projectmaker.git
cd projectmaker
```

### 2) Setup Backend (Python/FastAPI)

Navigate to the backend directory:
```bash
cd backend
```

#### Create Virtual Environment

**Linux/macOS:**
```bash
python3 -m venv venv
```

**Windows (Command Prompt):**
```cmd
python -m venv venv
```

**Windows (PowerShell):**
```powershell
python -m venv venv
```

#### Activate Virtual Environment

**Linux/macOS (Bash/Zsh):**
```bash
source venv/bin/activate
```

**macOS (if using bash):**
```bash
source venv/bin/activate
```

**Windows (Command Prompt):**
```cmd
venv\Scripts\activate.bat
```

**Windows (PowerShell):**
```powershell
venv\Scripts\Activate.ps1
```

#### Install Dependencies

```bash
pip install -r requirements.txt
```

#### Start Backend Server

```bash
python -m uvicorn app.main:app --reload --port 8000
```

✅ **Backend is now running at:** http://localhost:8000

**Keep this terminal open** and open a new terminal for the frontend.

### 3) Setup Frontend (React/Vite)

Open a new terminal and navigate to the project root, then:

```bash
cd frontend
```

#### Install Dependencies

```bash
npm install
```

#### Start Frontend Development Server

```bash
npm run dev
```

✅ **Frontend is now running at:** http://localhost:5173

---

## 🚀 Quick Start Commands (Reference)

**Terminal 1 - Backend:**
```bash
cd projectmaker/backend
source venv/bin/activate  # Linux/Mac
# OR venv\Scripts\activate  # Windows
pip install -r requirements.txt
python -m uvicorn app.main:app --reload --port 8000
```

**Terminal 2 - Frontend:**
```bash
cd projectmaker/frontend
npm install
npm run dev
```

**Access the application:**
- 🌐 Frontend UI: http://localhost:5173
- ⚙️  Backend API: http://localhost:8000
- 📚 API Docs: http://localhost:8000/docs

### Configuration
- CORS: set `FRONTEND_ORIGINS` (.env at repo root) to a comma‑separated list of allowed origins
- Rate limiting (optional): `RATE_LIMIT_ENABLED=true|false`, `RATE_LIMIT_DEFAULT=120/minute`
- Logs: written to `logs/`, rotated daily, kept 7 days

---

## 🛠️ Troubleshooting

### Backend won't start?

**Issue:** `ModuleNotFoundError: No module named 'app'`

**Solution:** Make sure you're in the `backend` directory and your virtual environment is activated:
```bash
cd backend
source venv/bin/activate  # Linux/Mac
# OR: venv\Scripts\activate  # Windows
python -m uvicorn app.main:app --reload --port 8000
```

**Issue:** `Permission denied` when activating venv on Windows

**Solution:** Run PowerShell as Administrator or use:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Frontend won't start?

**Issue:** `npm: command not found`

**Solution:** Install Node.js from https://nodejs.org (version 18 or higher)

**Issue:** Port already in use

**Solution:** Change the port in `frontend/vite.config.js` or kill the process using port 5173:
```bash
# Linux/Mac:
lsof -ti:5173 | xargs kill -9

# Windows:
netstat -ano | findstr :5173
taskkill /PID <PID> /F
```

### Can't connect backend from frontend?

**Solution:** Check that both servers are running:
- Backend: http://localhost:8000 (should show JSON response)
- Frontend: http://localhost:5173

If using different ports, update CORS settings in `backend/app/main.py` or set `FRONTEND_ORIGINS` environment variable.

## 🧱 Architecture (High Level)
```
projectmaker/
├─ backend/
│  ├─ app/
│  │  ├─ routes/         # APIs (preview, build, pdf, fs, frameworks)
│  │  ├─ services/
│  │  │  ├─ frameworks/  # per‑framework backends/frontends + registry
│  │  │  ├─ pdf_generator.py
│  │  │  └─ project_generator.py
│  │  └─ main.py         # FastAPI app, CORS, logging, errors, /version
│  └─ requirements.txt
└─ frontend/
   └─ src/               # React + Vite wizard (4 steps)
```

## 📄 PDF Summary (What you get)
- Colored header, section dividers, and branding footer
- Configuration, Project Structure (ASCII tree), Dependencies
- Ports & Scripts table (dev commands and ports)
- Next Steps (env copy hints, install/run, optional git remote)

## 🤝 Contributing & Support
- PRs welcome for new frameworks, fixes, and docs
- Open issues for bugs or ideas
- Contact: amit9000@tutanota.com

If you find this useful:
- ⭐ Star the repo
- 🍴 Fork and build something awesome
- 📣 Share with your dev friends

## 📸 Screenshots & Preview

<div align="center">

### 🏠 Home Page  
<img src="docs/HomePage.png" width="750" alt="Home Page">

---

### ⚙️ Project Info Sequence  
<img src="docs/ProjectInfo-1.png" width="700" alt="Project Info 1">
<img src="docs/ProjectInfo-2.png" width="700" alt="Project Info 2">
<img src="docs/ProjectInfo-3.png" width="700" alt="Project Info 3">
<img src="docs/ProjectInfo-4.png" width="700" alt="Project Info 4">
<img src="docs/ProjectInfo-5.png" width="700" alt="Project Info 5">
<img src="docs/ProjectInfo-6.png" width="700" alt="Project Info 6">
<img src="docs/ProjectInfo-7.png" width="700" alt="Project Info 7">
<img src="docs/ProjectInfo-8.png" width="700" alt="Project Info 8">
<img src="docs/ProjectInfo-9.png" width="700" alt="Project Info 9">
<img src="docs/ProjectInfo-10.png" width="700" alt="Project Info 10">
<img src="docs/ProjectInfo-11.png" width="700" alt="Project Info 11">
<img src="docs/ProjectInfo-12.png" width="700" alt="Project Info 12">

---

### 📄 PDF Output  
<img src="docs/PDF_1.png" width="750" alt="PDF Summary 1">
<img src="docs/PDF_2.png" width="750" alt="PDF Summary 2">
<img src="docs/PDF_3.png" width="750" alt="PDF Summary 3">

</div>


<div align="center">

Made with ❤️ by SwagCode4U

Generated with [ProjectMaker](https://github.com/SwagCode4U/projectmaker)

</div>



