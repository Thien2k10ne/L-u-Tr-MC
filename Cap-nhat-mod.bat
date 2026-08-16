@echo off
chcp 65001 >nul
title Cap nhat danh sach mod
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0mod\_generate.ps1"
echo.
pause