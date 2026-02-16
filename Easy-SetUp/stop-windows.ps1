# ProjectMaker Stop Script for Windows (PowerShell)
# This script stops all running ProjectMaker servers

Write-Host "Stopping ProjectMaker servers..."
Write-Host ""

# Stop Backend by port
Write-Host "Stopping Backend (port 8000)..."
$BackendProcess = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess
if ($BackendProcess) {
    Stop-Process -Id $BackendProcess -Force -ErrorAction SilentlyContinue
    Write-Host "✓ Backend server stopped" -ForegroundColor Green
} else {
    Write-Host "Backend server not found" -ForegroundColor Yellow
}

# Stop Frontend by port
Write-Host ""
Write-Host "Stopping Frontend (port 5173)..."
$FrontendProcess = Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess
if ($FrontendProcess) {
    Stop-Process -Id $FrontendProcess -Force -ErrorAction SilentlyContinue
    Write-Host "✓ Frontend server stopped" -ForegroundColor Green
} else {
    Write-Host "Frontend server not found" -ForegroundColor Yellow
}

# Stop any jobs
Get-Job | Stop-Job -ErrorAction SilentlyContinue
Get-Job | Remove-Job -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "All ProjectMaker servers have been stopped!" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
