@echo off
echo ======================================
echo S7 PLC Companion - Build and Release
echo ======================================
echo.

REM Set Flutter path
set FLUTTER_PATH=C:\Users\Hamed\Documents\flutter\bin\flutter.bat

REM Get current date and time for versioning
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set DATE=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%
set TIME=%datetime:~8,2%:%datetime:~10,2%

echo [1/3] Building APK (Release)...
call "%FLUTTER_PATH%" build apk --release
if not exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo ERROR: Build failed - APK not found!
    pause
    exit /b 1
)
echo.

echo [2/3] Copying APK to releases folder...
if not exist "releases" mkdir releases
copy /Y "build\app\outputs\flutter-apk\app-release.apk" "releases\app-release.apk"
if errorlevel 1 (
    echo ERROR: Failed to copy APK!
    pause
    exit /b 1
)
echo APK copied successfully to releases\app-release.apk
echo.

echo [3/3] Committing and pushing to GitHub...
git add releases/app-release.apk
git add .
git commit -m "Update release APK - Build %DATE% %TIME%"
if errorlevel 1 (
    echo No changes to commit or commit failed
    git push
) else (
    git push
    if errorlevel 1 (
        echo ERROR: Failed to push to GitHub!
        pause
        exit /b 1
    )
)
echo.

echo ======================================
echo Build and Release Complete!
echo ======================================
echo APK Location: releases\app-release.apk
echo Changes pushed to GitHub
echo.
pause
