@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Updater\Update-ForeverTools.ps1" -GamePath "%~dp0..\..\.."
if errorlevel 1 (
    echo Update fehlgeschlagen. Bitte die Meldung oben pruefen.
    pause
    exit /b 1
)
echo.
echo Fertig! Im Spiel jetzt /reload eingeben.
timeout /t 8
