# ProjectMaker Easy Setup Script for Windows (PowerShell)
# This script automates the entire setup process for Windows users
# Run with: powershell -ExecutionPolicy Bypass -File setup-windows.ps1

# Requires -Version 5.1

# Colors
$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Blue = "`e[34m"
$NC = "`e[0m"

Write-Host "$Blue========================================$NC"
Write-Host "$Blue  ProjectMaker - Easy Setup (Windows)  $NC"
Write-Host "$Blue========================================$NC"
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

# Check prerequisites
Write-Host "$Yellow Checking prerequisites...$NC"

# Check Python
$PythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $PythonCmd) {
    $PythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
}

if (-not $PythonCmd) {
    Write-Host "$Red Error: Python is not installed or not in PATH!$NC"
    Write-Host ""
    Write-Host "Please install Python 3.8 or higher from https://python.org"
    Write-Host "Make sure to check 'Add Python to PATH' during installation"
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Check Node.js
$NodeCmd = Get-Command node -ErrorAction SilentlyContinue
if (-not $NodeCmd) {
    Write-Host "$Red Error: Node.js is not installed or not in PATH!$NC"
    Write-Host ""
    Write-Host "Please install Node.js 18 or higher from https://nodejs.org"
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Check npm
$NpmCmd = Get-Command npm -ErrorAction SilentlyContinue
if (-not $NpmCmd) {
    Write-Host "$Red Error: npm is not installed or not in PATH!$NC"
    Write-Host "It should come with Node.js. Please reinstall Node.js."
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "$Green ✓ All prerequisites found!$NC"
Write-Host ""

# Display versions
Write-Host "$Blue Versions detected:$NC"
& $PythonCmd.Source --version
& $NodeCmd.Source --version
& $NpmCmd.Source --version
Write-Host ""

# Change to project root
Set-Location $ProjectRoot
Write-Host "$Yellow Working directory: $(Get-Location)$NC"
Write-Host ""

# Setup Backend
Write-Host "$Blue========================================$NC"
Write-Host "$Blue  Setting up Backend (Python/FastAPI)   $NC"
Write-Host "$Blue========================================$NC"
Write-Host ""

Set-Location "$ProjectRoot\backend"

# Check if venv exists
if (Test-Path "venv") {
    Write-Host "$Yellow Virtual environment already exists. Using existing venv...$NC"
} else {
    Write-Host "$Yellow Creating virtual environment...$NC"
    & $PythonCmd.Source -m venv venv
    Write-Host "$Green ✓ Virtual environment created!$NC"
}

# Activate virtual environment
Write-Host "$Yellow Activating virtual environment...$NC"
$VenvActivate = "$ProjectRoot\backend\venv\Scripts\Activate.ps1"

if (Test-Path $VenvActivate) {
    & $VenvActivate
    Write-Host "$Green ✓ Virtual environment activated!$NC"
} else {
    Write-Host "$Red Failed to find virtual environment activation script!$NC"
    Write-Host "Trying alternative method..."
    $env:PATH = "$ProjectRoot\backend\venv\Scripts;$env:PATH"
}

# Install requirements
Write-Host "$Yellow Installing Python dependencies...$NC"
python -m pip install --upgrade pip
pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "$Red Failed to install Python dependencies!$NC"
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-Host "$Green ✓ Dependencies installed!$NC"
Write-Host ""

# Start Backend
Write-Host "$Blue Starting Backend Server...$NC"
Write-Host "$Yellow Backend will run on http://localhost:8000$NC"
Write-Host ""

# Create logs directory
if (-not (Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

# Start backend as background job
$BackendJob = Start-Job -ScriptBlock {
    param($ProjectRoot)
    Set-Location "$ProjectRoot\backend"
    python -m uvicorn app.main:app --reload --port 8000 --log-level info
} -ArgumentList $ProjectRoot

# Save job info
$BackendJob.Id | Out-File -FilePath ".backend.pid" -Force

Start-Sleep -Seconds 3

# Check if backend is running
$BackendRunning = $false
try {
    $Response = Invoke-WebRequest -Uri "http://localhost:8000" -Method GET -TimeoutSec 5 -ErrorAction Stop
    $BackendRunning = $true
} catch {
    # Backend might still be starting
    Start-Sleep -Seconds 2
    try {
        $Response = Invoke-WebRequest -Uri "http://localhost:8000" -Method GET -TimeoutSec 5 -ErrorAction Stop
        $BackendRunning = $true
    } catch {
        $BackendRunning = $false
    }
}

if ($BackendRunning) {
    Write-Host "$Green ✓ Backend server started successfully!$NC"
} else {
    Write-Host "$Yellow Backend is starting... (check logs for details)$NC"
}
Write-Host "$Yellow Backend logs: backend\logs\backend.log$NC"
Write-Host ""

# Setup Frontend
Write-Host "$Blue========================================$NC"
Write-Host "$Blue  Setting up Frontend (React/Vite)      $NC"
Write-Host "$Blue========================================$NC"
Write-Host ""

Set-Location "$ProjectRoot\frontend"

# Check if node_modules exists
if (Test-Path "node_modules") {
    Write-Host "$Yellow node_modules already exists. Skipping npm install...$NC"
} else {
    Write-Host "$Yellow Installing npm dependencies...$NC"
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "$Red Failed to install npm dependencies!$NC"
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
    Write-Host "$Green ✓ npm dependencies installed!$NC"
}

Write-Host ""
Write-Host "$Blue Starting Frontend Server...$NC"
Write-Host "$Yellow Frontend will run on http://localhost:5173$NC"
Write-Host ""

# Start frontend in a new window
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$ProjectRoot\frontend'; npm run dev" -WindowStyle Normal

Write-Host "$Green ✓ Frontend server started!$NC"
Write-Host ""

# Wait a moment
Start-Sleep -Seconds 5

# Display final message
Write-Host "$Green========================================$NC"
Write-Host "$Green  ProjectMaker is Ready!               $NC"
Write-Host "$Green========================================$NC"
Write-Host ""
Write-Host "$Blue Access your application:$NC"
Write-Host "  Frontend UI:  http://localhost:5173"
Write-Host "  Backend API:  http://localhost:8000"
Write-Host "  API Docs:     http://localhost:8000/docs"
Write-Host ""
Write-Host "$Yellow To stop the servers:$NC"
Write-Host "  Close the PowerShell windows"
Write-Host "  Or run: Get-Job | Stop-Job; Get-Job | Remove-Job"
Write-Host ""
Write-Host "$Blue Opening browser...$NC"
Start-Process "http://localhost:5173"

Write-Host ""
Write-Host "$Green Setup complete!$NC"
Write-Host "$Yellow Press any key to keep this window open (servers will keep running)...$NC"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Keep the job running
while ($BackendJob.State -eq "Running") {
    Start-Sleep -Seconds 1
}
