@echo off
chcp 65001 >nul
title Diretorio dos Gabinetes - Aplicacao Windows
cls
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0Diretorio_Gabinetes.ps1"