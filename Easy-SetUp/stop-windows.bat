@echo off
REM ProjectMaker Stop Script for Windows (Command Prompt)
REM This script stops all running ProjectMaker servers

echo Stopping ProjectMaker servers...
echo.

REM Kill processes by port
echo Stopping Backend (port 8000)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8000') do (
    taskkill /PID %%a /F >nul 2>&1
    echo Backend server stopped
)

echo.
echo Stopping Frontend (port 5173)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173') do (
    taskkill /PID %%a /F >nul 2>&1
    echo Frontend server stopped
)

REM Also try to kill by process name
taskkill /F /IM node.exe >nul 2>&1
taskkill /F /IM python.exe >nul 2>&1

echo.
echo All ProjectMaker servers have been stopped!
pause
