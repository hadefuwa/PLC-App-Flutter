@echo off
echo ============================================================
echo PLC Communication Server (python-snap7)
echo ============================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.9 or higher from https://www.python.org/
    pause
    exit /b 1
)

echo Python found!
python --version
echo.

REM Check if dependencies are installed
echo Checking dependencies...
python -c "import snap7" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Installing dependencies...
    pip install -r requirements.txt
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo ERROR: Failed to install dependencies
        echo Please run manually: pip install -r requirements.txt
        pause
        exit /b 1
    )
) else (
    echo Dependencies OK!
)

echo.
echo ============================================================
echo Starting PLC Server on http://0.0.0.0:5000
echo ============================================================
echo.
echo Make sure:
echo   1. Your PLC is reachable on the network
echo   2. The Flutter app is configured with this server URL
echo   3. Firewall allows connections on port 5000
echo.
echo Press Ctrl+C to stop the server
echo.

python plc_server.py

pause

