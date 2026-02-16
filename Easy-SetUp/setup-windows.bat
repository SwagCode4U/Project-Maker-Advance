@echo off
REM ProjectMaker Easy Setup Script for Windows (Command Prompt)
REM This script automates the entire setup process for Windows users

title ProjectMaker - Easy Setup (Windows)

REM Colors (limited in batch)
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

echo %BLUE%========================================%NC%
echo %BLUE%  ProjectMaker - Easy Setup (Windows)  %NC%
echo %BLUE%========================================%NC%
echo.

REM Get script directory
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

REM Check prerequisites
echo %YELLOW%Checking prerequisites...%NC%

python --version >nul 2>&1
if errorlevel 1 (
    echo %RED%Error: Python is not installed or not in PATH!%NC%
    echo.
    echo Please install Python 3.8 or higher from https://python.org
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

node --version >nul 2>&1
if errorlevel 1 (
    echo %RED%Error: Node.js is not installed or not in PATH!%NC%
    echo.
    echo Please install Node.js 18 or higher from https://nodejs.org
    pause
    exit /b 1
)

npm --version >nul 2>&1
if errorlevel 1 (
    echo %RED%Error: npm is not installed or not in PATH!%NC%
    echo It should come with Node.js. Please reinstall Node.js.
    pause
    exit /b 1
)

echo %GREEN%✓ All prerequisites found!%NC%
echo.

REM Display versions
echo %BLUE%Versions detected:%NC%
python --version
node --version
npm --version
echo.

REM Change to project root
cd /d "%PROJECT_ROOT%"
echo %YELLOW%Working directory: %CD%%NC%
echo.

REM Setup Backend
echo %BLUE%========================================%NC%
echo %BLUE%  Setting up Backend (Python/FastAPI)   %NC%
echo %BLUE%========================================%NC%
echo.

cd backend

REM Check if venv exists
if exist "venv" (
    echo %YELLOW%Virtual environment already exists. Using existing venv...%NC%
) else (
    echo %YELLOW%Creating virtual environment...%NC%
    python -m venv venv
    echo %GREEN%✓ Virtual environment created!%NC%
)

REM Activate virtual environment
echo %YELLOW%Activating virtual environment...%NC%
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo %RED%Failed to activate virtual environment!%NC%
    echo If you get a permission error, run PowerShell as Administrator and run:
    echo Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    pause
    exit /b 1
)
echo %GREEN%✓ Virtual environment activated!%NC%

REM Install requirements
echo %YELLOW%Installing Python dependencies...%NC%
python -m pip install --upgrade pip
pip install -r requirements.txt
if errorlevel 1 (
    echo %RED%Failed to install Python dependencies!%NC%
    pause
    exit /b 1
)
echo %GREEN%✓ Dependencies installed!%NC%
echo.

REM Start Backend
echo %BLUE%Starting Backend Server...%NC%
echo %YELLOW%Backend will run on http://localhost:8000%NC%
echo.

REM Create logs directory
if not exist "logs" mkdir logs

REM Start backend in background using start command
start "ProjectMaker Backend" /B python -m uvicorn app.main:app --reload --port 8000 --log-level info > logs\backend.log 2>&1

REM Get the PID (Windows doesn't have easy PID tracking, so we'll use a different approach)
timeout /t 3 /nobreak >nul

REM Check if backend is running by checking the port
netstat -ano | findstr :8000 >nul
if errorlevel 1 (
    echo %RED%✗ Backend might not have started. Check logs\backend.log for errors.%NC%
) else (
    echo %GREEN%✓ Backend server started!%NC%
)
echo %YELLOW%Backend logs: backend\logs\backend.log%NC%
echo.

REM Setup Frontend
echo %BLUE%========================================%NC%
echo %BLUE%  Setting up Frontend (React/Vite)      %NC%
echo %BLUE%========================================%NC%
echo.

cd /d "%PROJECT_ROOT%\frontend"

REM Check if node_modules exists
if exist "node_modules" (
    echo %YELLOW%node_modules already exists. Skipping npm install...%NC%
) else (
    echo %YELLOW%Installing npm dependencies...%NC%
    call npm install
    if errorlevel 1 (
        echo %RED%Failed to install npm dependencies!%NC%
        pause
        exit /b 1
    )
    echo %GREEN%✓ npm dependencies installed!%NC%
)

echo.
echo %BLUE%Starting Frontend Server...%NC%
echo %YELLOW%Frontend will run on http://localhost:5173%NC%
echo.

REM Start frontend in a new window
start "ProjectMaker Frontend" cmd /k "npm run dev"

echo %GREEN%✓ Frontend server started!%NC%
echo.

REM Wait a moment
timeout /t 5 /nobreak >nul

REM Display final message
echo %GREEN%========================================%NC%
echo %GREEN%  ProjectMaker is Ready!               %NC%
echo %GREEN%========================================%NC%
echo.
echo %BLUE%Access your application:%NC%
echo   Frontend UI:  http://localhost:5173
echo   Backend API:  http://localhost:8000
echo   API Docs:     http://localhost:8000/docs
echo.
echo %YELLOW%Logs:%NC%
echo   Backend:  backend\logs\backend.log
echo   Frontend: Check the frontend window
echo.
echo %YELLOW%To stop the servers:%NC%
echo   Close this window and the frontend window
echo   Or run: taskkill /F /IM python.exe /IM node.exe
echo.
echo %BLUE%Press any key to open the browser...%NC%
pause >nul

REM Open browser
start http://localhost:5173

echo.
echo %BLUE%Setup complete! You can close this window now.%NC%
echo %YELLOW%(Keep the other windows open to keep servers running)%NC%
pause
