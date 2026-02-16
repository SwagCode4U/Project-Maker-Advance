# 🚀 Easy Setup Scripts

These scripts automate the entire ProjectMaker setup process. No manual steps required!

## 📁 Files in this Directory

### Setup Scripts (Start Everything)
- **`setup-linux.sh`** - For Linux users (Ubuntu, Debian, CentOS, etc.)
- **`setup-mac.sh`** - For macOS users
- **`setup-windows.bat`** - For Windows users (Command Prompt)
- **`setup-windows.ps1`** - For Windows users (PowerShell) ⭐ Recommended

### Stop Scripts (Stop Everything)
- **`stop-linux.sh`** - Stop servers on Linux
- **`stop-mac.sh`** - Stop servers on macOS
- **`stop-windows.bat`** - Stop servers on Windows (CMD)
- **`stop-windows.ps1`** - Stop servers on Windows (PowerShell)

---

## 🚀 Quick Start

### Linux
```bash
# Navigate to project root
cd projectmaker

# Run setup
./Easy-SetUp/setup-linux.sh

# To stop servers later:
./Easy-SetUp/stop-linux.sh
```

### macOS
```bash
# Navigate to project root
cd projectmaker

# Run setup
./Easy-SetUp/setup-mac.sh

# To stop servers later:
./Easy-SetUp/stop-mac.sh
```

### Windows (PowerShell) ⭐ Recommended
```powershell
# Navigate to project root
cd projectmaker

# Run setup (may need to bypass execution policy)
powershell -ExecutionPolicy Bypass -File Easy-SetUp\setup-windows.ps1

# To stop servers later:
powershell -ExecutionPolicy Bypass -File Easy-SetUp\stop-windows.ps1
```

### Windows (Command Prompt)
```cmd
# Navigate to project root
cd projectmaker

# Run setup
Easy-SetUp\setup-windows.bat

# To stop servers later:
Easy-SetUp\stop-windows.bat
```

---

## ⚙️ What These Scripts Do

1. **Check Prerequisites**
   - Verify Python 3.8+ is installed
   - Verify Node.js 18+ and npm are installed

2. **Setup Backend**
   - Create Python virtual environment (venv)
   - Activate the virtual environment
   - Install all Python dependencies from requirements.txt
   - Start the FastAPI backend server on port 8000

3. **Setup Frontend**
   - Install all npm dependencies
   - Start the React/Vite development server on port 5173

4. **Open Browser**
   - Automatically opens http://localhost:5173 in your default browser

---

## 📋 Prerequisites

Before running these scripts, make sure you have:

- **Python 3.8 or higher**: https://python.org
- **Node.js 18 or higher**: https://nodejs.org

### Installation Help

**macOS with Homebrew:**
```bash
brew install python node
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install python3 python3-venv nodejs npm
```

**Windows:**
Download installers from the official websites and install with default settings.

---

## 🔧 Troubleshooting

### Linux/macOS: "Permission denied"
```bash
chmod +x Easy-SetUp/*.sh
```

### Windows PowerShell: "ExecutionPolicy" error
Run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Or use the bypass flag:
```powershell
powershell -ExecutionPolicy Bypass -File Easy-SetUp\setup-windows.ps1
```

### Script says "Python not found" but it's installed
Make sure Python is added to your system PATH during installation.

**Windows:** Check "Add Python to PATH" during installation.

**Linux/macOS:** Try using `python3` instead of `python`:
```bash
alias python=python3
```

---

## 🌐 Access After Setup

Once the scripts complete, you can access:

- **Frontend UI**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

---

## 🛑 Stopping the Servers

### Linux/macOS
```bash
# Method 1: Use stop script
./Easy-SetUp/stop-linux.sh    # or stop-mac.sh

# Method 2: Manual
# Press Ctrl+C in the terminal windows
```

### Windows
```powershell
# Method 1: Use stop script
Easy-SetUp\stop-windows.ps1    # or stop-windows.bat

# Method 2: Manual
# Close the PowerShell/CMD windows

# Method 3: Task Manager
# End tasks: python.exe, node.exe
```

---

## 📞 Need Help?

If you encounter issues:
1. Check the logs in `backend/logs/`
2. Make sure ports 8000 and 5173 are not in use by other applications
3. Verify your Python and Node.js versions
4. Check the main README.md for detailed troubleshooting

---

**Happy Coding!** 🎉
