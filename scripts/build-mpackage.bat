@echo off
REM Build killswitch.mpackage — Windows launcher
REM Run from repo root:  scripts\build-mpackage.bat
REM Or double-click this file (working directory should be repo root for best results).

setlocal
cd /d "%~dp0.."

REM Prefer Git Bash if available (uses zip + bash script, same as macOS/Linux)
where bash >nul 2>&1
if %ERRORLEVEL% equ 0 (
  echo Using Git Bash + zip...
  bash scripts/build-mpackage.sh %*
  exit /b %ERRORLEVEL%
)

REM Fall back to PowerShell
echo Using PowerShell...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build-mpackage.ps1" %*
exit /b %ERRORLEVEL%
