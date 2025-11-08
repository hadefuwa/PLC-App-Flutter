@echo off
echo ============================================================
echo Starting PLC App Server
echo ============================================================
echo.
echo Server will be accessible at:
echo   - http://localhost:5000 (this computer)
echo   - http://192.168.0.13:5000 (network)
echo.
echo Press Ctrl+C to stop the server
echo ============================================================
echo.
python plc_server.py
