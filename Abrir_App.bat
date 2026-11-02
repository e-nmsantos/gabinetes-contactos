@echo off
chcp 65001 >nul
title Diretorio Institucional dos Gabinetes
cls
echo =======================================================
echo   MINISTERIO DAS FINANCAS - DIRETORIO DOS GABINETES
echo =======================================================
echo A iniciar a aplicacao no Microsoft Edge...

set "HTML_FILE=%~dp0Diretorio_Gabinetes.html"

if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" --app="%HTML_FILE%" --window-size=1200,800
) else if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" (
    start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" --app="%HTML_FILE%" --window-size=1200,800
) else (
    start "" "%HTML_FILE%"
)