@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Updater\Update-ForeverTools.ps1" -GamePath "%~dp0..\..\.." -Background
if errorlevel 1 (
    echo Update fehlgeschlagen. Bitte die Meldung oben pruefen.
    pause
    exit /b 1
)
echo.
echo Bereit! Updates jetzt ueber den Update-Button im Spiel anfordern.
timeout /t 8
