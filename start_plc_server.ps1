#!/usr/bin/env python3
# PowerShell script to start PLC server
Write-Host "============================================================" -ForegroundColor Green
Write-Host "PLC Communication Server (python-snap7)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Python found: $pythonVersion" -ForegroundColor Cyan
} catch {
    Write-Host "ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python 3.9 or higher from https://www.python.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Checking dependencies..." -ForegroundColor Cyan
try {
    python -c "import snap7" 2>&1 | Out-Null
    Write-Host "Dependencies OK!" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "ERROR: Failed to install dependencies" -ForegroundColor Red
        Write-Host "Please run manually: pip install -r requirements.txt" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Starting PLC Server on http://0.0.0.0:5000" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Make sure:" -ForegroundColor Yellow
Write-Host "  1. Your PLC is reachable on the network" -ForegroundColor White
Write-Host "  2. The Flutter app is configured with this server URL" -ForegroundColor White
Write-Host "  3. Firewall allows connections on port 5000" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Cyan
Write-Host ""

python plc_server.py

